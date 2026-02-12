# Kaku 快捷键对照表

## macOS vs Linux 快捷键映射

| 功能 | macOS | Linux | 说明 |
|------|-------|-------|------|
| **标签页管理** |
| 新建标签页 | `Cmd + T` | `Ctrl + Shift + T` | 创建新标签页 |
| 关闭标签页/窗格 | `Cmd + W` | `Ctrl + Shift + W` | 智能关闭（多窗格时关闭窗格，单窗格时关闭标签页） |
| 上一个标签页 | `Cmd + [` | `Ctrl + PageUp` 或 `Ctrl + Shift + [` | 切换到上一个标签页 |
| 下一个标签页 | `Cmd + ]` | `Ctrl + PageDown` 或 `Ctrl + Shift + ]` | 切换到下一个标签页 |
| 切换到标签页 1-9 | `Cmd + 1-9` | `Alt + 1-9` | 直接跳转到指定标签页 |
| **窗口管理** |
| 新建窗口 | `Cmd + N` | `Ctrl + Shift + N` | 创建新窗口 |
| 退出应用 | `Cmd + Q` | `Ctrl + Shift + Q` | 退出 Kaku |
| 全屏切换 | `Cmd + Ctrl + F` | `F11` 或 `Ctrl + Shift + F` | 切换全屏模式 |
| **窗格分割** |
| 垂直分割 | `Cmd + D` | `Ctrl + Shift + D` | 左右分割窗格 |
| 水平分割 | `Cmd + Shift + D` | `Ctrl + Shift + E` | 上下分割窗格 |
| 最大化/还原窗格 | `Cmd + Shift + Enter` | `Ctrl + Shift + Enter` | 切换窗格缩放状态 |
| **窗格导航** |
| 向左切换窗格 | `Cmd + Opt + ←` | `Alt + ←` | 激活左侧窗格 |
| 向右切换窗格 | `Cmd + Opt + →` | `Alt + →` | 激活右侧窗格 |
| 向上切换窗格 | `Cmd + Opt + ↑` | `Alt + ↑` | 激活上方窗格 |
| 向下切换窗格 | `Cmd + Opt + ↓` | `Alt + ↓` | 激活下方窗格 |
| **窗格调整大小** |
| 向左调整 | `Cmd + Ctrl + ←` | `Ctrl + Shift + ←` | 向左扩展窗格 |
| 向右调整 | `Cmd + Ctrl + →` | `Ctrl + Shift + →` | 向右扩展窗格 |
| 向上调整 | `Cmd + Ctrl + ↑` | `Ctrl + Shift + ↑` | 向上扩展窗格 |
| 向下调整 | `Cmd + Ctrl + ↓` | `Ctrl + Shift + ↓` | 向下扩展窗格 |
| **编辑操作** |
| 清屏 | `Cmd + R` | `Ctrl + Shift + R` | 清除屏幕和滚动缓冲区 |
| 增大字体 | `Cmd + +` | `Ctrl + +` 或 `Ctrl + Shift + +` | 增加字体大小 |
| 减小字体 | `Cmd + -` | `Ctrl + -` | 减小字体大小 |
| 重置字体 | `Cmd + 0` | `Ctrl + 0` | 恢复默认字体大小 |
| 重载配置 | `Cmd + Shift + .` | `Ctrl + Shift + .` | 重新加载配置文件 |
| **光标移动** |
| 行首 | `Cmd + ←` | `Home` | 移动到行首 |
| 行尾 | `Cmd + →` | `End` | 移动到行尾 |
| 单词跳转（左） | `Opt + ←` | `Ctrl + ←` | 向左跳转一个单词 |
| 单词跳转（右） | `Opt + →` | `Ctrl + →` | 向右跳转一个单词 |
| **删除操作** |
| 删除到行首 | `Cmd + Backspace` | `Ctrl + U` | 删除光标到行首的内容 |
| 删除单词 | `Opt + Backspace` | `Ctrl + Backspace` | 删除前一个单词 |
| **其他** |
| 换行不执行 | `Shift + Enter` | `Shift + Enter` | 插入换行符但不执行命令 |

## Shell 功能（zsh 插件）

这些功能通过 `kaku init` 安装的 zsh 插件提供，在 macOS 和 Linux 上完全相同：

| 功能 | 命令 | 说明 |
|------|------|------|
| 智能跳转 | `z <dir>` | 跳转到最常访问的目录 |
| 智能选择 | `z -l <dir>` | 列出匹配的目录 |
| 最近目录 | `z -t` | 按时间排序显示最近访问的目录 |

## 配置文件位置

### macOS
- 系统配置：`/Applications/Kaku.app/Contents/Resources/kaku.lua`
- 用户配置：`~/.config/kaku/kaku.lua`

### Linux
- 系统配置：
  - `/usr/share/kaku/kaku.lua`
  - `/usr/local/share/kaku/kaku.lua`
  - `~/.local/share/kaku/kaku.lua`
- 用户配置：`~/.config/kaku/kaku.lua`

## 自定义快捷键

你可以在 `~/.config/kaku/kaku.lua` 中自定义快捷键。例如：

```lua
local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- 添加自定义快捷键
config.keys = {
  -- 你的自定义快捷键
  {
    key = 'k',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ClearScrollback('ScrollbackAndViewport'),
  },
}

return config
```

## Linux 特定说明

### 为什么使用 `Ctrl + Shift` 而不是 `Ctrl`？

在 Linux 终端中，`Ctrl` 键通常被终端应用程序使用（如 `Ctrl+C` 中断程序，`Ctrl+D` EOF 等）。为了避免冲突，Kaku 在 Linux 上使用 `Ctrl + Shift` 组合键来实现窗口管理功能。

### 修饰键说明

- **CTRL**: Control 键
- **SHIFT**: Shift 键
- **ALT**: Alt 键（在某些系统上也称为 Meta 键）
- **SUPER**: Windows 键 / Super 键（未在默认配置中使用）

### 与其他终端的对比

| 功能 | Kaku (Linux) | GNOME Terminal | Konsole | Kitty |
|------|--------------|----------------|---------|-------|
| 新建标签页 | `Ctrl+Shift+T` | `Ctrl+Shift+T` | `Ctrl+Shift+T` | `Ctrl+Shift+T` |
| 分割窗格 | `Ctrl+Shift+D` | - | - | `Ctrl+Shift+Enter` |
| 切换标签页 | `Ctrl+PageUp/Down` | `Ctrl+PageUp/Down` | `Shift+Left/Right` | `Ctrl+Shift+Left/Right` |

## 鼠标操作

| 操作 | macOS | Linux | 说明 |
|------|-------|-------|------|
| 选择文本 | 鼠标拖拽 | 鼠标拖拽 | 自动复制到剪贴板 |
| 打开链接 | `Cmd + 点击` | `Ctrl + 点击` | 在浏览器中打开 URL |
| 粘贴 | 鼠标中键 | 鼠标中键 | 粘贴主选择区内容 |

## 提示

1. **学习曲线**：如果你从 macOS 切换到 Linux，主要需要适应 `Cmd` → `Ctrl+Shift` 的转换
2. **自定义**：可以通过修改 `~/.config/kaku/kaku.lua` 来自定义快捷键
3. **冲突检测**：如果某个快捷键不工作，检查是否与系统或其他应用冲突
4. **重载配置**：修改配置后使用 `Ctrl+Shift+.` 重新加载，无需重启

## 常见问题

### Q: 为什么 `Ctrl+C` 不能复制文本？
A: `Ctrl+C` 在终端中用于发送 SIGINT 信号（中断程序）。使用鼠标选择文本会自动复制到剪贴板。

### Q: 如何使用 `Cmd` 键（Super 键）？
A: 你可以在配置文件中将 `CTRL|SHIFT` 替换为 `SUPER` 来使用 Windows/Super 键。

### Q: 快捷键与我的窗口管理器冲突怎么办？
A: 修改 `~/.config/kaku/kaku.lua` 中的快捷键配置，或者修改窗口管理器的快捷键设置。
