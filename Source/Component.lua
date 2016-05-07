---------------------------
----- Component Class -----
---------------------------
local Component = {}

function Component.new(rootObject)
	assert(rootObject ~= nil, "rootObject must not be nil")
	assert(pcall(game.IsA, rootObject, "Instance"), "rootObject must be an Instance")
	
	return setmetatable({
		-- Must define RootObject before metatable assignment or stuff breaks.
		RootObject = rootObject;
	}, Component)
end

function Component:__index(key)
	local object = self.RootObject
	local class = getmetatable(self)
	local getter = class["get_"..key]
	local classValue = class[key]
	
	-- A getter!
	if getter then
		-- Call it and return what it spits out
		return getter(self)
	-- Boring normal class member
	elseif classValue then
		return classValue
	end
	
	-- Technically the default case isn't necessary because of implicit nil returns
	-- That's not very nice, though, so here it is.
	return nil
end

function Component:__newindex(key, value)
	local object = self.RootObject
	-- Always gets the object class, even from a higher class
	local class = getmetatable(self)
	local getter = class["get_"..key]
	local setter = class["set_"..key]
	
	-- Check if it's a property - all properties are gettable.
	if getter then
		-- If it's settable, invoke the setter.
		if setter then
			setter(self, value)
		-- Otherwise, throw an error.
		else
			error("Cannot set read-only property "..key)
		end
	else
		-- Occluding class values is typically a Bad Thing.
		if class[key] then
			warn("Class key "..key.." is being occluded from an object (RootObject: "..object:GetFullName()..")")
		end
		
		rawset(self, key, value)
	end
end

--------------------------------------
----- Component Class Properties -----
--------------------------------------
-- Since the component doesn't have the default GuiObject primitives they need to be implemented here
-- This way all components will have them.
function Component:get_Active()
	return self.RootObject.Active
end

function Component:set_Active(value)
	self.RootObject.Active = value
end

function Component:get_AbsolutePosition()
	return self.RootObject.AbsolutePosition
end

function Component:get_AbsoluteSize()
	return self.RootObject.AbsoluteSize
end

function Component:get_BackgroundColor3()
	return self.RootObject.BackgroundColor3
end

function Component:set_BackgroundColor3(value)
	self.RootObject.BackgroundColor3 = value
end

function Component:get_BackgroundTransparency()
	return self.RootObject.BackgroundTransparency
end

function Component:set_BackgroundTransparency(value)
	self.RootObject.BackgroundTransparency = value
end

function Component:get_BorderColor3()
	return self.RootObject.BorderColor3
end

function Component:set_BorderColor3(value)
	self.RootObject.BorderColor3 = value
end

function Component:get_BorderSizePixel()
	return self.RootObject.BorderSizePixel
end

function Component:set_BorderSizePixel(value)
	self.RootObject.BorderSizePixel = value
end

function Component:get_ClipsDescendants()
	return self.RootObject.ClipsDescendants
end

function Component:set_ClipsDescendants(value)
	self.RootObject.ClipsDescendants = value
end

function Component:get_Draggable()
	return self.RootObject.Draggable
end

function Component:set_Draggable(value)
	self.RootObject.Draggable = value
end

function Component:get_NextSelectionDown()
	return self.RootObject.NextSelectionDown
end

function Component:set_NextSelectionDown(value)
	self.RootObject.NextSelectionDown = value
end

function Component:get_NextSelectionLeft()
	return self.RootObject.NextSelectionLeft
end

function Component:set_NextSelectionLeft(value)
	self.RootObject.NextSelectionLeft = value
end

function Component:get_NextSelectionRight()
	return self.RootObject.NextSelectionRight
end

function Component:set_NextSelectionRight(value)
	self.RootObject.NextSelectionRight = value
end

function Component:get_NextSelectionUp()
	return self.RootObject.NextSelectionUp
end

function Component:set_NextSelectionUp(value)
	self.RootObject.NextSelectionUp = value
end

function Component:get_Position()
	return self.RootObject.Position
end

function Component:set_Position(value)
	self.RootObject.Position = value
end

function Component:get_Rotation()
	return self.RootObject.Rotation
end

function Component:set_Rotation(value)
	self.RootObject.Rotation = value
end

function Component:get_Selectable()
	return self.RootObject.Selectable
end

function Component:set_Selectable(value)
	self.RootObject.Selectable = value
end

function Component:get_SelectionImageObject()
	return self.RootObject.SelectionImageObject
end

function Component:set_SelectionImageObject(value)
	self.RootObject.SelectionImageObject = value
end

function Component:get_Size()
	return self.RootObject.Size
end

function Component:set_Size(value)
	self.RootObject.Size = value
end

function Component:get_SizeConstraint()
	return self.RootObject.SizeConstraint
end

function Component:set_SizeConstraint(value)
	self.RootObject.SizeConstraint = value
end

function Component:get_Visible()
	return self.RootObject.Visible
end

function Component:set_Visible(value)
	self.RootObject.Visible = value
end

function Component:get_ZIndex()
	return self.RootObject.ZIndex
end

function Component:set_ZIndex(value)
	self.RootObject.ZIndex = value
end

return Component