local cachedInventories = {}

function Inv.Cache.HasInventory(hash)
    return Inv.Cache.GetInventory(hash) ~= ""
end

function Inv.Cache.SetInventory(invHash, invMeta, invData) 
    if Inv.Cache.HasInventory(invData.hash) then
        return
    end

    local cacheEntry = {
        hash = invHash,
        meta = invMeta,
        data = invData
    }

    table.insert(cachedInventories, cacheEntry);
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
