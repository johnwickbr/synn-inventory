Inventory.Server = {}

function Inventory.Server.RegisterInventory(invName, invMetadata) 
    return exports["synn-inventory"]:RegisterInventory(invName, invMetadata)
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
