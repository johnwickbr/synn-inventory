function RegisterInventory(name, metadata) 
    
    local valid, status = Inv.Util.CheckRegisterInventoryParams(name, metadata)

    if not valid then
        return status
    end

    Inv.Util.LogInfo("RequestInventory", string.format("Registered inventory with name %s", name))

    local hash = sha256(name)

    if Inv.Cache.HasInventory(hash) then
        return 0
    end

    if metadata.transient then
        Inv.Cache.SetInventory(hash, metadata);
        return 1
    end

    if Inv.Database.HasInventory(hash) then 
        --Load data
        return 1
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

    if Inv.Database.HasItem(name) then
        return 1
    end
end
