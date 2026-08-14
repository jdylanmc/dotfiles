local wezterm = require("wezterm")
local home = os.getenv("HOME")
local maestro_config = home .. "/.config/maestro/wezterm.lua"
local file = io.open(maestro_config, "r")

if file then
  file:close()
  return dofile(maestro_config)
end

local config = wezterm.config_builder()
config.color_scheme = "nord"
config.font_size = 15.0
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20
config.default_prog = { "/bin/zsh", "-l" }
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

return config
