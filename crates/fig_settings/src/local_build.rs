//! Fixed policy for the account-free local build, independent of stored preferences.

pub const UPDATES_ENABLED: bool = false;
pub const TELEMETRY_ENABLED: bool = false;
pub const SHARE_CONTENT_WITH_AWS: bool = false;

/// Keep the preferences used by unchanged vendor helpers aligned with this build.
pub fn apply(settings: &crate::Settings) -> crate::Result<()> {
    for (key, value) in [
        ("app.disableAutoupdates", serde_json::json!(!UPDATES_ENABLED)),
        ("app.autoupdate.check-period", serde_json::json!(-1)),
        ("app.beta", serde_json::json!(false)),
        ("telemetry.enabled", serde_json::json!(TELEMETRY_ENABLED)),
        (
            "codeWhisperer.shareCodeWhispererContentWithAWS",
            serde_json::json!(SHARE_CONTENT_WITH_AWS),
        ),
    ] {
        if settings.get_value(key)?.as_ref() != Some(&value) {
            settings.set_value(key, value)?;
        }
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn local_build_overrides_old_opt_in_values() {
        let settings = crate::Settings::from_slice(&[
            ("telemetry.enabled", serde_json::json!(true)),
            ("codeWhisperer.shareCodeWhispererContentWithAWS", serde_json::json!(true)),
            ("app.disableAutoupdates", serde_json::json!(false)),
            ("app.beta", serde_json::json!(true)),
        ]);
        apply(&settings).unwrap();
        assert_eq!(settings.get_bool("telemetry.enabled").unwrap(), Some(false));
        assert_eq!(
            settings.get_bool("codeWhisperer.shareCodeWhispererContentWithAWS").unwrap(),
            Some(false)
        );
        assert_eq!(settings.get_bool("app.disableAutoupdates").unwrap(), Some(true));
        assert_eq!(settings.get_bool("app.beta").unwrap(), Some(false));
        apply(&settings).unwrap();
    }
}
