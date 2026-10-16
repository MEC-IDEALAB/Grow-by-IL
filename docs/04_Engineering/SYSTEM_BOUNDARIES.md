# Grow~ System Boundaries

This V1 boundary records both the original exclusions and the later product-owner
scope decision in the [September delta](../01_Product/PRODUCT_DECISION_DELTA_2026-09-17.md)
and [ADR-006](ARCHITECTURE_DECISIONS.md#adr-006-signed-in-external-participant-access-is-in-mobile-v1).
Signed-in external participants may use eligible event and fabrication/work-request
flows. Detailed contracts for eligibility, payments, privacy, and role routing remain
open in #93/#95; this boundary does not grant operational permissions.

## Purpose

This document defines what belongs inside Grow and what intentionally stays
outside the platform for V1.

## Inside Grow

- User identity and onboarding.
- Role-aware dashboards.
- Work Requests.
- Manufacturing Tasks.
- Machine queue visibility and controls.
- Machine runtime and maintenance records.
- Inventory and borrowing records.
- Visitor logs.
- Events and workshops.
- Signed-in external participant onboarding and eligible event/request access, subject to the product contracts.
- Quotations and manual payment verification.
- Notifications.
- Reports and exports.
- Audit logs.
- Master data configuration.

## Outside Grow For V1

- CAD editing.
- Design tool hosting.
- Large fabrication file storage as the primary source of truth.
- WhatsApp replacement or direct messaging.
- Public or anonymous ordering and guest checkout.
- Payment gateway processing.
- AI quotation.
- AI design validation.
- IoT machine telemetry.
- Multi-institution public UI.
- Public marketplace.

## Integration Boundary

Grow may store external links to Drive, GitHub, Dropbox, OneDrive, or similar
tools. The external tool remains the file source of truth unless a future phase
explicitly approves storage changes.

## Future Boundary Changes

Any item moving from "outside" to "inside" requires:

- approved requirement
- architecture decision
- security review
- storage/cost review
- testing plan

External participant access is inside V1 at the high-level scope only. Issue #93
tracks the remaining event and Work Request contracts; access does not confer
Machine Head, Operations Head, or other operational authority.
