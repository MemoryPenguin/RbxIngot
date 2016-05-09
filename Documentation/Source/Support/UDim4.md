# UDim4
The UDim4 type describes a position where each axis is described by a UDim2. This means that you can position something on the X axis based on the parent's Y size, for instance. UDim4 is contained within the Utility folder of Ingot.

Consider this example: a dynamically resizing container on both axes with an icon that stays as tall as its parent (and as wide as it is tall) via [SizeConstraint](http://wiki.roblox.com/index.php?title=API:Class/GuiObject/SizeConstraint). If you want to put something to the right of that icon, you cannot guarantee that it will remain to the right - the icon might overlap it on some aspect ratios. UDim4 can solve this.

## Constructors

### UDim4.new([UDim2](http://wiki.roblox.com/index.php?title=API:UDim2) x, [UDim2](http://wiki.roblox.com/index.php?title=API:UDim2) y)
Creates a new UDim4, using `x` and `y` as the X and Y values.

### UDim4.FromCoordinates([number](http://wiki.roblox.com/index.php?title=API:Number) xXScale, [number](http://wiki.roblox.com/index.php?title=API:Number) xXOffset, [number](http://wiki.roblox.com/index.php?title=API:Number) xYScale, [number](http://wiki.roblox.com/index.php?title=API:Number) xYOffset, [number](http://wiki.roblox.com/index.php?title=API:Number) yXScale, [number](http://wiki.roblox.com/index.php?title=API:Number) yYOffset, [number](http://wiki.roblox.com/index.php?title=API:Number) yYScale, [number](http://wiki.roblox.com/index.php?title=API:Number) yYOffset)
Creates a new UDim4, using the various values to construct UDim2 values as the X and Y values.

## Properties

### [UDim2](http://wiki.roblox.com/index.php?title=API:UDim2) X
The X coordinate of the UDim4.

### [UDim2](http://wiki.roblox.com/index.php?title=API:UDim2) Y
The Y coordinate of the UDim4.

## Methods

### [Vector2](http://wiki.roblox.com/index.php?title=API:Vector2) ToVector2([GuiObject](http://wiki.roblox.com/index.php?title=API:Class/GuiObject) guiObject)
Returns the absolute value (in pixels) of the UDim4, relative to the parent of `guiObject`. If `guiObject` is parented to `nil`, a zeroed Vector2 (`0, 0`) is returned.