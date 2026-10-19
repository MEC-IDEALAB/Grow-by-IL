# Repository layout and recovery

Updated: 20 October 2026. Current workspace evidence and historical recovery record.

## Current checkout

The primary checkout was moved from F:\kannan\projects\Grow\grow to
F:\kannan\projects\Grow. Git confirms the new root and one active worktree. The move
preserved .git, .env, .local, tracked and ignored user files, retained branches and the
recovery stash. The old grow/ directory is empty and remains because deletion was
rejected by the execution policy.

The outer workspace contained exactly one child checkout before the move; no sibling
folder was moved. Other directories under F:\kannan\projects are separate projects.
The private secondary repository NAVANEETHVVINOD/Grow-by-IL-ghsa-fgf9-xx2v-57qp was fully inventoried read-only: 29 refs (21 branches, 5 tags, 3 PR refs), with two PR records. Five tags and fourteen branch tips match primary; old main/RC5 tips are ancestors, and Dependabot, release-hardening and profile-identity histories are represented in primary PRs #80/#90/#103. The only unique content is a four-commit security series shared by closed-unmerged PR #1 and open PR #2; matching patch IDs show #1 duplicates #2. Its migration, pgTAP tests and ledger are absent from primary. PR #2 is not safe to port unchanged because it expects a different role/membership schema, has no hosted checks or submitted review, and pauses join/transfer flows. Retain this repository until a primary-specific fix passes current gates or the security work is preserved in a verified owner-approved private archive; confirm GHSA retention requirements before deletion.

The following ignored generated targets were verified before cleanup: .dart_tool,
root build, empty supabase/.temp, and .flutter-plugins-dependencies. The execution
policy rejected deletion; all four remain. No alternate deletion method was used.
android/build/reports/problems/problems-report.html is absent from this checkout and
HEAD; it was not recovered or preserved by this move. .env,
.local, Firebase/signing configuration and recovery data remain untouched.

    Grow/                         primary Git checkout and Flutter project root
      .git/                       history, refs and recovery stash
      .github/                    workflows and provider-required templates
      android/                    Android source and configuration
      assets/                     application assets
      docs/                       current narrative docs and contracts
      integration_test/           integration acceptance sources
      lib/                        Flutter source
      supabase/                   backend contracts and configuration
      test/                       unit/widget tests
      .env                        local environment configuration (preserved)
      .local/                     private recovery and local artifacts (preserved)
      README.md                   project entry point
      SECURITY.md                 disclosure/security entry point
      CONTRIBUTING.md             contribution entry point
      CODEOWNERS                  provider entry point
      pubspec.yaml                package manifest
      pubspec.lock                reproducible dependency resolution
      grow/                       empty former checkout shell; removal blocked

Narrative Markdown is versioned under docs/; docs/ is not ignored. Required repository
entry files, root governance pointer stubs and GitHub templates remain at their
required locations.

## PR #108 recovery work

The local branch fix/pr108-recovery-marker contains an uncommitted recovery-hardening
patch saved in stash@{1}; stash@{0} preserves the documentation refresh. The local focused tests and targeted analysis passed, and
independent review accepted the cleanup ordering. The remote PR head remains
a608aa136b084ac5de7ca3f9a8fa9f21d20267d4, behind RC5; no code was committed or
pushed. Hosted checks and device/provider/backend acceptance remain outstanding.

That source branch also contains the dated docs/02_Product/AUTH_PROFILE_CONTRACT.md
snapshot. It was not copied into canonical docs because it overlaps newer identity,
provider and security contracts and does not represent the reviewed recovery behavior.
Keep the source branch until its unique work is explicitly reconciled.

## Historical recovery record

The 16 October consolidation inventory recorded one primary checkout and 29 linked
worktrees, with dirty tracked files, non-generated untracked/ignored files and local
configurations copied under .local/recovery/2026-10-16/ before worktree removal.
It recorded retained branches, a recovery ref for detached pr64-test, an
all-refs.bundle, and the named recovery stash. Those are historical facts; this
20 October operation moved the current checkout and did not repeat every archived
hash check.

The scoped .local/recovery/2026-10-16/original-primary-docs inventory contains 109
Markdown files among 113 total files. Seven paths overlap the current docs/ tree,
but files at those paths are not byte-identical. This is not an inventory of all
.local/recovery. Recovery may contain credentials or signing material; never attach
it to public issues or PRs. It is not an off-machine backup. Issues #72 and #74 track
whether any safe historical material should be published. Preserve all recovery data
until its disposition is reviewed.

Keep branches until their unique product value is integrated or explicitly retired.
Never rewrite history or delete a remote repository as a folder-cleanup shortcut. The
[handoff](GROW_V1_TASK_BOARD.md) and live Project record track final outcomes and
remaining acceptance gates.
