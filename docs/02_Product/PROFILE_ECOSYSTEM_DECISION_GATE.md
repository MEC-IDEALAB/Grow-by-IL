# Profile Ecosystem Decision Gate

Status: evidence-based review record. It does not approve deployment of a
legacy migration, create profile tables, change visibility policies, or add
richer onboarding steps.

## Confirmed active V1 path

The active `ProfileSetupScreen` used by the auth release path completes only
these `users` fields:

- `name` (required)
- `phone` (optional)
- `college_roll` (optional)
- `profile_completed` (set only after the returned update confirms it)

This is the only profile-completion contract that can currently be treated as
the minimum auth gate. It is deliberately distinct from account role and from
any future profile richness.

## Why the richer profile UI is not a deployment contract

The repository contains legacy `003_profile_ecosystem.sql` and
`008_profile_ecosystem_patch.sql` files plus UI for profile details such as
education, experience, volunteering, portfolio entries, social links, skills
and interests. They are not proof that equivalent tables, grants, RLS policies
or storage buckets are deployed in the intended Supabase project.

The checked-in drafts also need reconciliation before use:

| Observed draft surface | Conflict or missing evidence |
| --- | --- |
| `user_profiles.user_type` values include `student`, `professional`, `faculty` | Current compatibility account roles are `student`, `lab_admin`, `super_admin`; profile type must not become authorization or silently rename accounts. |
| Several profile tables use broad authenticated read rules in the legacy patch | The product decision is public profile visibility for signed-in Grow users, while personal fields need field-level visibility policy. Verify the live schema and approved privacy model before trusting either draft. |
| Legacy media migration uses `avatars`/`portfolio`; Flutter media code uses `profiles`/`projects` | Bucket names, path ownership, access level and signed/public URL behavior are unresolved; see the Storage Access Contract. |
| RC5 onboarding stores interests/skills in device preferences and expects exactly five interests | The active `/profile-setup` route is the smaller minimum flow. A device cache is not a source of truth for a public profile. |
| Profile UI can display badges, experience and portfolio sections | Badges and verification must have earned, server-backed sources. Empty states are required until then. |

## Required product decisions

1. **Profile visibility:** Which fields are visible to every signed-in Grow
   user, the profile owner, assigned staff, or no one? Email, phone, roll
   number and audit data must not inherit public-profile visibility.
2. **Profile richness:** Which of bio, department, education, experience,
   volunteering, interests, skills, social links and portfolio are V1? Which
   are optional, editable later, or deliberately deferred?
3. **Badges:** Define the earning event, issuing trusted service, revocation
   rule, display source, and audit requirement for each badge. User profile
   edits must never grant a badge or verification state.
4. **Terms and policies:** Identify the versioned Terms, Community Guidelines,
   Lab Rules and Privacy Policy documents that must be accepted, the record
   retained for acceptance, and re-consent behavior after a material change.
5. **Storage and media:** Approve the bucket contract, MIME/size limits,
   ownership paths, retention, moderation and visibility before avatar or
   portfolio upload UI is enabled.

## Required engineering gate

1. Take a read-only live Supabase schema snapshot, then compare it with the
   current `users` table, legacy profile drafts, Flutter models and storage
   calls. The known migration-history drift means repository SQL alone is not
   sufficient evidence.
2. Approve a canonical profile field matrix: owner, nullable/validation rules,
   reader groups, writer groups, source of truth, retention and audit needs.
3. Produce one reviewed migration plan with strict RLS and negative tests for
   cross-user reads/writes, role/position changes, badge issuance and private
   field exposure. Keep it separate from the P0 role/membership remediation.
4. Build richer onboarding only against that approved contract. Every step must
   support save/resume, validation, loading/error/offline states, text scaling
   and clear privacy explanation; it must not require a separate scrolling
   questionnaire for the initial sign-in completion path.
5. Verify the exact release APK on Android: confirmed account -> explicit
   sign-in -> minimum profile -> Home; then test optional rich-profile editing
   and all privacy states once they exist.

## Immediate safe implementation boundary

Keep the compact minimum profile screen and its verified update path. Do not
apply `003`/`008`, publish profile details, enable uploads, or require the
rich set of fields until the decisions and engineering gate above are complete.
This keeps authentication reliable while allowing the full profile design to
be completed in Penpot as a contract, rather than a false persistence claim.
