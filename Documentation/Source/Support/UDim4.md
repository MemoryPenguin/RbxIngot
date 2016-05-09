# UDim4s
Consider this example: a dynamically resizing container on both axes with an icon that stays as tall as its parent (and as wide as it is tall) via [SizeConstraint](http://wiki.roblox.com/index.php?title=API:Class/GuiObject/SizeConstraint). If you want to put something to the right of that icon, you cannot guarantee that it will remain to the right - the icon might overlap it on some aspect ratios. Overcoming this issue requires scripting - that's what UDim4 does.

