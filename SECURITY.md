# Security Policy

## Supported Scope

Security review applies to:

- Flutter application code.
- Supabase access patterns.
- RLS policies and migrations.
- Authentication/session handling.
- Storage usage.
- CI/CD secrets and release signing configuration.

## Reporting Security Issues

Do not open public issues for sensitive vulnerabilities.

Contact:

- navaneeth2020kannan@gmail.com

This is the existing maintainer disclosure contact for this public repository.
Confirm an institution-owned security/support contact before launch; never publish
private exploit details in ordinary issues or general cleanup pull requests.

Include:

- affected area
- reproduction steps
- expected impact
- screenshots/logs if safe to share

## Security Engineering Rules

- Never commit secrets, keystores, `.env`, or Firebase service files.
- Do not log tokens, payment details, or private profile fields.
- Do not bypass RLS from client code.
- New Supabase mutations require RLS review.
- New storage buckets require access policy review.
- New public profile fields require privacy review.
- CI uses a lightweight grep-based scan plus Gitleaks. Treat either failure as a
  release blocker until reviewed.

## Current V1 Constraints

- Manual UPI verification is used instead of payment gateway processing.
- Large design files should usually remain in external tools and be linked.
- Direct messaging is not in scope for V1.
