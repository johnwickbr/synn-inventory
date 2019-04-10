Inventory.Server = {}

function Inventory.Server.CreateInventory(name, metadata) 
    exports["synn-inventory"]:CreateInventory(name, metadata)
end

function Inventory.Server.RegisterItemDefinition(itemName, itemData) 
    --TODO: Implement.
end


function Inventory.Server.UnregisterItemDefinition(itemName) 
    --TODO: Implement.
end


function Inventory.Server.AddItem(inventoryUniqueId, itemName, itemCount) 
    --TODO: Implement.
end


function Inventory.Server.PutItem(inventoryUniqueId, itemName, itemCount)
    --TODO: Implement.
end


function Inventory.Server.RemoveItem(inventoryUniqueId, itemName, itemCount) 
    --TODO: Implement.
end
