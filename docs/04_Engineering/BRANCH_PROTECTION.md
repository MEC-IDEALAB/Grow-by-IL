# Grow branch checks and review

Updated: 16 October 2026. Observations are not GitHub settings changes.

| Branch | Required checks | Current enforcement |
| --- | --- | --- |
| main | Quality Gate (CI); Android Production Build | Strict/up-to-date, admins enforced, force pushes disabled |
| rc5-release-candidate | Quality Gate; Debug APK Build | Strict/up-to-date, admins enforced, force pushes disabled; conversation resolution required |

Both branches report zero required GitHub approving reviews. Current project/user
instructions still require independent review before merge; a null review decision
is not itself approval. Preserve the difference between observed settings and our
review gate. Never use administrator bypass to make a failed check acceptable.

Before merge: refresh exact head/base, actual required job execution and conclusions,
independent review, unresolved feedback, mergeability and applicable local/device/
backend evidence. Missing, skipped, stale, neutral or failed required execution does
not pass. A green push run is not proof that the current PR merge revision passed.

The stacked PR bases feat/home-lab-profile-navigation and chore/production-hardening
need coverage by the reviewed trigger correction in #126, followed by propagation
and fresh PR-event verification. Do not weaken architecture/schema/security guards.

Version tags and signed release/configuration acceptance remain separate release
gates. No policy Markdown file alone changes protection, disables bot approval or
proves production deployment. Verify live settings and workflow versions when acting.
