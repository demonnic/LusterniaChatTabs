local gaggedMobs = LusterniaChatTabs.gaggedMobs
local mob = matches[2]
local echo = LusterniaChatTabs.echo
if gaggedMobs[mob] then
  echo(f"Mob {mob} is already gagged")
  return
end
gaggedMobs[mob] = true
echo(f"Mob {mob} added to the gag list")