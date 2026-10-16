# Work Request Requirements

Status: Draft - Phase 1B Preparation  
Owner: Product Owner / Lead Architect  
Last updated: 2026-08-02

## Purpose

This document freezes the first-level Work Request taxonomy and required fields
before any Create Work Request UI, database schema, Supabase policies, or
repositories are implemented.

This document exists because the Work Request create flow would otherwise bake
business rules directly into UI before PRD/SRS approval.

## Scope Decision

The first implementation path should focus on **Fabrication Work Requests**.

Other request categories may remain visible in planning docs as future master
data, but the first create flow should not pretend every category is fully
defined.

## Work Request Category Model

### Category Level

A Work Request category describes the student's business intent.

Initial categories:

| Category | First Build | Notes |
| --- | --- | --- |
| Fabrication | Yes | Primary V1 operational path |
| Technical Support | Later | Needs workflow definition |
| Design Assistance | Later | May become subflow or support request |
| Project Guidance | Later | May overlap mentorship |
| Inventory Purchase Request | Later | Requires Operation Head flow |
| Maintenance Request | Later | Core-team/admin oriented |
| General Inquiry | Later | Could route to support, not manufacturing |

### Fabrication Subcategories

Fabrication subcategories are student-facing selections that may later create
one or more Manufacturing Tasks.

| Subcategory | Potential Manufacturing Task Type |
| --- | --- |
| Laser Cutting | Laser Cutting |
| 3D Printing | 3D Printing |
| PCB Milling | PCB Milling |
| CNC Routing | CNC Routing |
| Electronics Assembly | Electronics Assembly |
| Mechanical Assembly | Mechanical Assembly |
| Mixed Fabrication | Multiple tasks after review |

### Manufacturing Task Types

Manufacturing Task types are operational units owned by core team/Machine Head.
They are not the same as Work Request categories.

Initial task types:

- Laser Cutting
- 3D Printing
- PCB Milling
- CNC Routing
- Electronics Assembly
- Mechanical Assembly
- Design Support
- Assembly
- Testing

## First Create Flow Boundary

The first Create Work Request flow should support:

- Category: Fabrication only
- Subcategory: one or more fabrication subcategories
- External file links
- Student description and purpose
- Preferred timeline
- Members
- Review summary

The first Create Work Request flow should not support yet:

- payment submission
- quotation generation
- machine assignment
- operator assignment
- queue reordering
- runtime logging
- inventory consumption
- Supabase persistence

Those belong after PRD/SRS, Phase 2 architecture, and schema approval.

## Required Fields

### Submission Identity

| Field | Required | Owner | Notes |
| --- | --- | --- | --- |
| Leader User ID | Yes | System | Current authenticated user |
| Leader Name | Yes | System | Display only from profile |
| Department/Class | Yes | User/Profile | Can be prefilled from profile |
| Contact Email | Yes | System | From auth/profile |

### Request Basics

| Field | Required | Owner | Notes |
| --- | --- | --- | --- |
| Request Title | Yes | Student | Short project/request name |
| Category | Yes | Student | First build: Fabrication |
| Fabrication Subcategory | Yes | Student | Laser, 3D print, PCB, CNC, etc. |
| Quantity | Yes | Student | Integer, minimum 1 |
| Purpose/Reason | Yes | Student | Why the work is needed |
| Description | Yes | Student | Details for review |
| Lab Preference | No | Student | IDEA Lab/Fab Lab; Machine Head may change |

### Team Members

| Field | Required | Owner | Notes |
| --- | --- | --- | --- |
| Members | No | Student | Multiple collaborators allowed at creation; editable while draft/submitted/changes_requested |
| Faculty Guide | Future | Student/Admin | Deferred |

### Timeline

| Field | Required | Owner | Notes |
| --- | --- | --- | --- |
| Preferred Completion Date | Recommended | Student | Helps queue planning |
| Priority | Yes | Student/Core Team | Student suggests; Machine Head can change |

### Design And Material Inputs

| Field | Required | Owner | Notes |
| --- | --- | --- | --- |
| External File Links | Recommended | Student | Drive/GitHub/Dropbox/OneDrive/etc. |
| Needs Design Support | Yes | Student | Boolean |
| Needs Material Procurement | Yes | Student | Boolean |
| Material Notes | Conditional | Student | Required if material procurement is needed |

### Review And Consent

| Field | Required | Owner | Notes |
| --- | --- | --- | --- |
| Safety/Policy Acknowledgement | Yes | Student | Before submission |
| Edit Approval Acknowledgement | Yes | Student | Student agrees core team may suggest edits |
| Review Summary Confirmation | Yes | Student | Final screen before submit |

## Validation Rules

| Rule ID | Rule |
| --- | --- |
| WR-VAL-001 | Request title cannot be empty. |
| WR-VAL-002 | Purpose/reason cannot be empty. |
| WR-VAL-003 | Description must provide enough detail for review: minimum 20 characters, recommended maximum about 2000 characters. |
| WR-VAL-004 | At least one fabrication subcategory is required for Fabrication; multiple subcategories are allowed at submission. |
| WR-VAL-005 | External links must use valid URL format when provided. |
| WR-VAL-006 | Required-before date cannot be earlier than today. |
| WR-VAL-007 | Related event date cannot be earlier than today. |
| WR-VAL-008 | Material notes are required if material procurement is selected. |
| WR-VAL-009 | Student must accept safety/policy acknowledgement before submit. |
| WR-VAL-010 | Student must confirm review summary before submit. |
| WR-VAL-011 | Priority must be Low, Normal, or High; defaults to Normal if unset. |

## Student Queue Visibility

Students should not see the raw Machine Head queue.

Student-facing queue information may include:

- current request status
- coarse queue position, such as "3 requests ahead"
- estimated waiting/completion window when available
- assigned lab or machine after review
- assigned core team contact after review

Student-facing queue information must not include:

- internal priority rationale
- full ordered task list
- internal Machine Head notes
- operator assignment details before publication
- maintenance conflicts
- queue reordering controls

## Edit And Cancel Rules

| Situation | Rule |
| --- | --- |
| Draft request | Student may edit all fields. |
| Submitted but not reviewed | Student may edit or cancel. |
| Reviewed with core-team edits | Student must approve or reject suggested changes before work starts. |
| Approved/committed | Student cannot directly edit key fields; they must request a change. |
| Work in progress | Cancellation requires core-team/admin handling. |
| Rejected | Student should start a new request instead of mutating the rejected one. |

Cancellation or major edits must preserve an audit/status event.

## Payment State Boundary

Payment collection is not part of the first UI-only Create Flow, but the product
requirements should support this lifecycle later:

1. quote draft
2. quote sent
3. 50% deposit due
4. deposit paid
5. work in progress
6. remaining 50% due
7. fully paid
8. closed/completed

Manual UPI recording is acceptable for V1. Payment gateway integration is not
required for the first implementation.

## Notification Matrix

| Trigger | Student | Machine Head/Core Team | Operation Head |
| --- | --- | --- | --- |
| Request submitted | Confirmation | New request alert | Optional digest |
| Request reviewed | Review result | - | - |
| Changes requested | Action required | - | - |
| Student approves edits | - | Student accepted changes | - |
| Request approved | Approved/next step | - | Optional digest |
| Work started | Status update | - | - |
| Ready for pickup | Pickup alert | - | Optional |
| Completed | Completion receipt | Completion logged | Record update |
| Cancelled | Cancellation confirmation | Cancellation alert | Optional |
| Rejected | Rejection reason | - | Optional |

## Business Rule References

- BRULE-001 through BRULE-012
- BRULE-020 through BRULE-023
- BRULE-030 through BRULE-035
- BRULE-040 through BRULE-044

## Dependencies

- Business Rule Matrix.
- Phase 1B PRD/SRS.
- Phase 2 role matrix and database architecture.

## Risks

- Supporting every category too early will create a generic, confusing form.
- Showing the raw machine queue to students can create disputes about priority.
- A create flow built before schema approval may need rework.

## Open Questions

1. Which external link providers should get first-class helper text?

## Resolved Decisions

- Members are added during request creation and may be edited later only while
  the request remains in `draft`, `submitted`, or `changes_requested`.
- Mixed fabrication requests may select multiple subcategories at submission.
  Student selections represent intent only; Machine Head still owns splitting
  the request into actual Manufacturing Tasks at approval time.

## Future Enhancements

- Full multi-category Work Request wizard.
- File upload for small safe artifacts.
- Template-based request types.
- Quote preview after review.
- Student-visible timeline with comment thread.
- Required-before date.
- Related event date.

## Approval Checklist

- [x] Fabrication-first scope approved
- [x] Category/subcategory distinction approved
- [x] Required fields approved
- [x] Validation rules approved
- [x] Student queue visibility boundary approved
- [x] Approved to design Create Work Request UI
