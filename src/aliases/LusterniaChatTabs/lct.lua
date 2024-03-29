local valid_options = {"font", "fontSize", "blink", "blankLine", "timestamp", "save", "load", "show", "hide"}
local valid_options_string = table.concat(valid_options)
local option = matches[2]
local value = matches[3]
if not table.contains(valid_options, option) then
  lecho("Tried to change a config value that does not exist: valid options are " .. valid_options_string)
  return
end
local chatEMCO = LusterniaChatTabs.chatEMCO
local lecho = LusterniaChatTabs.echo
local EMCO = require("LusterniaChatTabs.emco")
local gaggedMobFile = getMudletHomeDir() .. "LusterniaChatGaggedMobs.lua"
if option == "save" then
  LusterniaChatTabs.save()
  lecho("Options saved")
elseif option == "load" then
  LusterniaChatTabs.load()
  lecho("Options loaded")
elseif option == "show" then
  LusterniaChatTabs.emcoContainer:show()
elseif option == "hide" then
  LusterniaChatTabs.emcoContainer:hide()
else
  if value == nil then
    lecho("You need to provide a value when trying to configure things")
    return
  end
  if option == "font" then
    local validFont = table.contains(getAvailableFonts(), value)
    if not validFont then
      lecho("You tried to set the font to one that Mudlet doesn't recognize. This will not do.")
    else
      chatEMCO:setFont(value)
    end
  elseif table.contains({"blink", "blankLine", "timestamp"}, option) then
    value = EMCO:fuzzyBoolean(value)
    if value then
      if option == "timestamp" then
        chatEMCO:enableTimestamp()
      elseif option == "blankLine" then
        chatEMCO:enableBlankLine()
      elseif option == "blink" then
        chatEMCO:enableBlink()
      elseif option == "commandLine" then
        chatEMCO:enableCommandLine()
      end
    else
      if option == "timestamp" then
        chatEMCO:disableTimestamp()
      elseif option == "blankLine" then
        chatEMCO:disableBlankLine()
      elseif option == "blink" then
        chatEMCO:disableBlink()
      elseif option == "commandLine" then
        chatEMCO:disableCommandLine()
      end
    end
  else
    value = tonumber(value)
    if value then
      chatEMCO:setFontSize(value)
    else
      lecho("You tried to set the fontSize to a nonnumber. Attempted: " .. matches[3])
    end
  end
end
