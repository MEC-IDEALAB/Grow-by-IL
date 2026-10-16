# Storage Access Contract

Status: Decision record. It does not create buckets, policies, uploads or
public URLs.

## Current mismatch

The proposed `004_storage_buckets.sql` defines public `avatars`, `portfolio`
and `project-banners` buckets. The Flutter `MediaService` instead uploads to
`profiles` and `projects`; it creates a one-year avatar signed URL, requests a
project public URL, accepts caller-supplied identifiers and uses upsert.

The validation project has no buckets or object policies. Applying `004`
unchanged would not reconcile this mismatch and could make member media
publicly reachable.

## Product rule

Grow profile visibility is for signed-in Grow users, not anonymous web
visitors. Storage object visibility must enforce that rule. RLS on
`storage.objects` does not make an object in a public bucket private.

## Required decisions

| Media class | Intended reader | Writer | Unresolved decision |
| --- | --- | --- | --- |
| Member avatar | Signed-in Grow member permitted to view that profile | The member, subject to path validation | Whether an approved administrator can replace/remove it. |
| Portfolio item | Signed-in permitted profile viewer | Profile owner | Project/public-profile visibility and moderation rules. |
| Project image | Approved project viewer | Approved project contributor or designated project authority | Contributor upload policy and project membership source. |
| Work Request attachment | Request participant and authorized operational reviewer | Request creator while draft/submitted, then approved workflow rule | File types, retention and external-link policy. |
| Event media | Signed-in event viewer, unless a separate public-event rule is approved | Events Head or trusted editorial path | Public-event media boundary. |

Do not add a bucket merely because a screen needs an image. Each media class
must have a declared reader, writer, path format, retention period and delete
authority.

## Proposed safe direction for review

1. Use private buckets by default. Use signed URLs with short, purpose-limited
   expiry where a client needs a URL.
2. Use canonical names only after approval; retire the `avatars`/`portfolio`/
   `project-banners` versus `profiles`/`projects` mismatch rather than
   supporting both indefinitely.
3. Derive avatar ownership from `auth.uid()`, never from a user ID submitted by
   the Flutter caller.
4. Derive project-image permission from the project membership/creator rule;
   a path prefix alone is insufficient.
5. For upsert, provide `INSERT`, `SELECT` and `UPDATE` policies only to the
   authorized writer and use both ownership `USING` and `WITH CHECK` rules.
6. Never store a service-role key in Flutter or use a broad `authenticated`
   policy without an object-level authority predicate.
7. Remove EXIF data and enforce per-class file size and MIME-type limits.

## Required negative tests

- Unauthenticated actor cannot list, upload, download, replace or delete.
- Member A cannot upload into, read from, replace or delete Member B's media.
- A project non-member cannot access or upload project media.
- Revoked project membership loses access to new signed URLs and object
  operations.
- An Events Head cannot access unrelated Work Request attachments.
- A valid owner can upload and replace their permitted asset.
- Object deletion and profile/project deletion follow the approved retention
  policy.

## Implementation gate

Before a migration or MediaService change:

1. Approve the media matrix above and canonical bucket/path names.
2. Reconcile live Storage inventory, repository migrations and client calls.
3. Write one reviewed migration with private/public choice, limits, grants and
   RLS policies.
4. Add authorization tests against a production-faithful non-production
   baseline.
5. Replace MediaService caller-supplied ownership assumptions and add UI
   loading/error/retry states.

Issue #120 remains open until this evidence exists. Do not apply migration
`004_storage_buckets.sql` unchanged.
