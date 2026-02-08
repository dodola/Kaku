#!/usr/bin/env bash
set -euo pipefail

# This script downloads external dependencies for bundling into the Kaku App.
# It should be run before packaging.

VENDOR_DIR="$(cd "$(dirname "$0")/../assets/vendor" && pwd)"
mkdir -p "$VENDOR_DIR"

echo "[1/3] Downloading Starship..."
STARSHIP_BIN="$VENDOR_DIR/starship"

# Determine architecture for universal binary or current machine
# For now, we'll download the binary for the current architecture (likely Apple Silicon dev)
# In a proper CI/CD, we'd use 'lipo' to create a universal binary
ARCH=$(uname -m)
if [[ "$ARCH" == "arm64" ]]; then
	STARSHIP_URL="https://github.com/starship/starship/releases/latest/download/starship-aarch64-apple-darwin.tar.gz"
else
	STARSHIP_URL="https://github.com/starship/starship/releases/latest/download/starship-x86_64-apple-darwin.tar.gz"
fi

if [[ ! -f "$STARSHIP_BIN" ]]; then
	echo "Fetching Starship from $STARSHIP_URL..."
	curl -L "$STARSHIP_URL" | tar -xz -C "$VENDOR_DIR"
	chmod +x "$STARSHIP_BIN"
else
	echo "Starship already exists, skipping."
fi

echo "[2/3] Cloning zsh-autosuggestions..."
AUTOSUGGEST_DIR="$VENDOR_DIR/zsh-autosuggestions"
if [[ ! -d "$AUTOSUGGEST_DIR" ]]; then
	git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$AUTOSUGGEST_DIR"
	rm -rf "$AUTOSUGGEST_DIR/.git"
else
	echo "zsh-autosuggestions already exists, skipping."
fi

echo "[3/3] Cloning zsh-syntax-highlighting..."
SYNTAX_DIR="$VENDOR_DIR/zsh-syntax-highlighting"
if [[ ! -d "$SYNTAX_DIR" ]]; then
	git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$SYNTAX_DIR"
	rm -rf "$SYNTAX_DIR/.git"
else
	echo "zsh-syntax-highlighting already exists, skipping."
fi

echo "Vendor dependencies downloaded to $VENDOR_DIR"
