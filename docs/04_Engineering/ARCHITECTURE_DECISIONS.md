# Grow~ Architecture Decisions

This decision index preserves provenance. Later product-owner decisions are
recorded in the [September delta](../01_Product/PRODUCT_DECISION_DELTA_2026-09-17.md)
and [Work Request delta](../02_Product/WORK_REQUEST_CONTRACT_DELTA.md). The
high-level V1 scope permits verified-email external students and professionals to
use eligible event and fabrication/work-request flows. Detailed eligibility,
fields, routing, safety, payment, privacy and support remain open in #93/#95. This
scope decision does not grant operational permissions or authorize schema/RLS changes.

## ADR-001: Use Work Request Instead Of Order

Status: Accepted

Reason: Lab work is collaborative, review-based, and may split into multiple
Manufacturing Tasks. "Order" implies a transactional external-commerce model,
which is not the V1 mobile app model.

Consequence: UI, requirements, and future schema should use Work Request.

## ADR-002: Students Request, Core Team Executes

Status: Accepted

Reason: Students should not directly operate fabrication machines by default.
Core team and Machine Heads own execution.

Consequence: Student screens show request status and coarse queue information;
Machine Head screens own operational queue controls.

## ADR-003: Separate Work Requests And Manufacturing Tasks

Status: Accepted

Reason: One student request may require laser cutting, 3D printing, PCB milling,
assembly, or testing. These must be independently assignable and trackable.

Consequence: Future schema and UI must not collapse all work into one flat
request row.

## ADR-004: Separate Consumables, Borrowables, And Assets

Status: Accepted

Reason: Stock, borrowable items, and fixed assets have different lifecycles,
reporting needs, and audit requirements.

Consequence: Inventory architecture must preserve these distinctions.

## ADR-005: Manual UPI Verification For V1

Status: Accepted

Reason: Payment gateway integration is unnecessary for V1 and adds operational
and compliance complexity.

Consequence: V1 payment records should support manual verification and audit
history.

## ADR-006: Signed-In External Participant Access Is In Mobile V1

Status: Accepted at high-level product scope; implementation contracts remain pending.

Reason: The product owner approved verified-email onboarding for external students
and professionals, their participation in eligible events, and their ability to
submit fabrication/work requests. The scope decision is recorded in [issue #93](https://github.com/NAVANEETHVVINOD/Grow-by-IL/issues/93).

Decision: Eligible external participants may create an account, complete required
onboarding, and use the signed-in event and fabrication/work-request flows. Event
eligibility and request handling follow their product contracts. Public or anonymous
ordering remains outside V1.

Consequence: Define event audience/capacity, external request fields, safety and role
routing, payments, privacy, and support/abuse boundaries in reviewed contracts before
implementation. This ADR does not authorize a role, schema, RLS, or client-permission
change.

## ADR-007: Phase-Gated Architecture Before Persistence

Status: Accepted

Reason: Work Requests, inventory, payments, and roles are complex enough that
schema-first guessing will cause rework.

Consequence: No Supabase schema, migration, repository, or persistence logic for
new operational modules before PRD/SRS and architecture approval.
