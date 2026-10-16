# Grow~ Definition Of Done

A feature is not done until all relevant items below are satisfied.

## Product And Architecture

- [ ] Requirement or issue is clearly defined.
- [ ] Architecture impact is understood.
- [ ] Feature flag considered or added.
- [ ] Scope boundaries are respected.
- [ ] System boundaries are not violated.

## Implementation

- [ ] Code is focused and reversible.
- [ ] No unrelated cleanup is included.
- [ ] No direct Supabase calls from widgets.
- [ ] Loading, empty, error, and success states are handled.
- [ ] Accessibility and text overflow are considered.

## Data And Security

- [ ] Database impact documented.
- [ ] RLS/security impact documented.
- [ ] Audit log requirement considered.
- [ ] Sensitive data is not logged.
- [ ] Storage impact considered.

## Verification

- [ ] `dart format .` run.
- [ ] `flutter analyze` passes.
- [ ] `flutter test` passes.
- [ ] Manual smoke test completed when UI changes.
- [ ] Screenshots captured when visual design changes materially.

## Review And Release

- [ ] PR template completed.
- [ ] CI green.
- [ ] Reviewer approved.
- [ ] Rollback plan exists.
- [ ] Follow-up work documented.
