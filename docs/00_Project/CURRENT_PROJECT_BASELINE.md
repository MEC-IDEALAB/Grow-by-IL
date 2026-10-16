# Current Grow project baseline

Updated: 16 October 2026. Evidence record; not release approval.

[Repository](https://github.com/NAVANEETHVVINOD/Grow-by-IL) ·
[Live delivery Project](https://github.com/users/NAVANEETHVVINOD/projects/4) ·
[Layout/recovery](REPOSITORY_CONSOLIDATION.md).

## Repository and delivery

There is one primary application checkout, grow/. The extra directories were linked
Git worktrees, not separate app products. Unique dirty/untracked/ignored files are
privately preserved and branches retained before checkout removal. The security-advisory
repository is separate remediation work; no deletion or public disclosure is included.

main is the GitHub default; RC5 is the active product integration target. Neither is
proof of production deployment. PR #122 merged as aeeae736 after independent review
and passing applicable quality/schema/build checks. #80 was refreshed onto that base
and awaits its current build. #123/#125 closed without merge as incompatible grouped
major upgrades; #114 retains staged SDK/AGP/Kotlin/Riverpod/Google migration work.

#126 publishes the reviewed two-line stacked-base CI coverage correction. Exact-head
hosted checks precede merge; later parent/child propagation is separate acceptance.
#121 is being updated with consolidated docs; older green runs do not validate new
revisions. Final remote backup requires verified publication.

Meaningful product PRs #90/#99/#100/#103/#108/#115 retain their acceptance gates.
No Android device was connected at this audit. Build/unit success is not a real
auth/provider/backend/device journey or server authorization proof. Refresh actual
heads, checks, review and feedback before merge; the Project records later transitions.

## Product implementation boundary

Auth/profile, navigation, projects, events, lab and admin surfaces exist in RC5 or
active branches; real-environment acceptance is incomplete. Work Requests still use
a mock data source and local drafts. UI tests do not prove production persistence/RLS.
Manufacturing, queues, real inventory/borrowing, quotations/payments and operational
reports remain gated/partial. Work Request ≠ Manufacturing Task ≠ Machine Queue.
Historical ERDs are proposals; do not execute old migrations blindly.

## Recorded decisions and remaining inputs

Machine/Operations requests are separate and route to their respective heads. Both
may be cancelled directly before the head takes/reviews them; afterward the requester
supplies a reason and the head approves/denies. Pending/denied cancellation preserves
status. Operations Head approves updated stock/prices. Students request/book work;
Machine Heads operate fabrication machines. See the [current delta](../02_Product/WORK_REQUEST_CONTRACT_DELTA.md).

Still needed at dependent gates: exact V1 categories, charge/quote mapping, refund
consequences, booking/safety/concurrency rules, verified catalog/current prices and
a named pilot support/escalation owner. Do not reask settled cancellation decisions.

## Foundation gates

#88 requires live-versus-repository schema/grants/RLS/functions/migration reconciliation
and staging negative authorization tests. Historical 28P01 is not asserted as a current
verified outage. Provider/SMTP setup, Android acceptance, profile/storage privacy and
scoped position authority remain prerequisites to operational backend expansion.

Required main checks: Quality Gate (CI), Android Production Build. Required RC5 checks:
Quality Gate, Debug APK Build. Missing/failed/skipped required execution does not pass.
Independent review and applicable local/E2E evidence remain required. Cleanup does
not bypass protection, publish secrets or certify a release.
