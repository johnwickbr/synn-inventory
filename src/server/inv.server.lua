function RequestInventory(name, metadata, overwrite) 
    
    local valid, status = Inv.Util.CheckRequestInventoryParams(name, metadata, overwrite)

    if not valid then
        return status
    end

    --TODO: Log this, not print.
    print("^6Attempting to create inventory with name: " .. name)
    
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

function RegisterItem(name, namePlural, codeName, description, image, weight, stacksize)
    -- if Inv.Util.StringEmptyOrNull(name) then return 100 end
    -- if Inv.Util.StringEmptyOrNull(namePlural) then return 101 end
    -- if Inv.Util.StringEmptyOrNull(codeName) then return 102 end
    -- if not Inv.Util.StringOrNull(description) then return 103 end
    -- if not Inv.Util.StringOrNUll(image) then return 104 end
    -- if not Inv.Util.IsNumber(weight) then return 105 end
    -- if not Inv.Util.IsFloat(weight) then return 106 end
    -- if not Inv.Util.IsNumber(stacksize) then return 107 end

    
end 