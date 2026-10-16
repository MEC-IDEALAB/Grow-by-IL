# Grow~ Development Workflow

## Purpose

This document defines how work moves from idea to release. It is tracked in the
repo so the workflow does not depend on chat memory.

## Workflow

```text
Issue / Task
  -> Architecture Review
  -> Feature Branch
  -> Implementation
  -> Self Review
  -> Pull Request
  -> CI
  -> Review
  -> Squash Merge
  -> Release
```

## Branch Rules

- `main` is the protected GitHub default branch; deployment readiness is separately verified.
- `rc5-release-candidate` is the current product integration branch until it is merged
  through a PR into `main`.
- Do not push directly to protected trunks (`main`, and `rc5-release-candidate`
  if configured as protected in GitHub settings).
- All changes must go through pull requests.
- Use `feature/*` for product work.
- Use `fix/*` for bug fixes.
- Use `chore/*` for docs, tooling, CI, or cleanup.
- Keep branches small and single-purpose.

## Current RC Rule

Until RC5 stabilizes, `rc5-release-candidate` is treated as a trunk-equivalent
release candidate branch. Durable changes should be developed on short-lived
feature/chore branches and opened as PRs against `rc5-release-candidate` or
`main`, depending on the release target.

Local commits on a feature/chore branch are normal. Direct pushes to protected
branches are not.

## Historical Exceptions

The commits below were made before this PR-first rule was clarified for
`rc5-release-candidate`:

- `372d116 feat(work-requests): add operations hub foundation`
- `11ab748 chore(workflow): add enterprise development guardrails`

Do not rewrite shared history to remove them. Treat them as documented process
exceptions and apply the PR-first rule going forward.

## Phase Gate Rules

- Product implementation must follow approved requirements.
- Schema/migration work must wait for approved architecture and database design.
- New modules must be behind feature flags until stable.
- UI-only previews are allowed only when they are reversible and do not imply
  backend contracts.

## Local Check Rules

Run before opening or updating a PR:

```powershell
dart format .
flutter analyze
flutter test
```

For Android release-impacting changes, also run the relevant build command.

## PR Rules

A PR must include:

- purpose
- scope
- files changed
- architecture impact
- database impact
- breaking changes
- screens added or changed
- tests
- rollback plan
- future work

## Merge Rules

- CI must be green.
- At least one review is required.
- Use squash merge.
- Retire merged branches only after confirming no unique recovery work depends on them.

## Release Rules

- Releases must use signed artifacts.
- Internal testing comes before public rollout.
- Release checklist and rollback notes must be reviewed before production.

## Dependency Update Rule

Dependency updates require current checks and independent review. Do not infer that
auto-merge is disabled merely from this document: main and RC5 historically had different
automation workflows. Verify actual configured behavior. Flutter, Firebase, Supabase, Android, and
GitHub Actions updates can cause runtime or build regressions even when they are
minor version updates.
