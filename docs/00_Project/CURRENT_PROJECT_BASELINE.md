# Current Grow project baseline

Updated: 18 October 2026. Evidence record; not release approval.

[Repository](https://github.com/NAVANEETHVVINOD/Grow-by-IL) ·
[Live delivery Project](https://github.com/users/NAVANEETHVVINOD/projects/4) ·
[Layout and recovery record](REPOSITORY_CONSOLIDATION.md) ·
[Current task board](GROW_V1_TASK_BOARD.md).

## Repository and delivery

The 18 October workspace review found one Grow application Git checkout at `Grow/grow`
and one Git worktree. A remote repository inventory also found a second Grow-named
near-copy with unreconciled pull-request work. Its contents have not been fully
reconciled, so it cannot yet be called redundant or safe to delete; detailed disposition
evidence is tracked in private Project #4. Earlier consolidation notes describe local
recovery preservation; those historical notes do not make recovery disposable.

GitHub `main` remains the default branch; `rc5-release-candidate` is the current
integration base for the remaining product drafts. Neither branch implies a production
release. PR #122 merged to main as aeeae736 after applicable quality, schema and Android
build checks passed. PR #80 merged to main as 1fc7db0 after exact-head Quality Gate (CI),
Android Production Build and schema verification passed. PR #121 merged the current
documentation baseline to RC5 as 3b2af47 after its exact-head quality and Debug APK
checks passed.

PR #138 repaired `.github/dependabot.yml` and merged to main on 17 October 2026 as
`0a1020952c157e89193f9498b4493efe8dfd6ee7` from exact head
`01f9812aabd052af716b7dca0d90a53ea5033334`. Quality Gate (CI), Android Production
Build and Verify Schema Contract passed on that head. GitHub Release and the bot-only
Dependabot check were skipped. The valid GitHub Actions, Pub and Gradle entries each
set `open-pull-requests-limit: 0`, disabling routine version-update pull requests for
those ecosystems. Vulnerability alerts and automated security fixes are separate
repository settings and remain disabled.

Dependabot PR #136 was closed unmerged: its Android Production Build failed because
AGP 9.4.1 is incompatible with the current Kotlin Android plugin. PR #137 was closed
unmerged: Quality Gate failed because `riverpod_lint` 3.1.9 requires Dart 3.13 while
CI uses Dart 3.11.5; its Android build was skipped. No bundled dependency upgrades
were merged.

PR #126 updates the stacked-base CI coverage. Its refreshed head 99d475a1 passed the
exact-head Quality Gate and Debug APK Build, then merged to RC5 as 930594ae. PRs #123
and #125 were closed as incompatible grouped upgrades; duplicate main-target PR #57
is closed while RC5 PR #56 remains merged. Issue #114 tracks a staged Flutter 3.47,
Riverpod 3 and Google Sign-In 7 migration. PR #133 merged this delivery baseline to
RC5 as fb01f40 after its exact-head Quality Gate and Debug APK Build passed. PR #134
merged to RC5 as 39aa2587 after its exact-head Quality Gate and Debug APK Build
passed; superseded draft PR #115 is closed.

The five remaining open PRs are drafts with no submitted GitHub review. The live 18
October audit found #90 head `13d9d96d44489b3250431f9583d630b91b6f935a` DIRTY against
RC5 and blocked by unresolved release-security/configuration review; detailed findings
are kept in the private Project #4 card. PR #99 head
`772e808cb1974fad497d30782a62febae302287f`, #103 head
`d80a96ab68a1ad33b7a7fdd9446b66be5ea3cd04`, and #108 head
`a608aa136b084ac5de7ca3f9a8fa9f21d20267d4` are BEHIND RC5. Their old Quality Gate
and Debug APK results must be rerun after updating the base. Bounded independent
reviews of #103 and #108 found no reproducible code defect, but current-head checks,
formal review and applicable device/configuration acceptance remain incomplete. PR
#100 head `ed37a92d601c9ee6efb03fc951463a15058f8c23` is stacked on #99 and has no
required Quality Gate or Debug APK result. None is merge-ready. PR #134 ports the
useful high-level external-participant scope from draft #115 into the canonical ADR
and system-boundary docs; #115 is closed as superseded. Issues #93 and #95 remain open
for detailed eligibility, request fields, safety/routing, payment, privacy, support
contracts, and charter/backlog reconciliation.

Issues #84, #91 and #92 and their Project #4 cards now record the current release,
Dependabot-branch and navigation evidence. Issue #114 continues to track the staged
migration. Project #4 currently contains 61 items: 20 Done, 9 In Progress, 26 Todo and 6 Blocked.

## Documentation and workspace

The current narrative Markdown is consolidated under `docs/`; the broad `docs/`
ignore is removed. Short root pointers, repository-required files and GitHub templates
remain at their required root locations. The scoped inventory of
`.local/recovery/2026-10-16/original-primary-docs` contains 109 Markdown files among
113 total files. Seven paths overlap the current `docs/` tree; files at those paths
are not byte-identical. This is not a count of all `.local/recovery`. Issues #72 and #74
track whether safe, useful historical material should be published. Local recovery is
not an off-machine backup, and its disposition remains pending.

The reviewed outer workspace contains the single app checkout at `Grow/grow`; the
separate remote repository remains under review as described above. A broad
flatten/move command was rejected by runtime policy, so no folders were moved in that
review.
Generated ignored files `android/hs_err_pid8548.log` and
`supabase/.temp/cli-latest` were removed. The empty `supabase/.temp` directory remains;
an exact removal attempt was rejected by runtime policy on 18 October. The ignored-file
inventory also contains `.env`, `.local`, Firebase/signing files, and Android local
configuration; preserve those user and setup files. Preserve `.local`, secrets and
recovery data; do not treat this as proof that all generated files or caches are gone.

## Product implementation boundary

Auth/profile, navigation, projects, events, Lab and admin surfaces exist in RC5 or
active branches; real-environment acceptance is incomplete. Work Requests still use
a mock data source and local drafts. Unit/widget tests and an APK build do not prove
production persistence, RLS, provider configuration or a real Android journey.
Manufacturing, queues, real inventory/borrowing, quotes/payments and operational
reports remain gated or partial. Work Request ≠ Manufacturing Task ≠ Machine Queue.
Historical ERDs are proposals; do not execute old migrations blindly.

## Recorded decisions and remaining inputs

Machine and Operations requests are separate and route to their respective heads.
Both may be cancelled directly before the head takes or reviews them; afterward the
requester supplies a reason and the head approves or denies. Pending/denied
cancellation preserves status. Operations Head approves updated stock/prices.
Students request/book work; Machine Heads operate fabrication machines. See the
[current Work Request delta](../02_Product/WORK_REQUEST_CONTRACT_DELTA.md).

Verified-email external students and professionals may use eligible event and
fabrication/work-request flows after onboarding. This scope does not create staff
verification or machine/operations authority. Issue #93 remains open for event
eligibility, request fields and routing, safety, payment, privacy, and support rules;
issue #95 tracks charter/backlog reconciliation.

Still needed at dependent gates: exact V1 Work Request categories, quote/charge
mapping, cancellation/refund consequences, booking/safety/concurrency rules, an
owner-verified equipment catalog and price source, and a named pilot support/
escalation owner. Do not reopen settled cancellation-routing decisions.

## Foundation gates

Issue #88 requires live-versus-repository schema, grants, RLS, functions and migration
reconciliation, followed by staging negative-authorization tests. Historical 28P01 is
not asserted as a current verified outage. Issue #112 identifies the validation
Supabase project and records Google sign-in as disabled; current provider readiness
still needs confirmation. Flutter 3.41.9/Dart 3.11.5 and Android SDK/ADB are installed
outside PATH, but no AVD is configured and no Android device is connected for this
acceptance run. An initial emulator-list read was corrected after a diagnostic line was
mistaken for an AVD name. No app was launched or installed.
Provider/email setup, Android acceptance, profile/storage privacy and scoped position
authority remain prerequisites to operational backend expansion. The Project tracks
the issue dependencies and evidence.

Main requires `Quality Gate (CI)` and `Android Production Build`. RC5 requires
`Quality Gate` and `Debug APK Build`. Missing, failed or skipped required execution
does not pass. Independent review and applicable local/E2E evidence remain required.
No cleanup or documentation change approves a release or production backend write.
