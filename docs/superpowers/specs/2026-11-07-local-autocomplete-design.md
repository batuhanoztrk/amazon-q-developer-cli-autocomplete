# Account-free local autocomplete

Approved in chat: build Amazon Q v1.19.7 locally for Apple Silicon, allow local command completions without Amazon sign-in, and add Continue without an account to onboarding. Cloud AI authentication remains unchanged.

Approaches: the official signed app requires sign-in at startup; rebuilding it unchanged preserves that requirement. Selected: minimally change the open-source desktop startup and onboarding UI, then build and install locally.

Keep existing shell integration and completion specs. Preserve the original application for rollback. Automatic updates remain disabled with explicit user approval. Local signing replaces the vendor signature; macOS Accessibility may need renewed permission. Completion specs may still be downloaded; account-free does not imply fully offline.

User explicitly waived TDD and branch isolation. Validate with native compilation, frontend type checking/build, source review and runtime diagnostics.
