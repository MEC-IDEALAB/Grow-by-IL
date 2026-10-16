# Product decision delta — 2026-09-17

Status: review candidate; reconciles decisions given by the product owner in the Codex conversation. It is not a deployed backend contract or a substitute for a reviewed charter revision.

## Why this exists

The approved `00_PRODUCT_CHARTER.md` (2026-08-02) and the later product-owner decisions disagree on eligibility, identity, navigation, and the v1 boundary. Engineering must not choose whichever document is convenient. The following decisions are explicit and should be incorporated into a reviewed charter/backlog revision before new persistence or permission work.

| Topic | Older charter or implementation | Product-owner decision to carry forward | Consequence |
| --- | --- | --- | --- |
| Eligibility | College email and MEC-only mobile v1; external customers deferred | Any email may sign up. MEC members and outside students/professionals may use the app. Onboarding is mandatory, with organization/college or professional details appropriate to the person. | No email-domain eligibility gate. Keep user category/institution distinct from verified status; do not imply a person was checked by staff. |
| Identity | College identity treated as signup prerequisite | Sign in first, complete required onboarding, then enter Home. MEC roll number and college details are collected where applicable; optional profile enrichment remains editable. | Authenticated does not mean institution-verified or machine-authorized. |
| Navigation | Home / Akathalam / Profile | Home / Lab / Profile. Remove Akathalam from the bottom bar. | Three stable destinations, with Projects, Events, Work Requests, and operations reached contextually. |
| Lab model | IDEA Lab and Fab Lab listed as labs | One managed IDEA Lab + Fab Lab entity with two physical rooms. IDEA Lab primarily has components and some machines; Fab Lab primarily has fabrication machines. | Do not invent separate organizations, room inventory, or machine mapping until supplied. |
| Entry | QR emphasized in current UI | Manual check-in/out is primary; door QR is optional. Outside-hours entry requires an on-site checked-in head. | Do not claim a QR scan is required, or that a user may operate a machine after checking in. |
| Machine use | Student-friendly request model | Students and other users may directly request/book machine work, but only the Machine Head operates fabrication machines. Machine-related work goes to Machine Head; components/tools/billing/usage to Operation Head. | Keep booking/request distinct from authorization to operate. Route decisions server-side when the role model is approved. |
| Work Request | Local mock V1 currently appears operational in places | Requests need real lifecycle, machine-specific questions, estimate/slot/duration, quotation, payment, and accountable status history. | Remove fabricated counts and records; do not present local mock submission as a production request. Keep Work Request, Manufacturing Task, and Machine Queue separate. |
| Projects | Existing basic projects | Users may create public or private projects, discover public projects, and request to join via project code. Only the creator approves membership. | A project code initiates a request; it must not grant automatic membership. Code and membership checks belong on the server. |
| Events | Existing event browsing | Free and paid events may admit outside attendees. A paid seat is confirmed only after payment verification; unconfirmed payment must not hold capacity. Cancellation is a reasoned request to Events Head; Events Head handles event payments/refunds. Full events close to registration. | Capacity/payment transitions require one atomic server-side contract; no optimistic seat promise or automatic refund claim. |
| Payments | Manual UPI listed | Use official lab UPI QR, then transaction ID or proof upload and manual verification. Quotations, billing, and event refunds require accountable heads and history. | Never treat an entered transaction ID as verified payment. No gateway assumption. |
| Borrowing | Semester-bounded return suggested | User chooses expected return, capped within the semester; student marks returned, Operation Head verifies. Warning first; current provisional fine is ₹10/day after the warning. | Fine timing/waiver and due-date policy need approval before automated charges. |
| Roles | Three roles currently shipped (`student`, `lab_admin`, `super_admin`) | Super Admin assigns Machine, Operation, Events, Design, Web/Tech, and other core-head responsibilities. Machine/Operation/Events are first operational specialties. | Do not fake these as secure permissions in the client. Approve a role/assignment/RLS model before privileged screens. |
| Design | Older pastel/purple soft-neobrutalist RC5 tokens | Bright ink-and-paper neo-brutalism with intentional blue/lime/yellow/coral/pink, Space Grotesk + DM Sans, original doodles, authentic imagery, purposeful motion, English first, and no emoji decoration. | Reconcile Penpot and shared Flutter primitives in a separate design-system PR. Do not scatter page-specific hardcoded palettes. |
| Name | Grow used in code and links | Name may change to IDEA Lab or another final name. | Keep display name configurable/centralized; do not rename package IDs or domains without a separate decision. |

## Unresolved inputs — do not invent

1. Final product name, logo source, and approved photo/illustration assets.
2. Exact machines, tools, components, rooms, operating rules, pricing, and safety prerequisites. The owner will supply the inventory, possibly through a maintained spreadsheet.
3. Payment verification, quotation, fine-waiver, and refund accounting rules beyond the decisions above.
4. Backend authorization design for core-head assignments and outside users, including privacy scope of institutional and profile data.
5. Production domain and verified Android/iOS App Links for profile/project sharing. The existing `grow.app` example is not proof of domain control.

## Review and change control

This delta should be reviewed alongside `00_PRODUCT_CHARTER.md`, `PRODUCT_BACKLOG.md`, `FEATURE_INVENTORY.md`, the authorization model, and the current Supabase migrations. Close the contradictions explicitly, record a charter version/date, and only then advance persistence gates. Existing users and schemas need migration analysis rather than an ad-hoc live edit.
