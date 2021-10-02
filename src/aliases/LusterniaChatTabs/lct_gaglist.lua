local lecho = LusterniaChatTabs.echo
local gaggedMobs = table.keys(LusterniaChatTabs.gaggedMobs)
local gaggedLines = table.keys(LusterniaChatTabs.chatEMCO.gags)
table.sort(gaggedMobs)
table.sort(gaggedLines)

lecho("<orange>Gagging report. Remember these are Lua patterns, not regex")
lecho()
lecho("<orange>Gagged mobs")
for _,pattern in ipairs(gaggedMobs) do
  lecho("  <purple>" .. pattern)
end
lecho()
lecho("<orange>Gagged lines")
for _,pattern in ipairs(gaggedLines) do
  lecho("  <purple>" .. pattern)
end
