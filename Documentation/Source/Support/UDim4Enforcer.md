# UDim4Enforcer
The UDim4Enforcer class is designed to assist in applying a [UDim4](udim4.md) value to a GuiObject's [Position](http://wiki.roblox.com/index.php?title=API:Class/GuiObject/Position) and [Size](http://wiki.roblox.com/index.php?title=API:Class/GuiObject/Size) properties. It will automatically apply UDim4s to the object and keep them up to date until it is destroyed.

## Constructors
### UDim4Enforcer.new([GuiObject](http://wiki.roblox.com/index.php?title=API:Class/GuiObject) object, [UDim4](udim4.md) position, [UDim4](udim4.md) size)
Creates a new UDim4Enforcer for `object` with position `position` and size `size`. If either `position` or `size` are `nil`, the corresponding properties of the GuiObject will not be changed when the enforcer acts.

## Properties

!!! warning
    Do not set any of these properties! Use SetPosition and SetSize to change Position and Size - Object should never be changed.

### [GuiObject](http://wiki.roblox.com/index.php?title=API:Class/GuiObject) Object
The object the UDim4Enforcer is acting upon.

### [UDim4](udim4.md) Position
The position to set the object to.

### [UDim4](udim4.md) Size
The size to set the object to.

## Methods
### [void](http://wiki.roblox.com/index.php?title=API:Nil) SetPosition([UDim4](udim4.md) position)
Sets the position UDim4 and applies it to the object.

### [void](http://wiki.roblox.com/index.php?title=API:Nil) SetSize([UDim4](udim4.md) size)
Sets the size UDim4 and applies it to the object.

### [void](http://wiki.roblox.com/index.php?title=API:Nil) Enforce()
Enforces the position and size UDim4s on the object.

### [void](http://wiki.roblox.com/index.php?title=API:Nil) Destroy()
Halts the enforcer and releases all resources it contains. The enforcer is unusable after this.

## Example
This example assumes that the UDim4 and UDim4Enforcer modules have been loaded into variables of the same name.

```lua
local position = UDim4.new(UDim2.new(0, 0, 1, 0), UDim2.new(0, 0, 0, 0))
local size = UDim4.new(UDim2.new(1, 0, -1, 0), UDim2.new(0, 0, 1, 0))
local enforcer = UDim4Enforcer.new(script.Parent, position, size)
```