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
local properties = {
	"Active", "AbsolutePosition", "AbsoluteSize", "BackgroundColor3", "BackgroundTransparency",
	"BorderColor3", "BorderSizePixel", "ClipsDescendants", "Draggable", "NextSelectionDown",
	"NextSelectionLeft", "NextSelectionRight", "NextSelectionUp", "Position", "Rotation",
	"Selectable", "SelectionImageObject", "Size", "Visible", "ZIndex", "Parent"
}

local readOnlyProperties = {
	AbsolutePosition = true,
	AbsoluteSize = true
}

for _, property in ipairs(properties) do
	Component["get_"..property] = function(self)
		return self.RootObject[property]
	end
	
	if not readOnlyProperties[property] then
		Component["set_"..property] = function(self, value)
			self.RootObject[property] = value
		end
	end
end

return Component