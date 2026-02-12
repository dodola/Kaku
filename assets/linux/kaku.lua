-- Kaku Configuration (Linux)

local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end



local function basename(path)
  return path:match('([^/]+)$')
end

local function equal_padding(all)
  return {
    left = all,
    right = all,
    top = '40px',
    bottom = '30px',
  }
end

local function padding_matches(current, expected)
  return current
    and current.left == expected.left
    and current.right == expected.right
    and current.top == expected.top
    and current.bottom == expected.bottom
end

local fullscreen_uniform_padding = equal_padding('40px')

local function update_window_config(window, is_full_screen)
  local overrides = window:get_config_overrides() or {}
  if is_full_screen then
    if not padding_matches(overrides.window_padding, fullscreen_uniform_padding) or overrides.hide_tab_bar_if_only_one_tab ~= false then
      overrides.window_padding = fullscreen_uniform_padding
      overrides.hide_tab_bar_if_only_one_tab = false
      window:set_config_overrides(overrides)
    end
    return
  end

  if overrides.window_padding ~= nil or overrides.hide_tab_bar_if_only_one_tab ~= nil then
    overrides.window_padding = nil
    overrides.hide_tab_bar_if_only_one_tab = nil
    window:set_config_overrides(overrides)
  end
end

local function extract_path_from_cwd(cwd)
  if not cwd then
    return ''
  end

  local path = ''
  if type(cwd) == 'table' then
    path = cwd.file_path or cwd.path or tostring(cwd)
  else
    path = tostring(cwd)
  end

  path = path:gsub('^file://[^/]*', ''):gsub('/$', '')
  return path
end

local function tab_path_parts(pane)
  local cwd = pane.current_working_dir
  if not cwd then
    local ok, runtime_cwd = pcall(function()
      return pane:get_current_working_dir()
    end)
    if ok then
      cwd = runtime_cwd
    end
  end

  local path = extract_path_from_cwd(cwd)
  if path == '' then
    return '', ''
  end

  local current = basename(path) or path
  local parent_path = path:match('(.+)/[^/]+$') or ''
  local parent = basename(parent_path) or parent_path
  return parent, current
end

wezterm.on('format-tab-title', function(tab, _, _, _, _, max_width)
  local parent, current = tab_path_parts(tab.active_pane)
  local text = current
  if parent ~= '' and current ~= '' then
    text = parent .. '/' .. current
  end
  if text == '' then
    text = tab.active_pane.title
  end
  if tab.active_pane.is_zoomed then
    text = text .. ' [Z]'
  end
  text = wezterm.truncate_right(text, math.max(8, max_width - 2))

  local fg = tab.is_active and '#edecee' or '#6b6b6b'
  local intensity = tab.is_active and 'Bold' or 'Normal'
  return {
    { Attribute = { Intensity = intensity } },
    { Foreground = { Color = fg } },
    { Text = ' ' .. text .. ' ' },
  }
end)

wezterm.on('update-right-status', function(window)
  local dims = window:get_dimensions()
  update_window_config(window, dims.is_full_screen)
  if not dims.is_full_screen then
    window:set_right_status('')
    return
  end

  local clock_icon = wezterm.nerdfonts.md_clock_time_four_outline
    or wezterm.nerdfonts.md_clock_outline
    or ''
  local text = wezterm.strftime('%H:%M')
  if clock_icon ~= '' then
    window:set_right_status(wezterm.format({
      { Foreground = { Color = '#6b6b6b' } },
      { Text = ' ' .. clock_icon .. ' ' .. text .. ' ' },
    }))
    return
  end
  window:set_right_status(wezterm.format({
    { Foreground = { Color = '#6b6b6b' } },
    { Text = ' ' .. text .. ' ' },
  }))
end)

-- ===== Font =====
config.font = wezterm.font_with_fallback({
  { family = 'JetBrains Mono', weight = 'Regular' },
  { family = 'Noto Sans CJK SC', weight = 'Regular' },
  { family = 'Noto Color Emoji', assume_emoji_presentation = true },
})

config.font_rules = {
  {
    intensity = 'Normal',
    italic = true,
    font = wezterm.font_with_fallback({
      { family = 'JetBrains Mono', weight = 'Regular', italic = false },
      { family = 'Noto Sans CJK SC', weight = 'Regular' },
    }),
  },
}

config.bold_brightens_ansi_colors = false
config.font_size = 17.0
config.line_height = 1.28
config.cell_width = 1.02
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.use_cap_height_to_scale_fallback_fonts = false

config.freetype_load_target = 'Normal'
-- config.freetype_render_target = 'HorizontalLcd'

config.allow_square_glyphs_to_overflow_width = 'WhenFollowedBySpace'
config.custom_block_glyphs = true

-- ===== Cursor =====
config.default_cursor_style = 'BlinkingBar'
config.cursor_thickness = '2px'
config.cursor_blink_rate = 0

-- ===== Scrollback =====
config.scrollback_lines = 10000

-- ===== Mouse =====
config.selection_word_boundary = ' \t\n{}[]()"\'-'  -- Smart selection boundaries

-- ===== Window =====
config.window_padding = {
  left = '40px',
  right = '40px',
  top = '40px',  -- Linux doesn't have integrated titlebar
  bottom = '30px',
}

config.initial_cols = 110
config.initial_rows = 22
config.window_decorations = "RESIZE"  -- Use system titlebar on Linux
config.window_frame = {
  font = wezterm.font({ family = 'JetBrains Mono', weight = 'Regular' }),
  font_size = 13.0,
  active_titlebar_bg = '#15141b',
  inactive_titlebar_bg = '#15141b',
}

config.window_close_confirmation = 'NeverPrompt'

-- ===== Tab Bar =====
config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_max_width = 32
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = false

-- Color scheme for tabs
config.colors = {
  -- Background
  foreground = '#edecee',
  background = '#15141b',

  -- Cursor
  cursor_bg = '#a277ff',
  cursor_fg = '#15141b',
  cursor_border = '#a277ff',

  -- Selection
  selection_bg = '#29263c',
  selection_fg = 'none',

  -- Normal colors (ANSI 0-7)
  ansi = {
    '#110f18',  -- black
    '#ff6767',  -- red
    '#61ffca',  -- green
    '#ffca85',  -- yellow
    '#a277ff',  -- blue
    '#a277ff',  -- magenta
    '#61ffca',  -- cyan
    '#edecee',  -- white
  },

  -- Bright colors (ANSI 8-15)
  brights = {
    '#4d4d4d',  -- bright black
    '#ff6767',  -- bright red
    '#61ffca',  -- bright green
    '#ffca85',  -- bright yellow
    '#a277ff',  -- bright blue
    '#a277ff',  -- bright magenta
    '#61ffca',  -- bright cyan
    '#edecee',  -- bright white
  },

  -- Split separator color (increased contrast for better visibility)
  split = '#3d3a4f',

  -- Tab bar colors
  tab_bar = {
    background = '#15141b',

    active_tab = {
      bg_color = '#29263c',
      fg_color = '#edecee',
      intensity = 'Bold',
      underline = 'None',
      italic = false,
      strikethrough = false,
    },

    inactive_tab = {
      bg_color = '#15141b',
      fg_color = '#6b6b6b',
      intensity = 'Normal',
    },

    inactive_tab_hover = {
      bg_color = '#1f1d28',
      fg_color = '#9b9b9b',
      italic = false,
    },

    new_tab = {
      bg_color = '#15141b',
      fg_color = '#6b6b6b',
    },

    new_tab_hover = {
      bg_color = '#1f1d28',
      fg_color = '#9b9b9b',
    },
  },
}

-- ===== Shell =====
config.default_prog = { '/bin/zsh', '-l' }

-- ===== Linux Specific =====
-- On Linux, we use CTRL+SHIFT instead of CMD for most shortcuts
-- This avoids conflicts with terminal applications that use CTRL

-- ===== Key Bindings =====
config.keys = {
  -- Ctrl+Shift+R: clear screen + scrollback
  {
    key = 'R',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.Multiple({
      wezterm.action.SendKey({ key = 'l', mods = 'CTRL' }),
      wezterm.action.ClearScrollback('ScrollbackAndViewport'),
    }),
  },

  -- Ctrl+Shift+Q: quit
  {
    key = 'Q',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.QuitApplication,
  },

  -- Ctrl+Shift+N: new window
  {
    key = 'N',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SpawnWindow,
  },

  -- Ctrl+Shift+W: close current pane (smart)
  {
    key = 'W',
    mods = 'CTRL|SHIFT',
    action = wezterm.action_callback(function(win, pane)
      local tab = win:active_tab()
      if #tab:panes() > 1 then
        win:perform_action(wezterm.action.CloseCurrentPane { confirm = false }, pane)
      else
        win:perform_action(wezterm.action.CloseCurrentTab { confirm = false }, pane)
      end
    end),
  },

  -- Ctrl+Shift+T: new tab
  {
    key = 'T',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SpawnTab('CurrentPaneDomain'),
  },

  -- F11: toggle fullscreen
  {
    key = 'F11',
    mods = 'NONE',
    action = wezterm.action.ToggleFullScreen,
  },

  -- Ctrl+Shift+F: toggle fullscreen (alternative)
  {
    key = 'F',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ToggleFullScreen,
  },

  -- Ctrl+Shift+.: reload configuration
  {
    key = '.',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ReloadConfiguration,
  },

  -- Ctrl+Plus/Minus/0: adjust font size
  {
    key = '+',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.IncreaseFontSize,
  },
  {
    key = '=',
    mods = 'CTRL',
    action = wezterm.action.IncreaseFontSize,
  },
  {
    key = '-',
    mods = 'CTRL',
    action = wezterm.action.DecreaseFontSize,
  },
  {
    key = '0',
    mods = 'CTRL',
    action = wezterm.action.ResetFontSize,
  },

  -- Ctrl+Left / Ctrl+Right: word jump
  {
    key = 'LeftArrow',
    mods = 'CTRL',
    action = wezterm.action.SendKey({ key = 'b', mods = 'ALT' }),
  },
  {
    key = 'RightArrow',
    mods = 'CTRL',
    action = wezterm.action.SendKey({ key = 'f', mods = 'ALT' }),
  },

  -- Home / End: line start/end
  {
    key = 'Home',
    mods = 'NONE',
    action = wezterm.action.SendKey({ key = 'a', mods = 'CTRL' }),
  },
  {
    key = 'End',
    mods = 'NONE',
    action = wezterm.action.SendKey({ key = 'e', mods = 'CTRL' }),
  },

  -- Ctrl+Backspace: delete word
  {
    key = 'Backspace',
    mods = 'CTRL',
    action = wezterm.action.SendKey({ key = 'w', mods = 'CTRL' }),
  },

  -- Ctrl+Shift+D: vertical split
  {
    key = 'D',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
  },

  -- Ctrl+Shift+E: horizontal split (alternative to Shift+D)
  {
    key = 'E',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitVertical({ domain = 'CurrentPaneDomain' }),
  },

  -- Ctrl+PageUp / PageDown: prev/next tab
  {
    key = 'PageUp',
    mods = 'CTRL',
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    key = 'PageDown',
    mods = 'CTRL',
    action = wezterm.action.ActivateTabRelative(1),
  },

  -- Ctrl+Shift+[ / ]: prev/next tab (alternative)
  {
    key = '[',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    key = ']',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivateTabRelative(1),
  },

  -- Alt+Arrow: navigate between splits
  {
    key = 'LeftArrow',
    mods = 'ALT',
    action = wezterm.action.ActivatePaneDirection('Left'),
  },
  {
    key = 'RightArrow',
    mods = 'ALT',
    action = wezterm.action.ActivatePaneDirection('Right'),
  },
  {
    key = 'UpArrow',
    mods = 'ALT',
    action = wezterm.action.ActivatePaneDirection('Up'),
  },
  {
    key = 'DownArrow',
    mods = 'ALT',
    action = wezterm.action.ActivatePaneDirection('Down'),
  },

  -- Alt+1~9: switch tab
  {
    key = '1',
    mods = 'ALT',
    action = wezterm.action.ActivateTab(0),
  },
  {
    key = '2',
    mods = 'ALT',
    action = wezterm.action.ActivateTab(1),
  },
  {
    key = '3',
    mods = 'ALT',
    action = wezterm.action.ActivateTab(2),
  },
  {
    key = '4',
    mods = 'ALT',
    action = wezterm.action.ActivateTab(3),
  },
  {
    key = '5',
    mods = 'ALT',
    action = wezterm.action.ActivateTab(4),
  },
  {
    key = '6',
    mods = 'ALT',
    action = wezterm.action.ActivateTab(5),
  },
  {
    key = '7',
    mods = 'ALT',
    action = wezterm.action.ActivateTab(6),
  },
  {
    key = '8',
    mods = 'ALT',
    action = wezterm.action.ActivateTab(7),
  },
  {
    key = '9',
    mods = 'ALT',
    action = wezterm.action.ActivateTab(8),
  },

  -- Shift+Enter: newline without execute
  {
    key = 'Enter',
    mods = 'SHIFT',
    action = wezterm.action.SendString('\n'),
  },

  -- Ctrl+Shift+Enter: Toggle Pane Zoom (Maximize active pane)
  {
    key = 'Enter',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.TogglePaneZoomState,
  },

  -- Ctrl+Shift+Arrows: Resize panes
  {
    key = 'LeftArrow',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.AdjustPaneSize { 'Left', 5 },
  },
  {
    key = 'RightArrow',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.AdjustPaneSize { 'Right', 5 },
  },
  {
    key = 'UpArrow',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.AdjustPaneSize { 'Up', 5 },
  },
  {
    key = 'DownArrow',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.AdjustPaneSize { 'Down', 5 },
  },

}

-- Copy on select (equivalent to Kitty's copy_on_select)
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor('ClipboardAndPrimarySelection'),
  },
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}

-- ===== Performance =====
config.enable_scroll_bar = false
config.front_end = 'OpenGL'
config.webgpu_power_preference = 'HighPerformance'
config.animation_fps = 60
config.max_fps = 60

-- ===== Visuals & Splits =====
-- Inactive panes: No dimming (consistent background)
config.inactive_pane_hsb = {
  saturation = 1.0,
  brightness = 1.0,
}

-- Prevent accidental clicks when focusing panes
config.swallow_mouse_click_on_pane_focus = true
config.swallow_mouse_click_on_window_focus = true

-- ===== First Run Experience & Config Version Check =====
wezterm.on('gui-startup', function(cmd)
  local home = os.getenv("HOME")
  local current_version = 6  -- Update this when config changes

  -- Check for configuration version
  local version_file = home .. "/.config/kaku/.kaku_config_version"
  local is_first_run = false
  local needs_update = false

  -- Read current user version
  local vf = io.open(version_file, "r")
  if vf then
    -- Has version file, check if update needed
    local user_version = tonumber(vf:read("*all")) or 0
    vf:close()
    if user_version < current_version then
      needs_update = true
    end
  else
    -- New user, show first run
    is_first_run = true
  end

  if is_first_run then
    -- First run experience
    os.execute("mkdir -p " .. home .. "/.config/kaku")

    -- Try to find first_run.sh in common Linux paths
    local first_run_script = nil
    local possible_paths = {
      "/usr/share/kaku/first_run.sh",
      "/usr/local/share/kaku/first_run.sh",
      home .. "/.local/share/kaku/first_run.sh",
      wezterm.executable_dir .. "/../share/kaku/first_run.sh",
      wezterm.executable_dir .. "/../../assets/shell-integration/first_run.sh",
    }

    for _, path in ipairs(possible_paths) do
      local f = io.open(path, "r")
      if f then
        f:close()
        first_run_script = path
        break
      end
    end

    if first_run_script then
      wezterm.mux.spawn_window {
        args = { 'bash', first_run_script },
        width = 106,
        height = 22,
      }
      return
    end
  end

  if needs_update then
    -- Re-run guided setup on version upgrades
    local first_run_script = nil
    local possible_paths = {
      "/usr/share/kaku/first_run.sh",
      "/usr/local/share/kaku/first_run.sh",
      home .. "/.local/share/kaku/first_run.sh",
      wezterm.executable_dir .. "/../share/kaku/first_run.sh",
      wezterm.executable_dir .. "/../../assets/shell-integration/first_run.sh",
    }

    for _, path in ipairs(possible_paths) do
      local f = io.open(path, "r")
      if f then
        f:close()
        first_run_script = path
        break
      end
    end

    if first_run_script then
      wezterm.mux.spawn_window {
        args = { 'bash', first_run_script },
        width = 106,
        height = 22,
      }
      return
    end
  end

  -- Normal startup
  if not cmd then
    wezterm.mux.spawn_window(cmd or {})
  end
end)

return config
