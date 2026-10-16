# P0-03 CI and PR investigation

Status: Original diagnosis accepted; follow-up local CI trigger correction verified; remote CI problems remain open
Owner: Project coordinator, evidence explorer, PR auditor and security/evidence reviewer
Version: 1.1
Last updated: 2026-10-03
Depends on: [Current baseline](../00_Project/CURRENT_PROJECT_BASELINE.md)
Referenced by: [Single delivery board](../00_Project/GROW_V1_TASK_BOARD.md)

## Scope and completion meaning

The original P0-03 pass completed the requested investigation. Only the existing board
and evidence documents are edited locally. No application/product behavior, dependency,
workflow, PR, branch protection or production database is changed. No push, merge,
rerun, retarget or deployment is performed. Missing/failed/skipped required verification
remains a failure. The native goal tracks this investigation; the board shows live markers.

The later user-requested agent-orchestrator continuation prepared the narrowly scoped
local correction recorded below. Statements about no workflow edit above describe the
original investigation snapshot; current local preparation has its own exact evidence.

## Current verified state

Fresh GitHub CLI/API reads on October 3 confirm:

| Surface | Exact state |
| --- | --- |
| GitHub default main | `1041099156cf33a865e9b5d0ea30e25540e7bd46`; deployed production status not verified |
| Active product integration RC5 | `2fafcf2a7b41f3bb26df9db8200f4e8316a311ee` |
| main versus RC5 | RC5 ahead 16 / behind 0; 113 changed files |
| Relevant open work | 11 open PRs; each has zero submitted reviews |
| Mergeability | All 11 report MERGEABLE; #123/#124 BLOCKED by checks; others CLEAN at query |
| main protection | Strict, admins enforced, no force pushes; Quality Gate (CI) + Android Production Build; zero required approvals |
| RC5 protection | Strict, admins enforced, no force pushes; Quality Gate + Debug APK Build; zero required approvals; conversation resolution required |

Draft/CLEAN/MERGEABLE are not release approval. Parent/child branch protection differs;
the quality/build names above are the eventual integration acceptance contract, not a
claim that feature-branch bases currently enforce the same requirements. Current AGENTS
requires independent review before merging; no merge is part of this pass.

## Four diagnosed problems

| PR | Head / base | Current problem | Proven cause | Dependency | Fix ownership / risk |
| --- | --- | --- | --- | --- | --- |
| [#100](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/100) | `ed37a92d601c9ee6efb03fc951463a15058f8c23` / `feat/home-lab-profile-navigation` | Quality/debug absent; only skipped label check | Quality workflow excludes feature-branch PR bases and child push branch. Label job accepts Dependabot only. | #99 first | Workflow coverage belongs in common CI, or retarget/rebase after authorized parent integration. Risk: misattributed parent changes after squash merge. |
| [#115](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/115) | `d3809fc8556660083f2e36e5af6a922cc86a68f2` / `chore/production-hardening` | Zero checks/runs | Same excluded base/push filters; parent #90 also removes the incidental Dependabot label workflow. | #90 first | Resolve parent governance/doc overlap first; common CI coverage or later parent integration/child reconciliation. Risk: wrong documentation paths and false verification. |
| [#123](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/123) | `6f856183211fb93024a535b1841c8a08c3b9362d` / main | Android Production Build failure | AGP 9 built-in Kotlin conflicts with app's retained legacy kotlin-android plugin, while Flutter remains 3.41.9. | Independent toolchain work | Restore existing toolchain first; separate AGP/SDK migration. Risk: Android/plugin compatibility and runtime regressions. |
| [#124](https://github.com/NAVANEETHVVINOD/Grow-by-IL/pull/124) | `99f4d4e30c3bc0f7aa233a63523e28b562ac58fc` / main | Quality Gate dependency resolution failure; build skipped | Dart 3.11.5 cannot resolve riverpod_lint 3.1.9, requiring Dart >=3.13.0-0. Group contains other SDK/API major changes. | Independent Pub/SDK work | Split compatible dependency updates from major SDK/API migrations. Risk: provider lifecycle, code generation and Google auth changes. |

### #100 and #115: event/base selection

At the exact parent heads, [CI trigger lines 4–13](https://github.com/NAVANEETHVVINOD/Grow-by-IL/blob/772e808cb1974fad497d30782a62febae302287f/.github/workflows/ci.yml#L4)
allow PR bases and push branches only `main`, `develop`, `rc5-release-candidate`.
Neither child target is included. There is no draft exclusion in quality CI.

[#100's run 35126170965](https://github.com/NAVANEETHVVINOD/Grow-by-IL/actions/runs/35126170965)
is the label workflow. Its [actor condition](https://github.com/NAVANEETHVVINOD/Grow-by-IL/blob/772e808cb1974fad497d30782a62febae302287f/.github/workflows/dependabot-review.yml#L15)
skips non-Dependabot jobs. #90 deletes that workflow, so #115 has no incidental label run.

Exact ancestry comparisons show:

| Comparison | Ahead / behind | Interpretation |
| --- | --- | --- |
| RC5 → #99 `772e808cb1974fad497d30782a62febae302287f` | 1 / 0 | Parent contains current RC5 |
| #99 → #100 | 1 / 0 | Child contains current parent |
| RC5 → #90 `13d9d96d44489b3250431f9583d630b91b6f935a` | 4 / 0 | Parent contains current RC5 |
| #90 → #115 | 2 / 0 | Child contains current parent |

There is no observed stale-parent/conflict explanation. #99 changes seven navigation
files; #100 changes one Home file. #90 changes 25 hardening/tooling/governance paths;
#115 changes two governance documents. These are coherent stacks, not duplicate PRs.

#90 relocates required root governance files into `docs/governance/`. Correct this in
the parent under the current required-entry policy, preserving useful docs/history.
#115 assumes those paths. Reconcile #90's documentation work with #121 before integration.
Do not combine all four PRs or retarget children blindly.

Manual dispatch is insufficient whole-PR guard evidence: [CI lines 64–74](https://github.com/NAVANEETHVVINOD/Grow-by-IL/blob/13d9d96d44489b3250431f9583d630b91b6f935a/.github/workflows/ci.yml#L64)
fall back to the last commit when no PR/push range is supplied. #115 has two commits.
Retain architecture/schema/secret guards and test the true PR merge-base range.

### #123: exact failed Android boundary

[Run 37092584609 / job 111116275447](https://github.com/NAVANEETHVVINOD/Grow-by-IL/actions/runs/37092584609/job/111116275447)
fails applying `kotlin-android`. The log identifies AGP 9 built-in Kotlin as incompatible
with that legacy plugin. The executed merge was `e54f5baa6388082b0c2d60bde27ecdf63b2bade1`,
combining head `6f856183211fb93024a535b1841c8a08c3b9362d` with base
`1041099156cf33a865e9b5d0ea30e25540e7bd46`. Source links below pin the PR head;
the job tested this merge revision. Quality Gate and Schema Contract passed.
`Build APK (Release)` failed; `Upload Artifact` and the separate `GitHub Release` job
were skipped. The release-build failure itself was not skipped.

| File at exact head | Base → proposed |
| --- | --- |
| [android/settings.gradle.kts:22](https://github.com/NAVANEETHVVINOD/Grow-by-IL/blob/6f856183211fb93024a535b1841c8a08c3b9362d/android/settings.gradle.kts#L22) | AGP 8.11.1 → 9.4.1 |
| Same file, line 23 | KGP 2.3.21 → 2.4.20 |
| [android/gradle/wrapper/gradle-wrapper.properties:5](https://github.com/NAVANEETHVVINOD/Grow-by-IL/blob/6f856183211fb93024a535b1841c8a08c3b9362d/android/gradle/wrapper/gradle-wrapper.properties#L5) | Gradle 8.14 → 9.8.0 |
| [android/build.gradle.kts:2](https://github.com/NAVANEETHVVINOD/Grow-by-IL/blob/6f856183211fb93024a535b1841c8a08c3b9362d/android/build.gradle.kts#L2) | Google Services 4.4.2 → 4.5.0 |
| [android/app/build.gradle.kts:3](https://github.com/NAVANEETHVVINOD/Grow-by-IL/blob/6f856183211fb93024a535b1841c8a08c3b9362d/android/app/build.gradle.kts#L3) | Legacy kotlin-android plugin remains |
| [.github/workflows/ci.yml:51](https://github.com/NAVANEETHVVINOD/Grow-by-IL/blob/6f856183211fb93024a535b1841c8a08c3b9362d/.github/workflows/ci.yml#L51) | Flutter remains 3.41.9 |

[Android migration documentation](https://developer.android.com/build/migrate-to-built-in-kotlin)
supports the observed collision. [Flutter's migration guide](https://docs.flutter.dev/release/breaking-changes/migrate-to-built-in-kotlin/for-app-developers)
places AGP 9 legacy compatibility at Flutter 3.44 and built-in Kotlin support at 3.47.
Deleting one plugin line is not an evidenced complete migration on Flutter 3.41.9.
[Kotlin compatibility guidance](https://kotlinlang.org/docs/gradle-configure-project.html)
also places the proposed Gradle/AGP versions outside KGP 2.4.20's fully supported range;
this is a secondary migration risk, not the demonstrated failure cause.

### #124: dependency resolution fails before tests

[Run 37092839257 / job 111116631027](https://github.com/NAVANEETHVVINOD/Grow-by-IL/actions/runs/37092839257/job/111116631027)
tests merge `50cb13aab459f2711c7a866118674976f01d7275` from head `99f4d4e…`
and main `1041099…`. Dependency Integrity fails at `flutter pub get`: Dart 3.11.5
versus `riverpod_lint 3.1.9` requiring `>=3.13.0-0 <4.0.0`. The following lockfile
comparison, analyzer, format, unit tests and Android build do not execute successfully.

Pinned [workflow lines 24–31](https://github.com/NAVANEETHVVINOD/Grow-by-IL/blob/99f4d4e30c3bc0f7aa233a63523e28b562ac58fc/.github/workflows/ci.yml#L24)
use Flutter 3.41.9. [pubspec.yaml:65](https://github.com/NAVANEETHVVINOD/Grow-by-IL/blob/99f4d4e30c3bc0f7aa233a63523e28b562ac58fc/pubspec.yaml#L65)
requests the incompatible lint package. Official package metadata independently shows:

| Proposed package | SDK requirement |
| --- | --- |
| [riverpod_lint 3.1.9](https://pub.dev/api/packages/riverpod_lint/versions/3.1.9) | Dart >=3.13.0-0 <4.0.0 |
| [flutter_riverpod 3.4.3](https://pub.dev/api/packages/flutter_riverpod/versions/3.4.3) | Dart ^3.12.0 |
| [riverpod_annotation 4.0.7](https://pub.dev/api/packages/riverpod_annotation/versions/4.0.7) | Dart ^3.12.0 |
| [riverpod_generator 4.0.9](https://pub.dev/api/packages/riverpod_generator/versions/4.0.9) | Dart ^3.12.0 |
| [cupertino_icons 2.0.0](https://pub.dev/api/packages/cupertino_icons/versions/2.0.0) | Dart ^3.12.0 |
| [google_fonts 9.0.0](https://pub.dev/api/packages/google_fonts/versions/9.0.0) | Dart ^3.13.0; Flutter >=3.47.0 |

The lockfile SDK footer does not prove compatibility with these new selections.
An SDK bump alone is insufficient: pinned source still uses `StateNotifierProvider`
through the main Riverpod import, old observer signatures, and pre-7 Google Sign-In
construction/signIn/authentication APIs. See [Riverpod's migration guide](https://riverpod.dev/docs/3.0_migration)
and [Google Sign-In package guidance](https://pub.dev/packages/google_sign_in/versions/7.2.0).
These are additional source migration requirements, not failures observed after the
solver stopped. Separate them from the confirmed dependency-resolution cause.

## Exact fix plan for a later authorized implementation

1. **Shared stacked-PR CI coverage.** If checks must run before parent integration,
   prepare a separate workflow-only change permitting the known stacked bases (or all
   PR bases after explicit policy review). Keep current quality/build names, minimal
   permissions and all architecture/schema/secret steps. Test trigger selection and
   full merge-base range, including a two-commit child with a gated earlier change.
   A change only on RC5 does not update a child's inherited workflow automatically:
   after authorized publication, reconcile that common CI commit into BOTH parents
   (#90 `chore/production-hardening`, #99 `feat/home-lab-profile-navigation`), then
   BOTH children (#115 `docs/reconcile-external-access`, #100 `fix/home-unverified-content`).
   Preserve #90's existing release-hardening workflow edits during reconciliation.
   A new authorized head update generates a `pull_request` synchronize event; inspect
   its fresh merge ref and complete PR-range checks. A base-only retarget is not assumed
   to run the default event types: ensure a supported fresh PR event, or separately
   review adding the edited event. Verify workflow content/event on each revision.
   Recheck independent review and local QA
   for every changed head; obtain remote-mutation authority before these operations.
   Never bypass guards per child. File: `.github/workflows/ci.yml`; no product behavior.
   Event/base semantics follow [GitHub's workflow event reference](https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows#pull_request).
2. **#123 narrow toolchain correction.** Restore the four bundled version changes in
   `android/settings.gradle.kts`, `android/gradle/wrapper/gradle-wrapper.properties`
   and `android/build.gradle.kts` to the current baseline before separately evaluating
   Google Services. A full AGP 9 migration is separate SDK/plugin work.
3. **#124 compatible dependency correction.** Split/defer incompatible SDK targets and
   behavior-changing majors in `pubspec.yaml`/`pubspec.lock`. Resolve using the existing
   pinned CI SDK and require a clean lockfile comparison. Review Pub wildcard grouping
   in `.github/dependabot.yml` separately; use issue #114 for the staged major migration.
4. **Parent stack acceptance.** Fix #90's required-entry location/doc overlap in #90;
   review/test #99's navigation. After separately authorized parent integration,
   rebase/retarget children one stack at a time, accounting for squash ancestry, then
   require fresh PR-event quality/debug checks on the revised children.
5. **Actual verification.** On any implemented change, run applicable current-source
   local checks and independent review. Application/dependency changes also require
   the relevant backend/device journeys before a code push under current instructions.
   Then publish only when explicitly authorized, and inspect actual hosted runs on
   the new head. No existing green result validates an unimplemented fix.

Suggested execution order: shared CI coverage → independent #123/#124 corrections →
#90→#115 and #99→#100 as separate stacks. There is no dependency ordering between
#123 and #124. Main-target toolchain/dependency work must not accidentally inherit RC5
product commits or a new production-config claim.

## Main/RC5 and duplicates

Main is the current GitHub default branch; RC5 is the target of active product PRs.
Release workflows target main, but deployed production status is not established here.
RC5 has profile/offline-sync work, local fonts/startup changes, Work Request shell/
create/dashboard/detail/timeline and governance/CI changes beyond main. These remain
release-candidate work until integrated acceptance, security and device gates pass.

Auth #108, navigation #99/#100, identity #103, hardening #90, external-access #115 and
docs #121 exist only on their PR branches relative to their targets. They must be
reviewed/integrated as coherent slices before eventual RC5 promotion to main. This
investigation does not promote RC5 or declare a production-ready branch.

No duplicate among the four investigated PRs is established. #90/#121 documentation
overlap needs reconciliation, not automatic closure. Historical #57 is closed and #56
merged; neither is an active repair task. The September 14 RC5→integration-context
guard failure at [run 34808903767](https://github.com/NAVANEETHVVINOD/Grow-by-IL/actions/runs/34808903767)
is historical at the unchanged RC5 SHA. No currently open RC5→main PR exists. It must
be understood before future promotion, not presented as a current child PR failure.

## #121 publication readiness

Current remote #121 head remains `b8b4ecfd42232417ef9809fdb9b4ad4e0fbfabba`, targeting
RC5, draft/MERGEABLE/CLEAN. Its Quality Gate and Debug APK checks passed in run
36523509640 on that revision. Those checks do not cover local preservation commit
`e90e0a8ff346f6e2cb33ad8a3bbf9d6cbd0026d1` or this investigation's later edits.

Local preservation is exactly one commit ahead of #121 and changes only `.gitignore`
and Markdown docs. `git merge-base --is-ancestor b8b4ecf e90e0a8` returned 0;
`git rev-list --count b8b4ecf..e90e0a8` returned 1. A fast-forward reconciliation is
possible if the remote head remains unchanged. Preserve dirty launch-plan originals.
No force push, duplicate PR or branch reset is needed. Final investigation edits must
also be reviewed/committed locally before an authorized publication.

Required future authority: permission to push the reviewed docs commits to the existing
`docs/v1-execution-20260928` branch and update #121. Merge permission is separate.
Refresh head, independently review the exact complete docs diff, check private-record
exclusions, publish only with explicit authority, then verify remote SHA and hosted CI.
Off-machine backup remains unverified; ignored private records require their own
owner-approved private backup destination.

## Exact next security action and current blocker

Repository source still uses `student`, `lab_admin`, `super_admin` compatibility roles
(`lib/core/constants/app_roles.dart:10–11,36`). Client self-selection is student-only;
that is not proof of server-enforced role protection. Project membership uses direct
client table operations (`lib/features/projects/data/project_repository.dart:142–153`),
so deployed policy/privileged-function/grant evidence is required before acceptance.
The role/position and backend contracts remain reviewed-decision gates, not deployments.

[Issue #88](https://github.com/NAVANEETHVVINOD/Grow-by-IL/issues/88#issuecomment-5830317612)
last records September 25 catalog reads blocked by database authentication `28P01`.
This pass does not retry production reads; it cannot assert that error still occurs.
Live-versus-repository reconciliation and remediation deployment remain unverified.

Next P1-01 task: confirm the intended read-only connection/environment, restore connector
authentication if needed, then inventory table/column constraints, RLS/policies, table/
column grants, privileged functions/search paths/EXECUTE grants, triggers and migration
ledger without user rows or credential output. Compare the inventory with the exact
private remediation/source revisions; run role/membership allow/deny tests against a
production-faithful non-production baseline. Independent security review and migration/
rollback approval precede any production deployment. Do not run old migrations blindly.

This plan follows [Supabase RLS guidance](https://supabase.com/docs/guides/database/postgres/row-level-security)
and [function security guidance](https://supabase.com/docs/guides/database/functions).
No live protection or privileged access is declared verified from client code or docs.

## User action, autonomous work and exact next task

No additional business answers are required for this diagnosis. Later actions require
explicit choice/authorization of the scoped CI/dependency correction plan; each push,
PR mutation, merge or production change has its own requested scope. Docs publication
is still withheld under the handoff. Connector refresh and a real test backend/device
are needed when the security/auth acceptance slice reaches those dependencies.

Without user action, this pass can finish read-only evidence review, current-source
comparison, board/report QA and local documentation commit. It cannot restore hosted
CI without changing/publishing source, and no remote write is authorized here.

Exact next engineering task after authorization: prepare a workflow-only stacked-base
trigger correction, preserving all guards, with a deterministic trigger/range regression
check. Before any change, rerun the read-only current PR/head query:

```powershell
gh pr view 100 --repo NAVANEETHVVINOD/Grow-by-IL --json headRefOid,baseRefName,statusCheckRollup
```

## Evidence commands and verification limits

- `gh pr list/view`, `gh api .../branches/.../protection`, `gh api .../pulls/.../reviews`:
  refreshed exact heads, bases, checks, mergeability/protection and zero reviews.
- `gh api .../compare/<parent>...<child>`: parent/child ahead/behind proof and changed scope.
- `gh run view` / job APIs / narrowly redacted failed logs: exact executed failures.
- Pinned GitHub source and official package manifests/docs: trigger filters and SDK/API
  requirements. No package archives were downloaded.
- Coordinator's current-head quality/build assertion read all four PRs and exited 2:
  four missing checks, two failed checks and one skipped build = seven non-success
  outcomes. This deliberately reproduces the reported verification problem.
- Local commit ancestry/path checks: docs-only, fast-forward reconciliation candidate.
- No local Flutter, Gradle, device or database tests run; no fix or hosted rerun claimed.
  Current report/board/baseline local links, scope and whitespace checks passed.
- Independent cross-review verified other agents' diagnoses from source/job evidence.
  Corrections clarified #123's executed merge SHA and failed/skipped step distinction,
  both parent/child workflow propagation with fresh PR events, and main's default-branch
  designation without an unsupported production implication. Corrections were accepted
  by the reviewers. No reviewer is counted as independent review of its own findings.

## Follow-up: local workflow correction

The coordinator ran the agent-orchestrator decision → implementation → actual QA →
independent review loop. Two agents independently selected a workflow-only correction
as the smallest next slice; dependency/toolchain and production work stayed separate.

Base: RC5 `2fafcf2a7b41f3bb26df9db8200f4e8316a311ee`, freshly checked on GitHub.
Isolated branch: `fix/stacked-pr-ci-20261003`, worktree `grow-stacked-ci`.
Local commit: `6bdbd319907b42d4c06b523152dccef901fa5805`.
The exact diff is one file, two insertions in `.github/workflows/ci.yml`:

```yaml
      - feat/home-lab-profile-navigation
      - chore/production-hardening
```

These are added to `pull_request.branches`. Default PR activity types are retained.
Push/tag filters, all jobs/steps, permissions, guard logic, secrets and build behavior
are unchanged. No dependency or application file changed. Original dirty worktrees
and the docs preservation branch were preserved.

Actual local QA:

- Before correction, an assertion against the original parsed workflow failed because
  both stacked bases were absent. This reproduces the demonstrated coverage defect.
- After correction, nine event/base cases passed: the five allowed bases, supported
  synchronize/reopened examples, unknown-base rejection and default edited exclusion.
- YAML parsed using existing PyYAML 6.0.2. Semantic comparison, normalizing only the
  two intentional additions, matched the complete baseline workflow exactly.
- `C:\Git\bin\bash.exe -n` accepted all 13 workflow shell blocks after replacing
  GitHub expressions with safe syntax-fixture values.
- The actual extracted architecture guard executed in two owned temporary Git fixtures
  with real two-commit children and PR-style merge commits. A gated migration in the
  first child commit was caught (expected exit 1); a clean two-commit child passed
  (exit 0). A gated migration introduced only on the base was excluded in both cases.
- An initial harness comparison failed because Windows default decoding misread UTF-8
  source. Explicit UTF-8 decoding fixed the harness; the complete QA then passed.
  No workflow was changed to suppress that failure.
- `git diff --check`, staged whitespace, one-file/two-insertion scope and clean local
  CI checkout passed. Three independent code/security reviews accepted the actual diff;
  all applicable local QA conditions were satisfied.

No Flutter/backend/device checks were run for this trigger-only change; application
acceptance is not cleared. No new packages/tools were installed. Owned temporary QA
fixtures were cleaned within their checked temporary directory. Hosted CI has not run
on this local commit; #100/#115 therefore remain unverified remotely.

Next gate: explicit permission to push this exact local branch and open a separate
workflow-only draft PR targeting RC5. Then inspect real PR-event CI on the resulting
head/merge revision. Later authorized propagation must reach BOTH parent/child stacks,
preserve #90 hardening and satisfy each affected head's local review/QA/E2E contract.
This local commit alone does not update any existing PR or authorize its merge.
