# Work Request Implementation Contract

Status: Approved  
Owner: Product Owner / Lead Architect  
Last updated: 2026-08-02

This is the concise implementation contract for the first Work Request Create
Flow. No Flutter form, repository, schema migration, or RLS policy should be
implemented until this contract is reviewed and approved.

## Scope

First build: Fabrication Work Requests only.

Out of scope for the first Create Flow:

- non-fabrication request categories
- quotation generation
- payment collection
- machine assignment
- operator assignment
- queue reordering
- inventory consumption
- Supabase persistence, unless Phase 2 ERD/RLS is approved

Draft persistence is local-device only using SharedPreferences, matching the
existing onboarding draft pattern. There is no cloud draft table and no Supabase
writes of any kind in this phase.

## State Machine

Student-facing Work Request states:

| State | Meaning | Owner |
| --- | --- | --- |
| `draft` | Student is preparing the request locally or as a saved draft | Student |
| `submitted` | Request is submitted for core-team review | Student/System |
| `reviewed` | Core team has reviewed and may suggest edits, estimate, or split tasks | Core Team |
| `changes_requested` | Core team needs student approval or correction before work starts | Core Team |
| `approved` | Student and core team have agreed to proceed | Student/Core Team |
| `in_progress` | Work has started | Machine Head/Core Team |
| `ready_for_pickup` | Work is completed and ready to collect | Core Team |
| `completed` | Student collected/accepted the work | Student/Core Team |
| `cancelled` | Student cancelled before commitment | Student |
| `rejected` | Request cannot proceed | Core Team/Admin |

Default rejection path:

- reject with comments
- allow resubmission as a new request
- do not mutate a rejected request into a new active request

Rejected requests carry a `rejection_type`:

- `resubmittable` is the default and allows the student to create a new request
  using the rejection comments as guidance.
- `permanent` is Machine Head/Admin only and is used for safety violations,
  policy breach, or abuse. The student sees that the request cannot be
  resubmitted and must contact the core team.

Manufacturing Tasks are first created at the `reviewed` -> `approved`
transition, not earlier.

## Manufacturing Task Cascade

- Before `approved`, no Manufacturing Tasks exist, so cancellation or rejection
  needs no cascade.
- After `approved`, associated Manufacturing Tasks exist. Parent cancellation
  cascades to all child tasks: each child task moves to `cancelled`, carries the
  parent cancellation reason for audit, operators are notified, and the queue is
  updated.
- No Manufacturing Task may exist in isolation without a non-cancelled parent
  Work Request.

## Required Fields

### System Prefill

- leader user id
- leader display name
- contact email
- department/class if already in profile

### Student Input

- request title
- fabrication subcategory
- purpose/reason
- detailed description
- quantity
- priority: Low/Normal/High, default Normal, student-suggested, Machine Head may override later
- preferred completion date
- external file links, if design files exist
- design support needed: yes/no
- material procurement needed: yes/no
- material notes when procurement is needed
- lab preference: IDEA Lab/Fab Lab/no preference
- collaborators/members, optional
- safety acknowledgement
- edit approval acknowledgement
- review summary confirmation

## Validation Rules

- Title is required.
- Purpose/reason is required.
- Description is required and must be detailed enough for review.
- At least one fabrication subcategory is required.
- Quantity must be at least 1.
- Priority must be Low, Normal, or High and defaults to Normal.
- External file links must be valid URLs when provided.
- Preferred completion date cannot be in the past. No required-before date or
  related-event date is included in the first build.
- Material notes are required when material procurement is selected.
- Student must accept safety/policy acknowledgement before submitting.
- Student must confirm the review summary before submitting.

## Permission Rules

| Actor | Allowed |
| --- | --- |
| Student | create draft, submit request, edit before commitment, cancel before commitment, approve core-team edits |
| Core Team | review request, suggest edits, create internal tasks, update status |
| Machine Head | manage machine task queue, assign machine/operator, log runtime |
| Operation Head | manage records, inventory impact, exports, billing support |
| Super Admin | override, audit, moderate, soft-delete |

Students must not see:

- raw machine queue
- internal priority rationale
- internal notes
- full operator assignment history
- maintenance conflict details

Students may see:

- current status
- coarse queue position
- estimated completion window
- assigned lab/machine after review
- public-facing core-team contact

## Payment State Rules

Payment implementation is deferred, but the approved lifecycle should support:

| State | Meaning |
| --- | --- |
| `quote_draft` | Core team is preparing cost estimate |
| `quote_sent` | Student can review estimated cost |
| `deposit_due` | 50% advance is required before committed work |
| `deposit_paid` | Work can begin |
| `balance_due` | Remaining 50% due after completion |
| `paid` | Payment complete |
| `waived` | Admin/core team waived payment |

V1 payment collection may be manual UPI recording. Do not integrate a payment
gateway until the payment workflow is approved.

The Work Request status state machine and payment state machine are linked:
`in_progress` cannot be entered until `deposit_paid`, even when the request is
otherwise approved.

## Notification Events

| Event | Recipient |
| --- | --- |
| Request submitted | Machine Head/Core Team |
| Request reviewed | Student |
| Changes requested | Student |
| Student approved edits | Machine Head/Core Team |
| Request approved | Student |
| Work started | Student |
| Ready for pickup | Student |
| Request completed | Student and Operation Head |
| Request cancelled | Machine Head/Core Team |
| Request rejected | Student |
| Payment/deposit state changed | Student |

## Database Entities

Phase 2 ERD should define these before migration:

- `work_requests`
- `work_request_members`
- `work_request_links`
- `manufacturing_tasks`
- `machine_task_queue`
- `work_request_status_events`
- `work_request_comments`
- `work_request_payment_records`

## API / Repository Contracts

Initial repository operations:

- create draft
- update draft
- submit request
- fetch my requests
- fetch request detail
- cancel request
- approve suggested edits
- core review update
- update public status

All write operations must record an audit/status event.

## UI Flow

First Create Flow:

1. Select category and fabrication subcategory. Fabrication is enabled; future
   categories are visible but disabled with a "Coming soon" label.
2. Enter title, purpose, and description.
3. Add quantity, timeline, lab preference, and file links.
4. Add members/collaborators.
5. Answer design/material support questions.
6. Review summary.
7. Accept acknowledgements.
8. Submit.

## Acceptance Criteria

- Student can submit a fabrication request with all required information.
- Invalid links and missing required fields block submission.
- Student sees only coarse queue/status information.
- Existing booking/admin/auth flows remain unaffected.
- No schema migration is merged without approved Phase 2 ERD/RLS.
- No Supabase file upload dependency is introduced in the first flow.
- The Create Flow remains feature-flagged until device QA passes.
