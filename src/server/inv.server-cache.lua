local cachedInventories = {}
local cachedItems = {}

function Inv.Cache.HasInventory(hash)
    return Inv.Cache.GetInventory(hash) ~= ""
end

function Inv.Cache.HasItem(name)
    local found, data = Inv.Cache.GetItem(name)
    return found
end

function Inv.Cache.SetInventory(invHash, invMeta) 
    if Inv.Cache.HasInventory(invMeta.hash) then
        return
    end

    local cacheEntry = {
        hash = invHash,
        meta = invMeta,
        data = {}
    }

    table.insert(cachedInventories, cacheEntry);
    Inv.Util.LogVerbose("Cache", string.format("Cached inventory %s with metadata %s", invHash, json.encode(invMeta)))
end

function Inv.Cache.SetItem(name, data) 
    if Inv.Cache.HasItem(name) then
        return 
    end

    local cacheEntry = {
        name = name,
        data = data
    }

    table.insert(cachedItems, cacheEntry)
    Inv.Util.LogVerbose("Cache", string.format("Cached item %s with data %s", name, json.encode(data)))
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

function Inv.Cache.GetItem(name)
    for i = 1, #cachedItems do
        local item = cachedItems[i]

        if item.name == name then
            return true, item.data
        end
    end

    return false, {}
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
