-------------------
----- Imports -----
-------------------
local Component = require(script.Parent.Component)

---------------------
----- Constants -----
---------------------
local ENTRY_HEIGHT = 30

------------------------------
----- Dropdown Component -----
------------------------------
local Dropdown = {}
setmetatable(Dropdown, { __index = Component })
Dropdown.__index = Component.__index
Dropdown.__newindex = Component.__newindex

function Dropdown.new(parent)
	-- Object tree creation
	local root = Instance.new("TextButton", parent)
	root.Name = "Dropdown"
	root.BackgroundColor3 = Color3.new(1, 1, 1)
	root.Size = UDim2.new(0, 100, 0, 100)
	root.TextTransparency = 1
	
	local currentOption = Instance.new("TextLabel", root)
	currentOption.Name = "CurrentOption"
	currentOption.BackgroundTransparency = 1
	currentOption.Font = Enum.Font.SourceSans
	currentOption.FontSize = Enum.FontSize.Size24
	currentOption.Position = UDim2.new(0, 5, 0, 0)
	currentOption.Size = UDim2.new(1, -45, 1, 0)
	currentOption.Text = ""
	currentOption.TextXAlignment = Enum.TextXAlignment.Left
	
	local arrow = Instance.new("ImageLabel", root)
	arrow.Name = "Arrow"
	arrow.Image = "rbxassetid://409178361"
	arrow.ImageColor3 = Color3.new(0, 0, 0)
	arrow.Position = UDim2.new(1, -28, 0.5, -8)
	arrow.Size = UDim2.new(0, 16, 0, 16)
	
	local itemList = Instance.new("ScrollingFrame", root)
	itemList.Name = "Entries"
	itemList.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
	itemList.Position = UDim2.new(0, 0, 1, 0)
	itemList.ScrollBarThickness = 0
	itemList.Size = UDim2.new(1, 0, 0, 0)
	
	-- Object creation
	local super = Component.new(root)
	local self = setmetatable(super, Dropdown)
	self.AnimationTime = 0.3
	self.CloseOnOptionSelected = true
	self._open = false
	self.SelectedEntryFont = Enum.Font.SourceSansBold
	self.ShownItems = 3
	
	-- Event connection
	root.MouseButton1Click:connect(function()
		self.Open = not self.Open
	end)
	
	return self
end

----------------------------------
----- Dropdown Class Methods -----
----------------------------------
function Dropdown:_reflowList()
	local list = self.RootObject.Entries
	local items = list:GetChildren()
	
	table.sort(items, function(a, b)
		return a.Text < b.Text
	end)
	
	for index, item in ipairs(items) do
		-- curse you one-based indices
		item.Position = UDim2.new(0, 0, 0, ENTRY_HEIGHT * (index - 1))
	end
	
	list.CanvasSize = UDim2.new(0, 0, 0, #items * ENTRY_HEIGHT)
	
	if self.Open then
		local listHeight = math.min(#items, self.ShownItems) * ENTRY_HEIGHT
		list.Size = UDim2.new(1, 0, 0, listHeight)
	end
end

function Dropdown:GetEntryButton(entryText)
	return self.RootObject.Entries:FindFirstChild(entryText)
end

function Dropdown:AddEntry(entryText)
	if self:HasEntry(entryText) then
		return
	end
	
	local list = self.RootObject.Entries
	
	local entry = Instance.new("TextButton", list)
	entry.Name = entryText
	entry.BackgroundColor3 = list.BackgroundColor3
	entry.BorderSizePixel = 0
	entry.Font = self.Font
	entry.FontSize = math.max(0, self.RootObject.CurrentOption.FontSize.Value - 1)
	entry.Size = UDim2.new(1, 0, 0, ENTRY_HEIGHT)
	entry.Text = entryText
	entry.ZIndex = list.ZIndex
	
	entry.MouseButton1Click:connect(function()
		self.CurrentEntry = entryText
		if self.CloseOnOptionSelected then
			self.Open = false
		end
	end)
	
	self:_reflowList()
end

function Dropdown:RemoveEntry(entryText)
	if self:HasEntry(entryText) then
		if self.CurrentEntry == entryText then
			self.CurrentEntry = nil
		end
		
		self:GetEntryButton(entryText):Destroy()
		self:_reflowList()
	end
end

function Dropdown:AddEntries(entries)
	for _, entry in ipairs(entries) do
		self:AddEntry(entry)
	end
end

function Dropdown:HasEntry(entry)
	return self:GetEntryButton(entry) ~= nil
end

-------------------------------------
----- Dropdown Class Properties -----
-------------------------------------
function Dropdown:get_BorderColor3()
	return self.RootObject.BorderColor3
end

function Dropdown:set_BorderColor3(value)
	self.RootObject.BorderColor3 = value
	self.RootObject.Entries.BorderColor3 = value
end

function Dropdown:get_CurrentEntry()
	return self._currentEntry
end

function Dropdown:set_CurrentEntry(value)
	if self._currentEntry then
		local currentEntryButton = self:GetEntryButton(self._currentEntry)
		
		if currentEntryButton then
			currentEntryButton.Font = self.Font
		end
	end
	
	if value then
		local entryButton = self:GetEntryButton(value)
	
		if not entryButton then
			error(value.." is not an entry within the Dropdown")
		end
		
		entryButton.Font = self.SelectedEntryFont
	end
	
	self.RootObject.CurrentOption.Text = value or ""
	self._currentEntry = value
end

function Dropdown:get_Entries()
	local entries = {}
	
	for _, child in ipairs(self.RootObject.Entries:GetChildren()) do
		table.insert(entries, child.Text)
	end
	
	return entries
end

function Dropdown:set_Entries(value)
	assert(type(value) == "table", "Entries is a table value")
	
	self.RootObject.Entries:ClearAllChildren()
	for _, entry in ipairs(value) do
		self:AddEntry(entry)
	end
end

function Dropdown:get_Font()
	return self.RootObject.CurrentOption.Font
end

function Dropdown:set_Font(value)
	self.RootObject.CurrentOption.Font = value
	
	for _, button in ipairs(self.RootObject.Entries:GetChildren()) do
		if button.Text ~= self.CurrentEntry then
			button.Font = value
		end
	end
end

function Dropdown:get_FontSize()
	return self.RootObject.CurrentOption.FontSize
end

function Dropdown:set_FontSize(value)
	self.RootObject.CurrentOption.FontSize = value
	
	for _, button in ipairs(self.RootObject.Entries:GetChildren()) do
		button.FontSize = self.RootObject.CurrentOption.FontSize.Value - 1
	end
end

function Dropdown:get_Open()
	return self._open
end

function Dropdown:set_Open(value)
	assert(type(value) == "boolean", "cannot assign Open to a "..type(value)..", use a boolean instead")
	self._open = value
	
	local list = self.RootObject.Entries
	local listHeight = math.min(#list:GetChildren(), self.ShownItems) * ENTRY_HEIGHT
	local goal = value and UDim2.new(1, 0, 0, listHeight) or UDim2.new(1, 0, 0, 0)
	
	list.ScrollBarThickness = 0
	
	if self.AnimationTime == 0 or not list:IsDescendantOf(game) then
		list.Size = goal
		list.ScrollBarThickness = 5
	else
		list:TweenSize(goal, Enum.EasingDirection.InOut, Enum.EasingStyle.Quart, self.AnimationTime, true, function()
			if value then
				list.ScrollBarThickness = 5
			end
		end)
	end
end

function Dropdown:get_ZIndex()
	return self.RootObject.ZIndex
end

function Dropdown:set_ZIndex(value)
	self.RootObject.ZIndex = value
	self.RootObject.CurrentOption.ZIndex = value
	self.RootObject.Arrow.ZIndex = value
	self.RootObject.Entries.ZIndex = value
	
	for _, button in ipairs(self.RootObject.Entries:GetChildren()) do
		button.ZIndex = value
	end
end

return Dropdown