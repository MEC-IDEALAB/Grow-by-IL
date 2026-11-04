# Shared account SQL source reconciliation

This source-only change records two exact owner-approved migrations already installed during maintenance on 2 November 2026 and the core contract's local review fixtures. It does not apply SQL, activate clients, introduce a new operational schema or approve production rollback.

## Installed records

A read-only check of the IDEALAB MEC shared project's migration ledger on 4 November returned one stored statement for each version. Local source files match the statement bytes exactly:

| Version | Name | SHA-256 of stored statement and source file |
| --- | --- | --- |
| `20261102083307` | `shared_access_hardening_v1` | `d0b78457f55befaabc67d4767507e0b6a282ed6c909c4884cae7535719f23a15` |
| `20261102130200` | `shared_profile_contract_v1` | `492fbccba41ac6db03836b2ab62b1a5e9d7349a278d0670f032e8b2daad297b0` |

The owner explicitly approved these two changes before installation. That approval does not cover additional persistence, role provisioning, client activation or new production SQL. The stale draft wording inside these historical files is preserved so their bytes remain verifiable; this document explains their observed installation state.

These versions were absent from the organization repository's `a88ce7eb357faa37e0b7b447b8ff43b4050092bc` tree even though local files existed. The existing older migration files do not reproduce the full deployed history. Do not replay the directory or run `supabase db push` as a reconciliation shortcut.

## Selected core sources

The source slice includes the two installed records, `shared_profile_contract_v1.sql` and its rollback under `supabase/candidates/`, and five contract fixture/check files under `supabase/tests/`. Candidates are review inputs, not a second installation path. The canonical installed profile migration is authoritative for byte-level comparison. The rollback supports only its documented pristine/maintenance protocol and would restore known weaker legacy access; it needs separate live authorization and actual client isolation.

Five unfinished public-profile candidate/test files are deliberately excluded. Independent review found auto-publication on save, incomplete withdrawal/takedown lifecycle and loss of owner access to preserved portfolio rows. They remain preserved in the original worktree and exact recovery branch for a separate Profile implementation. [Web issue #5](https://github.com/MEC-IDEALAB/IDEALAB-MEC-WEB/issues/5) remains open; excluding these drafts does not complete or cancel public Profile requirements.

## Exact bytes and guard boundary

Nine explicit `.gitattributes` entries disable line-ending conversion for this slice. This matters because four source files contain CRLF bytes and PostgreSQL function-definition fingerprints depend on body bytes. The original fourteen-file inventory and raw recovery snapshot remain preserved outside this isolated source slice; no dirty Flutter/UI/Android changes were copied.

The architecture guard still blocks schema/persistence changes. Its narrow historical exception accepts only an addition of either named installed record at its exact raw SHA-256. Edits, deletions, renames, different bytes and other migrations remain blocked. Operational path rules are unchanged. This is source-history reconciliation, not blanket approval of future migrations.

## Acceptance and remaining gates

Local disposable PG17.11 checks in the web checkout verified thirteen profile function descriptors against captured shared metadata and tested canonical forward/pristine rollback against the retained nineteen-column users baseline. They used synthetic accounts and removed their scratch clusters. No member records, credentials or Auth fingerprint values were imported or exported. Current local/hosted check results for this packaged revision must still be recorded before merge.

This evidence does not establish all nineteen application tables, managed Supabase Auth/API behavior, Flutter cross-client acceptance, production email delivery, Android device behavior or production readiness. Legacy clients and production member access remain gated until those journeys pass. The repository workflows build/check source; they contain no SQL deployment step. External platform integrations were not audited here, so no live deployment is authorized by this record.
