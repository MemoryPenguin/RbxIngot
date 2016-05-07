---------------------
----- Variables -----
---------------------
local propertyCache = {}
local findFirstChild = game.FindFirstChild
local pcall = pcall

---------------------
----- Functions -----
---------------------
local function RawIsMemberOf(object, key)
	return object[key] ~= findFirstChild(object, key)
end

local function IsMemberOf(object, key)
	local className = object.ClassName
	
	if not propertyCache[className] then
		propertyCache[className] = {}
	end
	
	local cache = propertyCache[className]
	if cache[key] ~= nil then
		return cache[key]
	else
		print("cache miss: "..className.."."..key)
		local success, notChild = pcall(RawIsMemberOf, object, key)
		local memberOf = success and notChild
		cache[key] = memberOf
		return memberOf
	end
end

local function Set(object, key, value)
	object[key] = value
end

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
	-- Object property (not a child of the object), better spit that out
	elseif IsMemberOf(object, key) then
		return object[key]
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
		
		-- Try to set the property of the object.
		local setSuccess, failureReason = pcall(Set, object, key, value)
		
		-- If we couldn't set it for some reason, go forward - otherwise we're done here.
		if not setSuccess then
			-- If the property's actually a member of the object, we need to error out - invalid value.
			if IsMemberOf(object, key) then
				error(failureReason)
			-- Not a member of the object. Set the value as a field.
			else
				rawset(self, key, value)
			end
		end
	end
end

function Component:Test()
	return "hi from component"
end

return Component