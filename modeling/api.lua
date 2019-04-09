--[[
    Example of creating a new inventory.
    Each inventory has a name, which will get hashed to avoid collisions.
    Then a table of data. 
        Theme: On a per inventory basis you can set the theme the inventory should use.
        Style: On a per inventory basis you can set the style, single or tetris.
               As where tetris is non-uniform items and single always 1x1 items.
        Dimensions: The size of the inventory.
        Owner: possible owner of the inventory, keep nil if it's a public inventory.
]]
local inventory = CreateInventory("trunk-149520", {
    Theme = "default",
    Style = "tetris",
    Dimensions = vector2(8, 8),
    Owner = nil,
});