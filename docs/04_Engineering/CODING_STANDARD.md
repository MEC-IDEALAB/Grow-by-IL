# Grow~ Coding Standard

## Flutter Architecture

- Keep features modular under `lib/features/<feature>/`.
- Widgets should not directly call Supabase.
- Use repositories/services for data access.
- Use Riverpod providers for state ownership.
- Avoid giant `ConsumerWidget`s that watch unrelated providers.
- Prefer section-level consumers for heavy screens.
- New risky modules must be feature-flagged.

## UI/UX Standards

- Build mobile-first.
- Use existing RC5 design tokens and shared widgets where possible.
- Keep cards, buttons, and chips consistent.
- Avoid overloaded screens.
- Use clear empty, loading, error, and success states.
- Do not encode unapproved business rules into forms.

## Data And Business Logic

- Do not put business rules only in UI.
- Avoid magic strings for statuses, roles, and categories.
- Prefer configurable master data for operational values.
- Preserve auditability for operational actions.

## Supabase Standards

- No schema changes without approved architecture.
- No RLS changes without explicit review.
- Avoid broad realtime streams.
- Avoid unbounded queries.
- Add indexes with query patterns.
- Supabase migration linting should be restored to CI when Phase 2 database
  architecture begins and migrations become active again.
- The current schema contract check is intentionally blacklist-based until an
  approved generated schema contract exists.

## Testing Standards

- Unit test models, validators, and business logic.
- Repository logic should be testable without UI automation where practical.
- UI integration tests should stay small and smoke-focused.
- Business correctness should not depend only on widget text assertions.

## Logging

- Debug logs must not create release-mode overhead.
- Do not log secrets, tokens, payment identifiers, or private profile fields.
