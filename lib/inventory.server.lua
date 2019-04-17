Inventory.Server = {}

function Inventory.Server.RegisterInventory(invName, invMetadata) 
    return exports["synn-inventory"]:RegisterInventory(invName, invMetadata, false)
end

function Inventory.Server.RegisterItem(itemName, itemData) 
   return exports["synn-inventory"]:RegisterItem(itemName, itemData)
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
