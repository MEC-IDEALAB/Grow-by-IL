# Repository layout and recovery

Updated: 17 October 2026. Current workspace evidence and historical recovery record.

The reviewed outer `Grow/` workspace contains one Grow application checkout at
`Grow/grow`. No second Grow Git repository was found. The separate security-advisory
repository is remediation work, not a duplicate app to delete. A broad flatten/move
command was rejected by runtime policy during this review, so no folders were moved.
Preserve the current checkout path and user recovery data.

## Current checkout layout

```text
Grow/
  grow/                 one primary Git checkout
    .git/               common history, retained refs and stash
    .github/            workflows and provider-required templates
    android/            platform source; generated outputs ignored
    assets/             app assets
    docs/               current narrative docs/contracts/evidence
    integration_test/   integration acceptance sources
    lib/                Flutter source
    test/               unit/widget tests
    .local/             ignored recovery and local artifacts
    README.md           project entry point
    SECURITY.md         disclosure/security entry point
    CONTRIBUTING.md     contribution entry point
    CODEOWNERS          provider entry point
    pubspec.yaml        manifest
    pubspec.lock        reproducible dependency resolution
```

Required agent/skill/governance entry files remain discoverable. Root governance can
be concise pointers to canonical docs. Do not move .github templates into docs.

## Historical recovery record

The earlier 16 October consolidation record says 30 original checkouts were inventoried:
one primary checkout and 29 linked worktrees. It records that dirty tracked files,
non-generated untracked/ignored files and discovered local configs were copied into
`.local/recovery/2026-10-16/` before linked worktrees were removed, with file/ZIP SHA-256
verification. It also records retained branches, a recovery ref for detached `pr64-test`,
a verified `all-refs.bundle`, and the named stash `recovery: original primary auth UI
work before 2026-10-16 consolidation` (object
`7d21c264f8ee4d196785e2e5f0872ed94f9cffa4`). These are historical consolidation facts;
the 17 October review separately confirmed only the current nested application checkout
and did not repeat every historical hash check.

The scoped `.local/recovery/2026-10-16/original-primary-docs` inventory contains 109
Markdown files among 113 total files. Seven paths overlap the current `docs/` tree;
files at those paths are not byte-identical. This is not a count of all `.local/recovery`,
which also contains user recovery data. Recovery may contain credentials or signing
material: never attach it to public issues or PRs. It is local, not an off-machine backup.
The disposition of `.local/recovery` remains pending; preserve it until that review is
complete.

The earlier recovery manifest maps original roots and heads to archived files and
hashes. Snapshots may contain credentials or signing material; never attach them to
public issues or PRs. Private security-advisory work is retained separately. To restore
work, inspect retained branches or the named stash without dropping it; extract only a
chosen ZIP into a private temporary directory; compare its manifest hashes; then restore
reviewed files. Never apply every old auth patch over newer code blindly.

The current narrative Markdown is under `docs/`; `docs/` is no longer broadly ignored.
The earlier consolidation record counted 100 historical Markdown files in a private
archive; the scoped `.local/recovery/2026-10-16/original-primary-docs` inventory counted
109 Markdown files among 113 total files. Seven paths overlap the current `docs/` tree,
but files at those paths are not byte-identical.
These are dated, scoped inventories, not proof that all old material is redundant or
safe to publish. Issues #72 and #74 track whether a safe, useful subset should be
published. Old alone never means safe to destroy.

The ignored/generated files `android/hs_err_pid8548.log` and
`supabase/.temp/cli-latest` were removed. The now-empty `supabase/.temp` directory
remains because directory removal was rejected. No broad cache deletion or flatten/move
was completed in the 17 October review. Earlier notes about Flutter build output and
small Android cache directories are historical; the prior statement that cache
directories are currently in ignored recovery quarantine was not reverified and must
not be used as current cleanup status. Preserve `.local`, secrets, recovery data,
private configs, signing material and user media.

Keep branches until their unique product value is integrated or explicitly retired.
Never rewrite history or delete a remote repository as a folder-cleanup shortcut. The
[handoff](GROW_V1_TASK_BOARD.md) and live Project record final outcomes and remaining
acceptance gates.
