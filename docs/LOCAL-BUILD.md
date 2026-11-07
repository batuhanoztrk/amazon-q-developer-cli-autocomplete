# Local account-free autocomplete build

Based on upstream tag `v1.19.7` (`b654a1beb880951dd2343120bb867659622eecd9`).
The desktop Rust executable and dashboard are compiled from this source.
The original verified Amazon Q 1.19.7 bundle supplies the unchanged CLI,
qterm, chat helper, input method, completion frontend and themes.

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

Keep the original app for rollback. Automatic updates must remain disabled
to preserve these changes (the user explicitly approved this setting):

```sh
q settings app.disableAutoupdates true
q settings autocomplete.disable false
```

Cloud AI features still require signing in. Never falsify authentication
state or supply fabricated tokens.
