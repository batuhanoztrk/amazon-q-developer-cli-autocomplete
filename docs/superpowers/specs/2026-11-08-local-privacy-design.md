# Local build privacy and update policy

User approved removing Kiro upgrade promotions and update/sharing controls from both the fork and installed application. Keep account-free autocomplete and input-method support working.

Remove Kiro promotion banners, upgrade links, the Kiro release announcement, update menu entry, and update/beta/telemetry/content-sharing preference controls. Enforce no updater checks/downloads, no telemetry dispatch/transmission and AWS content opt-out in the shared source, regardless of old settings. Build the desktop, CLI and qterm from the fork; retain the unchanged original input method and chat helper, with local privacy settings off. Preserve cloud authentication and completion-spec downloads. The vendor chat helper is outside the immutable source policy and continues to use its existing privacy preferences.

The selected approach combines source enforcement with existing local opt-out settings. Merely changing settings leaves upgrade promotions and resettable defaults, so is insufficient for the user's approved scope. Re-signing the updated app can require renewed macOS Accessibility consent. No TDD or branch change, per user instruction.
