# Grow documentation

Updated: 20 October 2026. Canonical documentation index.

- [Live delivery Project](https://github.com/users/NAVANEETHVVINOD/projects/4): task status, phase, priority, blockers and evidence.
- [Current baseline](00_Project/CURRENT_PROJECT_BASELINE.md).
- [Task handoff](00_Project/GROW_V1_TASK_BOARD.md).
- [Repository layout and recovery](00_Project/REPOSITORY_CONSOLIDATION.md).
- [Approval provenance](00_Project_Management/APPROVAL_LOG.md).
- [CI investigation and correction evidence](05_DevOps/P0_03_CI_INVESTIGATION.md).

The 20 October snapshot records primary RC5 at `ef14bf3e5e2d20f3c9b76a05d4b49f787d12b58d` and Project #4 at 68 cards (25 Done, 5 In Progress, 7 Todo, 31 Blocked). The primary repo has 37 open issues and five open product PRs (#90, #99, #100, #103 and #108); they are drafts, 27 commits behind RC5, and none is merge-ready or proven unwanted. Project #4 is the live queue.

Documentation PR #146 merged to RC5 as `503db777b5f066fabac570ee08dfe2c70ef95a3c` from exact head `b40e4a7e1583bad8c3e6b2c7b606eeda2fc9a3d4`; exact-head and post-merge required checks passed. PR #147 merged as `9233e02ffdf0c6f773b67c4d3ab1cd6f8fe003e3` from exact head `562fa0f4d053986588cb15662db4838af2483850`; exact-head checks, independent audit and post-merge run #39321857192 passed. PR #148 merged as `ef14bf3e5e2d20f3c9b76a05d4b49f787d12b58d` from exact head `47df5cfdd9a8298038ffe53938ff2294e108ff8d`; exact-head checks passed in #39323517381, independent audit passed, and post-merge run #39324673949 passed both required RC5 jobs. Release APK builds were skipped and are not required for these docs-only changes. PRs #144/#145 removed `.github/dependabot.yml` from main/RC5; their checks/reviews and post-merge Android builds passed.

The private secondary repository `NAVANEETHVVINOD/Grow-by-IL-ghsa-fgf9-xx2v-57qp` was fully inventoried. It contains one unique four-commit security series shared by closed PR #1 and open PR #2; the migration, tests and ledger are absent from primary. PR #2 expects a different role/membership schema, has no hosted checks or submitted review, and pauses join/transfer flows. Retain the repo until a primary-specific fix is verified or its security history is preserved in a restorable private archive; confirm GHSA retention requirements before deletion.

Issue #88 tracks conditional authorization concerns pending live-schema/grant verification. The tracked source alone does not establish an active production exploit, and no production migration is authorized. Issue #143 remains open for the next weekly observation of the generated Dependabot workflow. The local #108 recovery patch remains in stash; local test results are not hosted PR checks. The task board and Project #4 record the current acceptance gates.

## Product and approval provenance

Retain the scope of the [approval log](00_Project_Management/APPROVAL_LOG.md),
[charter](01_Product/00_PRODUCT_CHARTER.md),
[Business Requirements](01_Product/03_BUSINESS_REQUIREMENTS.md),
[Work Request requirements](01_Product/05_WORK_REQUEST_REQUIREMENTS.md) and
[implementation contract](01_Product/06_WORK_REQUEST_IMPLEMENTATION_CONTRACT.md).
The approval log records dated decisions for their stated scope only. They do not
prove a deployed backend, approval of other modules, or release readiness.

Current decision gates: [Work Request delta](02_Product/WORK_REQUEST_CONTRACT_DELTA.md),
[profile](02_Product/PROFILE_ECOSYSTEM_DECISION_GATE.md),
[catalog](02_Product/IDEA_LAB_CATALOG_INTAKE.md),
[identity](01_Product/AUTH_IDENTITY_POLICY.md),
[September decisions](01_Product/PRODUCT_DECISION_DELTA_2026-09-17.md),
[Penpot](01_Design/PENPOT_ACCEPTANCE_MATRIX.md),
[backend security](03_Database/BACKEND_SECURITY_BASELINE.md),
[auth providers](03_Database/AUTH_PROVIDER_RELEASE_CHECKLIST.md),
[roles/positions](03_Database/ROLE_AND_POSITION_CONTRACT.md), and
[Storage](03_Database/STORAGE_ACCESS_CONTRACT.md).

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
its owning tool; generated caches are not documentation.

Reviewed non-sensitive project docs are versioned. Credentials, signing files,
private security evidence, raw snapshots and recovery archives remain local/ignored.
The secondary Grow-by-IL GHSA repository has been inventoried and retained because open PR #2 contains unique security history; see the current baseline and repository consolidation record. Directory-name similarity alone does not establish that a repository is safe to delete.
