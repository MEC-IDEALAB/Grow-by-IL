# Grow Platform Product Charter

Status: Approved - Version 1.0  
Owner: Product Owner / Lead Architect  
Last updated: 2026-08-02

## 1. Project Overview

Grow is the digital operating platform for the Innovation Hub ecosystem at Model
Engineering College, initially serving IDEA Lab and Fab Lab. It coordinates the
people, machines, materials, requests, visitors, events, payments, and records
needed to run a student-centered innovation facility.

Grow is not only a lab booking app. It is an Innovation Hub Management Platform
that combines student identity, core team operations, manufacturing workflows,
inventory control, borrowing, visitor logging, events/workshops, payments,
reports, notifications, and auditability.

## 2. Mission

Help students, core team members, faculty, and alumni engage with the Innovation
Hub through a reliable system that turns ideas into organized requests,
trackable work, responsible lab usage, and measurable community impact.

## 3. Vision

Grow should become the operating system for college innovation hubs: a platform
where students discover opportunities, submit work requests, attend events,
borrow tools, build portfolios, and collaborate with a core team that can manage
machines, inventory, visitors, payments, reports, and institutional records with
confidence.

Long term, Grow should be configurable enough to support other institutions, but
the initial user experience remains focused on Model Engineering College.

## 4. Product Objectives

1. Provide a single trusted platform for IDEA Lab and Fab Lab operations.
2. Replace informal tracking with structured Work Requests, task queues, logs,
   payments, reports, and audit trails.
3. Help students access lab support without directly operating fabrication
   machines.
4. Give Machine Heads and core team members clear queues, status, and task
   ownership.
5. Give Operation Head reliable inventory, borrowing, visitor, payment, and
   reporting workflows.
6. Support events, workshops, attendance, and community engagement.
7. Preserve student identity and alumni connection without compromising
   operational clarity.
8. Keep MVP scope focused while designing for future modules.

## 5. Stakeholders

Primary stakeholders:

- Students
- Core Team
- Machine Heads
- Operation Head
- Student Ambassador
- Events Head
- Tech Head
- Design Head
- Media Head
- Documentation Head
- Faculty
- Super Admin

Secondary and future stakeholders:

- Trainees
- Alumni
- Lab Staff
- External customers through future website/portal
- College administration
- Partner schools, startups, or companies

## 6. Scope

### In Scope For Platform Architecture

- Authentication and institution-aware identity
- User profiles and alumni readiness
- Role and position-aware access
- Work Requests
- Work Request collaborators
- Manufacturing Tasks
- Machine queue and machine assignment
- Machine runtime and maintenance records
- Consumables, borrowable items, and assets
- Inventory import/export
- Borrowing and return workflows
- Visitor logs
- Events and workshops
- Attendance and optional certificate eligibility
- Quotations
- UPI/manual payment verification
- Notifications and announcements
- Reports and analytics
- Audit logs
- Master data configuration
- Knowledge Base as a future-ready module

### MVP / V1 Focus

V1 should focus on operational reliability before advanced automation:

- college email signup and onboarding
- common dashboard with role-based widgets
- Work Requests with collaborators
- Manufacturing Tasks and machine queue basics
- inventory/borrowing foundation
- visitor log
- event/workshop management
- quotation and manual UPI verification
- notifications
- audit history for critical actions
- exportable reports

### Out Of Scope For V1

- Direct messaging/chat
- Full online payment gateway
- AI cost estimation
- AI design validation
- IoT machine monitoring
- External public ordering inside the mobile app
- Multi-college UI
- Public marketplace
- Advanced analytics dashboard
- Automatic machine/material consumption without human review

## 7. Core Product Principles

### 7.1 Operations First

The platform must make lab operations easier, not just make screens look modern.
Machine Heads, Operation Head, and core team workflows are first-class.

### 7.2 Student-Friendly But Safe

Students can request work, attend events, borrow items, and use lab facilities,
but fabrication machine operation is handled primarily by trained core team or
machine team members.

### 7.3 Work Request, Not Order

The system uses Work Requests because lab work is collaborative and review-based.
One Work Request may involve several Manufacturing Tasks.

### 7.4 Auditability By Default

Important operational actions should create history: inventory changes, payments,
task assignment, role changes, borrowing, visitor check-in/out, and status
updates.

### 7.5 Master Data Over Hardcoding

Departments, labs, machine types, positions, visitor purposes, inventory
categories, payment methods, notification categories, and allowed email domains
should be configurable.

### 7.6 Keep Storage Lightweight

Large design files should usually be external links such as Google Drive, GitHub,
Dropbox, or OneDrive. Supabase Storage should be used selectively for smaller
images and necessary documents.

### 7.7 Phase-Gated Development

Do not move from one phase to the next without review and approval. Architecture
is the source of truth before implementation.

### 7.8 Single Source Of Truth

Each operational entity should have a clear primary owner so edits, approvals,
and accountability do not conflict.

Examples:

- Work Request -> Student Leader
- Machine Queue -> Machine Head
- Inventory -> Operation Head
- Event -> Events Head
- Asset -> Operation Head
- Visitor Log -> System

## 8. Key Business Concepts

### Institution

The top-level organization. Initially Model Engineering College. The architecture
should be ready for future multi-institution configuration, but the UI should
stay single-institution for now.

### Labs

Initial labs:

- IDEA Lab
- Fab Lab

The system should support adding labs later without code changes.

### Work Request

A request submitted by a student/team for help, fabrication, design, machine
work, or project support.

Work Requests support:

- leader/owner
- multiple members
- optional future faculty guide
- reason/purpose
- external file links
- review
- Machine Head edits
- student re-approval after edits
- quotation
- payment
- task creation
- status timeline

### Manufacturing Task

A unit of work under a Work Request, such as laser cutting, 3D printing, PCB
milling, CNC routing, assembly, or design support.

### Inventory

Operational stock and items separated into:

- consumables
- borrowable items
- assets

### Asset

A fixed or individually tracked item such as a machine, laptop, projector,
camera, UPS, or oscilloscope.

### Master Data

Configurable operational reference data controlled by authorized admins.

## 9. Initial Roles

Base roles and positions should be refined in the Role Permission Matrix phase.

Planned roles/positions:

- Super Admin
- Student
- Trainee
- Faculty
- Alumni
- Core Team
- Student Ambassador
- Machine Head
- Operation Head
- Events Head
- Documentation Head
- Tech Head
- Design Head
- Media Head
- Future Lab Staff

Principle: start with simple permissions and common dashboards. Add specialized
widgets and permissions by role/position as the system matures.

## 10. Success Metrics

Operational success:

- Work Requests are trackable from submission to pickup.
- Machine Heads can understand queue and task state quickly.
- Operation Head can inspect inventory, borrowing, visitors, and reports.
- Payment verification is traceable.
- Audit logs exist for critical actions.

Student success:

- Students can onboard with college identity.
- Students can submit and track Work Requests.
- Students can attend events/workshops.
- Students can borrow and return items responsibly.
- Students understand why they visited the lab and have digital history where
  appropriate.

Institutional success:

- Weekly/monthly reports can be exported.
- Visitor and usage records are reliable.
- Inventory movement history is preserved.
- Machine runtime and maintenance history are available.

Engineering success:

- Architecture reduces rework.
- MVP remains focused.
- Future modules can be added without major schema collapse.
- Documentation and decisions stay aligned.

## 11. Constraints

- Current frontend stack is Flutter.
- Current backend stack is Supabase.
- Supabase storage should be used carefully.
- The product is initially for MEC only.
- External customer experience is deferred to a future website/portal.
- Core team capacity and manual operation must be respected.
- The system must be understandable for student operators and core team members,
  not only engineers.

## 12. Assumptions

- Students primarily use college identity for signup.
- Allowed email domains are institution-configurable.
- Admin can manually approve exceptional users.
- Large fabrication/design files are mostly shared through external links.
- Operation Head owns inventory records and many operational reports.
- Machine Head chooses machines and manages machine queue decisions.
- External customer flow is not part of mobile app V1.
- Payment gateway integration is not required for V1.

## 13. High-Level Risks

- Scope expands beyond MVP.
- Operational workflows become too complex for student core team use.
- Inventory data quality suffers without import validation and audit history.
- Payment records become disputed without verification workflow.
- Database may become hard to evolve if Work Requests, Tasks, Assets, and
  Inventory are not separated early.
- Documentation may drift if phase gates are ignored.

Mitigations are tracked in `../00_Project_Management/RISK_REGISTER.md`.

## 14. Recommended Phase Roadmap

### Phase 0 - Product Charter

Goal: freeze product direction and governance.

Deliverable: this charter.

### Phase 1 - Requirements

Goal: define what the platform must do.

Deliverables: executive summary, vision, BRD, PRD, SRS.

### Phase 2 - Architecture

Goal: define how the platform is structured.

Deliverables: system architecture, module architecture, database architecture,
ERD, role permission matrix.

### Phase 3 - UX And Workflows

Goal: define how users move through the product.

Deliverables: user journeys, navigation map, screen flow, workflows, dashboard
blueprint.

### Phase 4 - Engineering Design

Goal: define how the system will be implemented safely.

Deliverables: Flutter architecture, Supabase architecture, API contracts,
security model, testing strategy.

### Phase 5 - Implementation Planning

Goal: define build order.

Deliverables: roadmap, sprint plan, task breakdown, AI/Codex handover, master
blueprint.

## 15. Phase 0 Approval Requirements

To approve Phase 0, reviewers should confirm:

- The platform direction is correct.
- The MVP/V1 boundaries are acceptable.
- Work Request terminology is accepted.
- Task-based manufacturing is accepted.
- Inventory/borrowable/assets separation is accepted.
- UPI/manual payment verification is accepted for V1.
- External customer website is deferred.
- Phase-gated architecture process is accepted.

## Open Questions

1. Exact initial allowed email domains must be configured.
2. Exact machine-to-lab mapping should be completed.
3. Exact pricing templates and cost formula require Operation Head/Machine Head
   review.
4. Alumni dashboard scope can be refined later.
5. External website scope can be defined after mobile V1 architecture.
6. Rejected Work Request lifecycle should be defined: permanent rejection,
   rejection with comments and resubmission, or conversion into another request
   type.

## Future Enhancements

- Public external order website
- AI quotation/cost estimation
- AI design validation
- IoT machine runtime telemetry
- QR badges for visitors
- Full payment gateway integration
- Multi-institution admin UI
- Public alumni/community portal
- Advanced analytics dashboards
- Knowledge Base with SOPs, manuals, and training media

## Approval Checklist

- [x] Product direction approved
- [x] Scope approved
- [x] Out-of-scope list approved
- [x] Roles accepted at charter level
- [x] Work Request model accepted
- [x] Inventory/asset separation accepted
- [x] Payment approach accepted
- [x] Risks acknowledged
- [x] Open questions accepted for later phases
- [x] Approved to begin Phase 1
