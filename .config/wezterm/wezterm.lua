local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font 'monospace'
config.font_size = 10

local copy_or_ctrl_c = wezterm.action_callback(function(window, pane)
    if window:get_selection_text_for_pane(pane):len() == 0 then
        window:perform_action(act.SendKey { mods = 'CTRL', key = 'c' }, pane)
    else
        window:perform_action(act.CopyTo 'Clipboard', pane)
        window:perform_action(act.ClearSelection, pane)
    end
end)

local paste_or_ctrl_v = wezterm.action_callback(function(window, pane)
    if pane:is_alt_screen_active() then
        window:perform_action(act.SendKey { mods = 'CTRL', key = 'v' }, pane)
    else
        window:perform_action(act.PasteFrom 'Clipboard', pane)
    end
end)

local edit_config = act.SpawnCommandInNewWindow {
    args = { os.getenv("SHELL"), "-ci", "$EDITOR $WEZTERM_CONFIG_FILE" }
}

config.keys = {
    { mods = 'CTRL',       key = 'c', action = copy_or_ctrl_c },
    { mods = 'CTRL|SHIFT', key = 'c', action = edit_config },
    { mods = 'CTRL',       key = 'v', action = paste_or_ctrl_v },
    { mods = 'CTRL|SHIFT', key = 'v', action = act.SendKey { mods = 'CTRL', key = 'v' } },
}

return config
