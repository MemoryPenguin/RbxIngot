# Dropdown Component
The Dropdown component is a simple dropdown that supports selection of one item from a large amount of choices.
![Dropdown image](/images/dropdown-1.png)

![Dropdown structure](/images/dropdown-2.png)

## Properties
*Dropdown supports all GuiObject properties, For brevity, they have not been listed here.*

### [number](http://wiki.roblox.com/index.php?title=Number) AnimationTime
How long the dropdown's opening animation will take. If zero, no animation takes place. Defaults to `0.3`.

### [boolean](http://wiki.roblox.com/index.php?title=API:Boolean) CloseOnOptionSelected
Whether to close the dropdown when an option is selected. Defaults to `true`.

### [string](http://wiki.roblox.com/index.php?title=API:String) CurrentEntry
The currently selected item, or nil if it does not exist. Setting this will select the item corresponding to the string, or error if it does not exist. Defaults to `nil`.

### [array&lt;string&gt;](http://wiki.roblox.com/index.php?title=API:Table) Entries
The entries of the dropdown. Setting this value will remove all entries from the dropdown, then add all the entries in the assigned value.

!!! note
    Modifying this value via `table.insert` will not add or remove entries from the dropdown. To modify entries, use [AddEntry](#AddEntry) and [RemoveEntry](#RemoveEntry).
	
### [Font](http://wiki.roblox.com/index.php?title=API:Enum/Font) Font
The font the dropdown uses. Defaults to `SourceSans`.

### [FontSize](http://wiki.roblox.com/index.php?title=API:Enum/FontSize) FontSize
The size of the dropdown's text. This value is used directly for the size of the dropdown's current item text, and the value immediately below it is used as the item entry font size. For example, if this property is set to `Size24`, the current item text will have a font size of `Size24` and the item entries will have a font size of `Size18`. Defaults to `Size24`.

### [boolean](http://wiki.roblox.com/index.php?title=API:Boolean) Open
Whether the dropdown is open or not. Defaults to `false`.

### [Font](http://wiki.roblox.com/index.php?title=API:Enum/Font) SelectedEntryFont
The font that the dropdown's selected entry uses. Defaults to `SourceSansBold`. If this is the same as [Font](#Font), there will be no visual difference between a selected entry and an unselected one.
	
### [number](http://wiki.roblox.com/index.php?title=Number) ShownItems
How many options, at most, should be shown at once when the dropdown is open. Excess options will be wrapped in a scrolling frame. Defaults to `3`.

## Methods

### [TextButton](http://wiki.roblox.com/index.php?title=API:Class/TextButton) GetEntryButton([string](http://wiki.roblox.com/index.php?title=API:String) entryName)
Returns the TextButton that corresponds to `entryName`, or nil if one does not exist.

### [boolean](http://wiki.roblox.com/index.php?title=API:Boolean) AddEntry([string](http://wiki.roblox.com/index.php?title=API:String) entryName)
Adds an entry to the dropdown. Returns `true` on success and `false` if the dropdown already has an entry named `entryName`.

### [boolean](http://wiki.roblox.com/index.php?title=API:Boolean) RemoveEntry([string](http://wiki.roblox.com/index.php?title=API:String) entryName)
Removes an entry from the dropdown. Returns `true` on success and `false` if the dropdown doesn't have an entry named `entryName`.

### [boolean](http://wiki.roblox.com/index.php?title=API:Boolean) HasEntry([string](http://wiki.roblox.com/index.php?title=API:String) entryName)
Returns whether an entry named `entryName` is within the dropdown.

!!! note
    This is faster than iterating over [Entries](#Entries) when the only goal is to check whether the dropdown contains an entry.

### [void](http://wiki.roblox.com/index.php?title=API:Nil) AddEntries([array&lt;string&gt;](http://wiki.roblox.com/index.php?title=API:Table) entryNames)
Adds all the entries within `entryNames` to the dropdown. This does not return a success/failure boolean; additions will fail silently.

## Example
This example assumes that the Dropdown module has been already loaded and stored in the `Dropdown` variable.
```lua
local drop = Dropdown.new(script.Parent)

for i = 1, 10 do
    drop:AddEntry("Item "..i)
end
```