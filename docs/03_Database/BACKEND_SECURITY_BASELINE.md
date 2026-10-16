# Backend Security Baseline

Status: Draft approval gate. This is neither a database migration nor an
implementation specification.

## Purpose

This baseline defines the evidence and approvals required before Grow adds or
restores persistence for operational modules. It covers identity,
authorization, RLS, migration and audit boundaries. It does not authorize
production SQL, seed data, role assignment, storage access, or Flutter
persistence work.

## Canonical sources

- `SECURITY.md` for security engineering rules.
- The tracked architecture and system-boundary records for phase-gated
  persistence and V1 scope.
- `supabase/migrations/` for the repository schema and policy history.
- Flutter source for the current client contract.

Locally ignored records may provide context, but cannot override a reviewed,
tracked reconciliation.

## Verified constraints

1. Supabase Auth is the application identity provider. `public.users` is the
   operational account row used by Flutter; extended profile tables are not an
   authorization source.
2. Email/password and native Google sign-in must synchronize the same
   `public.users` identity. Splash and the profile-completion gate decide the
   post-sign-in route, not a sign-in button.
3. Repository history contains incompatible authorization vocabulary:
   `base_role`/`system_role` and `users.role` must not be treated as
   interchangeable without an approved migration.
4. The deployed schema and repository migration ledger have not yet been
   reconciled. Do not run historical migrations out of order or create an
   ad-hoc replacement schema.
5. Flutter must never use a service-role key, bypass RLS, or widen client
   policy as an error workaround.
6. Function execution, function search paths, extension placement and
   leaked-password protection need a reviewed disposition before operational
   backend expansion.

## Required decisions before database design

| Decision | Required outcome |
| --- | --- |
| Account model | One canonical account vocabulary with a migration path from legacy fields. |
| Positions | Assignments distinct from account type, scoped and time-bounded where applicable. |
| Authority | Elevated assignment/revocation is server-authoritative and audited. |
| Profile ownership | `public.users` owns identity/authorization; extended profile tables own profile data only. |
| RLS matrix | Every table/RPC has an actor, scope, allowed operation and denial rule. |
| Authentication | Email and Google share synchronization, profile completion, sign-out and denied-user behavior. |
| Audit model | Protected events, retained fields, readers and integrity rules are defined. |
| Migration ledger | Live schema is reconciled to an approved, ordered migration plan. |

## Required evidence for a change proposal

1. A read-only live schema inventory: tables, columns, constraints, indexes,
   RLS, policies, functions, triggers, extensions and deployed migration
   ledger. It must contain no secrets or user data.
2. A comparison of the inventory to each tracked migration, classifying every
   source migration as applied, partially represented, unapplied, superseded
   or incompatible.
3. An approved account/position authorization contract before position tables,
   policies, repositories or administration screens.
4. An operation-by-operation RLS and RPC matrix.
5. A migration, rollback and staging-verification plan that protects existing
   rows.
6. Tests for unauthenticated access, own-record access, cross-user denial,
   elevated access, revoked access, email/Google auth, profile creation,
   profile completion and sign-out/relaunch.

## Prohibited until approval

- Running existing migrations directly against the shared project.
- Parallel account, profile, role or position schemas.
- Persistence for Work Requests, Manufacturing Tasks, Machine Queue,
  Inventory or Payments.
- Data/domain layers that imply an unapproved backend contract.
- Broad client grants, disabled RLS or service-role keys in Flutter.
- Mapping legacy “Head” strings to positions without a reviewed migration.
- Treating a hidden UI action as authorization enforcement.

## Approval exit criteria

This baseline is satisfied only after the repository records approval of:

1. Live-schema and migration-ledger reconciliation.
2. Canonical account and position authorization model.
3. RLS/RPC policy matrix.
4. Security-advisor disposition and ownership.
5. Migration, rollback and test plan.

Only then may a narrowly scoped database architecture proposal be prepared for
one module. Each module still needs its own approved requirements and
implementation contract.
