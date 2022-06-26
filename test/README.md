# Lusternia Chat Tabs

Set of chat tabs similarly laid out to KaiUI, but using my latest version of EMCO which provides for automatic logging among other things, and not part of an all or nothing UI.

By default, the logs are kept in `getMudletHomeDir() .. "/log/Chatbox/YYYY/MM/DD/tabname.html"`

Will start on the right side, attached to the right border. Resize, move, adjust how you see fit.

## Configuration Alias

* `lct hide`
  * hides the chat tabs
* `lct show`
  * shows the chat tabs again.
* `lct save`
  * saves the configuration
* `lct load`
  * loads the configuration
* `lct font <new font name>`
  * Sets the font for the chat consoles. Will not allow you to set one which does not exist.
* `lct fontSize <new font size>`
  * Sets the font size for the chat consoles
* `lct blink <true|false>`
  * set whether it should blink
* `lct timestamp <true|false>`
  * set whether it should add a timestamp at the front
* `lct blankLine`
  * set whether it should automatically add a newline to things echoed.
* `lct gaglist`
  * lists the mobs and lines being gagged in the chat tabs.
* `lct gagmob <Lua pattern>`
  * add a Lua pattern to check speakers against. See [this tutorial from lua-users.org](http://lua-users.org/wiki/PatternsTutorial) for more information. If the speaker matches the pattern, anything they say or emote on any channel will be gagged from the tabbed chat consoles. Does not affect the main window. Uses gmcp.Comm.Channel.Text.talker to make the determination.
    * `lct gagmob Abeytu`
      * gags any mob with "Abeytu" in the speaker name in gmcp.
    * `lct gagmob a sick .+ child`
      * gags `a sick human child` and `a sick merian child` and `a sick kepheran child` etc
* `lct ungagmob <Lua pattern>`
  * Removes a lua pattern from the gagged mobs list.
* `lct gag <Lua pattern>`
  * add a Lua pattern to check lines against. See [this tutorial from lua-users.org](http://lua-users.org/wiki/PatternsTutorial) for more information. If the content of the line matches any of the patterns then the line will be gagged from the tabbed chat consoles. Does not affect the main window.
    * `lct gag .- shouts "I love cheese!"`
      * will gag anyone shouting "I love cheese!"
* `lct ungag <Lua pattern>`
  * removes a lua pattern from the gagged lines list.