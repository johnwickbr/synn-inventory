local cachedInventories = {}

function Inv.Cache.HasInventory(hash)
    return Inv.Cache.GetInventory(hash) ~= ""
end

function Inv.Cache.SetInventory(invData) 
    if Inv.Cache.HasInventory(invData.hash) then
        return
    end

    table.insert(cachedInventories, invData);
end

function Inv.Cache.GetInventory(hash) 
    for i = 1, #cachedInventories do 
        local inv = cachedInventories[i]

        if inv.hash == hash then
            return inv.hash
        end
    end

    return ""
end

function Inv.Cache.GetInventoryData(hash) 
    for i = 1, #cachedInventories do 
        local inv = cachedInventories[i]

        if inv.hash == hash then
            return inv.data
        end
    end

    return {}
end
