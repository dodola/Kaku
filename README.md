<div align="center">
  <img src="assets/logo.png" width="160" alt="Kaku Logo" />
  <h1>Kaku</h1>
  <p><em>A fast, out-of-the-box terminal built for AI coding.</em></p>
</div>

<p align="center">
  <img src="https://img.shields.io/badge/platform-macOS-lightgrey.svg?style=flat-square" alt="Platform">
  <img src="https://img.shields.io/badge/built%20with-Rust-orange.svg?style=flat-square" alt="Rust">
  <img src="https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square" alt="License">
</p>

<p align="center">
  <img src="assets/kaku.png" alt="Kaku Screenshot" width="1000" />
  <br/>
  Kaku is a deeply customized fork of <a href="https://github.com/wez/wezterm">WezTerm</a>, designed for an <b>out-of-the-box</b> experience.
</p>

## Features

- **Out-of-the-Box Aesthetics**: Beautiful defaults, polished UI/UX, and carefully selected fonts—no configuration needed to look good.
- **Built for AI Coding**: Optimized for the "Vibe Coding" era, designed to enhance AI-assisted workflows.
- **Instant Shell Integration**: Comes with **Starship**, **Zsh Syntax Highlighting**, and **Autosuggestions** built-in. One click to set up a pro-level shell environment.
- **Streamlined & Fast**: Stripped of heavy, unused features from WezTerm. Simplified logic for a cleaner, lighter, and more performant experience.
- **MacOS Native**: Deeply optimized for macOS, providing a native feel that fits perfectly into your workflow.
- **GPU Accelerated**: Blazing fast rendering powered by modern GPU APIs.
- **Lua Configuration**: Retains WezTerm's powerful Lua scripting for infinite customization when you need it.

## Quick Start

### First Run Experience

When you launch Kaku for the first time, it will offer to automatically configure your shell environment:
- **Starship Prompt**: Fast, customizable, and cross-shell.
- **Autosuggestions**: Type less, code faster.
- **Syntax Highlighting**: Catch errors before you run them.

> Kaku respects your existing config. It backs up your `.zshrc` before making any changes.

### Download & Install

Download the latest release for macOS:

👉 [**Download Kaku DMG**](https://github.com/tw93/Kaku/releases/latest)

**Installation:**
1. Open the DMG file (if blocked, run `sudo xattr -d com.apple.quarantine ~/Downloads/Kaku.dmg`)
2. Drag Kaku.app to Applications folder
3. Right-click Kaku.app in Applications and select "Open"
4. If still blocked: System Settings → Privacy & Security → Click "Open Anyway"

**Quick fix:** `sudo xattr -d com.apple.quarantine /Applications/Kaku.app`

## Configuration

Kaku uses a prioritized configuration system to ensure stability while allowing customization.

**Config Load Order:**

1. **Environment Variable**: `KAKU_CONFIG_FILE` (if set)
2. **Bundled Config**: `Kaku.app/Contents/Resources/kaku.lua` (Default experience)
3. **User Config**: `~/.kaku.lua` or `~/.config/kaku/kaku.lua`

To customize Kaku, simply create a `~/.kaku.lua` file. It will override the bundled defaults where specified.

## Development

For developers contributing to Kaku:

```bash
# Clone the repository
git clone https://github.com/tw93/Kaku.git
cd Kaku

# Build and verify
cargo check
cargo test

# Build application and DMG
./scripts/build.sh
# Outputs: dist/Kaku.app and dist/Kaku-{version}.dmg

# Build and open immediately
./scripts/build.sh --open

# Clean build artifacts
rm -rf dist target
```

> **Note**: The build script is macOS-only and requires Rust/Cargo installed.

## License

MIT License. See [LICENSE](LICENSE.md) for details.
