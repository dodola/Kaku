# Kaku 快捷键移植总结

## 完成的工作

### 1. 创建 Linux 配置文件

创建了 `assets/linux/kaku.lua`，这是专门为 Linux 优化的配置文件，包含：

- ✅ **快捷键映射**：将 macOS 的 `CMD` 键映射为 Linux 的 `CTRL+SHIFT` 组合
- ✅ **界面适配**：调整窗口装饰、内边距等 Linux 特定设置
- ✅ **字体配置**：使用 Linux 常见字体（Noto Sans CJK SC, Noto Color Emoji）
- ✅ **路径适配**：适配 Linux 文件系统结构

### 2. 快捷键映射策略

#### 主要原则

1. **避免冲突**：Linux 终端中 `Ctrl` 键被广泛使用（如 `Ctrl+C` 中断程序），因此使用 `Ctrl+Shift` 组合
2. **保持一致**：尽可能保持与其他 Linux 终端模拟器（GNOME Terminal, Konsole）的一致性
3. **易于记忆**：快捷键逻辑与 macOS 版本保持相似，便于跨平台用户适应

#### 具体映射

| 类别 | macOS 修饰键 | Linux 修饰键 | 示例 |
|------|-------------|-------------|------|
| 窗口/标签管理 | `CMD` | `CTRL+SHIFT` | `Cmd+T` → `Ctrl+Shift+T` |
| 窗格导航 | `CMD+OPT` | `ALT` | `Cmd+Opt+←` → `Alt+←` |
| 标签切换 | `CMD+[/]` | `CTRL+PageUp/Down` | `Cmd+[` → `Ctrl+PageUp` |
| 标签跳转 | `CMD+1-9` | `ALT+1-9` | `Cmd+1` → `Alt+1` |
| 字体调整 | `CMD+/=/0` | `CTRL+/=/0` | `Cmd++` → `Ctrl++` |

### 3. 完整的快捷键列表

所有快捷键的详细对照表请参考 [KEYBINDINGS.md](KEYBINDINGS.md)。

主要功能快捷键：

#### 标签页管理
- **新建标签页**: `Ctrl+Shift+T`
- **关闭标签页**: `Ctrl+Shift+W`
- **切换标签页**: `Ctrl+PageUp/Down` 或 `Ctrl+Shift+[/]`
- **跳转到标签页**: `Alt+1-9`

#### 窗格管理
- **垂直分割**: `Ctrl+Shift+D`
- **水平分割**: `Ctrl+Shift+E`
- **最大化窗格**: `Ctrl+Shift+Enter`
- **窗格导航**: `Alt+方向键`
- **调整窗格大小**: `Ctrl+Shift+方向键`

#### 其他功能
- **清屏**: `Ctrl+Shift+R`
- **全屏**: `F11` 或 `Ctrl+Shift+F`
- **字体大小**: `Ctrl++/-/0`
- **重载配置**: `Ctrl+Shift+.`

### 4. 与其他终端的兼容性

Kaku 的 Linux 快捷键设计参考了主流 Linux 终端模拟器：

| 功能 | Kaku | GNOME Terminal | Konsole | Kitty |
|------|------|----------------|---------|-------|
| 新建标签页 | `Ctrl+Shift+T` | `Ctrl+Shift+T` | `Ctrl+Shift+T` | `Ctrl+Shift+T` |
| 关闭标签页 | `Ctrl+Shift+W` | `Ctrl+Shift+W` | `Ctrl+Shift+W` | `Ctrl+Shift+W` |
| 切换标签页 | `Ctrl+PageUp/Down` | `Ctrl+PageUp/Down` | `Shift+Left/Right` | `Ctrl+Shift+Left/Right` |
| 分割窗格 | `Ctrl+Shift+D/E` | - | - | `Ctrl+Shift+Enter` |
| 全屏 | `F11` | `F11` | `Ctrl+Shift+F11` | `Ctrl+Shift+F11` |

### 5. 配置文件结构

```
~/.config/kaku/
├── kaku.lua              # 用户自定义配置（优先级最高）
└── .kaku_config_version  # 配置版本标记

~/.local/share/kaku/
├── kaku.lua              # 系统默认配置（Linux 版本）
├── setup_zsh.sh          # Shell 集成脚本
└── vendor/               # 第三方工具
    ├── starship          # Starship 提示符
    ├── zsh-autosuggestions/
    ├── zsh-syntax-highlighting/
    ├── zsh-completions/
    └── zsh-z/
```

### 6. 自定义配置示例

用户可以在 `~/.config/kaku/kaku.lua` 中自定义快捷键：

```lua
local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- 自定义快捷键
config.keys = {
  -- 使用 Super 键（Windows 键）代替 Ctrl+Shift
  {
    key = 't',
    mods = 'SUPER',
    action = wezterm.action.SpawnTab('CurrentPaneDomain'),
  },
  
  -- 添加自定义命令
  {
    key = 'k',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ClearScrollback('ScrollbackAndViewport'),
  },
}

return config
```

### 7. 测试建议

1. **基本功能测试**：
   ```bash
   # 测试标签页管理
   Ctrl+Shift+T  # 新建标签页
   Ctrl+Shift+W  # 关闭标签页
   Alt+1         # 跳转到第一个标签页
   
   # 测试窗格分割
   Ctrl+Shift+D  # 垂直分割
   Ctrl+Shift+E  # 水平分割
   Alt+←/→/↑/↓   # 窗格导航
   ```

2. **冲突检测**：
   - 检查是否与窗口管理器快捷键冲突
   - 检查是否与其他应用程序快捷键冲突

3. **性能测试**：
   - 快捷键响应速度
   - 多窗格情况下的性能

### 8. 已知差异

| 功能 | macOS | Linux | 原因 |
|------|-------|-------|------|
| 窗口装饰 | 集成按钮 | 系统标题栏 | Linux 桌面环境差异 |
| 修饰键 | `CMD` | `CTRL+SHIFT` | 避免与终端应用冲突 |
| 字体 | PingFang SC | Noto Sans CJK SC | Linux 系统字体 |
| TouchID | 支持 | 不支持 | macOS 专有功能 |

### 9. 下一步计划

- [ ] 添加对 SUPER 键（Windows 键）的支持选项
- [ ] 创建快捷键配置向导
- [ ] 支持更多桌面环境的集成（KDE, GNOME, etc.）
- [ ] 添加快捷键冲突检测工具

## 使用建议

1. **新用户**：建议使用默认的 Linux 配置（`assets/linux/kaku.lua`）
2. **从 macOS 迁移的用户**：参考 [KEYBINDINGS.md](KEYBINDINGS.md) 快速适应
3. **高级用户**：根据个人习惯自定义 `~/.config/kaku/kaku.lua`

## 反馈

如果你发现任何快捷键问题或有改进建议，请：
1. 查看 [KEYBINDINGS.md](KEYBINDINGS.md) 确认预期行为
2. 检查是否与系统快捷键冲突
3. 提交 issue 或 PR
