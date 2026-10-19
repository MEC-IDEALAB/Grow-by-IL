# Current Grow project baseline

Updated: 20 October 2026. Evidence record; not release approval.

[Repository](https://github.com/NAVANEETHVVINOD/Grow-by-IL) ·
[Live delivery Project](https://github.com/users/NAVANEETHVVINOD/projects/4) ·
[Workspace record](REPOSITORY_CONSOLIDATION.md) ·
[Current task board](GROW_V1_TASK_BOARD.md).

## Repository and delivery snapshot

The primary checkout is now rooted at F:\kannan\projects\Grow; git rev-parse --show-toplevel and the Git worktree list both identify this root. The move preserved .git, .env, .local, branches and stash. One empty old grow/ directory remains because the execution policy rejected its deletion. The ignored generated targets .dart_tool, root build, supabase/.temp, and .flutter-plugins-dependencies were audited but remain because deletion was rejected. android/build/reports/problems/problems-report.html is absent from this checkout and HEAD; it was not recovered or preserved by this move. See the [workspace record](REPOSITORY_CONSOLIDATION.md).

GitHub main is at 0a1020952c157e89193f9498b4493efe8dfd6ee7; rc5-release-candidate is at 6bc9c43fbc626026bc67e5fc6c684886fff946e9. The local documentation branch is based on the RC5 head. Project #4 has 66 items: 21 Done, 7 In Progress, 7 Todo and 31 Blocked. The repository has 37 open issues and seven open pull requests: five product drafts (#90, #99, #100, #103, #108) and two Dependabot config-removal PRs (#144, #145).

The second Grow-named GitHub repository is retained. Its separate PR #2 contains unreconciled authentication work that has not been proven redundant or safely integrated. Do not delete it until its unique work is reconciled or explicitly abandoned. Sibling directories under F:\kannan\projects are separate projects and were not changed.

## Pull requests and verification

The five existing product PRs are drafts with no submitted review. None is merge-ready:

| PR | Current state | Remaining gate |
| --- | --- | --- |
| [#90](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/90) | DIRTY against RC5; old CI | Resolve conflict, complete release-trust review and rerun exact-head checks. |
| [#99](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/99) | BEHIND RC5; old CI | Update base, rerun required checks, review and repeat applicable Android acceptance. |
| [#100](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/100) | Stacked on #99; no required CI | Review with the stack and provide current-head checks and acceptance. |
| [#103](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/103) | BEHIND RC5; old CI | Update base, rerun required checks, review and repeat applicable Android acceptance. |
| [#108](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/108) | Remote head a608aa1, BEHIND RC5; 28 September checks | Reconcile local recovery fix, update base, run current hosted checks, obtain review and complete provider/backend/device acceptance. |

The two Dependabot config-removal PRs are open, each against its intended current base:

| PR | Exact head and required checks | Remaining gate |
| --- | --- | --- |
| [#144](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/144) | Head 1250d1f; Quality Gate (CI) and Verify Schema Contract passed | Required Android Production Build was still running at latest check. |
| [#145](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/145) | Head e7ab6b2; Quality Gate passed; Release APK Build skipped | Required Debug APK Build was still running at latest check. |

An independent read-only reviewer accepted both deletion-only diffs, exact base SHAs and supported GitHub semantics; `git diff --check` passed. GitHub review submissions are empty and branch protection requires zero approvals. Do not merge until all exact-head required checks pass.

For #108, the remote PR remains unchanged: its 28 September Quality Gate and Debug APK checks passed on the then-current head; Release APK and Dependabot-only checks were skipped. There is no submitted review. Local recovery hardening is saved in the fix/pr108-recovery-marker branch stash and has not been committed or pushed. On the final local snapshot, the callback guard, recovery session, router gate and reset-password suites passed 27/27, 10/10, 13/13 and 11/11 (61 tests total); targeted analysis of 11 files found no issues, formatting and git diff --check passed, and independent review accepted the malformed-preference cleanup ordering. These are local results, not hosted PR checks. Android device E2E and provider/backend acceptance remain unverified.

No open PR was closed as unwanted: the current audit did not prove any of the five existing product PRs disposable. The two config-removal branches were pushed and PRs #144/#145 were opened; neither had merged at the latest check. The five existing product PRs remain blocked by their recorded checks, review and product-acceptance gates.

## Dependabot state

The remote configuration on main and RC5 has valid GitHub Actions, Pub and Gradle entries with open-pull-requests-limit: 0; routine version-update PRs are suppressed for those ecosystems. PRs #144 and #145 delete `.github/dependabot.yml` from their respective branches using GitHub's documented control to disable version updates entirely. Repository vulnerability alerts, security-update PRs and automated security fixes are disabled. The repository-managed Dependabot Auto-Merge and Review Gate workflows are disabled; normal Grow CI and Schema Contract Check remain enabled.

GitHub still lists its generated Dependabot Updates workflow (ID 273755587) as active. Attempts to disable it returned HTTP 422. Its newest visible runs were on 17 October, before the configuration merges; no later run appeared in the 20 October query. This observed absence does not prove the generated workflow is disabled. Issue [#143](https://github.com/NAVANEETHVVINOD/Grow-by-IL/issues/143) tracks the residual state.

## Product and technical boundaries

Auth/profile, navigation, projects, events, Lab and admin surfaces exist in RC5 or active branches. Real-environment acceptance remains incomplete. Work Requests still use a mock data source and local drafts. A passing unit/widget suite or APK build does not establish production persistence, RLS, provider configuration, or an Android user journey.

Manufacturing, queues, real inventory/borrowing, quotes/payments and operational reports remain gated or partial. Work Request, Manufacturing Task and Machine Queue are separate concepts. Historical ERDs are proposals; do not execute old migrations blindly.

Still needed before dependent implementation: exact V1 Work Request categories; quote/charge mapping; cancellation/refund consequences; booking, safety and concurrency rules; an owner-verified equipment catalog and approved price source; and a named pilot support/escalation owner. Existing cancellation-routing decisions remain settled.

Issue #88 requires live-versus-repository schema, grants, RLS, functions and migration reconciliation, followed by staging negative-authorization tests. Issue #112 records Google sign-in disabled in the validation project. No AVD or Android device was available for this acceptance run; no app was installed or launched. Provider/email setup, Android acceptance, profile/storage privacy and scoped position authority remain prerequisites to operational backend expansion.

Main requires Quality Gate (CI) and Android Production Build. RC5 requires Quality Gate and Debug APK Build. Missing, failed or skipped required execution does not pass. No cleanup or documentation change approves a release or production backend write.
