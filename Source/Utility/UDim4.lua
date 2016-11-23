-- @author Narrev
-- @original MemoryPenguin
-- UDim4 Object

local function ToUDim2(self, guiObject)
	if not guiObject.Parent or not guiObject.Parent:IsA("GuiBase2d") then
		return UDim2.new()
	end

	local parentSize = guiObject.Parent.AbsoluteSize
	local X, Y, XX, XY, YX, YY = parentSize.X, parentSize.Y, self.XX, self.XY, self.YX, self.YY
	return UDim2.new(
		0, XX.Offset + XY.Offset + XX.Scale*X + XY.Scale*Y,
		0, YY.Offset + YX.Offset + YY.Scale*Y + YX.Scale*X
	)
end

-- Renders position and size
local function Render(self)
	local object = self._object
	object.Position = ToUDim2(self._position, object)
	object.Size = ToUDim2(self._size, object)
end

-- Attaches to object's parent and intercepts resize events there
local function AttachToParent(self)
	local parent = self._object.Parent

	if self._parentConnection then
		self._parentConnection:Disconnect()
	end

	if parent then
		self._parentConnection = parent.Changed:Connect(function(property)
			if property == "AbsoluteSize" or property == "AbsolutePosition" then
				Render(self)
			end
		end)
	end

	Render(self)
	return self
end

-- UDim4Render Class
local UDim4Render = {Render = Render}

function UDim4Render:__index(i)
	if i == "Size" then
		return self._size
	elseif i == "Position" then
		return self._position
	else
		return UDim4Render[i]
	end
end

function UDim4Render:__newindex(i, v)
	if i == "Size" then
		self._size = v
		Render(self)
	elseif i == "Position" then
		self._position = v
		Render(self)
	end
end

-- Halts the enforcer
function UDim4Render:Destroy()
	self._objectConnection:Disconnect()
	if self._parentConnection then
		self._parentConnection:Disconnect()
	end
	self._object, self._size, self._position, self._objectConnection, self._parentConnection = nil
end

-- UDim4 Class
local UDim4 = {ToUDim2 = ToUDim2}
UDim4.__index = UDim4

function UDim4.new(x, y, ...)
	if ... then
		return setmetatable({X = UDim2.new(x, y, ...); Y = UDim2.new(select(3, ...))}, UDim4)
	else
		return setmetatable({X = x or UDim2.new(); Y = y or UDim2.new()}, UDim4)
	end
end

local defaultSize = UDim4.new(UDim2.new(0, 0, 1, 0), UDim2.new(0, 0, 0, 0))
local defaultPosition = UDim4.new(UDim2.new(1, 0, -1, 0), UDim2.new(0, 0, 1, 0))

function UDim4.MakeEnforcer(guiObject, position, size)
	self = {
		_object = guiObject;
		_size = size or defaultSize;
		_position = position or defaultPosition;
		_parentConnection = false;
	}

	self._objectConnection = guiObject.Changed:Connect(function(property)
		if property == "AbsoluteSize" or property == "AbsolutePosition" then
			Render(self)
		elseif Property == "Parent" then
			AttachToParent(self)
		end
	end)

	return setmetatable(AttachToParent(self), UDim4Render)
end

return UDim4
