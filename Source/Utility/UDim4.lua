local UDim4 = {}
UDim4.__index = UDim4

function UDim4.new(...)
	local args = {...}
	
	local x, y = args[1], args[2]
	
	if #args == 8 then
		x = UDim2.new(args[1], args[2], args[3], args[4])
		y = UDim2.new(args[5], args[6], args[7], args[8])
	end
	
	assert(x and y, "Must supply x and y values.")
	
	local self = setmetatable({
		X = x;
		Y = y;
	}, UDim4)
	
	return self
end

function UDim4.FromUDim2(x, y)
	return UDim4.new(
		x.X.Scale, x.X.Offset, 
		x.Y.Scale, x.Y.Offset, 
		y.X.Scale, y.X.Offset, 
		y.Y.Scale, y.Y.Offset
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