# Grow delivery handoff

Updated: 17 October 2026. The [GitHub Project](https://github.com/users/NAVANEETHVVINOD/projects/4)
is the live delivery queue. Issues hold acceptance criteria; Project fields track
phase, priority, dependency and evidence. This file records the current handoff.

Status key: ✓ complete; - in progress; ✗ blocked; blank not started.

| Status | Task | Evidence / next action |
| --- | --- | --- |
| ✓ | Consolidate the workspace | One Grow app checkout remains. The other 29 linked worktrees were removed after preserving their unique state. The separate security-advisory repository is remediation work, not a duplicate app. |
| ✓ | Preserve user work | 30 hash-verified snapshots, a verified Git bundle and a named stash preserve unique dirty/untracked files and history. Private config, signing material and user artifacts were retained. |
| ✓ | Publish the current documentation baseline | PR #121 merged to RC5 as 3b2af47. Current narrative Markdown is under docs/; the broad docs ignore was removed. Required repository entry files and GitHub templates stay in their required root locations. |
| - | Decide on older documentation snapshots | 100 historical Markdown files remain in private recovery. Issues #72 and #74 track whether a safe, useful subset should be published. The snapshots are not remote backups yet. |
| ✓ | Remove generated Flutter build output | `flutter clean` removed build and `.dart_tool`; `/android/build/` is ignored. |
| ✗ | Delete the remaining small Android cache folders | Direct recursive deletion was rejected by automatic approval review. The checked `.gradle`, `.kotlin`, `.claude` and `.worktrees` folders are in ignored recovery quarantine and are not deleted. |
| ✓ | Merge verified repository PRs | #122, #80, #121, #126, #133 and #134 merged after their applicable exact-head checks passed. #123 and #125 were closed as incompatible grouped upgrades; duplicate main-target PR #57 and superseded PR #115 are closed. Issue #114 tracks the staged Flutter/Riverpod/Google Sign-In migration. |
| ✓ | Merge the CI trigger correction, PR #126 | Refreshed head 99d475a1 passed exact-head Quality Gate and Debug APK Build; merged to RC5 as 930594ae. |
| - | Resolve remaining meaningful PRs | All five remain drafts: #90 conflicts with RC5; #99, #103 and #108 are behind RC5; #100 is stacked on #99 and has only a skipped Dependabot check, with no required Quality Gate or Debug APK result. Reconcile bases, rerun current exact-head checks, obtain independent review and complete applicable device/security acceptance before merging. |
| ✓ | Reconcile external-participant scope in canonical docs | PR #134 merged to RC5 as 39aa2587; ADR-006 and the system boundary allow signed-in, verified-email external participants in eligible event and fabrication/work-request flows while keeping public/anonymous ordering out of scope. PR #115 is closed as superseded; issues #93 and #95 remain open for contract and charter/backlog work. |
| ✓ | Reconcile the issue backlog | All 34 existing issue descriptions were refreshed; #73, #75, #76 and #109 closed against evidence. Issues #127–#132 now record missing queue, safety, attendance, reporting, notification and pilot work. |
| ✓ | Populate the live Grow Project | Project #4 has phase, priority, dependency, status and evidence fields for issue, checkpoint and PR work. Open issues remain open until their acceptance is met. |
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
