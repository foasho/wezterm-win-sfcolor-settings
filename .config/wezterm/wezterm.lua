local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ── 基本 ──────────────────────────────────
config.automatically_reload_config = true
config.use_ime = true
config.font_size = 12.0
config.line_height = 1.4


config.font = wezterm.font_with_fallback({
  'CaskaydiaCove Nerd Font',
  'Cascadia Code',
  'Consolas',
})

-- ── ウィンドウ ─────────────────────────────
config.window_background_opacity = 0.5  -- 透過強め（blurが見える）
config.win32_system_backdrop = 'Acrylic' -- Windows11のblur
config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
config.window_padding = { left = 14, right = 14, top = 10, bottom = 8 }

-- ウィンドウ背景色をシアンで縁取り
config.window_frame = {
  border_left_width = '3px',
  border_right_width = '3px',
  border_bottom_height = '3px',
  border_top_height = '4px',
  border_left_color = '#00e5ff',
  border_right_color = '#00e5ff',
  border_bottom_color = '#00e5ff',
  border_top_color = '#00e5ff',
}


-- ── カラースキーム（Cyber Cyan） ──────────
config.colors = {
  foreground = '#b0d8f0',
  background = '#020509',  -- ほぼ黒
  cursor_bg = '#00e5ff',
  cursor_border = '#00e5ff',
  cursor_fg = '#080d18',
  selection_bg = '#003a5a',
  selection_fg = '#e8f8ff',

  ansi = {
    '#0e1e2e',  -- black
    '#e05c7a',  -- red
    '#00e5c8',  -- green
    '#f0a04a',  -- yellow
    '#00bcd4',  -- blue
    '#7c6fff',  -- magenta
    '#00e5ff',  -- cyan
    '#b0d8f0',  -- white
  },
  brights = {
    '#1a4060',  -- bright black
    '#ff7a94',  -- bright red
    '#30ffdd',  -- bright green
    '#ffc06a',  -- bright yellow
    '#40d8ff',  -- bright blue
    '#a09fff',  -- bright magenta
    '#60eeff',  -- bright cyan
    '#e8f8ff',  -- bright white
  },

  tab_bar = {
    background = '#060b14',
    active_tab = {
      bg_color = '#080d18',
      fg_color = '#00e5ff',
    },
    inactive_tab = {
      bg_color = '#060b14',
      fg_color = '#1a4060',
    },
    inactive_tab_hover = {
      bg_color = '#0a1520',
      fg_color = '#00bcd4',
    },
    new_tab = {
      bg_color = '#060b14',
      fg_color = '#1a4060',
    },
  },
}

-- ── タブバー ───────────────────────────────
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.tab_max_width = 36

-- ── ステータスバー ─────────────────────────
wezterm.on('update-right-status', function(window, pane)
  local date = wezterm.strftime('%H:%M')
  window:set_right_status(wezterm.format({
    { Foreground = { Color = '#00bcd4' } },
    { Text = '  ' .. date .. '  ' },
  }))
end)

-- ── タブタイトル ───────────────────────────
wezterm.on('format-tab-title', function(tab, tabs, panes, cfg, hover, max_width)
  local title = tab.active_pane.title

  -- "powershell.exe" → "PS" に短縮
  title = title:gsub('powershell%.exe', 'PS')
  title = title:gsub('cmd%.exe', 'cmd')

  -- パスが含まれる場合は最後のフォルダ名だけ抽出
  -- 例: "C:\Users\<username>\projects\xr-dev" → "xr-dev"
  local short = title:match('.*[\\/]([^\\/]+)%s*$') or title

  -- 実行中コマンドはそのまま表示（パス区切りがない場合）
  if short == title and #title > 20 then
    short = title:sub(1, 19) .. '…'
  end

  if tab.is_active then
    return {
      { Background = { Color = '#080d18' } },
      { Foreground = { Color = '#00e5ff' } },
      { Text = ' ' .. short .. ' ' },
    }
  end
  return {
    { Background = { Color = '#060b14' } },
    { Foreground = { Color = '#1a4060' } },
    { Text = ' ' .. short .. ' ' },
  }
end)

-- ── キーバインド ───────────────────────────
config.keys = {
  { key = 'd', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'e', mods = 'CTRL|SHIFT', action = wezterm.action.SplitVertical   { domain = 'CurrentPaneDomain' } },
  { key = 'LeftArrow',  mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Left'  },
  { key = 'RightArrow', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'UpArrow',    mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Up'    },
  { key = 'DownArrow',  mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Down'  },
}

-- ── デフォルトシェル（Windows） ────────────
config.default_prog = { 'powershell.exe', '-NoLogo' }

return config