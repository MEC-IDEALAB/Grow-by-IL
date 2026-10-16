# Current Grow project baseline

Updated: 17 October 2026. Evidence record; not release approval.

[Repository](https://github.com/NAVANEETHVVINOD/Grow-by-IL) ·
[Live delivery Project](https://github.com/users/NAVANEETHVVINOD/projects/4) ·
[Layout and recovery record](REPOSITORY_CONSOLIDATION.md) ·
[Current task board](GROW_V1_TASK_BOARD.md).

## Repository and delivery

There is one primary Grow application checkout. The extra local directories were
linked Git worktrees, not separate application repositories. Unique dirty,
untracked and ignored state was preserved before removing those checkouts. The
security-advisory repository is separate remediation work and remains separate.

GitHub `main` remains the default branch; `rc5-release-candidate` is the active
product integration target. Neither branch implies a production release. PR #122
merged to main as aeeae736 after applicable quality, schema and Android build checks
passed. PR #80 merged to main as 1fc7db0 after exact-head Quality Gate (CI),
Android Production Build and schema verification passed. PR #121 merged the current
documentation baseline to RC5 as 3b2af47 after its exact-head quality and Debug APK
checks passed.

PR #126 updates the stacked-base CI coverage. Its refreshed head 99d475a1 passed the
exact-head Quality Gate and Debug APK Build, then merged to RC5 as 930594ae. PRs #123
and #125 were closed as incompatible grouped upgrades; duplicate main-target PR #57
is closed while RC5 PR #56 remains merged. Issue #114 tracks a staged Flutter 3.47,
Riverpod 3 and Google Sign-In 7 migration. PR #133 merged this delivery baseline to
RC5 as fb01f40 after its exact-head Quality Gate and Debug APK Build passed. PR #134
merged to RC5 as 39aa2587 after its exact-head Quality Gate and Debug APK Build
passed; superseded draft PR #115 is closed.

Draft PR #90 currently conflicts with RC5; #99, #103 and #108 are behind RC5; #100
is stacked on #99 and has only a skipped Dependabot check, with no required Quality
Gate or Debug APK result. Reconcile these bases, rerun current exact-head checks, get
independent review, and complete applicable device/security acceptance before merge.
Historic green checks do not validate the updated RC5 base. PR #134 ports the useful
high-level external-participant scope from draft #115 into the canonical ADR and
system-boundary docs; #115 is closed as superseded. Issues #93 and #95 remain open for
detailed eligibility, request fields, safety/routing, payment, privacy, support
contracts, and charter/backlog reconciliation.

## Documentation and workspace

The current narrative Markdown is consolidated under `docs/`; the broad `docs/`
ignore is removed. Short root pointers, repository-required files and GitHub templates
remain at their required root locations. The active set has 26 Markdown documents.
One hundred older Markdown files and unique worktree state remain in private local
recovery; issues #72 and #74 track whether safe, useful historical material should be
published. Local recovery is not an off-machine backup.

Flutter build output and `.dart_tool` were removed. The remaining small Android cache
folders are in ignored recovery quarantine; direct recursive removal was blocked by
automatic approval review. This local cleanup does not alter the remote release or
branch-protection settings.

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
still needs confirmation. No Android device is connected for this acceptance run.
Provider/email setup, Android acceptance, profile/storage privacy and scoped position
authority remain prerequisites to operational backend expansion. The Project tracks
the issue dependencies and evidence.

Main requires `Quality Gate (CI)` and `Android Production Build`. RC5 requires
`Quality Gate` and `Debug APK Build`. Missing, failed or skipped required execution
does not pass. Independent review and applicable local/E2E evidence remain required.
No cleanup or documentation change approves a release or production backend write.
