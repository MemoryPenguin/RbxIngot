-- @author MemoryPenguin
-- @author Narrev
-- UDim4 Object

local newVector2 = Vector2.new
local newUDim2 = UDim2.new
local IsA = game.IsA
local SizePos = {
	Size = "AbsoluteSize";
	Position = "AbsolutePosition";
}

local function Connect(Event, func)
	Connect = Event.Connect
	Connect(Event, func)
end

local function Disconnect(Event)
	Disconnect = Event.Disconnect
	Disconnect(Event)
end

local function ToUDim2(self, GuiObject)
	if not GuiObject.Parent or not IsA(GuiObject.Parent, "GuiBase2d") then
		return newVector2(0, 0)
	end

	local ParentSize = GuiObject.Parent.AbsoluteSize
	local X, Y, XX, XY, YX, YY = ParentSize.X, ParentSize.Y, self.XX, self.XY, self.YX, self.YY
	return newUDim2(
		0, XX.Offset + XY.Offset + XX.Scale*X + XY.Scale*Y,
		0, YY.Offset + YX.Offset + YY.Scale*Y + YX.Scale*X
	)
end

local function Render(self)
	--- Renders position and size

	local Object = self.Object
	Object.Position = ToUDim2(self.AbsolutePosition, Object)
	Object.Size = ToUDim2(self.AbsoluteSize, Object)
end

local function AttachToParent(self)
	--- Attaches to object's parent and intercepts resize events there

	local Parent = self.Object.Parent

	if self._parentConnection then
		Disconnect(self._parentConnection)
	end

	if Parent then
		self._parentConnection = Connect(Parent.Changed, function(Property)
			if Property == "AbsoluteSize" or Property == "AbsolutePosition" then
				Render(self)
			end
		end)
	end

	Render(self)
	return self
end

function newUDim4(X, Y, ...)
	if ... then
		return setmetatable({X = newUDim2(X, Y, ...); Y = newUDim2(select(3, ...))}, UDim4)
	else
		return setmetatable({X = X or newUDim2(); Y = Y or newUDim2()}, UDim4)
	end
end

-- UDim4Render Class
local UDim4Render = {Render = Render}

function UDim4Render:__index(i)
	return UDim4Render[i] or self[SizePos[i]]
end

function UDim4Render:__newindex(i, v)
	self[SizePos[i]] = v -- Only allows you to change Position and Size
	Render(self)
end

function UDim4Render:Destroy()
	--- Halts the enforcer
	Disconnect(self._objectConnection)
	if self._parentConnection then
		Disconnect(self._parentConnection)
	end

	-- Release references
	self.Object, self.AbsoluteSize, self.AbsolutePosition, self._objectConnection, self._parentConnection = nil
end

-- UDim4 Class
local UDim4 = {new = newUDim4}
UDim4.__index = UDim4

function UDim4:ToVector2(GuiObject)
	local Dim = ToUDim2(self, GuiObject)
	return newVector2(Dim.X.Offset, Dim.Y.Offset)
end

function UDim4:MakeEnforcer(GuiObject, Position, Size)
	self = {
		Object = GuiObject;
		AbsoluteSize = Size or newUDim4(newUDim2(0, 0, 1, 0), newUDim2(0, 0, 0, 0));
		AbsolutePosition = Position or newUDim4(newUDim2(1, 0, -1, 0), newUDim2(0, 0, 1, 0));
		_parentConnection = true;
	}

	self._objectConnection = Connect(GuiObject.Changed, function(Property)
		if Property == "AbsoluteSize" or Property == "AbsolutePosition" then
			Render(self)
		elseif Property == "Parent" then
			AttachToParent(self)
		end
	end)

	return setmetatable(AttachToParent(self), UDim4Render)
end

return UDim4
