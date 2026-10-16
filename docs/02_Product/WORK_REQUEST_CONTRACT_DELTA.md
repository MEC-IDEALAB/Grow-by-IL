# Work Request Contract Delta

Status: decision record for review. This document does not authorize a schema,
database migration, pricing rule, stock import, payment integration or role
assignment.

## Purpose

Work Request is the request-intake workflow for help that the IDEA Lab can
review. It is not a Manufacturing Task, a Machine Queue entry, an inventory
reservation, or a payment record. Those are separate workflows and must not
be collapsed into one client-controlled status field.

The current Flutter provider constructs `MockWorkRequestDataSource`, so the
dashboard records and counts are simulated. Issue #85 tracks their removal.
They must not be presented as a member's live requests, lab workload, queue
position, payment state, assigned head, or estimated completion date.

## Decisions already supplied

| Area | Agreed direction |
| --- | --- |
| Entry point | Expose one primary **Start a Work Request** action; do not duplicate it with a second New Request action. |
| Routing | Machine-related work is routed to Machine responsibility; operation-related work is routed to Operations responsibility. The assignment is workflow data, not a client-writable account role. |
| Separate requests | Owner decision, 2026-10-03: machine and operations work are submitted as separate requests and sent to their respective heads. |
| Requester cancellation | Owner decision, 2026-10-03: the requester may directly cancel a Machine or Operations request before its responsible head takes or reviews it. Claim/review and cancellation must be checked atomically on the server; the first accepted action determines whether direct cancellation remains allowed. |
| Cancellation after head involvement | After the responsible head takes or reviews a request, the requester submits a cancellation request with a reason. That head may approve or deny it. A pending or denied cancellation request does not mark the work cancelled. |
| Catalog approval | Owner decision, 2026-10-03: Operations Head approves updated stock and current prices. |
| Scope | Work Request, Manufacturing Task, and Machine Queue remain separate modules. |
| Data honesty | Use loading, empty, unavailable and permission-denied states until the backend can return a real record. |
| Stock and price | Do not seed quantities or prices. The product owner will supply the updated stock and official price rules later. |
| Storage | Request attachments cannot be enabled until the storage access contract is approved and implemented. |

## Current local-client surface to reconcile

The local model contains a useful UI draft, but it is not a backend contract.
The following fields need an approved source of truth before they can be
persisted or shown as live operational data:

| Local field or concept | Why it is not launch-ready | Required decision/evidence |
| --- | --- | --- |
| Fabrication subcategories | The current labels include machine claims not yet approved against the lab catalog. | Canonical service/machine catalog with stable identifiers and operational owner. |
| `labPreference` | IDEA Lab/Fab Lab selection assumes a room model that is not reconciled. | One-lab/two-room policy and permitted request destinations. |
| Priority | A requester-selected value is not an approval decision. | Who can set/override priority, allowed values, reason/audit requirement. |
| `leaderName` and assignment | A display name is neither authority nor proof of responsibility. | Scoped position assignments and read policy; no client-selected head. |
| Estimated completion and coarse queue position | Both can mislead users if generated from mock data. | Manufacturing Task/Machine Queue handoff contract and safe disclosure rules. |
| Payment state | The app explicitly labels it a placeholder. | Quote/deposit/payment/refund ownership, verified-payment source, and no-seat/no-work reservation rule. |
| Material procurement | It does not prove availability or purchase authorization. | Inventory/procurement workflow, stock provenance, and approver authority. |
| Collaborators | Plain names are not authenticated member references. | Member-selection/privacy policy and project relationship rule. |
| External links and attachments | Links/files can expose data and require validation. | Allowed domains/file types, retention, malware scanning and storage RLS. |
| Cancellation/rejection | Reasons need an auditable actor and transition rules. | Implement the approved direct-cancel cutoff and head decision path; define remaining rejection/resubmission and downstream execution rules separately. |

## Minimal lifecycle to approve

The local status enum may be used only as a UI draft until the following
transition matrix is approved and enforced on the server:

```text
Draft (private) -> Submitted -> Under Review
Under Review -> Changes Requested | Approved | Rejected
Approved -> Manufacturing Task handoff (separate record) | Cancelled
Changes Requested -> Submitted | Cancelled
Rejected -> resubmit only when the reviewer explicitly marks it resubmittable
```

`In Progress`, `Ready for Pickup`, machine assignment, queue position, and
payment labels belong to the downstream workflow unless a reviewed contract
defines the exact synchronized source. A submitted request must never become
approved, paid, assigned, or completed from a client-only update.

## Approved cancellation behavior

- Before the responsible head takes or reviews the request, its requester can
  cancel directly. This applies to both Machine and Operations requests.
- After that cutoff, the UI offers **Request cancellation** and requires a
  reason. The responsible head has **Approve** and **Deny** actions.
- Submission records a pending cancellation decision while preserving the
  current work status. Only approval changes the work status to cancelled;
  denial preserves the current status and is shown to the requester.
- Record the requester, reason, submission time, deciding head, decision and
  decision time in the audit history. Deny cross-user requests and decisions
  from an unrelated head on the server.
- Test cancellation racing with head claim/review, approval and denial,
  duplicate submissions/decisions, and permissions for both request types.
  Manufacturing execution, consumed materials and refunds need their own
  downstream rules before cancellation can trigger those effects.

## Required implementation gates

1. Resolve #93 and #95 product/eligibility conflicts and approve the decisions
   in the table above. The owner must supply the actual catalog, stock and
   official price policy when those flows are in scope.
2. Close the authorization foundation gate: current roles remain compatibility
   labels, and position assignments need their own reviewed scope/RLS matrix.
3. Approve an API/schema contract with immutable request history, server-side
   transition authorization, audit events, RLS negative tests and rollback
   plan. Do not derive permission from a client-provided role, position or
   assignee.
4. Implement a real repository/data source in a focused PR. Remove simulated
   dashboard rows, counts and detail records; preserve an honest unavailable
   state until the real service is enabled.
5. Test request creation, view permissions, routing, every allowed/denied
   transition, concurrent update handling, error/offline states, and Android
   E2E with a non-production data set.

## Questions requiring owner approval

1. Which exact request categories are V1: machine, fabrication, component,
   design help, technical support, or another set? Machine and component
   requests should remain visibly distinct if both are approved.
2. When the relevant head is absent, should the separate request remain
   pending or go to a designated deputy?
3. When, if ever, may a requester see an estimated date, a queue summary or
   a named responsible person?
4. Which requests can incur cost, who creates the quote, and which verified
   payment/refund provider and audit record are authoritative?

## Next smallest safe task

Resolve the remaining questions and the current catalog boundary.
Then create a reviewed Work Request API/schema proposal with authorization
tests. Until then, do not turn the mock provider into a production backend.
