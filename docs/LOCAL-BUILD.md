# Local account-free autocomplete build

Based on upstream tag `v1.19.7` (`b654a1beb880951dd2343120bb867659622eecd9`).
The desktop, CLI, qterm and dashboard are compiled from this source.
The original verified Amazon Q 1.19.7 bundle supplies the unchanged chat
helper, input method, completion frontend and themes.

Local command completions no longer require Amazon authentication. Onboarding
offers **Continue without an account**; explicit sign-in remains available for
cloud AI features, whose authentication is unchanged. This is account-free,
not a guarantee of offline operation: command specs may be downloaded.

Use Apple Silicon macOS, Xcode command-line tools, Rust 1.87.0, Node 22,
pnpm 10.0.0 and protoc >= 3.12. The original app is available from:
https://desktop-release.q.us-east-1.amazonaws.com/1.19.7/Amazon%20Q.dmg
Verify its Apple signature and notarization before use.

```sh
Q_LOCAL_BASE_APP='/path/to/original/Amazon Q.app' \
Q_LOCAL_OUTPUT_DIR='/path/to/new/output-directory' \
bash scripts/build-local-macos.sh
```

The output is locally ad-hoc signed, not signed or notarized by Amazon.
After copying it to `/Applications/Amazon Q.app`, macOS may require renewed
Accessibility permission. Restart terminal sessions after installation.

Keep the original app for rollback. Vendor updates, telemetry and AWS content
sharing are disabled by the fixed policy in `fig_settings::local_build`.
The update and sharing controls and Kiro promotions are removed from the UI.
`q update` and `q telemetry enable` report that those features are disabled.
Old stored opt-in values cannot re-enable the rebuilt components.

Startup also normalizes the privacy settings used by the unchanged vendor
chat helper, and the CLI reapplies them before launching that helper. The
vendor binary itself is outside this fork's immutable source policy.
Completion-spec downloads and explicitly requested authenticated AI calls
remain available; this is not an offline build.

Autocomplete stays enabled:

```sh
q settings autocomplete.disable false
```

Cloud AI features still require signing in. Never falsify authentication
state or supply fabricated tokens.

## Verification on the installation Mac

- Rust release build and TypeScript/Vite dashboard build passed.
- Changed TypeScript files passed ESLint and Prettier; patch whitespace check passed.
- Packaged and installed app passed deep code-signature verification.
- Continue without an account persisted onboarding state and survived restart.
- Explicit AI sign-in remained available; no Amazon account was authenticated.
- Native Accessibility diagnostic returned true after consent.
- User confirmed the Fig-style dropdown in a fresh iTerm tab after typing `git `.

The privacy revision also adds focused checks for stale opt-in settings,
manual/automatic update checks, telemetry client creation and forced AWS
content opt-out. Rebuilt qterm shell copies are refreshed by content, even
when the upstream version number is unchanged.
