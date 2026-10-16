# Auth Provider Release Checklist

Status: Release gate. This document records configuration and test evidence;
it must never contain client secrets, SMTP passwords, access tokens or test
member credentials.

## 1. Keep the identity boundaries clear

Grow uses Supabase Auth as the application identity authority. Firebase is not
a second sign-in authority. Confirmation proves email ownership; it does not
complete a Grow login. The required route is:

`account created → email confirmed → intentional sign-in → profile complete → Home`

An expired, used or invalid callback must not authenticate anyone.

## 2. Supabase URL and mobile callback

Before a build is tested, confirm the intended Supabase project allows:

- The production website URL as its Site URL.
- `com.idealab.mec.grow://auth/callback` as an allowed redirect URL.
- The same callback in the Android manifest intent filter.
- The exact callback route in Flutter's router.

Use the latest confirmation email only. The callback route exchanges a
single-use code, clears a temporary confirmation session, and directs the
member to ordinary sign-in. Never replace this with a localhost redirect in a
mobile build.

## 3. Email/password confirmation delivery

For a member-facing release, configure a project-owned SMTP provider and a
verified sender domain in Supabase Auth. The built-in sender is not sufficient
evidence of reliable delivery to general member email addresses.

Confirm in the console, without copying credentials into this repository:

1. Email provider enabled.
2. Email confirmation enabled.
3. SMTP sender/domain verified and rate limits appropriate for the pilot.
4. Confirmation and password-recovery templates use the approved Grow name,
   support address and callback behavior.
5. The resend response is not treated as inbox-delivery proof.

## 4. Google sign-in

Google is a preferred sign-in method, not the only account path. Configure it
in the intended Supabase project and Google Cloud project:

1. Create/verify the Android OAuth client for Grow's package name and signing
   certificate fingerprints.
2. Create/verify the web OAuth client that Supabase uses to validate native ID
   tokens.
3. Enable the Google provider in Supabase Auth with the approved OAuth client
   ID and secret; keep the secret only in Supabase.
4. Set the repository/CI `GOOGLE_WEB_CLIENT_ID` configuration value used by the
   Android build. It is public client configuration, but it must be supplied
   through the protected build configuration rather than hardcoded.
5. Ensure the release signing certificate used for the pilot matches the
   Android OAuth configuration.

Do not expose a visible Google button when the exact APK lacks required Google
configuration. A configuration failure must show a recoverable error and keep
email/password available.

## 5. Exact Android evidence

Run these on the same signed APK and intended Supabase project:

| Scenario | Required result |
| --- | --- |
| Fresh email sign-up | Account is pending; no Grow session/Home access. |
| New confirmation link | Browser completes verification; Grow asks for normal sign-in. |
| Used/old link | No session; clear “link unavailable” recovery path. |
| App restart during callback | No temporary session reaches Home or Profile Setup. |
| Email/password sign-in | Confirmed incomplete member reaches Profile Setup; completed member reaches Home. |
| Password recovery | Verified callback reaches reset flow only; then normal sign-in works. |
| Google cancel | No unintended session or error loop. |
| Google new/existing member | Same `public.users` identity/profile gate as email flow. |
| Offline/SMTP delay | Clear retry state; no false confirmation or silent hang. |

Record only the build SHA, test date, result and redacted error category in the
issue/PR. Do not record addresses, passwords, ID tokens or email links.

## Exit criteria

The authentication gate is complete only when the exact release candidate has
all configuration checks, every Android scenario above, current-head CI, and
independent review evidence. Issues #112 and #113 remain open until their
respective live configuration and device evidence exist.
