"""Fail-closed architecture guard with exact historical migration additions."""

import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys


class GuardError(Exception):
    """The changeset could not be checked safely."""


def git(repo, *args):
    result = subprocess.run(
        ["git", "-C", str(repo), *args], capture_output=True, check=False
    )
    if result.returncode:
        raise GuardError(f"Git command failed: {' '.join(args[:2])}")
    return result.stdout


def resolve_commit(repo, ref):
    # --end-of-options prevents event values from becoming Git options.
    return git(repo, "rev-parse", "--verify", "--end-of-options", ref + "^{commit}").decode().strip()


def comparison_base(repo, pr_base, before):
    head = resolve_commit(repo, "HEAD")
    if pr_base:
        base = resolve_commit(repo, pr_base)
        return git(repo, "merge-base", base, head).decode().strip(), head
    if before:
        if before == "0" * 40:
            raise GuardError("New branch push has no trusted comparison base")
        return resolve_commit(repo, before), head
    parents = git(repo, "rev-list", "--parents", "-n", "1", head).decode().split()
    # On an initial commit diff-tree --root checks all additions.
    return (parents[1] if len(parents) > 1 else None), head


def load_policy(repo):
    directory = Path(repo) / ".github" / "ci"
    rules = []
    for line in (directory / "architecture_guard_paths.txt").read_text(encoding="utf-8").splitlines():
        if not line or line.startswith("#"):
            continue
        pattern, separator, reason = line.partition("::")
        if not separator or not pattern or not reason:
            raise GuardError("Invalid architecture path rule")
        rules.append((re.compile(pattern), reason))
    if not rules:
        raise GuardError("Architecture path rules are empty")
    manifest = json.loads((directory / "approved_historical_migrations.json").read_text(encoding="utf-8"))
    if not isinstance(manifest, dict) or not manifest:
        raise GuardError("Historical migration manifest must be a nonempty object")
    for path, digest in manifest.items():
        if not re.fullmatch(r"supabase/migrations/[0-9]{14}_[a-z0-9_]+\.sql", path):
            raise GuardError("Invalid historical migration path")
        if not isinstance(digest, str) or not re.fullmatch(r"[0-9a-f]{64}", digest):
            raise GuardError("Invalid historical migration SHA-256")
    return rules, manifest


def changes(repo, base, head):
    if base is None:
        raw = git(repo, "diff-tree", "--root", "--no-commit-id", "-r", "--name-status", "-z", "--find-renames", head, "--")
    else:
        raw = git(repo, "diff", "--name-status", "-z", "--find-renames", base, head, "--")
    fields = raw.split(b"\0")
    if fields.pop() != b"":
        raise GuardError("Invalid NUL-delimited Git diff")
    result = []
    index = 0
    while index < len(fields):
        status = fields[index].decode("ascii")
        count = 2 if status.startswith(("R", "C")) else 1
        paths = fields[index + 1:index + 1 + count]
        if len(paths) != count or not status or any(not path for path in paths):
            raise GuardError("Invalid Git diff record")
        result.append((status, [os.fsdecode(path) for path in paths]))
        index += 1 + count
    return result


def approved_addition(repo, base, head, status, path, manifest):
    if status != "A" or path not in manifest:
        return False
    if base is not None and git(repo, "ls-tree", "-z", base, "--", path):
        return False
    entry = git(repo, "ls-tree", "-z", head, "--", path)
    if not entry.startswith(b"100644 blob "):
        return False
    # Hash the committed blob, not a checkout subject to line-ending filters.
    content = git(repo, "cat-file", "blob", f"{head}:{path}")
    return hashlib.sha256(content).hexdigest() == manifest[path]


def check(repo, pr_base="", before=""):
    rules, manifest = load_policy(repo)
    base, head = comparison_base(repo, pr_base, before)
    blocked = []
    for status, paths in changes(repo, base, head):
        for path in paths:
            if approved_addition(repo, base, head, status, path, manifest):
                continue
            for pattern, reason in rules:
                if pattern.search(path):
                    blocked.append(f"{status} {path!r}: {reason}")
    return blocked


def main():
    try:
        blocked = check(Path.cwd(), os.environ.get("ARCHITECTURE_PR_BASE", ""), os.environ.get("ARCHITECTURE_PUSH_BEFORE", ""))
        if blocked:
            for message in blocked:
                print(message)
            print("Architecture phase guard failed. Complete the approval gate.")
            return 1
        print("Architecture phase guard passed.")
        return 0
    except (GuardError, OSError, ValueError, re.error, UnicodeError) as error:
        print(f"Architecture phase guard could not verify changes: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
