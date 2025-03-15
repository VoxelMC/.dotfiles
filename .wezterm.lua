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

config.default_cwd = 'Users/tfox/Dev'
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
	-- local tab, _, window = main_window:spawn_tab { domain = { DomainName = domain:name() }, cwd = '/Users/tfox/dev', args = { '/opt/homebrew/bin/nvim', '~/Dev' } }
	-- local tab2, _, _ = main_window:spawn_tab { domain = { DomainName = domain:name() }, cwd = '/Users/tfox/dev', args = { '/opt/homebrew/bin/nvim', '~/Dev/typst/ubc-typst' } }
	-- local tab3, _, _ = main_window:spawn_tab { domain = { DomainName = domain:name() }, cwd = '/Users/tfox/dev', args = { '/bin/zsh', '-i', '-c', '/opt/homebrew/bin/nvim ~/Dev/typst/ubc-typst' } }
	-- local tab4, _, window = main_window:spawn_tab { domain = { DomainName = domain:name() }, cwd = '/Users/tfox/dev', args = { '/bin/zsh', '/Users/tfox/startnvimdev.sh' } }
	-- local tab4, _, window = main_window:spawn_tab { domain = { DomainName = domain:name() }, cwd = '/Users/tfox/dev', args = { '/bin/zsh', '/Users/tfox/startnvimdev.sh' } }
	-- local tab4, _, window = main_window:spawn_tab { domain = { DomainName = domain:name() }, cwd = '/Users/tfox/dev', args = { '/Users/tfox/startnvimdev.sh' } }

	-- activate the first tab
	-- window:tabs()[1]:activate()
	-- tab:set_title("nvim @ Dev")
	-- tab2:set_title("nvim @ typst-ubc")
	-- tab3:set_title("Test Zsh")
	-- tab4:set_title("nvim @ ~/Dev")
end)

-- local tab, pane, window = window:spawn_tab {}

-- config.initial_cols = 120
-- config.initial_rows = 30

-- config.tab_bar_at_bottom = true
config.native_macos_fullscreen_mode = true
-- For example, changing the color scheme:
config.color_scheme = 'Tokyo Night'
-- config.color_scheme = 'Panda (Gogh)'
-- config.color_scheme = 'Tokyo Night (Gogh)'

-- config.default_cursor_style = "BlinkingUnderline"
config.default_cursor_style = "SteadyUnderline"
config.animation_fps = 1
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'
config.cursor_thickness = 2

-- config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.max_fps = 120

config.enable_kitty_keyboard = true
config.enable_csi_u_key_encoding = false
config.hide_tab_bar_if_only_one_tab = true

-- Feeling Monaspace
config.font = wezterm.font "MonaspiceNe Nerd Font Mono"
-- config.font = wezterm.font "MonaspiceKr Nerd Font Mono"
-- End

-- Feeling JetBrains Mono
-- config.font = wezterm.font "JetBrainsMono Nerd Font"
-- End

-- config.font = wezterm.font "Liga Comic Mono"
-- config.font = wezterm.font "Monaspace Neon" DONT USE

-- Feeling SpaceMono
-- config.font = wezterm.font "SpaceMono Nerd Font"
config.font_size = 16
-- config.line_height = 0.8
-- End

config.harfbuzz_features = {
	'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'calt', 'rlig', 'liga'
}

-- config.dpi = 152

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
		key = 'k',
		mods = 'CMD',
		action = wezterm.action.DisableDefaultAssignment,
	},
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
-- config.hide_tab_bar_if_only_one_tab = false

-- BELOW IS TAB BAR CONFIGURATION
--
local button_bg = '#302042'
local main_bg = '#0B0D14'

config.colors = {
	background = "0B0D14",
	tab_bar = {
		-- background = "#1a1b26",
		background = "transparent",
		new_tab = {
			bg_color = button_bg,
			fg_color = '#FFFFFF',

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `new_tab`.
		},

		-- You can configure some alternate styling when the mouse pointer
		-- moves over the new tab button
		new_tab_hover = {
			-- bg_color = '#eb346e',
			bg_color = main_bg,
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
		-- return tab_info.tab_index + 1 .. ": " .. title
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	-- return tab_info.tab_index + 1 .. ": " .. tab_info.active_pane.title
	return tab_info.active_pane.title
end

wezterm.on(
	'format-tab-title',
	function(tab, tabs, panes, cfg, hover, max_width)
		-- local edge_background = '#1a1b26'
		local edge_background = 'transparent'
		-- local background = '#3b2042'
		-- local background = 'transparent'
		local background = button_bg
		-- local foreground = '#DDDDDD'
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

		-- local edge_foreground = background
		local edge_foreground = '#FFFFFF'

		local title = Tab_Title(tab)

		-- ensure that the titles fit in the available space,
		-- and that we have room for the edges.
		-- title = "  " .. title .. "  "
		title = "  " .. title .. "  "
		-- title = wezterm.truncate_right(title, max_width - 2)

		return {
			{ Background = { Color = edge_background } },
			{ Foreground = { Color = edge_foreground } },
			{ Text = "" },
			-- { Text = SOLID_LEFT_ARROW },
			{ Background = { Color = background } },
			{ Foreground = { Color = foreground } },
			{ Text = title },
			{ Background = { Color = edge_background } },
			{ Foreground = { Color = edge_foreground } },
			{ Text = "" },
			-- { Text = SOLID_RIGHT_ARROW .. " " },
		}
	end
)

-- config.background = {
-- 	{
-- 		source = {
-- 			-- File = '/Users/tfox/Downloads/Dark Background Levi Frey.jpg'
-- 			-- File = '/Users/tfox/Downloads/Annie Spratt Dark Background.jpg'
-- 			File = '/Users/tfox/Downloads/Dark Background Shyam.jpg'
-- 			-- File = '/Users/tfox/Downloads/Dark Background Annie Spratt.jpg'
-- 			-- File = '/Users/tfox/Downloads/Dark Background Evgeni Evgeniev.jpg'
-- 			-- File = '/Users/tfox/Downloads/fireplace.gif'
-- 		},
-- 		vertical_align = "Middle",
-- 		attachment = "Fixed",
-- 		hsb = { brightness = 0.04 }
-- 	}
-- }

-- and finally, return the configuration to wezterm
return config
