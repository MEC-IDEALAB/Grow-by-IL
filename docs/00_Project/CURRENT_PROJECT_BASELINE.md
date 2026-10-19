# Current Grow project baseline

Updated: 20 October 2026. Evidence record; not release approval.

[Repository](https://github.com/NAVANEETHVVINOD/Grow-by-IL) ·
[Live delivery Project](https://github.com/users/NAVANEETHVVINOD/projects/4) ·
[Workspace record](REPOSITORY_CONSOLIDATION.md) ·
[Current task board](GROW_V1_TASK_BOARD.md).

## Repository and delivery snapshot

The primary checkout is now rooted at F:\kannan\projects\Grow; git rev-parse --show-toplevel and the Git worktree list both identify this root. The move preserved .git, .env, .local, branches and stash. One empty old grow/ directory remains because the execution policy rejected its deletion. The ignored generated targets .dart_tool, root build, supabase/.temp, and .flutter-plugins-dependencies were audited but remain because deletion was rejected. android/build/reports/problems/problems-report.html is absent from this checkout and HEAD; it was not recovered or preserved by this move. See the [workspace record](REPOSITORY_CONSOLIDATION.md).

GitHub `main` is at `3015c4ef6c6963c265fd644689fc8dd4fc2042be`; `rc5-release-candidate` is at `ef14bf3e5e2d20f3c9b76a05d4b49f787d12b58d`. Project #4 has 68 items: 25 Done, 5 In Progress, 7 Todo and 31 Blocked. The repository has 37 open issues and five open product pull requests: #90, #99, #100, #103 and #108. Narrative project docs are tracked under `docs/`. Documentation PRs #146, #147 and #148 are merged to RC5; their exact-head and post-merge verification is recorded below. Project #4 is the live queue for newer status.

The private secondary repository `NAVANEETHVVINOD/Grow-by-IL-ghsa-fgf9-xx2v-57qp` has 29 refs (21 branches, 5 tags, 3 pull-request refs) and two PRs. All tags match primary; 14 branch heads match, older main/RC5 heads are ancestors, and other non-security histories are represented in primary (#80/#90/#103). Its only unique content is a four-commit security series shared by closed-unmerged PR #1 and open PR #2; their patch IDs match. The migration, pgTAP tests and ledger are absent from primary main and RC5. PR #2 targets stale history, expects a different role/membership schema, has no hosted checks or submitted review, and pauses join/transfer flows. Do not port it as-is. Retain the repository until the security fix is adapted to the confirmed schema and passes current primary gates, or is preserved in a verified owner-approved private archive; confirm GHSA retention requirements before deletion. Sibling directories under F:\kannan\projects are separate projects and were not changed.

## Pull requests and verification

The five existing product PRs are drafts with no submitted review. None is merge-ready or proven unwanted:

| PR | Current state | Remaining gate |
| --- | --- | --- |
| [#90](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/90) | Conflicting; 27 commits behind RC5; no submitted review. Prior required checks are from 25 Sep and stale. | Resolve conflicts, review redundant Dependabot overlap while preserving unique release/docs gates, rerun current checks and obtain independent review. |
| [#99](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/99) | 1 ahead / 27 behind RC5; draft, no review; prior required checks are from 16 Sep. | Reconcile base and deleted Akathalam/workflow scope, rerun checks, review and repeat navigation/auth/deep-link/offline Android acceptance. |
| [#100](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/100) | Stacked on #99; 2 ahead / 27 behind RC5; required checks absent. | Wait for #99 acceptance, update the stack, pass Quality Gate and Debug APK, obtain review and repeat applicable Android acceptance. |
| [#103](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/103) | 2 ahead / 27 behind RC5; draft, no review; prior required checks are from 25 Sep. | Reconcile base, rerun current checks, review independently and complete Android profile/privacy acceptance. |
| [#108](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/108) | Remote head a608aa1; 18 ahead / 27 behind RC5; draft, no review; prior required checks are from 28 Sep. | Reconcile the local recovery patch in stash@{1}, update base, run current hosted checks, review and complete provider/backend/device acceptance. |

Documentation PR [#146](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/146) refreshed the root README and canonical docs after PRs #144/#145 merged. It merged to RC5 from exact head `b40e4a7e1583bad8c3e6b2c7b606eeda2fc9a3d4` as `503db777b5f066fabac570ee08dfe2c70ef95a3c` after exact-head Quality Gate and Debug APK Build passed in run #39316875608 and independent read-only review found no blocker. Post-merge run #39318103268 passed those same required RC5 jobs. Documentation PR [#147](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/147) merged as `9233e02ffdf0c6f773b67c4d3ab1cd6f8fe003e3` from exact head `562fa0f4d053986588cb15662db4838af2483850`; its exact-head Quality Gate and Debug APK Build passed in run #39320508110, and independent audit found no blocker. Post-merge run #39321857192 passed both required jobs; Release APK Build was skipped and is not required. Documentation PR [#148](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/148) then merged to RC5 as `ef14bf3e5e2d20f3c9b76a05d4b49f787d12b58d` from exact head `47df5cfdd9a8298038ffe53938ff2294e108ff8d`. Exact-head Quality Gate and Debug APK Build passed in #39323517381, independent review found no blocker, and post-merge run #39324673949 passed both required jobs; Release APK Build was skipped and is not required. These PRs changed documentation only; they do not change application code or approve a release.

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

Issue #88 requires live-versus-repository schema, grants, RLS, functions and migration reconciliation, followed by staging negative-authorization tests. Static RC5 review identified conditional high-severity authorization candidates, but active grants/policies remain unverified; these are not confirmed production exploits. The private secondary PR #2 is schema-incompatible and not merge-ready. No production migration is authorized. Issue #112 records Google sign-in disabled in the validation project. No AVD or Android device was available for this acceptance run; no app was installed or launched. Provider/email setup, Android acceptance, profile/storage privacy and scoped position authority remain prerequisites to operational backend expansion.

Main requires Quality Gate (CI) and Android Production Build. RC5 requires Quality Gate and Debug APK Build. Missing, failed or skipped required execution does not pass. No cleanup or documentation change approves a release or production backend write.
