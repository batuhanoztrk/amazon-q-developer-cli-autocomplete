# Account-free autocomplete implementation plan

> Execute with superpowers:executing-plans in this session.

**Goal:** Install a locally built v1.19.7 desktop app with account-free autocomplete.
**Architecture:** Remove only local autocomplete startup authentication gating. Make onboarding login optional and suppress unsolicited login modals after onboarding. Preserve cloud authentication.
**Tech stack:** Rust, React/TypeScript, pnpm, macOS arm64.
**Spec:** docs/superpowers/specs/2026-11-07-local-autocomplete-design.md

## Constraints
- v1.19.7, Apple Silicon; no TDD or new branch per user.
- No credential or cloud authorization changes.
- Preserve original app; disable auto-updates per explicit approval.

## Review focus
- Signed-out cold launch enables local autocomplete.
- Completing onboarding without login survives restart.
- Existing account login remains available and cloud APIs retain auth.
- Local app resources and shell helper paths resolve after installation.
- Accessibility consent may differ after local signing.

## Tasks
1. [x] Update desktop startup and optional login UI; check formatting and frontend build.
2. [x] Prepare isolated toolchain and compile desktop arm64; package resources and helpers, sign locally.
3. [x] Review diff, install with rollback backup, verify runtime and report any manual OS permission step.

## Progress
- Source tag b654a1beb880951dd2343120bb867659622eecd9 checked out.
- Existing official app 1.19.7 installed and notarization verified; updates disabled.
- Plan execution authorized by user's request to prepare the account-free local version.
- Dashboard TypeScript/Vite build passed; ESLint and Prettier checks passed.
- Rust 1.87 release desktop build passed; script packaging and deep signature verification passed.
- Independent source review found an explicit-login regression: fixed with /login and return-home on onboarding completion. Tray refresh after skipping was also added.
- Runtime UI verified: Continue without an account completes onboarding, persists true in desktop.completedOnboarding, and explicit AI login remains available without forcing authentication.
- Accessibility permission granted with explicit approval and user Touch ID authentication; native diagnostic reports Accessibility Enabled: true.
- Signed-out restart verified in UI: dashboard opens without a login modal. CLI confirms not signed in; updates disabled, autocomplete enabled, cloud inline suggestions disabled.
- User verified Fig-style dropdown completions in a new iTerm tab by typing `git `.
- Stable cargo fmt cannot validate this repository's nightly-only formatting configuration; no broad formatting changes made. Changed TypeScript files pass Prettier; git diff --check passes.
