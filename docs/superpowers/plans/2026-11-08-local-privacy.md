# Local build privacy implementation plan

> Execute inline with superpowers:executing-plans. User waived TDD and branch changes.

**Goal:** Remove upgrade/sharing UI and enforce local privacy in the installed fork.
**Architecture:** Shared immutable local-build policy; guard update and telemetry boundaries; force content opt-out; remove matching frontend controls. Package rebuilt desktop and CLI with existing helpers.
**Tech stack:** Rust 1.87, React/TypeScript, macOS arm64.
**Spec:** docs/superpowers/specs/2026-11-08-local-privacy-design.md

## Constraints and review focus
- Old true settings must not re-enable sharing or updates.
- No telemetry client creation or IPC forwarding when telemetry is disabled.
- Manual q update must report that updates are disabled without downloading anything.
- Keep autocomplete, input method and explicit account sign-in intact.
- Preserve rollback app and renew only the already-approved app permission if needed.

## Tasks
- [x] Enforce shared policy and remove upgrade/sharing controls.
- [x] Build dashboard, desktop, CLI and qterm; run focused policy checks and source review.
- [x] Package, install, verify privacy and integrations; refresh deliverables and commit.

## Progress
- Existing settings confirmed: telemetry/content sharing false, automatic updates disabled.
- Per-user configuration also sets update interval -1 and beta false.
- User explicitly requested changes in the fork and installed app.
- Four focused Rust tests passed: old opt-in normalization, forced content opt-out, skipped update checks, and no telemetry clients.
- Dashboard TypeScript/Vite build, ESLint, Prettier and git diff whitespace checks passed.
- Independent source review found no critical/important defects. Fixed its telemetry-enable/status inconsistency and updated component documentation.
- Refreshed cached qterm shell copies by content so same-version local rebuilds replace old binaries.
- Native desktop, CLI and qterm release builds passed. Clean bundle installation avoids stale dashboard assets; deep code-signature verification passed.
- Runtime UI verified without Kiro banners or update/sharing controls. q update is disabled; telemetry and content-sharing preferences are false.
- Accessibility permission renewed with user Touch ID; native status true, input method Installed. Bundle build number 11907.2.
- The vendor qchat helper remains unchanged; its existing sharing preferences are normalized before CLI delegation. This binary itself is outside the immutable source policy.
