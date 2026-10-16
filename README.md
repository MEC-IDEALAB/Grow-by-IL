# Grow — IDEA Lab and Fab Lab

Android-first platform for IDEA Lab/Fab Lab operations at MEC. The initial target is
an evidence-backed 25–50-user pilot, followed by measured expansion toward 4,000+.
Operational backend and release acceptance remain in progress.

- [Documentation index](docs/README.md)
- [Current baseline](docs/00_Project/CURRENT_PROJECT_BASELINE.md)
- [Repository layout and recovery](docs/00_Project/REPOSITORY_CONSOLIDATION.md)
- [Live delivery Project](https://github.com/users/NAVANEETHVVINOD/projects/4)

## Source layout

Use one primary checkout, grow/. Flutter code is in lib/core, lib/features and
lib/shared; Android source is in android; assets, unit/widget tests and integration
acceptance sources remain in their framework locations. Narrative docs live in docs.
Required repository/agent/security entry files and GitHub templates remain discoverable.
Ignored .local contains private recovery and local artifacts, never application source.

## Local setup

Use the pinned Flutter 3.41.9 toolchain for the current RC5 source and the committed
pubspec.lock. SDK/API major upgrades are separate migration work, tracked in #114.

```sh
flutter pub get
flutter analyze
flutter test
```

Supply the intended environment's public mobile configuration through the existing
build configuration; .env.example lists names. Place the environment-specific
Firebase Android configuration at android/app/google-services.json, which is ignored.
Use the [provider checklist](docs/03_Database/AUTH_PROVIDER_RELEASE_CHECKLIST.md) before
claiming Google/email auth or an exact APK is ready.

Supabase Auth is the application identity authority. Firebase/native Google integration
is not a second authorization authority. Values supplied with --dart-define are bundled
into the APK: never put service-role credentials, signing/payment secrets or other
privileged secrets there. Server-enforced grants/RLS and protected functions remain
required; UI visibility and successful builds do not prove authorization.

## Current verification boundary

Auth/profile/navigation surfaces and local Work Request UI exist, but the Work Request
runtime is still simulated. Real backend authorization, providers/email delivery,
Android journeys, operational data, signing, recovery/load and pilot support remain
acceptance gates. No universal RLS, vulnerability-free, or production-ready claim is
made. See the current baseline and live Project for exact evidence and next tasks.
