# Grow~ System Boundaries

Historical V1 boundary record. Later approved product decisions are recorded in
[the September delta](../01_Product/PRODUCT_DECISION_DELTA_2026-09-17.md) and
[current Work Request delta](../02_Product/WORK_REQUEST_CONTRACT_DELTA.md).
Conflicts concerning external participation or payments remain #93/#95; this
documentation cleanup does not approve a product-scope change.

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
- External customer ordering inside the mobile app.
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
