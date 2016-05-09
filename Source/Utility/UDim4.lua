local UDim4 = {}
UDim4.__index = UDim4

function UDim4.new(x, y)
	assert(x and y, "Must supply x and y values.")
	
	local self = setmetatable({
		X = x;
		Y = y;
	}, UDim4)
	
	return self
end

function UDim4.FromCoordinates(...)
	return UDim4.new(
		UDim2.new(select(1, ...)),
		UDim2.new(select(5, ...))
	)
end

function UDim4:ToVector2(guiObject)
	if not guiObject.Parent or not guiObject.Parent:IsA("GuiBase2d") then
		return Vector2.new(0, 0)
	end
	
	local parentSize = guiObject.Parent.AbsoluteSize
	local xPosition = (self.X.X.Scale * parentSize.X) + self.X.X.Offset + (self.X.Y.Scale * parentSize.Y) + self.X.Y.Offset
	local yPosition = (self.Y.X.Scale * parentSize.X) + self.Y.X.Offset + (self.Y.Y.Scale * parentSize.Y) + self.Y.Y.Offset
	
	return Vector2.new(xPosition, yPosition)
end

return UDim4