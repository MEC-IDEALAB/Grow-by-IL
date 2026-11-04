"""Exercise the guard against real, isolated Git histories (no external services)."""

import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest
from unittest import mock

import architecture_phase_guard as guard


APPROVED = "supabase/migrations/20261102083307_shared_access_hardening_v1.sql"
SECOND = "supabase/migrations/20261102130200_shared_profile_contract_v1.sql"
CONTENT = b"-- approved historical bytes\r\nselect 1;\r\n"


class GuardTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.repo = Path(self.temp.name)
        self.git("init", "-q")
        self.git("config", "user.email", "guard-test@example.invalid")
        self.git("config", "user.name", "Architecture guard test")
        self.git("config", "core.autocrlf", "false")
        self.git("config", "commit.gpgsign", "false")
        self.git("config", "core.hooksPath", str(self.repo / "no-hooks"))
        directory = self.repo / ".github" / "ci"
        directory.mkdir(parents=True)
        shutil.copyfile(Path(__file__).with_name("architecture_guard_paths.txt"), directory / "architecture_guard_paths.txt")
        self.manifest = {APPROVED: hashlib.sha256(CONTENT).hexdigest(), SECOND: hashlib.sha256(CONTENT).hexdigest()}
        self.write_manifest()
        self.commit()
        self.base = self.git("rev-parse", "HEAD").strip()

    def git(self, *args):
        return subprocess.run(["git", "-C", str(self.repo), *args], check=True, capture_output=True, text=True).stdout

    def write(self, path, content=CONTENT):
        target = self.repo / path
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(content)

    def write_manifest(self):
        self.write(".github/ci/approved_historical_migrations.json", json.dumps(self.manifest).encode())

    def commit(self):
        self.git("add", "--all")
        self.git("commit", "-qm", "test change")

    def check(self):
        return guard.check(self.repo, before=self.base)

    def existing_migration(self):
        self.write(APPROVED)
        self.commit()
        self.base = self.git("rev-parse", "HEAD").strip()

    def test_exact_additions_pass(self):
        for path in self.manifest:
            self.write(path)
        self.commit()
        self.assertEqual([], self.check())

    def test_wrong_hash_blocked(self):
        self.write(APPROVED, CONTENT.replace(b"\r\n", b"\n"))
        self.commit()
        self.assertTrue(self.check())

    def test_ordinary_ui_passes(self):
        self.write("lib/features/inventory/presentation/preview.dart", b"// UI preview\n")
        self.commit()
        self.assertEqual([], self.check())

    def test_every_gated_operational_module_blocked(self):
        for module in ("work_requests", "inventory", "borrowing", "payments", "quotations", "visitors", "machines"):
            for layer in ("data", "domain"):
                self.write(f"lib/features/{module}/{layer}/new.dart", b"// gated\n")
        self.commit()
        self.assertEqual(14, len(self.check()))

    def test_unapproved_migration_blocked(self):
        self.write("supabase/migrations/20261104000000_new.sql")
        self.commit()
        self.assertTrue(self.check())

    def test_existing_migration_edit_blocked(self):
        self.existing_migration()
        self.write(APPROVED, CONTENT + b"select 2;\n")
        self.commit()
        self.assertTrue(self.check())

    def test_existing_migration_delete_blocked(self):
        self.existing_migration()
        (self.repo / APPROVED).unlink()
        self.commit()
        self.assertTrue(self.check())

    def test_existing_migration_rename_to_approved_path_blocked(self):
        self.existing_migration()
        self.git("mv", APPROVED, SECOND)
        self.commit()
        self.assertTrue(self.check())

    def test_existing_migration_rename_outside_migrations_blocked(self):
        self.existing_migration()
        self.git("mv", APPROVED, "historical.sql")
        self.commit()
        self.assertTrue(self.check())

    def test_pr_uses_merge_base(self):
        self.git("checkout", "-qb", "target")
        self.write("supabase/migrations/20261104000000_target_only.sql")
        self.commit()
        target = self.git("rev-parse", "HEAD").strip()
        self.git("checkout", "-qb", "feature", self.base)
        self.write("lib/preview.dart", b"// preview\n")
        self.commit()
        self.assertEqual([], guard.check(self.repo, pr_base=target))

    def test_new_branch_push_cannot_hide_earlier_migration(self):
        self.write("supabase/migrations/unapproved.sql")
        self.commit()
        self.write("lib/preview.dart", b"// preview\n")
        self.commit()
        with self.assertRaisesRegex(guard.GuardError, "no trusted comparison base"):
            guard.check(self.repo, before="0" * 40)

    def test_missing_refs_fail_closed(self):
        for kwargs in ({"pr_base": "missing"}, {"before": "missing"}, {"before": "--help"}):
            with self.subTest(kwargs=kwargs), self.assertRaises(guard.GuardError):
                guard.check(self.repo, **kwargs)

    def test_missing_or_invalid_manifest_fails_closed(self):
        manifest = self.repo / ".github/ci/approved_historical_migrations.json"
        for content in (b"[]", b"{}", b"{bad json", b'{"../bad": "bad"}'):
            manifest.write_bytes(content)
            with self.subTest(content=content), self.assertRaises((guard.GuardError, ValueError)):
                self.check()
        manifest.unlink()
        with self.assertRaises(OSError):
            self.check()

    def test_missing_rules_fail_closed(self):
        (self.repo / ".github/ci/architecture_guard_paths.txt").unlink()
        with self.assertRaises(OSError):
            self.check()

    def test_git_error_exits_failure(self):
        with mock.patch.object(guard, "check", side_effect=guard.GuardError("failure")):
            self.assertEqual(1, guard.main())

    def test_initial_commit_is_checked(self):
        # Replace only the temporary test repository's history with a root commit.
        self.git("checkout", "--orphan", "initial")
        self.write("supabase/migrations/20261104000000_unapproved.sql")
        self.commit()
        self.assertTrue(guard.check(self.repo))

    def test_newline_in_gated_filename_is_not_split(self):
        # Build Git objects directly: Windows cannot create this filename, but
        # the guard must still handle a commit containing it without checkout.
        def git_input(*args, data):
            return subprocess.run(
                ["git", "-C", str(self.repo), *args],
                input=data, check=True, capture_output=True,
            ).stdout

        blob = git_input("hash-object", "-w", "--stdin", data=CONTENT).strip()
        migrations = git_input(
            "mktree", "-z",
            data=b"100644 blob " + blob + b"\tunusual\nname.sql\0",
        ).strip()
        supabase = git_input(
            "mktree", "-z",
            data=b"040000 tree " + migrations + b"\tmigrations\0",
        ).strip()
        base_entries = git_input("ls-tree", "-z", self.base, data=b"")
        root = git_input(
            "mktree", "-z",
            data=base_entries + b"040000 tree " + supabase + b"\tsupabase\0",
        ).strip()
        commit = git_input(
            "commit-tree", root.decode("ascii"), "-p", self.base,
            data=b"Test newline-containing migration filename\n",
        ).decode("ascii").strip()
        self.git("update-ref", "HEAD", commit)

        filename = "supabase/migrations/unusual\nname.sql"
        self.assertEqual([("A", [filename])], guard.changes(self.repo, self.base, commit))
        blocked = self.check()
        self.assertEqual(1, len(blocked))
        self.assertIn(repr(filename), blocked[0])


if __name__ == "__main__":
    unittest.main()
