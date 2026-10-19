# Grow documentation

Updated: 20 October 2026. Canonical documentation index.

- [Live delivery Project](https://github.com/users/NAVANEETHVVINOD/projects/4): task status, phase, priority, blockers and evidence.
- [Current baseline](00_Project/CURRENT_PROJECT_BASELINE.md).
- [Task handoff](00_Project/GROW_V1_TASK_BOARD.md).
- [Repository layout and recovery](00_Project/REPOSITORY_CONSOLIDATION.md).
- [Approval provenance](00_Project_Management/APPROVAL_LOG.md).
- [CI investigation and correction evidence](05_DevOps/P0_03_CI_INVESTIGATION.md).

The 20 October baseline records six open PRs: product drafts #90, #99, #100, #103
and #108, plus documentation PR #146. None of the five product drafts is merge-ready
or proven unwanted. PRs #144 (main) and #145 (RC5)
merged after exact-head required checks and independent review; `.github/dependabot.yml`
is absent from both protected branch trees. Post-merge run #39310512505 on main and
run #39310529054 on RC5 both completed successfully, including the Android Production
Build and Debug APK Build respectively. PR #108 has a locally verified recovery
patch in a stash, but its remote head and hosted checks remain unchanged. The generated
GitHub-managed workflow remains listed active; no run after the config-removal merges
appears as of 20 October. Issue #143 tracks the next weekly observation.

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
Other repositories remain separate until their contents are reviewed; directory-name
similarity alone does not establish that a repository is safe to delete.
