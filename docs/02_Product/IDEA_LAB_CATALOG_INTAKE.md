# IDEA Lab Catalog Intake

Status: candidate master-data intake; not a live inventory, booking catalog,
price list, operating approval, safety clearance or availability feed.

## Source and boundary

The product owner supplied a copy of the official IDEA Lab MEC Facilities and
Inventory pages on 2026-09-29, with `https://idealab.mec.ac.in/facilities` as
the source for facilities. The public page is useful for identifying items
that need verification; it is not a current machine register. It must not be
used to infer ownership, status, capacity, machine availability, stock,
condition, policy or price.

The owner also clarified that the national scheme document lists requirements
and possible equipment across labs, not equipment necessarily owned by MEC.
It is intentionally excluded from this intake.

## Candidate facilities to verify

These names were copied from the official site material. Preserve the source
label until a lab representative confirms the canonical display name, model,
asset tag and operational state.

| Candidate source label | Likely service family | Required verification before it appears in Grow |
| --- | --- | --- |
| Epilog laser engraver | Laser cutting / engraving | Exact model, usable materials, trained operator policy, safety rule, room and status. |
| HMT CNC lathe | CNC machining | Exact model, capability, machine owner, training/safety restriction and status. |
| HMT CNC router machine | CNC routing | Exact model, material limitations, owner, safety restriction and status. |
| PC workstation | Digital design workstation | Count, permitted software, booking rules, owner and availability. |
| PCB manufacturing station | PCB fabrication | Included equipment, chemical/safety process, owner and current usability. |
| Sand blasting machine | Surface finishing | Exact asset, PPE/process rule, operator authorization and status. |
| Shopbot CNC | CNC routing | Exact model, materials, owner, safety restriction and status. |
| Snapmaker A350T | 3D printing / laser / CNC | Enabled modules, material/size limits, owner and separate queue rules. |
| SolidWorks Software | CAD software | Licence availability, workstation scope, access policy and owner. |
| Sublimation printing station | Printing / transfer | Included equipment, materials, owner, safety/process rule and status. |
| Ultimaker 2+ | 3D printing | Exact unit count, nozzle/material policy, owner and status. |

## Inventory material is intentionally not imported

The supplied old Inventory page mentions components and tools such as ESP32,
Arduino Uno, Raspberry Pi 4, soldering equipment, breadboards, multimeters,
sensors, motors and CROs. Its quantities include duplicate labels and are
explicitly not the updated stock supplied for launch. Grow must not convert
them into available quantities, borrowing limits or bookable stock.

When the owner provides the updated stock, import it through a reviewed
template with:

- canonical item and variant identifier;
- classification: consumable, borrowable, tool or fixed asset;
- unit and audited opening quantity;
- storage location and responsible team;
- condition/availability status;
- source date and approver; and
- safe correction/reconciliation process.

## Master-data release gate

Before a facility can be shown as bookable or a component can be requested:

1. A Super Admin or delegated trusted server-side process records a verified
   catalog entry. Client profile fields or visible head labels cannot create
   one.
2. Operations approves the service and safety/eligibility policy; Machine
   responsibility is assigned only under the separate position contract.
3. The final name, room, service limits, maintenance state, pricing policy and
   visibility are confirmed. Unknown values are represented as unavailable,
   not guessed.
4. Backend storage, RLS and audit rules distinguish catalog definition,
   availability, inventory movement, machine queue and booking request.
5. A real-time view is enabled only after server-side data, concurrency rules
   and Android tests exist. A static website list is not real-time data.

## Next owner input

Provide a dated, reviewed facility/stock export and identify the person
authorized to correct it. The first implementation PR can then define the
canonical master-data schema and import validation without copying old public
counts into production.
