# Kaku Linux 移植说明

## 概述

已成功将 `kaku init` 命令从仅支持 macOS 扩展到同时支持 Linux 和 macOS。

## 修改的文件

### 1. `kaku/src/init.rs`

- **移除平台限制**：将 `#[cfg(target_os = "macos")]` 改为 `#[cfg(any(target_os = "macos", target_os = "linux"))]`
- **添加 Linux 路径支持**：
  - 添加了 `get_default_kaku_path()` 函数，为不同平台返回默认路径
  - 添加了 `generate_wrapper_script()` 函数，为不同平台生成相应的 wrapper 脚本
  - 修改 `resolve_preferred_kaku_bin()` 函数，添加 Linux 常见安装路径：
    - `/usr/local/bin/kaku`
    - `/usr/bin/kaku`
    - `~/.local/bin/kaku`
  - 修改 `resolve_setup_script()` 函数，添加 Linux 资源路径：
    - `/usr/share/kaku/setup_zsh.sh`
    - `/usr/local/share/kaku/setup_zsh.sh`
    - `~/.local/share/kaku/setup_zsh.sh`

### 2. `assets/shell-integration/setup_zsh.sh`

- **添加操作系统检测**：使用 `uname -s` 检测当前操作系统
- **适配 Linux 路径**：
  - 添加 Linux 二进制文件搜索路径
  - 添加 Linux 资源目录搜索路径
- **限制 TouchID 功能**：TouchID 配置仅在 macOS 上执行

### 3. `scripts/download_vendor.sh`

- **添加操作系统检测**：自动检测 macOS 或 Linux
- **Linux Starship 下载**：
  - 支持 x86_64 和 aarch64/arm64 架构
  - 下载对应平台的 Starship 二进制文件
- **保留 macOS Universal Binary**：macOS 继续使用 lipo 创建通用二进制文件

### 4. `assets/linux/kaku.lua`

- **创建 Linux 专用配置文件**：适配 Linux 的快捷键和界面
- **快捷键映射**：将 macOS 的 `CMD` 键映射为 Linux 的 `CTRL+SHIFT` 组合
  - 例如：`Cmd+T` → `Ctrl+Shift+T`（新建标签页）
  - 例如：`Cmd+D` → `Ctrl+Shift+D`（垂直分割）
  - 例如：`Cmd+Opt+Arrow` → `Alt+Arrow`（窗格导航）
- **界面调整**：
  - 使用系统标题栏（`window_decorations = "RESIZE"`）
  - 调整窗口内边距（去除 macOS 的集成按钮空间）
  - 使用 Linux 常见字体（Noto Sans CJK SC, Noto Color Emoji）
- **路径适配**：first_run.sh 脚本路径适配 Linux 文件系统结构

详细的快捷键对照表请参考 [KEYBINDINGS.md](KEYBINDINGS.md)。

## 测试结果

✅ **编译成功**：在 Linux (x86_64) 上成功编译  
✅ **vendor 下载**：成功下载 Linux 版本的 Starship 和所有 zsh 插件  
✅ **init 命令**：`kaku init` 成功执行，生成了以下文件：
- `~/.config/kaku/zsh/kaku.zsh` - Shell 集成脚本
- `~/.config/kaku/zsh/bin/kaku` - Wrapper 脚本（使用 Linux 路径）
- `~/.config/kaku/zsh/bin/starship` - Starship 二进制文件
- `~/.config/kaku/zsh/plugins/` - zsh 插件目录

**生成的 wrapper 脚本示例**：
```bash
#!/bin/bash
set -euo pipefail

if [[ -n "${KAKU_BIN:-}" && -x "${KAKU_BIN}" ]]; then
    exec "${KAKU_BIN}" "$@"
fi

for candidate in \
    "/home/user/github/Kaku/target/release/kaku" \
    "/usr/local/bin/kaku" \
    "/usr/bin/kaku" \
    "$HOME/.local/bin/kaku"; do
    if [[ -n "$candidate" && -x "$candidate" ]]; then
        exec "$candidate" "$@"
    fi
done

echo "kaku: kaku binary not found. Please ensure kaku is installed." >&2
exit 127
```

## 快速开始（Linux）

### 从源码构建和安装

```bash
# 1. 克隆仓库
git clone https://github.com/tw93/Kaku.git
cd Kaku

# 2. 下载 vendor 依赖
bash scripts/download_vendor.sh

# 3. 编译
cargo build --release -p kaku

# 4. 安装到用户目录（推荐）
mkdir -p ~/.local/bin
cp target/release/kaku ~/.local/bin/

# 5. 复制资源文件
mkdir -p ~/.local/share/kaku
cp assets/shell-integration/setup_zsh.sh ~/.local/share/kaku/
cp -r assets/vendor ~/.local/share/kaku/
# 复制 Linux 配置文件（可选，作为默认配置）
cp assets/linux/kaku.lua ~/.local/share/kaku/

# 6. 确保 ~/.local/bin 在 PATH 中
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 7. 运行 init 命令
kaku init

# 8. （可选）使用 Linux 优化的配置
# 如果你想使用 Linux 优化的快捷键配置，可以复制到用户配置目录
mkdir -p ~/.config/kaku
cp assets/linux/kaku.lua ~/.config/kaku/
```

**注意**：用户配置文件 `~/.config/kaku/kaku.lua` 会覆盖系统默认配置。

### 开发测试

如果你在开发目录中测试，可以直接运行：

```bash
# 下载依赖
bash scripts/download_vendor.sh

# 编译
cargo build --release -p kaku

# 测试 init 命令（使用当前目录的二进制）
KAKU_BIN=$(pwd)/target/release/kaku $(pwd)/target/release/kaku init --update-only
```

## 系统级安装（可选）

如果需要系统级安装（需要 root 权限）：

```bash
# 复制二进制文件
sudo cp target/release/kaku /usr/local/bin/

# 创建资源目录
sudo mkdir -p /usr/local/share/kaku

# 复制 shell 集成脚本和资源
sudo cp assets/shell-integration/setup_zsh.sh /usr/local/share/kaku/
sudo cp -r assets/vendor /usr/local/share/kaku/
```

## 与 macOS 的差异

- **TouchID 支持**：Linux 版本不包含 TouchID 配置（macOS 专有功能）
- **路径结构**：
  - macOS 使用 `.app` bundle 结构
  - Linux 使用标准的 Unix 文件系统层次结构（FHS）
- **默认安装位置**：
  - macOS: `/Applications/Kaku.app/`
  - Linux: `/usr/local/bin/kaku` 或 `~/.local/bin/kaku`
- **Starship 二进制**：
  - macOS: Universal Binary（支持 ARM64 和 x86_64）
  - Linux: 单架构二进制（根据系统架构下载）

## 注意事项

1. **vendor 目录**：确保 `assets/vendor` 目录包含所有必要的资源
   - 运行 `bash scripts/download_vendor.sh` 下载依赖
   - 脚本会自动检测操作系统并下载对应平台的 Starship 二进制文件

2. **权限**：wrapper 脚本需要可执行权限（755）
   - `kaku init` 会自动设置正确的权限

3. **Shell 支持**：当前主要支持 zsh
   - bash 用户可能需要额外配置

4. **路径优先级**：wrapper 脚本按以下顺序查找 kaku 二进制：
   1. `$KAKU_BIN` 环境变量
   2. 当前开发目录（如果从源码运行）
   3. `/usr/local/bin/kaku`
   4. `/usr/bin/kaku`
   5. `~/.local/bin/kaku`

## 已知问题

目前没有已知问题。如果遇到问题，请提交 issue。

## 下一步

- [ ] 添加 bash 支持
- [ ] 创建 Linux 安装包（.deb, .rpm）
- [ ] 添加 AUR 包（Arch Linux）
- [ ] 完善文档
