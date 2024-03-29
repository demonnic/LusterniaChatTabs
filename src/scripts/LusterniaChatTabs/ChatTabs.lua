local EMCO = require("LusterniaChatTabs.emco")
LusterniaChatTabs = LusterniaChatTabs or {}
local default_constraints = {name = "LusterniaChatTabsContainer", x = "-25%", y = "-60%", width = "25%", height = "60%", attached = "right"}
LusterniaChatTabs.emcoContainer = LusterniaChatTabs.emcoContainer or Adjustable.Container:new(default_constraints)
LusterniaChatTabs.chatEMCO = LusterniaChatTabs.chatEMCO or EMCO:new({
  name = "LusterniaChat",
  x = 0,
  y = 0,
  height = "100%",
  width = "100%",
  consoles = {"All", "Local", "Org", "Guild", "Tells", "Squad", "Order", "Clans", "Misc"},
  allTab = true,
  allTabName = "All",
  blankLine = true,
  blink = true,
  bufferSize = 10000,
  deleteLines = 500,
  timestamp = true,
  fontSize = 12,
  font = "Ubuntu Mono",
  commandLine = true,
}, LusterniaChatTabs.emcoContainer)
local chatEMCO = LusterniaChatTabs.chatEMCO
local filename = getMudletHomeDir() .. "/EMCO/LusterniaChat.lua"
if io.exists(filename) then
  chatEMCO:load()
end
chatEMCO:replayAll(10)
function LusterniaChatTabs.echo(msg)
  msg = msg or ""
  cecho(f"<green>LusterniaChatTabs: <reset>{msg}\n")
end

LusterniaChatTabs.gaggedMobs = {}
local gaggedMobFile = getMudletHomeDir() .. "/LusterniaChatGaggedMobs.lua"
if io.exists(gaggedMobFile) then
  table.load(gaggedMobFile, LusterniaChatTabs.gaggedMobs)
end

function LusterniaChatTabs.loadGaggedMobs()
  if io.exists(gaggedMobFile) then
    table.load(gaggedMobFile, LusterniaChatTabs.gaggedMobs)
  end
end

function LusterniaChatTabs.saveGaggedMobs()
  table.save(gaggedMobFile, LusterniaChatTabs.gaggedMobs)
end

function LusterniaChatTabs.load()
  LusterniaChatTabs.loadGaggedMobs()
  if io.exists(filename) then
    chatEMCO:load()
  end
end

function LusterniaChatTabs.save()
  chatEMCO:save()
  LusterniaChatTabs.saveGaggedMobs()
end

local channelToTab = {
  ct = "Org",
  cgt = "Org",
  gt = "Guild",
  gts = "Guild",
  gnt = "Guild",
  sqt = "Squad",
  tell = "Tells",
  says = "Local",
  emotes = "Local",
  ot = "Order",
  oto = "Order",
  ft = "Misc",
  newbie = "Misc",
  market = "Misc",
}

local function addNDBdecho(txt)
  local format = string.match(txt, "<%d+.->")
  local names = ndb.findnames(txt)
  if not names then
    return txt
  end
  local done = {}
  for _, name in pairs(names) do
    if not done[name] then
      local color = ndb.getcolor(name) or "<white>"
      color = color:gsub("<", "")
      color = color:gsub(">", "")
      if color == "" then -- they're a rogue, most likely, since the ndb has the name but returned "" as the color
        debugc("LusterniaChatTabs got '' from ndb.getcolor for " .. name .. ". We are assuming they are rogue and looking up the correct color in ndb.conf or mm.conf. If it can't find either it will fallback to white")
        color = ndb.roguescolor
        color = color or (mm and mm.conf and mm.conf.roguescolor)
        color = color or "white"
      end
      color = string.format("<%d,%d,%d>", unpack(color_table[color]))
      txt = txt:gsub(name, color .. name .. format)
      done[name] = true
    end
  end
  return txt
end

local function chatCapture()
  local info = gmcp.Comm.Channel.Text
  local gaggedMobs = LusterniaChatTabs.gaggedMobs
  local talker = info.talker
  if gaggedMobs[talker] then
    return
  end
  for pattern,_ in pairs(gaggedMobs) do
    if talker:match(pattern) then
      return
    end
  end
  local channel = "Misc"
  if info.channel:starts("tell ") then
    channel = "Tells"
  end
  if info.channel:match("clt") then
    channel = "Clans"
  end
  if channelToTab[info.channel] then
    channel = channelToTab[info.channel]
  end
  local txt = ansi2decho(info.text)
  txt = txt:gsub(string.char(27) .. [[.-]] .. string.char(4), "")
  if ndb then
    txt = addNDBdecho(txt)
  end
  chatEMCO:decho(channel, txt)
end

if LusterniaChatTabs.chatCaptureEventID then
  killAnonymousEventHandler(LusterniaChatTabs.chatCaptureEventID)
end
LusterniaChatTabs.chatCaptureEventID = registerAnonymousEventHandler("gmcp.Comm.Channel.Text", chatCapture)

local function startGMCPChat()
  cecho("<green>LusterniaChatTabs:<reset> Turning on GMCP comm channels\n")
  sendGMCP([[Core.Supports.Add ["Comm.Channel 1"] ]])
end

if not LusterniaChatTabs.loginHandler then
  LusterniaChatTabs.loginHandler = registerAnonymousEventHandler("gmcp.Char.Name", startGMCPChat)
end
