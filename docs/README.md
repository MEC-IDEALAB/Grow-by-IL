# Grow documentation

Updated: 17 October 2026. Single documentation index.

- [Live delivery Project](https://github.com/users/NAVANEETHVVINOD/projects/4): task status, phase, priority, blockers and next actions.
- [Current baseline](00_Project/CURRENT_PROJECT_BASELINE.md).
- [Task handoff](00_Project/GROW_V1_TASK_BOARD.md).
- [Repository layout and recovery](00_Project/REPOSITORY_CONSOLIDATION.md).
- [CI investigation and correction evidence](05_DevOps/P0_03_CI_INVESTIGATION.md).

The verified delivery state is recorded in the [baseline](00_Project/CURRENT_PROJECT_BASELINE.md)
and [handoff](00_Project/GROW_V1_TASK_BOARD.md): PR #138 repaired the Dependabot
configuration and disabled routine version-update PRs; five meaningful drafts remain
open behind merge, review, or current-base gates.

## Product and approval provenance

Retain the original scope of the [approval log](00_Project_Management/APPROVAL_LOG.md),
[charter](01_Product/00_PRODUCT_CHARTER.md), [BRD](01_Product/03_BUSINESS_REQUIREMENTS.md),
[Work Request requirements](01_Product/05_WORK_REQUEST_REQUIREMENTS.md) and
[implementation contract](01_Product/06_WORK_REQUEST_IMPLEMENTATION_CONTRACT.md).
Old approvals do not prove a deployed backend or release readiness. Later recorded
decisions supersede only their stated scope.

Current decision gates: [Work Request delta](02_Product/WORK_REQUEST_CONTRACT_DELTA.md),
[profile](02_Product/PROFILE_ECOSYSTEM_DECISION_GATE.md),
[catalog](02_Product/IDEA_LAB_CATALOG_INTAKE.md),
[identity](01_Product/AUTH_IDENTITY_POLICY.md),
[September decisions](01_Product/PRODUCT_DECISION_DELTA_2026-09-17.md),
[Penpot](01_Design/PENPOT_ACCEPTANCE_MATRIX.md),
[backend security](03_Database/BACKEND_SECURITY_BASELINE.md),
[auth providers](03_Database/AUTH_PROVIDER_RELEASE_CHECKLIST.md),
[roles/positions](03_Database/ROLE_AND_POSITION_CONTRACT.md),
and [Storage](03_Database/STORAGE_ACCESS_CONTRACT.md).

## Documentation policy

Engineering references: [workflow](04_Engineering/DEV_WORKFLOW.md),
[branch checks](04_Engineering/BRANCH_PROTECTION.md),
[coding standards](04_Engineering/CODING_STANDARD.md),
[definition of done](04_Engineering/DEFINITION_OF_DONE.md),
[architecture decisions](04_Engineering/ARCHITECTURE_DECISIONS.md) and
[system boundaries](04_Engineering/SYSTEM_BOUNDARIES.md).

Narrative docs belong here. Required README, SECURITY, CONTRIBUTING, AGENTS/SKILL
loaders, CODEOWNERS and GitHub templates stay at their discovery locations. Root
governance entries can link to canonical docs. Vendor/framework Markdown stays with
its owning tool; generated caches are not project documentation.

Reviewed non-sensitive docs are versioned. Credentials, signing files, private security
evidence, raw snapshots and recovery archives remain ignored. The advisory repository
is separate remediation work, not a duplicate app to delete.

The 17 October workspace review found one Grow application checkout nested under the
outer `Grow/` workspace and no second Grow Git repository. The scoped
`.local/recovery/2026-10-16/original-primary-docs` inventory contains 109 Markdown
files among 113 total files. Seven paths overlap the current `docs/` tree; files at
those paths are not byte-identical. This is not a count of all `.local/recovery`.
The recovery disposition remains pending; preserve `.local`, secrets, and user data.
Recovery is local, not an off-machine backup. Do not restore old competing roadmaps as
live boards.

The generated files `android/hs_err_pid8548.log` and `supabase/.temp/cli-latest` were
removed after confirming they were ignored/generated. The now-empty `supabase/.temp`
directory remains because directory removal was rejected. No broad cache cleanup was
completed; only the two exact files above were removed.
