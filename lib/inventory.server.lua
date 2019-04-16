Inventory.Server = {}

function Inventory.Server.RequestInventory(invName, invMetadata, invOverwrite) 
    return exports["synn-inventory"]:RequestInventory(invName, invMetadata, invOverwrite)
end

function Inventory.Server.RegisterItem(itemName, itemData) 
    export["synn-inventory"]:RegisterItem(name, data)
    --TODO: Implement.
end


function Inventory.Server.UnregisterItem(itemName) 
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
