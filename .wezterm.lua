-- Pull in the wezterm API
local wezterm = require 'wezterm'
local mux = wezterm.mux
-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
wezterm.on('gui-attached', function(domain)
	-- maximize all displayed windows on startup
	local workspace = mux.get_active_workspace()
	for _, window in ipairs(mux.all_windows()) do
		if window:get_workspace() == workspace then
			window:gui_window():maximize()
		end
	end

	local main_window_id = wezterm.mux.all_windows()[1]:window_id()
	local main_window = wezterm.mux.get_window(main_window_id)
	local tab, _, window = main_window:spawn_tab { domain = { DomainName = domain:name() }, cwd = '/Users/tfox/dev', args = { '/opt/homebrew/bin/nvim', '~/Dev' } }
	local tab, _, window = main_window:spawn_tab { domain = { DomainName = domain:name() }, cwd = '/Users/tfox/dev', args = { '/opt/homebrew/bin/nvim', '~/Dev/typst/ubc-typst' } }

	-- activate the first tab
	window:tabs()[1]:activate()
	tab:set_title("nvim @ Dev")
	tab:set_title("nvim @ typst-ubc")
end)

-- local tab, pane, window = window:spawn_tab {}

config.initial_cols = 120
config.initial_rows = 30
config.native_macos_fullscreen_mode = true
-- For example, changing the color scheme:
config.color_scheme = 'Tokyo Night'
-- config.color_scheme = 'Tokyo Night (Gogh)'

-- config.font = wezterm.font "Monaspace Neon"
-- config.harfbuzz_features = {
-- 	'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'calt', 'dlig'
-- }


config.keys = {
	-- Turn off the default CMD-m Hide action, allowing CMD-m to
	-- be potentially recognized and handled by the tab
	-- {
	--   key = 'CapsLock',
	--   action = wezterm.action.DisableDefaultAssignment,
	-- },
	-- {
	--   key = 'CapsLock',
	--   action = wezterm.action.SendKey { key = 'Escape' },
	-- },
	{
		key = "f",
		mods = "CMD|SHIFT",
		action = wezterm.action.ToggleFullScreen,
	},
	{
		key = "/",
		mods = "CMD",
		action = wezterm.action.SplitHorizontal
	}
}

config.window_decorations = "TITLE | RESIZE"
config.window_padding = {
	left = 0,
	right = 0,
	top = "0.3cell",
	bottom = 0,
}
config.use_fancy_tab_bar = false
config.tab_max_width = 200
config.show_tab_index_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false

-- BELOW IS TAB BAR CONFIGURATION

config.colors = {
	tab_bar = {
		background = "#1a1b26",
		new_tab = {
			bg_color = '#302042',
			fg_color = '#FFFFFF',

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `new_tab`.
		},

		-- You can configure some alternate styling when the mouse pointer
		-- moves over the new tab button
		new_tab_hover = {
			bg_color = '#eb346e',
			fg_color = '#FFFFFF',
			italic = true,

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `new_tab_hover`.
		},
	}
}

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function Tab_Title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return tab_info.tab_index + 1 .. ": " .. title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.tab_index + 1 .. ": " .. tab_info.active_pane.title
end

wezterm.on(
	'format-tab-title',
	function(tab, tabs, panes, cfg, hover, max_width)
		local edge_background = '#1a1b26'
		local background = '#3b2042'
		local foreground = '#DDDDDD'

		if tab.is_active then
			-- background = '#5d3269'
			background = '#eb346e'
			foreground = '#FFFFFF'
		elseif hover then
			-- background = '#6b3052'
			background = '#66003b'
			foreground = '#EEEEEE'
		end

		local edge_foreground = background

		local title = Tab_Title(tab)

		-- ensure that the titles fit in the available space,
		-- and that we have room for the edges.
		title = "  " .. title .. "  "
		-- title = wezterm.truncate_right(title, max_width - 2)

		return {
			{ Background = { Color = edge_background } },
			{ Foreground = { Color = edge_foreground } },
			{ Text = SOLID_LEFT_ARROW },
			{ Background = { Color = background } },
			{ Foreground = { Color = foreground } },
			{ Text = title },
			{ Background = { Color = edge_background } },
			{ Foreground = { Color = edge_foreground } },
			{ Text = SOLID_RIGHT_ARROW .. " " },
		}
	end
)

-- and finally, return the configuration to wezterm
return config
