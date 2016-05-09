-------------------
----- Imports -----
-------------------
local Component = require(script.Parent.Component)

-------------------------
----- Bar Component -----
-------------------------
local Bar = {}
setmetatable(Bar, { __index = Component })
Bar.__index = Component.__index
Bar.__newindex = Component.__newindex

Bar.Directions = {
	Horizontal = 1;
	Vertical = 2;
}

Bar.Origins = {
	Start = 1;
	End = 2;
	Middle = 3;
}

function Bar.new(parent)
	-- Object tree creation
	local root = Instance.new("Frame", parent)
	root.Name = "Bar"
	root.BackgroundColor3 = Color3.new(1, 1, 1)
	root.Size = UDim2.new(0, 100, 0, 5)
	
	local realBar = Instance.new("Frame", root)
	realBar.Name = "Real"
	realBar.BackgroundColor3 = Color3.new(0, 0, 0)
	realBar.BorderSizePixel = 0
	
	-- Object creation
	local super = Component.new(root)
	local self = setmetatable(super, Bar)
	self.Bar = realBar
	self._min = 0
	self._max = 1
	self._value = 0
	self._direction = Bar.Directions.Horizontal
	self._origin = Bar.Origins.Start
	self.AnimationTime = 0.2
	
	return self
end

-----------------------------
----- Bar Class Methods -----
-----------------------------
function Bar:_update()
	local percentage = self._value - self._min / self._max - self._min
	local position = UDim2.new(0, 0, 0, 0)
end

--------------------------------
----- Bar Class Properties -----
--------------------------------
function Bar:set_ZIndex(value)
	self.RootObject.ZIndex = value
	self.RootObject.Real.ZIndex = value
end

return Bar