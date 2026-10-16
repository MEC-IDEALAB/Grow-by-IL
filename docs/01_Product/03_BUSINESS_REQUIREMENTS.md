# Grow Platform Business Requirements Document

Status: Draft - Phase 1A  
Owner: Product Owner / Lead Architect  
Last updated: 2026-08-02

## Purpose

This Business Requirements Document defines what Grow must achieve from a
business and operations perspective. It does not define database tables, Flutter
widgets, Supabase policies, API contracts, or detailed UI flows.

## Dependencies

- Approved Product Charter v1.0.
- Business Glossary.
- Product Vision.
- Review by Product Owner and relevant core team roles.

## Scope Levels

| Scope | Meaning |
| --- | --- |
| MVP | Minimum internally usable system for trusted users |
| V1 | Operational production release for MEC Innovation Hub |
| V2 | Expansion after V1 stability |
| Future | Long-term platform direction |

## Business Requirements

### MOD-01 Authentication

| ID | Scope | Requirement |
| --- | --- | --- |
| BR-AUTH-001 | MVP | The system must allow users to sign in with institution-approved email identity. |
| BR-AUTH-002 | MVP | The system must support configurable allowed email domains. |
| BR-AUTH-003 | V1 | Admins must be able to manually approve exceptional users outside the standard domain rule. |
| BR-AUTH-004 | V1 | The system must prevent unauthorized users from accessing operational modules. |

### MOD-02 User Profiles

| ID | Scope | Requirement |
| --- | --- | --- |
| BR-PROF-001 | MVP | The system must collect enough onboarding information to identify the user, role, department, and purpose. |
| BR-PROF-002 | V1 | Users must have a common dashboard with role-based widgets. |
| BR-PROF-003 | V1 | Profile data must separate public identity from private operational records. |
| BR-PROF-004 | V2 | Alumni profile features should support future alumni engagement. |

### MOD-04 Work Requests

| ID | Scope | Requirement |
| --- | --- | --- |
| BR-WR-001 | MVP | Students must be able to submit Work Requests for project, fabrication, design, or technical support. |
| BR-WR-002 | MVP | A Work Request must have one student leader. |
| BR-WR-003 | V1 | A Work Request must support multiple members/collaborators. |
| BR-WR-004 | V1 | A Work Request must support external design/file links instead of requiring large file uploads. |
| BR-WR-005 | V1 | Machine Head/core team must be able to review Work Requests and propose edits. |
| BR-WR-006 | V1 | If core team edits a Work Request materially, the student leader must approve the edited request before execution. |
| BR-WR-007 | V1 | A Work Request must preserve status history and comments. |
| BR-WR-008 | V1 | Rejected Work Requests must follow the approved lifecycle: Needs Changes for correctable issues, permanent rejection only for safety, prohibited work, policy violations, or duplicates. |
| BR-WR-009 | V1 | Work Requests must support configurable categories through Master Data. |
| BR-WR-010 | V1 | Work Requests should support priority and due-date information. |

### MOD-05 Manufacturing Tasks

| ID | Scope | Requirement |
| --- | --- | --- |
| BR-MT-001 | MVP | A Work Request may be split into one or more Manufacturing Tasks. |
| BR-MT-002 | MVP | Manufacturing Tasks must support task types such as laser cutting, 3D printing, PCB milling, CNC routing, design, assembly, and testing. |
| BR-MT-003 | V1 | Each Manufacturing Task must have an owner or responsible core team role. |
| BR-MT-004 | V1 | Manufacturing Tasks must support progress states from draft/review to approved/completed. |
| BR-MT-005 | V1 | If a Work Request is cancelled or permanently rejected before completion, all unfinished Manufacturing Tasks must automatically move into Cancelled state while preserving history. |
| BR-MT-006 | V1 | Manufacturing Tasks should support estimated duration and task dependencies. |

### MOD-06 Machine Queue

| ID | Scope | Requirement |
| --- | --- | --- |
| BR-MQ-001 | MVP | Machine Heads must have a clear queue of pending Manufacturing Tasks. |
| BR-MQ-002 | V1 | Machine Heads must be able to assign or reorder work based on operational judgment. |
| BR-MQ-003 | V1 | Queue views must show enough information to understand what must be done next. |
| BR-MQ-004 | V1 | The system must support multiple tasks being handled when operationally possible. |

### MOD-07 Machines And MOD-08 Maintenance

| ID | Scope | Requirement |
| --- | --- | --- |
| BR-MACH-001 | MVP | Machines must be associated with a lab. |
| BR-MACH-002 | V1 | Machines must have availability/maintenance state. |
| BR-MACH-003 | V1 | Machine runtime or usage must be manually recordable. |
| BR-MACH-004 | V1 | Runtime and usage records must support future costing and maintenance reports. |

### MOD-09 Assets, MOD-10 Inventory, MOD-11 Borrowing

| ID | Scope | Requirement |
| --- | --- | --- |
| BR-INV-001 | MVP | The system must separate consumables, borrowable items, and assets. |
| BR-INV-002 | MVP | Operation Head/core team must be able to import inventory data from CSV or Excel. |
| BR-INV-003 | V1 | Inventory records must include lab/location details such as shelf, rack, drawer, or similar placement. |
| BR-INV-004 | V1 | Inventory changes must create movement/history records. |
| BR-INV-005 | V1 | Students must be able to borrow eligible items. |
| BR-INV-006 | V1 | Borrowing must support due dates, reminders, overdue marking, return status, and operational clearing. |
| BR-INV-007 | V1 | Users with unresolved overdue borrowing may be blocked from future borrowing until cleared. |
| BR-INV-008 | V1 | Reports must support export to Excel/CSV/PDF. |

### MOD-12 Visitors

| ID | Scope | Requirement |
| --- | --- | --- |
| BR-VIS-001 | MVP | Users must be able to check into a lab with a reason/purpose. |
| BR-VIS-002 | MVP | The system must record check-in and checkout times. |
| BR-VIS-003 | V1 | Visitor logs must support event, project, machine, tool, or personal-project context when relevant. |
| BR-VIS-004 | V1 | Visitor reports must be exportable. |

### MOD-13 Events And MOD-14 Workshops

| ID | Scope | Requirement |
| --- | --- | --- |
| BR-EVT-001 | MVP | Events Head/admin must be able to create and publish events/workshops. |
| BR-EVT-002 | MVP | Students must be able to view upcoming events/workshops. |
| BR-EVT-003 | V1 | Events must support registration, attendance, and optional certificate eligibility. |
| BR-EVT-004 | V1 | Event participation must support reports. |

### MOD-15 Payments And MOD-16 Quotations

| ID | Scope | Requirement |
| --- | --- | --- |
| BR-PAY-001 | MVP | Work Requests that require payment must support quotation creation. |
| BR-PAY-002 | MVP | V1 payment handling must support UPI/manual verification, not a payment gateway. |
| BR-PAY-003 | V1 | The default payment model should support 50 percent before completion and 50 percent after completion where required. |
| BR-PAY-004 | V1 | Payment records must include verification status and verifier. |
| BR-PAY-005 | V1 | Payment history must be auditable. |

### MOD-17 Notifications

| ID | Scope | Requirement |
| --- | --- | --- |
| BR-NOTIF-001 | MVP | The system must notify users about important operational status changes. |
| BR-NOTIF-002 | V1 | Notification categories must support work request, manufacturing task, payment, borrowing, event, system, and admin updates. |
| BR-NOTIF-003 | V2 | Push notifications should be added after in-app notification flows are stable. |

### MOD-18 Reports And MOD-19 Audit Logs

| ID | Scope | Requirement |
| --- | --- | --- |
| BR-REP-001 | MVP | Operation Head/admin must be able to export basic operational reports. |
| BR-REP-002 | V1 | Reports must include inventory, borrowing, visitors, Work Requests, machine usage, payments, and events. |
| BR-AUD-001 | MVP | Important operational actions must create audit history. |
| BR-AUD-002 | V1 | Audit logs must include actor, action, target entity, timestamp, and relevant metadata. |

### MOD-20 Administration And MOD-21 Master Data

| ID | Scope | Requirement |
| --- | --- | --- |
| BR-ADM-001 | MVP | Super Admin must be able to manage core operational configuration. |
| BR-ADM-002 | V1 | Labs, departments, semesters, positions, machine types, categories, visitor purposes, and payment methods must be configurable. |
| BR-ADM-003 | V1 | Admin controls must avoid exposing sensitive configuration to normal users. |

### MOD-22 Knowledge Base

| ID | Scope | Requirement |
| --- | --- | --- |
| BR-KB-001 | Future | The system should support approved SOPs, tutorials, machine guides, and troubleshooting articles. |
| BR-KB-002 | Future | Community-authored knowledge should require moderation or approval before publishing. |

## Business Rules

| ID | Rule |
| --- | --- |
| BIZ-001 | A Work Request has exactly one student leader. |
| BIZ-002 | A Work Request can have multiple members. |
| BIZ-003 | Students do not directly operate fabrication machines by default. |
| BIZ-004 | Machine Heads own machine queue decisions. |
| BIZ-005 | Operation Head owns inventory, borrowing, visitor, payment, and reporting records. |
| BIZ-006 | Events Head owns event/workshop planning and publishing. |
| BIZ-007 | Material edits to a student Work Request by core team require student leader approval before execution. |
| BIZ-008 | Large design files should normally be stored externally and linked. |
| BIZ-009 | Consumables, borrowable items, and assets must not be modeled as one generic item type without distinction. |
| BIZ-010 | Payment gateway integration is not required for V1. |
| BIZ-011 | External customer ordering is deferred to a future website/portal. |
| BIZ-012 | Audit history is required for critical operational state changes. |
| BIZ-013 | Master data should be configurable instead of hardcoded. |
| BIZ-014 | Users with unresolved overdue borrowing may be restricted from new borrowing. |
| BIZ-015 | Rejected Work Request lifecycle must be finalized before workflow implementation. |
| BIZ-016 | Default Work Request review outcome for correctable issues is Needs Changes, not Rejected. |
| BIZ-017 | Permanent rejection is reserved for safety violations, prohibited work, policy violations, or duplicate requests. |
| BIZ-018 | Cancelled or permanently rejected Work Requests cancel unfinished Manufacturing Tasks while preserving history. |
| BIZ-019 | Work Request categories, visitor reasons, machine types, inventory categories, priorities, asset statuses, and borrowing statuses are Master Data. |

## Risks

| ID | Risk | Impact | Mitigation |
| --- | --- | --- | --- |
| R-BRD-001 | MVP scope becomes too large | Delayed release | Separate MVP, V1, V2, Future scope |
| R-BRD-002 | Core team workflow becomes too heavy | Low adoption | Minimize required input and support imports |
| R-BRD-003 | Inventory data quality is poor | Wrong reports | Import validation, audit logs, correction history |
| R-BRD-004 | Payment disputes occur | Trust loss | Verification records and audit trail |
| R-BRD-005 | UI redesign distracts from operations | Operational gaps | Build around workflow modules first |

## Open Questions

1. Which Work Request categories require quotation by default?
2. Which reports are mandatory for the first V1 release?
3. Which exact machine names and locations should be configured first?
4. What are the initial allowed email domains and exception process?
5. Should Work Requests or Inventory/Borrowing be the first operational module
   implemented after architecture approval?

## Future Enhancements

- External customer website/portal.
- Push notifications.
- Payment gateway.
- AI-assisted quotation.
- IoT machine telemetry.
- Certificate automation.
- Multi-institution support.
- Alumni engagement.

## Approval Checklist

- [ ] Business requirements reviewed
- [ ] Business rules reviewed
- [ ] MVP/V1/V2/Future scope accepted
- [ ] Open questions accepted or assigned
- [ ] Risks acknowledged
- [ ] Approved to proceed to Phase 1B PRD/SRS
