# Current Grow project baseline

Updated: 20 October 2026. Evidence record; not release approval.

[Repository](https://github.com/NAVANEETHVVINOD/Grow-by-IL) ·
[Live delivery Project](https://github.com/users/NAVANEETHVVINOD/projects/4) ·
[Workspace record](REPOSITORY_CONSOLIDATION.md) ·
[Current task board](GROW_V1_TASK_BOARD.md).

## Repository and delivery snapshot

The primary checkout is now rooted at F:\kannan\projects\Grow; git rev-parse --show-toplevel and the Git worktree list both identify this root. The move preserved .git, .env, .local, branches and stash. One empty old grow/ directory remains because the execution policy rejected its deletion. The ignored generated targets .dart_tool, root build, supabase/.temp, and .flutter-plugins-dependencies were audited but remain because deletion was rejected. android/build/reports/problems/problems-report.html is absent from this checkout and HEAD; it was not recovered or preserved by this move. See the [workspace record](REPOSITORY_CONSOLIDATION.md).

GitHub `main` is at `3015c4ef6c6963c265fd644689fc8dd4fc2042be`; `rc5-release-candidate` is at `503db777b5f066fabac570ee08dfe2c70ef95a3c`. At this snapshot, Project #4 has 68 items: 24 Done, 6 In Progress, 7 Todo and 31 Blocked. The repository has 37 open issues and six open pull requests: product drafts #90, #99, #100, #103 and #108, plus docs-only PR #147. Narrative project docs are tracked under `docs/`. Documentation PR [#146](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/146) merged to RC5 from exact head `b40e4a7e1583bad8c3e6b2c7b606eeda2fc9a3d4` as `503db777b5f066fabac570ee08dfe2c70ef95a3c`; its Project card is Done. Exact-head Quality Gate and Debug APK Build passed in run [#39316875608](https://github.com/NAVANEETHVVINOD/Grow-by-IL/actions/runs/39316875608). Post-merge run [#39318103268](https://github.com/NAVANEETHVVINOD/Grow-by-IL/actions/runs/39318103268) also passed Quality Gate and Debug APK Build; Release APK Build was skipped and is not required. PR [#147](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/147) is open against the current RC5 base and tracked In Progress in Project #4; its current-head required checks and independent audit must pass before merge. Project #4 is the live queue for newer status.

The second Grow-named GitHub repository remains separate. A read-only comparison found unmerged changes absent from both current primary branches, and some of its unmerged history remains unaudited. Deletion is not safe until all such work is reconciled and preserved or explicitly abandoned. Sibling directories under F:\kannan\projects are separate projects and were not changed.

## Pull requests and verification

The five existing product PRs are drafts with no submitted review. None is merge-ready or proven unwanted:

| PR | Current state | Remaining gate |
| --- | --- | --- |
| [#90](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/90) | DIRTY against RC5; old CI | Resolve conflict, complete release-trust review and rerun exact-head checks. |
| [#99](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/99) | BEHIND RC5; old CI | Update base, rerun required checks, review and repeat applicable Android acceptance. |
| [#100](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/100) | Draft stacked on #99; no required CI | Review with the stack and provide current-head checks and acceptance. |
| [#103](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/103) | BEHIND RC5; old CI | Update base, rerun required checks, review and repeat applicable Android acceptance. |
| [#108](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/108) | Remote head a608aa1, BEHIND RC5; 28 September checks | Reconcile local recovery fix, update base, run current hosted checks, obtain review and complete provider/backend/device acceptance. |

Documentation PR [#146](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/146) refreshed the root README and canonical docs after PRs #144/#145 merged. It merged to RC5 from exact head `b40e4a7e1583bad8c3e6b2c7b606eeda2fc9a3d4` as `503db777b5f066fabac570ee08dfe2c70ef95a3c` after exact-head Quality Gate and Debug APK Build passed in run #39316875608 and independent read-only review found no blocker. Post-merge run #39318103268 passed those same required RC5 jobs. The PR changed documentation only; it does not change application code or approve a release.

The two Dependabot config-removal PRs are merged:

| PR | Exact head and merge commit | Verification |
| --- | --- | --- |
| [#144](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/144) | Head `1250d1f`; merge `3015c4e` to `main` | Exact-head Quality Gate, Verify Schema Contract and required Android Production Build passed. Post-merge run 39310512505 completed successfully, including Android Production Build; Schema Contract Check also passed. |
| [#145](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/145) | Head `e7ab6b2`; merge `8dc7976` to RC5 | Exact-head Quality Gate and required Debug APK Build passed. Post-merge run 39310529054 completed successfully, including Quality Gate and Debug APK Build. |

An independent read-only reviewer accepted both deletion-only diffs, exact base SHAs and supported GitHub semantics; `git diff --check` passed. GitHub review submissions were empty and branch protection required zero approvals. The exact-head required checks passed before both merges. The protected branch trees now confirm `.github/dependabot.yml` is absent from main and RC5.

For #108, the remote PR remains unchanged: its 28 September Quality Gate and Debug APK checks passed on the then-current head; Release APK and Dependabot-only checks were skipped. There is no submitted review. Local recovery hardening is saved in the fix/pr108-recovery-marker branch stash and has not been committed or pushed. On the final local snapshot, the callback guard, recovery session, router gate and reset-password suites passed 27/27, 10/10, 13/13 and 11/11 (61 tests total); targeted analysis of 11 files found no issues, formatting and git diff --check passed, and independent review accepted the malformed-preference cleanup ordering. These are local results, not hosted PR checks. Android device E2E and provider/backend acceptance remain unverified.

No open product PR was closed as unwanted: the current audit did not prove any of the five existing product PRs disposable. Config-removal PRs #144 and #145 were merged after exact-head required checks and independent review. The five existing product PRs remain blocked by their recorded checks, review and product-acceptance gates.

## Dependabot state

The `.github/dependabot.yml` file is absent from main and RC5 after PRs #144 and #145 merged. Repository vulnerability alerts, security-update PRs and automated security fixes are disabled. The repository-managed Dependabot Auto-Merge and Review Gate workflows are manually disabled; normal Grow CI and Schema Contract Check remain enabled. Secret scanning and push protection remain enabled.

GitHub still lists its generated Dependabot Updates workflow (ID 273755587) as active. Attempts to disable it returned HTTP 422. GitHub's [Dependabot on GitHub Actions documentation](https://docs.github.com/en/code-security/concepts/supply-chain-security/dependabot-on-actions) explains that each Dependabot job uses a dynamic workflow that is not stored under `.github/workflows`, and Dependabot jobs bypass Actions policy or disablement while Dependabot remains enabled. The active listing is therefore consistent with the platform model; it does not prove that repository update configuration remains or that no future update job will run. The latest successful dynamic runs were on 17 October, before the configuration merges; no run appears after the 19 October merges as of the 20 October query. Issue [#143](https://github.com/NAVANEETHVVINOD/Grow-by-IL/issues/143) remains open until the next weekly cycle and any residual behavior is recorded. Post-merge Android builds passed in main run #39310512505 and RC5 runs #39310529054 and #39318103268.

## Product and technical boundaries

Auth/profile, navigation, projects, events, Lab and admin surfaces exist in RC5 or active branches. Real-environment acceptance remains incomplete. Work Requests still use a mock data source and local drafts. A passing unit/widget suite or APK build does not establish production persistence, RLS, provider configuration, or an Android user journey.

Manufacturing, queues, real inventory/borrowing, quotes/payments and operational reports remain gated or partial. Work Request, Manufacturing Task and Machine Queue are separate concepts. Historical ERDs are proposals; do not execute old migrations blindly.

Still needed before dependent implementation: exact V1 Work Request categories; quote/charge mapping; cancellation/refund consequences; booking, safety and concurrency rules; an owner-verified equipment catalog and approved price source; and a named pilot support/escalation owner. Existing cancellation-routing decisions remain settled.

Issue #88 requires live-versus-repository schema, grants, RLS, functions and migration reconciliation, followed by staging negative-authorization tests. Issue #112 records Google sign-in disabled in the validation project. No AVD or Android device was available for this acceptance run; no app was installed or launched. Provider/email setup, Android acceptance, profile/storage privacy and scoped position authority remain prerequisites to operational backend expansion.

Main requires Quality Gate (CI) and Android Production Build. RC5 requires Quality Gate and Debug APK Build. Missing, failed or skipped required execution does not pass. No cleanup or documentation change approves a release or production backend write.
