#!/usr/bin/env bash
set -euo pipefail

if [[ "${OSTYPE:-}" != darwin* ]]; then
	echo "This script is macOS-only." >&2
	exit 1
fi

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

APP_NAME="Kaku"
TARGET_DIR="${TARGET_DIR:-target}"
PROFILE="${PROFILE:-release}"
OUT_DIR="${OUT_DIR:-dist}"
OPEN_APP="${OPEN_APP:-0}"

if [[ "${1:-}" == "--open" ]]; then
	OPEN_APP=1
fi

APP_BUNDLE_SRC="assets/macos/Kaku.app"
APP_BUNDLE_OUT="$OUT_DIR/$APP_NAME.app"

echo "[1/6] Building binaries ($PROFILE)..."
if [[ "$PROFILE" == "release" ]]; then
	cargo build --release -p kaku-gui -p kaku
	BIN_DIR="$TARGET_DIR/release"
else
	cargo build -p kaku-gui -p kaku
	BIN_DIR="$TARGET_DIR/debug"
fi

echo "[2/6] Preparing app bundle..."
rm -rf "$APP_BUNDLE_OUT"
mkdir -p "$OUT_DIR"
cp -R "$APP_BUNDLE_SRC" "$APP_BUNDLE_OUT"

# Move libraries from root to Frameworks (macOS requirement)
if ls "$APP_BUNDLE_OUT"/*.dylib 1>/dev/null 2>&1; then
	mkdir -p "$APP_BUNDLE_OUT/Contents/Frameworks"
	mv "$APP_BUNDLE_OUT"/*.dylib "$APP_BUNDLE_OUT/Contents/Frameworks/"
fi

mkdir -p "$APP_BUNDLE_OUT/Contents/MacOS"
mkdir -p "$APP_BUNDLE_OUT/Contents/Resources"

echo "[3/6] Downloading vendor dependencies..."
./scripts/download_vendor.sh

echo "[4/6] Copying resources and binaries..."
cp -R assets/shell-integration/* "$APP_BUNDLE_OUT/Contents/Resources/"
cp -R assets/shell-completion "$APP_BUNDLE_OUT/Contents/Resources/"
cp -R assets/fonts "$APP_BUNDLE_OUT/Contents/Resources/"
mkdir -p "$APP_BUNDLE_OUT/Contents/Resources/vendor"
cp -R assets/vendor/* "$APP_BUNDLE_OUT/Contents/Resources/vendor/"
cp assets/shell-integration/first_run.sh "$APP_BUNDLE_OUT/Contents/Resources/"
chmod +x "$APP_BUNDLE_OUT/Contents/Resources/first_run.sh"

# Explicitly use the logo.icns from assets if available
if [[ -f "assets/logo.icns" ]]; then
	cp "assets/logo.icns" "$APP_BUNDLE_OUT/Contents/Resources/terminal.icns"
fi

tic -xe kaku -o "$APP_BUNDLE_OUT/Contents/Resources/terminfo" termwiz/data/kaku.terminfo

for bin in kaku kaku-gui; do
	cp "$BIN_DIR/$bin" "$APP_BUNDLE_OUT/Contents/MacOS/$bin"
	chmod +x "$APP_BUNDLE_OUT/Contents/MacOS/$bin"
done

# Clean up xattrs to prevent icon caching issues or quarantine
xattr -cr "$APP_BUNDLE_OUT"

echo "[5/6] Signing app bundle..."
codesign --force --deep --sign - "$APP_BUNDLE_OUT"

touch "$APP_BUNDLE_OUT/Contents/Resources/terminal.icns"
touch "$APP_BUNDLE_OUT/Contents/Info.plist"
touch "$APP_BUNDLE_OUT"

echo "[5/6] Creating DMG..."
if command -v create-dmg &>/dev/null; then
	DMG_NAME="$APP_NAME.dmg"
	rm -f "$OUT_DIR/$DMG_NAME"
	create-dmg "$APP_BUNDLE_OUT" "$OUT_DIR" --overwrite --dmg-title="$APP_NAME" 2>&1 | grep -v "^hdiutil:" || true

	CREATED_DMG=$(find "$OUT_DIR" -name "*.dmg" -type f -print0 | xargs -0 ls -t | head -1)
	if [[ -n "$CREATED_DMG" ]]; then
		if [[ "$(basename "$CREATED_DMG")" != "$DMG_NAME" ]]; then
			mv "$CREATED_DMG" "$OUT_DIR/$DMG_NAME"
		fi
		echo "DMG created: $OUT_DIR/$DMG_NAME"
	fi
else
	echo "Warning: create-dmg not found. Install with: brew install create-dmg"
fi

echo "[6/6] Done: $APP_BUNDLE_OUT"
if [[ "$OPEN_APP" == "1" ]]; then
	echo "Opening app..."
	open "$APP_BUNDLE_OUT"
fi
