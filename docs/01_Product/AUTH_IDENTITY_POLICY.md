# Grow Auth Identity Policy

Status: Product policy captured. Implementation is blocked pending auth/schema reconciliation and security review.

## Account Types

Grow's intended account types are Super Admin, Student, and Faculty. Operational Heads and coordinators are positions assigned to an account; they are not signup-selected account types.

## Student Signup

The current college convention uses Gmail addresses with a .mec marker in the local part of the address. This is an informal eligibility signal, not a verified institutional identity. Any person can create a similar Gmail address, so a local-part substring check must never be treated as authorization proof.

The future signup flow must require verified email ownership. Before launch, the product owner must approve how student eligibility is established beyond this weak naming convention, for example a verified institutional domain, a college directory/import, an invitation, or a manual approval process.

## Faculty Onboarding

Faculty onboarding is invitation-only. There is no open faculty signup path. The invitation and account activation design must be implemented only after the canonical account and authorization contract is approved.

## Super Admin Bootstrap

The initial Super Admin identity is a controlled bootstrap exception, not a general signup rule. Provisioning must use a one-time, audited administrative process that never stores or logs a password in source code, migrations, documentation, CI configuration, skills, or chat transcripts.

The password previously entered in chat is considered exposed and must not be used for provisioning. The account owner must set a new unique password through a secure Supabase Auth or password-reset flow outside this conversation.

## Enforcement Requirements

- The client must not decide that a user is Super Admin from email text alone.
- The database must be the authority for account type and active permissions.
- Email verification is not equivalent to college affiliation verification.
- Faculty invitation state and account activation must be auditable.
- Passwords, recovery links, tokens, and service-role keys must never be logged or committed.

## Future Upgrade Path

If Model Engineering College confirms a real institutional email domain, this policy should be revised to validate that domain server-side. Until then, do not claim institutional identity is strongly verified by Gmail address format.

