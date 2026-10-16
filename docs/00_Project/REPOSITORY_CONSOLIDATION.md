# Repository layout and recovery

Updated: 17 October 2026. User-authorized cleanup and GitHub reconciliation.

## Target layout

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

## Verified preservation

30 original checkouts were inventoried: one primary checkout and 29 linked worktrees.
Dirty tracked files, non-generated untracked/ignored files and discovered local
configs were copied into .local/recovery/2026-10-16/ before removing linked worktrees.
Each file and ZIP was SHA-256 verified. Committed work remains in retained branches;
detached pr64-test was anchored with a recovery ref. all-refs.bundle was created and
verified. Primary auth/UI edits also remain in the named Git stash with subject
recovery: original primary auth UI work before 2026-10-16 consolidation
(stash object 7d21c264f8ee4d196785e2e5f0872ed94f9cffa4).

manifest.json maps original roots/heads to ZIPs and hashes. Snapshots may contain
credentials/signing material: never attach them to public issues/PRs. Local recovery
is not an off-machine backup. Private security-advisory work is retained separately.

Recovery: inspect retained branches or the named stash without dropping it; extract
only a chosen ZIP into a private temporary directory, compare its manifest hashes,
then restore reviewed files. Never apply every old auth patch over newer code blindly.

100 historical Markdown files from the former docs checkout were preserved in
historical-public-docs.zip with a hash manifest before removal. They were not all
judged redundant or safe to publish. The current 26-document narrative set is tracked
under docs/ on RC5 through PR #121, and docs/ is no longer broadly ignored. Issues #72
and #74 track a safe publication decision for older unique records. Unique ignored
originals, including sensitive records, remain in worktree snapshots. Old alone never
means safe to destroy.

Flutter build/.dart_tool output was removed with flutter clean; android/build is
ignored. Small Android .gradle/.kotlin and local .claude/.worktrees directories remain
in ignored recovery quarantine because automatic approval review blocked direct
recursive removal. Preserve private configs/signing/user media. Keep branches until
their unique product value is integrated or explicitly retired. Never rewrite history
or delete a remote repo as a folder-cleanup shortcut. The [handoff](GROW_V1_TASK_BOARD.md)
and live Project record final outcomes and remaining acceptance gates.
