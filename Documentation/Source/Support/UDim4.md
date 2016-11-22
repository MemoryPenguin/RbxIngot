# UDim4
The UDim4 type describes a position where each axis is described by a UDim2. This means that you can position something on the X axis based on the parent's Y size, for instance. UDim4 is contained within the `Utility` folder of Ingot.

Consider this example: a dynamically resizing container on both axes with an icon that stays as tall as its parent (and as wide as it is tall) via [SizeConstraint](http://wiki.roblox.com/index.php?title=API:Class/GuiObject/SizeConstraint). If you want to put something to the right of that icon, you cannot guarantee that it will remain to the right - the icon might overlap it on some aspect ratios. UDim4 can solve this.

## Constructors

### UDim4.new([UDim2](http://wiki.roblox.com/index.php?title=API:UDim2) x, [UDim2](http://wiki.roblox.com/index.php?title=API:UDim2) y)
Creates a new UDim4, using `x` and `y` as the X and Y values.

### UDim4.new([number](http://wiki.roblox.com/index.php?title=API:Number) xXScale, [number](http://wiki.roblox.com/index.php?title=API:Number) xXOffset, [number](http://wiki.roblox.com/index.php?title=API:Number) xYScale, [number](http://wiki.roblox.com/index.php?title=API:Number) xYOffset, [number](http://wiki.roblox.com/index.php?title=API:Number) yXScale, [number](http://wiki.roblox.com/index.php?title=API:Number) yYOffset, [number](http://wiki.roblox.com/index.php?title=API:Number) yYScale, [number](http://wiki.roblox.com/index.php?title=API:Number) yYOffset)
Creates a new UDim4, using the various values to construct UDim2 values as the X and Y values.

## Properties

### [UDim2](http://wiki.roblox.com/index.php?title=API:UDim2) X
The X coordinate of the UDim4.

### [UDim2](http://wiki.roblox.com/index.php?title=API:UDim2) Y
The Y coordinate of the UDim4.

## Methods

### [Vector2](http://wiki.roblox.com/index.php?title=API:Vector2) ToVector2([GuiObject](http://wiki.roblox.com/index.php?title=API:Class/GuiObject) guiObject)
Returns the absolute value (in pixels) of the UDim4, relative to the parent of `guiObject`. If `guiObject` is parented to `nil`, a zeroed Vector2 (`0, 0`) is returned.

# UDim4Enforcer
The UDim4Enforcer class is designed to assist in applying a [UDim4](udim4.md) value to a GuiObject's [Position](http://wiki.roblox.com/index.php?title=API:Class/GuiObject/Position) and [Size](http://wiki.roblox.com/index.php?title=API:Class/GuiObject/Size) properties. It will automatically apply UDim4s to the object and keep them up to date until it is destroyed.

## Constructors
### UDim4.MakeEnforcer([GuiObject](http://wiki.roblox.com/index.php?title=API:Class/GuiObject) object, UDim4 position, UDim4 size)
Creates a new UDim4Enforcer for `object` with position `position` and size `size`. If either `position` or `size` are `nil`, the corresponding properties of the GuiObject will not be changed when the enforcer acts.

## Properties
### [GuiObject](http://wiki.roblox.com/index.php?title=API:Class/GuiObject) Object *[readonly]*
The object the UDim4Enforcer is acting upon.

### UDim4 Position
The position to set the object to.

### UDim4 Size
The size to set the object to.

## Methods
### [void](http://wiki.roblox.com/index.php?title=API:Nil) Render()
Enforces the position and size UDim4s on the object.

### [void](http://wiki.roblox.com/index.php?title=API:Nil) Destroy()
Halts the enforcer and releases all resources it contains. The enforcer is unusable after this.

## Example

```lua
local Position = UDim4.new(0, 0, 1, 0, 0, 0, 0, 0)
local Size = UDim4.new(UDim2.new(1, 0, -1, 0), UDim2.new(0, 0, 1, 0))
local Enforcer = UDim4.MakeEnforcer(script.Parent, Position, Size)
```
You can also assign Size and Position later, but it is much more efficient to pass them as parameters initially

```lua
Enforcer.Position = Position
Enforcer.Size = Size
```
