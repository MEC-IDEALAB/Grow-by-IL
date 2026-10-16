# Penpot 00–18 acceptance matrix

Updated: 2026-09-28. The live Penpot connector returned `No Penpot instance connected for user token` during this audit. Earlier work observed **19 pages numbered 00–18**, not 18 pages. Page 17 previously gained a motion/interaction board; that is not a fresh live verification or proof that every page is complete. Keep existing useful design work and record the actual page names when the connector returns.

## Page inventory and evidence

| Page number | Live title / purpose | Visual/state audit | Prototype audit | Android parity |
| --- | --- | --- | --- | --- |
| 00 | Reconfirm live title | Pending connector | Pending | N/A or pending |
| 01 | Reconfirm live title | Pending connector | Pending | N/A or pending |
| 02 | Auth flow previously linked; reconfirm | Pending connector | Recheck signup, confirm, sign-in, reset | Pending |
| 03 | Reconfirm live title | Pending connector | Pending | Pending |
| 04 | Reconfirm live title | Pending connector | Pending | Pending |
| 05 | Reconfirm live title | Pending connector | Pending | Pending |
| 06 | Reconfirm live title | Pending connector | Pending | Pending |
| 07 | Reconfirm live title | Pending connector | Pending | Pending |
| 08 | Reconfirm live title | Pending connector | Pending | Pending |
| 09 | Reconfirm live title | Pending connector | Pending | Pending |
| 10 | Earlier Explore treatment may be stale | Pending connector | Recheck Lab naming/routes | Pending |
| 11 | Work Request flow previously linked; reconfirm | Pending connector | Recheck start/detail/back | Pending |
| 12 | Work Request flow previously linked; reconfirm | Pending connector | Recheck start/detail/back | Pending |
| 13 | Reconfirm live title | Pending connector | Pending | Pending |
| 14 | Reconfirm live title | Pending connector | Pending | Pending |
| 15 | Reconfirm live title | Pending connector | Pending | Pending |
| 16 | Reconfirm live title | Pending connector | Pending | Pending |
| 17 | Motion/interaction board previously populated; reconfirm | Pending connector | Recheck state transitions | Pending |
| 18 | Home/Lab/Profile shell previously present; reconfirm | Pending connector | Recheck all tab variants | Pending |

`Pending` means unverified, not incomplete. Replace it with direct board/frame evidence, issue or screenshot reference, and the date of inspection. Do not rename a page just to fit an older proposed mapping.

## Definition of a complete buildable page

1. Named persona/task, entry route, primary action, exit/back/cancel/retry targets and privacy/permission boundary.
2. Shared components and tokens: Space Grotesk display, DM Sans body, paper/ink foundation, purposeful blue/lime/yellow/coral accents, 4/8 spacing, 2 px borders, restrained corners and hard shadows. Text never relies on color alone.
3. Phone layout without clipped auth or onboarding content at normal text size, plus large-text and responsive variants. Interactive targets at least 48 dp.
4. Real default, loading, empty, recoverable error, offline and unauthorized states as applicable. Financial/destructive actions get explicit confirmation. Never imply data that the backend cannot provide.
5. Original vector doodles and approved real lab/project imagery with rights and alt-text notes. No emoji decoration or generic machinery pretending to be installed equipment.
6. Motion timing, purpose and reduced-motion equivalent. Animation never blocks account confirmation, form completion or navigation.
7. A clickable happy path **and** back/cancel/error/retry links. No dead controls or route to a fake screen.
8. Flutter component/token mapping and a captured Android comparison for implemented screens. A Penpot frame alone is not an implementation acceptance test.

## High-priority flows to verify first

`Create account → check email → verified success → explicit sign-in → profile setup → Home` (a stale/used link never signs in); Google success/cancel/error; Home↔Lab↔Profile and Back; manual lab check-in/out; Work Request start/detail/status; machine/component request split; project join-code request and creator approval; free/paid event RSVP with no pre-payment seat hold; cancellation/refund request to Events Head.

The phone is unavailable for this audit. Live Penpot edits, full-page completion and Android screenshot parity remain open gates.
