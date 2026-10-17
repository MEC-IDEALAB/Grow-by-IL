# Grow delivery handoff

Updated: 17 October 2026. The [GitHub Project](https://github.com/users/NAVANEETHVVINOD/projects/4)
is the live delivery queue (61 items: 20 Done, 14 In Progress, 27 Todo). Issues hold
acceptance criteria; Project fields track phase, priority, dependency and evidence.
This file records the current handoff.

Status key: ✓ complete; - in progress; ✗ blocked; blank not started.

| Status | Task | Evidence / next action |
| --- | --- | --- |
| ✓ | Check for a duplicate Grow app repository | The 17 October review found one app checkout at `Grow/grow` and no second Grow Git repository in the outer workspace. The security-advisory repository remains separate remediation work. |
| ✓ | Preserve user recovery data | The scoped `.local/recovery/2026-10-16/original-primary-docs` inventory contains 109 Markdown files among 113 total files; seven paths overlap the current `docs/` tree, but files at those paths are not byte-identical. Other `.local` recovery and user data remain preserved; this is not an off-machine backup. |
| ✓ | Publish the current documentation baseline | PR #121 merged to RC5 as 3b2af47. Current narrative Markdown is under docs/; the broad docs ignore was removed. Required repository entry files and GitHub templates stay in their required root locations. |
| - | Decide on older documentation snapshots | The scoped `.local/recovery/2026-10-16/original-primary-docs` inventory contains 109 Markdown files among 113 total files. Issues #72 and #74 track whether a safe, useful subset should be published; recovery is not a remote backup. |
| ✓ | Repair and disable routine Dependabot version updates | PR #138 merged to `main` as `0a1020952c157e89193f9498b4493efe8dfd6ee7` from head `01f9812aabd052af716b7dca0d90a53ea5033334`; valid GitHub Actions, Pub and Gradle entries use limit 0. Quality Gate, Android Production Build and schema verification passed; Release and bot-only checks were skipped. |
| ✓ | Close failed Dependabot upgrade PRs | #136 closed unmerged after its Android build failed on AGP 9.4.1/Kotlin Android plugin incompatibility. #137 closed unmerged after Quality Gate failed because `riverpod_lint` 3.1.9 requires Dart 3.13 while CI has Dart 3.11.5; Android build was skipped. No upgrades were merged. |
| ✗ | Flatten or move the outer workspace | A broad flatten/move was rejected by runtime policy; no folders were moved. |
|  | Decide the disposition of local recovery | Pending review. Preserve `.local`, secrets and user recovery data. The scoped `original-primary-docs` count does not represent all `.local/recovery`; issues #72 and #74 track safe publication of older documents. |
| ✓ | Remove two verified generated files | Removed ignored `android/hs_err_pid8548.log` and `supabase/.temp/cli-latest`. |
| ✗ | Complete broad cache and temp cleanup | The empty `supabase/.temp` directory remains because directory removal was rejected. Only the two exact files above were removed; broader cleanup is incomplete. |
| ✓ | Merge verified repository PRs | #122, #80, #121, #126, #133, #134 and #138 merged after applicable exact-head checks passed. #123 and #125 were closed as incompatible grouped upgrades; #57 is a duplicate main-target PR; #115 is superseded; #136 and #137 were closed unmerged after CI failures. Issue #114 tracks the staged Flutter/Riverpod/Google Sign-In migration. |
| ✓ | Merge the CI trigger correction, PR #126 | Refreshed head 99d475a1 passed exact-head Quality Gate and Debug APK Build; merged to RC5 as 930594ae. |
| ✗ | Merge the five remaining meaningful PRs | All remain drafts with no submitted review. #90 head `13d9d96d44489b3250431f9583d630b91b6f935a` is DIRTY/conflicting; #99 head `772e808cb1974fad497d30782a62febae302287f`, #103 head `d80a96ab68a1ad33b7a7fdd9446b66be5ea3cd04` and #108 head `a608aa136b084ac5de7ca3f9a8fa9f21d20267d4` are BEHIND RC5. #100 head `ed37a92d601c9ee6efb03fc951463a15058f8c23` is stacked on #99 and has no required Quality Gate or Debug APK result. Rebase/reconcile, run current checks, obtain independent review and complete applicable device/security acceptance first. |
| ✓ | Reconcile external-participant scope in canonical docs | PR #134 merged to RC5 as 39aa2587; ADR-006 and the system boundary allow signed-in, verified-email external participants in eligible event and fabrication/work-request flows while keeping public/anonymous ordering out of scope. PR #115 is closed as superseded; issues #93 and #95 remain open for contract and charter/backlog work. |
| ✓ | Reconcile the issue backlog | The prior 16 October pass refreshed all 34 issue descriptions then present; #73, #75, #76 and #109 closed against evidence. Issues #127–#132 now record missing queue, safety, attendance, reporting, notification and pilot work. |
| ✓ | Update issues and the live Grow Project | Issues #91 and #114 and their Project cards now record the Dependabot config repair, closed failures and remaining migration work. Project #4 has 61 items: 20 Done, 14 In Progress and 27 Todo. Open issues remain open until acceptance is met. |
| ✗ | Complete real application acceptance | Device E2E is unverified in this workspace: `adb` and Flutter are unavailable, and Google sign-in remains disabled in validation project #112. Unit/build success is not sign-in, persistence, RLS or backend E2E evidence. |
|  | Deliver the remaining product pipeline | Follow the live issue queue: authorization and auth → profile/storage/positions → real Work Request → Manufacturing → queue/booking → maintenance/inventory → projects/events/payments → reports/admin → real E2E and release. |
|  | Run a controlled pilot and scale review | Pilot support ownership, release readiness, backup/restore, accessibility, offline behavior and measured capacity remain unverified. |

Product decisions still needed before dependent implementation: exact V1 Work Request
categories; which categories receive a quote or charge; cancellation/refund consequences;
machine booking, safety and concurrency semantics; verified equipment and price source;
and a named pilot support/escalation owner. Do not reopen the cancellation-routing
decisions already recorded in the [Work Request delta](../02_Product/WORK_REQUEST_CONTRACT_DELTA.md).

Keep new work behind the [backend security baseline](../03_Database/BACKEND_SECURITY_BASELINE.md),
[role contract](../03_Database/ROLE_AND_POSITION_CONTRACT.md),
[Storage contract](../03_Database/STORAGE_ACCESS_CONTRACT.md) and
[Work Request contract](../01_Product/06_WORK_REQUEST_IMPLEMENTATION_CONTRACT.md).
