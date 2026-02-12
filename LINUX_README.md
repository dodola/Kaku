# Kaku for Linux

Kaku 现在支持 Linux！这是一个快速、开箱即用的终端模拟器，专为 AI 编码设计。

## 平台支持

- ✅ **macOS** - 原生支持
- ✅ **Linux** - 完整支持（新增）
  - Ubuntu 20.04+
  - Debian 11+
  - Fedora 35+
  - Arch Linux
  - 其他主流 Linux 发行版

## Linux 快速开始

### 从源码构建

```bash
# 1. 安装依赖
# Ubuntu/Debian
sudo apt install build-essential pkg-config libfontconfig1-dev libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev

# Fedora
sudo dnf install gcc pkg-config fontconfig-devel libxcb-devel

# Arch Linux
sudo pacman -S base-devel fontconfig libxcb

# 2. 克隆仓库
git clone https://github.com/tw93/Kaku.git
cd Kaku

# 3. 下载 vendor 依赖
bash scripts/download_vendor.sh

# 4. 编译
cargo build --release -p kaku

# 5. 安装
mkdir -p ~/.local/bin ~/.local/share/kaku
cp target/release/kaku ~/.local/bin/
cp assets/shell-integration/setup_zsh.sh ~/.local/share/kaku/
cp -r assets/vendor ~/.local/share/kaku/
cp assets/linux/kaku.lua ~/.local/share/kaku/

# 6. 添加到 PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 7. 初始化 shell 环境
kaku init

# 8. （可选）使用 Linux 优化的配置
mkdir -p ~/.config/kaku
cp assets/linux/kaku.lua ~/.config/kaku/
```

### 运行

```bash
kaku
```

## Linux 特性

### 快捷键

Kaku 在 Linux 上使用 `Ctrl+Shift` 组合键，避免与终端应用冲突：

| 功能 | macOS | Linux |
|------|-------|-------|
| 新建标签页 | `Cmd+T` | `Ctrl+Shift+T` |
| 关闭标签页 | `Cmd+W` | `Ctrl+Shift+W` |
| 垂直分割 | `Cmd+D` | `Ctrl+Shift+D` |
| 水平分割 | `Cmd+Shift+D` | `Ctrl+Shift+E` |
| 窗格导航 | `Cmd+Opt+方向键` | `Alt+方向键` |
| 标签切换 | `Cmd+[/]` | `Ctrl+PageUp/Down` |
| 全屏 | `Cmd+Ctrl+F` | `F11` |

完整的快捷键列表请参考 [KEYBINDINGS.md](KEYBINDINGS.md)。

### 界面

- 使用系统原生标题栏
- 支持 Linux 桌面环境主题
- 优化的字体渲染（Noto Sans CJK SC, Noto Color Emoji）

### Shell 集成

与 macOS 版本相同的 shell 集成功能：

- **Starship** - 快速、可定制的提示符
- **zsh-z** - 智能目录跳转
- **zsh-autosuggestions** - 命令自动建议
- **zsh-syntax-highlighting** - 语法高亮
- **zsh-completions** - 扩展的命令补全

## 配置

### 配置文件位置

- 用户配置：`~/.config/kaku/kaku.lua`
- 系统配置：`~/.local/share/kaku/kaku.lua`

### 自定义配置示例

```lua
local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- 自定义字体大小
config.font_size = 14.0

-- 自定义快捷键
config.keys = {
  {
    key = 't',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SpawnTab('CurrentPaneDomain'),
  },
}

return config
```

## 文档

- [Linux 移植说明](LINUX_PORT.md) - 详细的移植文档
- [快捷键对照表](KEYBINDINGS.md) - macOS 和 Linux 快捷键对比
- [快捷键移植总结](KEYBINDINGS_PORT.md) - 快捷键设计说明

## 系统要求

- **操作系统**: Linux (kernel 4.15+)
- **桌面环境**: X11 或 Wayland
- **依赖**: fontconfig, libxcb
- **Shell**: zsh（推荐）或 bash

## 已知问题

目前没有已知的重大问题。如果遇到问题，请：

1. 查看 [LINUX_PORT.md](LINUX_PORT.md) 中的故障排除部分
2. 在 [GitHub Issues](https://github.com/tw93/Kaku/issues) 中搜索类似问题
3. 提交新的 issue

## 性能

Linux 版本保持了与 macOS 版本相同的性能优势：

| 指标 | 上游 WezTerm | Kaku |
|------|-------------|------|
| 可执行文件大小 | ~67 MB | ~40 MB |
| 启动延迟 | 标准 | 即时 |
| Shell 初始化 | ~200ms | ~100ms |

## 贡献

欢迎贡献！特别是：

- Linux 特定的优化
- 桌面环境集成
- 打包脚本（.deb, .rpm, AUR）
- 文档改进

请参考 [CONTRIBUTING.md](CONTRIBUTING.md) 了解详情。

## 许可证

MIT License - 详见 [LICENSE.md](LICENSE.md)

## 致谢

- [WezTerm](https://github.com/wez/wezterm) - 强大的终端引擎
- [Starship](https://starship.rs/) - 跨 shell 提示符
- Linux 社区的各种工具和库
