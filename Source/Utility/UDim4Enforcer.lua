-- Enforces a variable UDim4 on a GuiObject.

-------------------
----- Imports -----
-------------------
local UDim4 = require(script.Parent.UDim4)

-------------------------------
----- UDim4Enforcer Class -----
-------------------------------
local UDim4Enforcer = {}
UDim4Enforcer.__index = UDim4Enforcer

function UDim4Enforcer.new(guiObject, position, size)
	local self = setmetatable({
		Object = guiObject;
		Position = position;
		Size = size;
	}, UDim4Enforcer)
	
	local objectConnection
	objectConnection = guiObject.Changed:connect(function(property)
		if property == "AbsoluteSize" or property == "AbsolutePosition" then
			self:Enforce()
		elseif property == "Parent" then
			self:_attachToParent()
		end
	end)
	
	self._objectConnection = objectConnection
	self:_attachToParent()
end

-- Attaches to the object's parent to intercept resize events there.
function UDim4Enforcer:_attachToParent()
	if self._parentConnection then
		self._parentConnection:disconnect()
	end
	
	local connection
	local parent = self.Object.Parent
	
	if parent then
		connection = parent.Changed:connect(function(property)
			if property == "AbsoluteSize" or property == "AbsolutePosition" then
				self:Enforce()
			end
		end)
		
		self._parentConnection = connection
		self:Enforce()
	end
end

-- Enforces the position and size.
function UDim4Enforcer:Enforce()
	local object = self.Object
	
	local position = self.Position:ToVector2(object)
	local size = self.Size:ToVector2(object)
	object.Position = UDim2.new(0, position.X, 0, position.Y)
	object.Size = UDim2.new(0, size.X, 0, size.Y)
end

function UDim4Enforcer:SetPosition(position)
	self.Position = position
	self:Enforce()
end

function UDim4Enforcer:SetSize(size)
	self.Size = size
	self:Enforce()
end

-- Halts the enforcer.
function UDim4Enforcer:Destroy()
	self._objectConnection:disconnect()
	
	if self._parentConnection then
		self._parentConnection:Destroy()
	end
	
	-- Release references
	self.Object = nil
	self.Position = nil
	self.Size = nil
end

return UDim4Enforcer