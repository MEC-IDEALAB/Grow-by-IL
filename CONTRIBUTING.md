# Contributing to Grow~

Grow~ is now managed as a production-oriented Innovation Hub platform. The
project uses phase gates, pull requests, CI, and documented architecture
decisions to avoid drift.

## Required Reading

Before contributing, read:

- `DEV_WORKFLOW.md`
- `CODING_STANDARD.md`
- `DEFINITION_OF_DONE.md`
- `SYSTEM_BOUNDARIES.md`
- `ARCHITECTURE_DECISIONS.md`
- `SECURITY.md`

## Branching Strategy

- `main`: protected GitHub default branch; production readiness is separately verified. Never push directly.
- `develop`: optional integration branch when active release coordination needs
  it.
- `release/*`: release stabilization branches.
- `feature/*`: new feature slices.
- `fix/*`: bug fixes.
- `chore/*`: tooling, docs, CI, cleanup.

Use one branch for one coherent change. Do not mix product features, schema
changes, formatting, and unrelated cleanup in one PR.

## Development Process

1. Start from an approved issue/task or documented architecture decision.
2. Create a focused branch.
3. Implement the smallest reversible slice.
4. Run local checks before pushing:
   - `dart format .`
   - `flutter analyze`
   - `flutter test`
5. Open a pull request using `.github/PULL_REQUEST_TEMPLATE.md`.
6. Wait for CI to pass.
7. Get at least one review.
8. Squash merge only after approval.

## Pull Request Rules

Every PR must state:

- purpose
- scope
- architecture impact
- database impact
- security/RLS impact
- UI/UX impact
- tests run
- rollback plan

No PR should merge if CI is red.

## Architecture Gate

During the architecture phase, do not add Supabase migrations, schema changes,
new repositories, or persistence logic unless the relevant PRD/SRS, architecture,
role matrix, and database design are approved.

UI-only exploratory slices must be feature-flagged and reversible.

## Coding Standards

See `CODING_STANDARD.md`.

## Definition Of Done

See `DEFINITION_OF_DONE.md`.
