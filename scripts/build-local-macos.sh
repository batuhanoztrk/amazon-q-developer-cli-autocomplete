#!/usr/bin/env bash
set -euo pipefail

# Prerequisites: Apple Silicon macOS, Xcode tools, Rust 1.87.0, Node 22,
# pnpm 10.0.0 and protoc >= 3.12. Toolchains can live outside the home directory.
repo_dir="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo_dir"
base_app="${Q_LOCAL_BASE_APP:?Set Q_LOCAL_BASE_APP to the verified original Amazon Q 1.19.7.app}"
output_dir="${Q_LOCAL_OUTPUT_DIR:-$repo_dir/build/local}"

if [[ "$(uname -m)" != arm64 || "$(uname -s)" != Darwin ]]; then
  echo 'This build script targets Apple Silicon macOS.' >&2
  exit 1
fi
if [[ "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$base_app/Contents/Info.plist")" != 1.19.7 ]]; then
  echo 'The base app must be Amazon Q 1.19.7.' >&2
  exit 1
fi
codesign --verify --deep --strict "$base_app"

pnpm install --frozen-lockfile --ignore-scripts
pnpm exec turbo build --filter=@amzn/dashboard-app
export RUSTUP_TOOLCHAIN=1.87.0
export AMAZON_Q_BUILD_VARIANT=full
export CARGO_PROFILE_RELEASE_DEBUG=0
export CARGO_PROFILE_RELEASE_OPT_LEVEL=1
export CARGO_PROFILE_RELEASE_LTO=false
export CARGO_PROFILE_RELEASE_CODEGEN_UNITS=16
cargo build --locked --release --package fig_desktop --package q_cli --package figterm

mkdir -p "$output_dir"
local_app="$output_dir/Amazon Q.app"
if [[ -e "$local_app" ]]; then
  echo "Output already exists: $local_app. Choose an empty Q_LOCAL_OUTPUT_DIR." >&2
  exit 1
fi
ditto "$base_app" "$local_app"
cp target/release/fig_desktop "$local_app/Contents/MacOS/q_desktop"
cp target/release/q_cli "$local_app/Contents/MacOS/q"
cp target/release/figterm "$local_app/Contents/MacOS/qterm"
codesign --force --sign - "$local_app/Contents/MacOS/q"
codesign --force --sign - "$local_app/Contents/MacOS/qterm"
ditto packages/dashboard-app/dist "$local_app/Contents/Resources/dashboard"
/usr/libexec/PlistBuddy -c 'Set :CFBundleVersion 11907.2' "$local_app/Contents/Info.plist"
codesign --force --sign - --entitlements crates/fig_desktop/entitlements.plist "$local_app"
codesign --verify --deep --strict "$local_app"
echo "Built and locally signed: $local_app"
