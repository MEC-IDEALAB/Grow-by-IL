# Role and Position Contract

Status: Decision record for review. It does not create tables, policies,
permissions or production assignments.

## Why this boundary exists

Grow must keep a member's account role separate from a temporary IDEA Lab core
position. A position describes responsibility; it must not become a
client-writable authorization field or a shortcut around RLS.

## Current compatibility vocabulary

The currently observed compatibility account-role vocabulary is:

| Account role | Meaning in this release phase |
| --- | --- |
| `student` | Ordinary authenticated member. |
| `lab_admin` | Existing elevated lab account; preserve meaning until a separate migration. |
| `super_admin` | Existing platform-level administrator. |

Do not rename `lab_admin`, add `faculty`, backfill accounts, or infer a role
from a display name in the security/foundation phase. The desired future
product account vocabulary is a separate reviewed migration.

## Core positions are assignments

The following position names came from the approved product discussions and
need an official member assignment before they drive an operational workflow:

- Operations Head
- Machine Head
- Events Head
- Web Head
- Design Head

A position is assigned by a Super Admin through a trusted server-side path and
must have an audit record. It is not supplied by onboarding, profile edit,
Google metadata, a project join code, or a direct client update.

## Proposed authority model to approve

| Action | Account role / trusted path | Position effect |
| --- | --- | --- |
| Join Grow | Authenticated member | None; starts as ordinary member. |
| Edit own profile | Authenticated member, allowed columns only | Cannot alter role or position. |
| Assign/revoke core position | Super Admin via audited server path | Adds/removes scoped position assignment. |
| Route a work request | Approved workflow/RLS rule | May select Operations or Machine responsibility; not an account-role mutation. |
| Event payment/refund decision | Approved event workflow/RLS rule | Must be tied to an assigned Events Head or explicitly authorized administrator. |
| Machine queue decision | Approved queue workflow/RLS rule | Must be tied to an assigned Machine Head or explicitly authorized administrator. |

The final RLS matrix must name the affected tables/RPCs and deny every
unlisted action. UI visibility alone never grants authority.

## Decisions still required

1. Confirm the authoritative roster and whether any other core positions are
   needed for V1.
2. Decide whether a position is lab-wide, room-scoped, machine-scoped or
   event-scoped; do not assume one scope fits all heads.
3. Decide start/end dates, handover behavior and absence/delegation rules.
4. Confirm which actions an assigned head may perform without Super Admin
   approval for Work Requests, machines, events, refunds, inventory and lab
   presence.
5. Define the audit readers, retention period and revocation process.

## Required implementation gate

Before schema or UI implementation:

1. Reconnect the read-only live Supabase inspection path and capture the
   deployed roles, policies, grants, triggers and migration ledger.
2. Approve the canonical account/position matrix and scope decisions above.
3. Design one reviewed migration, rollback plan, RLS/RPC matrix and negative
   authorization tests.
4. Validate against a production-faithful non-production baseline before any
   production deployment.

This contract intentionally leaves Work Requests, Manufacturing Tasks, Machine
Queue, Events and Payments as separate modules. Each needs its own approved
requirements before persistence work begins.
