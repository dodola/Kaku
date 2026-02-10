#!/bin/bash
# Kaku First Run Experience
# This script is launched automatically on the first run of Kaku.

set -euo pipefail

# Always persist config version at script exit to avoid repeated onboarding loops
# when optional setup steps fail on user machines.
persist_config_version() {
	mkdir -p "$HOME/.config/kaku"
	echo "5" >"$HOME/.config/kaku/.kaku_config_version"
}
trap persist_config_version EXIT

# Resources directory resolution
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/setup_zsh.sh" ]]; then
	RESOURCES_DIR="$SCRIPT_DIR"
elif [[ -f "/Applications/Kaku.app/Contents/Resources/setup_zsh.sh" ]]; then
	RESOURCES_DIR="/Applications/Kaku.app/Contents/Resources"
elif [[ -f "$HOME/Applications/Kaku.app/Contents/Resources/setup_zsh.sh" ]]; then
	RESOURCES_DIR="$HOME/Applications/Kaku.app/Contents/Resources"
else
	# Fallback for dev environment
	RESOURCES_DIR="$SCRIPT_DIR"
fi

SETUP_SCRIPT="$RESOURCES_DIR/setup_zsh.sh"

# Clear screen
clear

# Display Welcome Message
echo -e "\033[1;35m"
echo "  _  __      _          "
echo " | |/ /     | |         "
echo " | ' / __ _ | | __ _   _ "
echo " |  < / _\` || |/ /| | | |"
echo " | . \ (_| ||   < | |_| |"
echo " |_|\_\__,_||_|\_\ \__,_|"
echo -e "\033[0m"
echo "Welcome to Kaku!"
echo "The terminal built for the AI coding era."
echo "--------------------------------------------------------"
echo "Would you like to install Kaku's enhanced shell features?"
echo "This includes:"
echo "  - Starship Prompt"
echo "  - z - Smart Directory Jumper"
echo "  - Zsh Syntax Highlighting"
echo "  - Zsh Autosuggestions"
echo "--------------------------------------------------------"
echo ""

# Interactive Prompt
read -p "Install enhanced shell features? [Y/n] " -n 1 -r
echo ""

INSTALL_SHELL=false
if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
	INSTALL_SHELL=true
fi

# Kaku Theme Prompt
echo "--------------------------------------------------------"
echo "Would you like to use the Kaku Theme?"
echo "A modern, high-contrast dark theme optimized for AI coding."
echo "Perfect for Claude, Codex, and late-night hacking."
echo "--------------------------------------------------------"
read -p "Apply Kaku Theme? [Y/n] " -n 1 -r
echo ""

INSTALL_THEME=false
if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
	INSTALL_THEME=true
fi

# Delta (Git Diff Beautifier) Prompt
echo "--------------------------------------------------------"
echo "Would you like to install Delta?"
echo "Beautiful git diffs with syntax highlighting."
echo "Perfect for code review and AI-assisted development."
echo "--------------------------------------------------------"
read -p "Install Delta? [Y/n] " -n 1 -r
echo ""

INSTALL_DELTA=false
if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
	INSTALL_DELTA=true
fi

# Process Shell Features
if [[ "$INSTALL_SHELL" == "true" ]]; then
	if [[ -f "$SETUP_SCRIPT" ]]; then
		if ! "$SETUP_SCRIPT"; then
			echo ""
			echo "Warning: shell setup failed. You can retry manually:"
			echo "  bash \"$SETUP_SCRIPT\""
		fi
	else
		echo "Error: setup_zsh.sh not found at $SETUP_SCRIPT"
	fi
else
	echo ""
	echo "Skipping shell setup. You can run it manually later:"
	echo "$SETUP_SCRIPT"
fi

mkdir -p "$HOME/.config/kaku"
VERSION_FILE="$HOME/.config/kaku/.kaku_config_version"
USER_CONFIG_VERSION=0
if [[ -f "$VERSION_FILE" ]]; then
	RAW_VERSION="$(cat "$VERSION_FILE" 2>/dev/null || true)"
	if [[ "$RAW_VERSION" =~ ^[0-9]+$ ]]; then
		USER_CONFIG_VERSION="$RAW_VERSION"
	fi
fi

# Process Kaku Theme
if [[ "$INSTALL_THEME" == "true" ]]; then
	KAKU_LUA_SRC="$RESOURCES_DIR/kaku.lua"
	KAKU_LUA_DEST="$HOME/.config/kaku/kaku.lua"

		if [[ -f "$KAKU_LUA_SRC" ]]; then
			if [[ -f "$KAKU_LUA_DEST" && "$USER_CONFIG_VERSION" -ne 1 ]]; then
				echo "Detected existing custom kaku.lua, skipping automatic overwrite."
				echo "To apply theme manually, review: $KAKU_LUA_SRC"
			else
				if [[ -f "$KAKU_LUA_DEST" ]]; then
					BACKUP_FILE="$KAKU_LUA_DEST.kaku-backup-$(date +%s)"
					cp "$KAKU_LUA_DEST" "$BACKUP_FILE"
					echo "Detected v1 config, backup created at: $BACKUP_FILE"
				fi

				echo "Installing Kaku theme..."
				cp "$KAKU_LUA_SRC" "$KAKU_LUA_DEST"

				# Inject Kaku theme before the return statement
				# We use a temporary file to construct the new content
				TMP_FILE=$(mktemp)

				# Read all lines except the last one (return config)
				sed '$d' "$KAKU_LUA_DEST" >"$TMP_FILE"

				# Append Kaku theme config
				cat <<EOF >>"$TMP_FILE"

-- ===== Kaku Theme =====
config.colors = {
  foreground = '#d4d4d4',
  background = '#1e1e1e',
  cursor_bg = '#569cd6',
  cursor_fg = '#1e1e1e',
  cursor_border = '#569cd6',
  selection_bg = '#264f78',
  selection_fg = '#d4d4d4',
  ansi = {'#000000', '#cd3131', '#0dbc79', '#e5e510', '#2472c8', '#bc3fbc', '#11a8cd', '#e5e5e5'},
  brights = {'#666666', '#f14c4c', '#23d18b', '#f5f543', '#3b8eea', '#d670d6', '#29b8db', '#e5e5e5'},
  tab_bar = {
    background = '#1e1e1e',
    active_tab = {
      bg_color = '#1e1e1e',
      fg_color = '#569cd6',
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = '#2d2d2d',
      fg_color = '#858585',
    },
    inactive_tab_hover = {
      bg_color = '#2d2d2d',
      fg_color = '#d4d4d4',
    },
    new_tab = {
      bg_color = '#1e1e1e',
      fg_color = '#858585',
    },
    new_tab_hover = {
      bg_color = '#2d2d2d',
      fg_color = '#d4d4d4',
    },
  },
}
config.window_frame = {
  active_titlebar_bg = '#1e1e1e',
  inactive_titlebar_bg = '#1e1e1e',
  button_bg = '#1e1e1e',
  button_fg = '#cccccc',
}

return config
EOF
				mv "$TMP_FILE" "$KAKU_LUA_DEST"
				echo "Kaku theme applied!"
			fi
		else
			echo "Warning: Could not find kaku.lua source at $KAKU_LUA_SRC"
		fi
fi

# Process Delta Installation
if [[ "$INSTALL_DELTA" == "true" ]]; then
	DELTA_SCRIPT="$RESOURCES_DIR/install_delta.sh"
	if [[ -f "$DELTA_SCRIPT" ]]; then
		echo ""
		if ! bash "$DELTA_SCRIPT"; then
			echo "Warning: Delta installation failed."
		fi
	else
		echo "Warning: install_delta.sh not found at $DELTA_SCRIPT"
	fi
fi

echo -e "\n\033[1;32m❤️ Kaku environment is ready! Enjoy coding.\033[0m"

# `exec` replaces the shell process and skips EXIT trap handlers.
# Persist explicitly here so successful first-run/upgrade paths are recorded.
persist_config_version

# Replace current process with zsh to enter the shell
exec /bin/zsh -l
