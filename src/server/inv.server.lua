function RequestInventory(name, metadata, overwrite) 
    
    local valid, status = Inv.Util.CheckRequestInventoryParams(name, metadata, overwrite)

    if not valid then
        return status
    end

    Inv.Util.LogInfo("RequestInventory", string.format("Requested inventory with name %s", name))

    local hash = sha256(name)

    if Inv.Cache.HasInventory(hash) then
        return 0
    end

    if metadata.transient then
        Inv.Cache.SetInventory(hash, metadata);
        return 1
    end

    if Inv.Database.HasInventory(hash) then 
        if overwrite then 
            -- Overwrite the inventory meta data.
            -- Load the inventory data
            -- Cache the data
            return 2
        else
            --local data = Inv.Database.LoadInventory(hash)
            --Inv.Cache.SetInventoryData(data)
            return 0
        end
    end

    Inv.Database.CreateInventory(hash, metadata)
    Inv.Cache.SetInventory(hash, metadata);
    return 1
end

function RegisterItem(name, data)
    local valid, status = Inv.Util.CheckRegisterItemParams(name, data)

    if not valid then
        return status
    end

    if Inv.Cache.HasItem(name) then
        return 0
    end


end
