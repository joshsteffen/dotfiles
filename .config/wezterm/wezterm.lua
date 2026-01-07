local wezterm = require("wezterm")
local act = wezterm.action

local copy_or_interrupt = wezterm.action_callback(function(window, pane)
    if window:get_selection_text_for_pane(pane):len() == 0 then
        window:perform_action(act.SendKey { mods = 'CTRL', key = 'c' }, pane)
    else
        window:perform_action(act.CopyTo 'Clipboard', pane)
        window:perform_action(act.ClearSelection, pane)
    end
end)

local edit_config = act.SpawnCommandInNewWindow {
    args = { os.getenv("SHELL"), "-ci", "$EDITOR $WEZTERM_CONFIG_FILE" }
}

return {
    use_fancy_tab_bar = false,
    hide_tab_bar_if_only_one_tab = true,
    font = wezterm.font 'monospace',
    font_size = 10,

    keys = {
        { mods = 'CTRL',       key = 'c', action = copy_or_interrupt },
        { mods = 'CTRL|SHIFT', key = 'c', action = edit_config },
        { mods = 'CTRL',       key = 'v', action = act.PasteFrom 'Clipboard' },
        { mods = 'CTRL|SHIFT', key = 'v', action = act.SendKey { mods = 'CTRL', key = 'v' } },
    },
}
