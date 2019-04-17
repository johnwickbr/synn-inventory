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
        --TODO: We ideally don't wan to load the item until the server actually needs it.
        --  Otherwise we get 100's (2x) upon starting the server, seems undesireable.
        local found, itemData = Inv.Database.LoadItem(name)

        if found then
            Inv.Cache.SetItem(name, itemData)
            return 1
        end
    else
        Inv.Database.CreateItem(name, data)
        Inv.Cache.SetItem(name, data)
        return 2
    end
end