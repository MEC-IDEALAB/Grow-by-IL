# Grow delivery handoff

Updated: 18 October 2026. The [GitHub Project](https://github.com/users/NAVANEETHVVINOD/projects/4)
is the live delivery queue (61 items: 20 Done, 9 In Progress, 26 Todo, 6 Blocked). Issues hold
acceptance criteria; Project fields track phase, priority, dependency and evidence.
This file records the current handoff.

Status key: ✓ complete; - in progress; ✗ blocked; blank not started (GitHub Project Status: Todo).

| Status | Task | Evidence / next action |
| --- | --- | --- |
| ✓ | Audit the local Grow checkout and worktrees | The outer workspace contains one app checkout at `Grow/grow`; the live Git worktree list also contains one checkout. |
| ✗ | Remove the secondary Grow GitHub repository if it is unnecessary | A remote inventory found a second Grow-named near-copy with unreconciled PR work. Its contents are not proven redundant, so preserve it until the unique work is reviewed and safely ported or explicitly abandoned. Detailed evidence belongs in private Project #4. |
| ✓ | Audit the unreconciled remote repository work | Two independent read-only reviews are complete. One broad snapshot PR was closed as redundant with its branch preserved; a separate change contains unique work that cannot safely be merged into the current baseline yet. Exact findings and preservation steps are in private Project #4. |
| ✓ | Preserve user recovery data | The scoped `.local/recovery/2026-10-16/original-primary-docs` inventory contains 109 Markdown files among 113 total files; seven paths overlap the current `docs/` tree, but files at those paths are not byte-identical. Other `.local` recovery and user data remain preserved; this is not an off-machine backup. |
| ✓ | Publish the current documentation baseline | PR #121 merged to RC5 as 3b2af47. Current narrative Markdown is under docs/; the broad docs ignore was removed. Required repository entry files and GitHub templates stay in their required root locations. |
| - | Decide on older documentation snapshots | The scoped `.local/recovery/2026-10-16/original-primary-docs` inventory contains 109 Markdown files among 113 total files. Issues #72 and #74 track whether a safe, useful subset should be published; recovery is not a remote backup. |
| ✓ | Repair and disable routine Dependabot version updates | PR #138 merged to default branch `main` as `0a1020952c157e89193f9498b4493efe8dfd6ee7` from head `01f9812aabd052af716b7dca0d90a53ea5033334`; its valid GitHub Actions, Pub and Gradle entries use limit 0. Quality Gate, Android Production Build and schema verification passed; Release and bot-only checks were skipped. Live PR inventory shows no open bot PRs. RC5 still has limit 5 but is not the default branch; align it before any promotion. |
| ✓ | Close failed Dependabot upgrade PRs | #136 closed unmerged after its Android build failed on AGP 9.4.1/Kotlin Android plugin incompatibility. #137 closed unmerged after Quality Gate failed because `riverpod_lint` 3.1.9 requires Dart 3.13 while CI has Dart 3.11.5; Android build was skipped. No upgrades were merged. |
| ✗ | Flatten or move the outer workspace | A broad flatten/move was rejected by runtime policy; no folders were moved. |
|  | Decide broader local recovery disposition | Not started; separate from the active review of the `original-primary-docs` snapshot in issues #72/#74. Preserve `.local`, secrets and user data; inspect exact recovery scopes before deciding what to retain or clean up. |
| ✓ | Remove two verified generated files | Removed ignored `android/hs_err_pid8548.log` and `supabase/.temp/cli-latest`. |
| ✗ | Complete broad cache and temp cleanup | The empty `supabase/.temp` directory remains because directory removal was rejected. Only the two exact files above were removed; broader cleanup is incomplete. |
| ✓ | Merge verified repository PRs | #122, #80, #121, #126, #133, #134 and #138 merged after applicable exact-head checks passed. #123 and #125 were closed as incompatible grouped upgrades; #57 is a duplicate main-target PR; #115 is superseded; #136 and #137 were closed unmerged after CI failures. Issue #114 tracks the staged Flutter/Riverpod/Google Sign-In migration. |
| ✓ | Merge the CI trigger correction, PR #126 | Refreshed head 99d475a1 passed exact-head Quality Gate and Debug APK Build; merged to RC5 as 930594ae. |
| ✓ | Audit every currently open pull request in the primary repository | Live primary-repo audit found five drafts: #90 has unique release work but a conflict and unresolved release-trust review; #99/#103/#108 are behind RC5 and still need current-head checks/review/device acceptance; #100 is stacked on #99 and lacks required checks. No open primary-repo PR is both unwanted and safe to close, and none is ready to merge. |
| ✗ | Merge the five remaining meaningful primary-repo PRs | Live audit on 18 Oct: all five are drafts without submitted review. #90 head `13d9d96d44489b3250431f9583d630b91b6f935a` is DIRTY and blocked by release-trust review; details remain in private Project #4. #99 (`772e808cb1974fad497d30782a62febae302287f`), #103 (`d80a96ab68a1ad33b7a7fdd9446b66be5ea3cd04`) and #108 (`a608aa136b084ac5de7ca3f9a8fa9f21d20267d4`) are behind RC5; their old required checks must be rerun. PR #99 has author-reported I2301 navigation evidence for its old head; repeat after updating the base and confirm whether deleting the full Akathalam screen preserves issue #92 workflows. Independent review found no reproducible code defect in bounded #103/#108 review, but current checks and applicable E2E remain outstanding. #100 (`ed37a92d601c9ee6efb03fc951463a15058f8c23`) is stacked on #99 without required CI. No PR is merge-ready. |
| ✓ | Reconcile external-participant scope in canonical docs | PR #134 merged to RC5 as 39aa2587; ADR-006 and the system boundary allow signed-in, verified-email external participants in eligible event and fabrication/work-request flows while keeping public/anonymous ordering out of scope. PR #115 is closed as superseded; issues #93 and #95 remain open for contract and charter/backlog work. |
| ✓ | Reconcile the issue backlog | The prior 16 October pass refreshed all 34 issue descriptions then present; #73, #75, #76 and #109 closed against evidence. Issues #127–#132 now record missing queue, safety, attendance, reporting, notification and pilot work. |
| ✓ | Update issues and the live Grow Project | On 18 Oct, issue #92 records the navigation acceptance gap; Project #4 now has a Blocked Status option and current disposition/evidence for issue #88 and PRs #90/#99/#100/#103/#108. The 61-item project has 20 Done, 9 In Progress, 26 Todo and 6 Blocked. Open issues remain open until acceptance is met. |
| ✗ | Complete real application acceptance | Flutter 3.41.9/Dart 3.11.5 and Android SDK/ADB exist outside PATH, but no AVD is configured and ADB has no connected device. PRs #99/#100 report older-head navigation/home device evidence; it must be repeated against the current base. Google sign-in remains disabled in validation project #112. This pass did not launch/install the app; current auth, persistence, RLS and backend E2E remain unverified. |
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
