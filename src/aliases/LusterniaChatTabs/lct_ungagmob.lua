local gaggedMobs = LusterniaChatTabs.gaggedMobs
local mob = matches[2]
local echo = LusterniaChatTabs.echo
if not gaggedMobs[mob] then
  echo(f"Mob {mob} is not gagged, so I cannot ungag them.")
  return
end
gaggedMobs[mob] = true
echo(f"Mob {mob} removed from the gag list")