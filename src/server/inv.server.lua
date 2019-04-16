function RequestInventory(name, metadata, overwrite) 

    -- Check if all the inputs are valid.
    if Inv.Util.StringEmptyOrNull(name) then return 100 end
    if Inv.Util.IsNull(metadata) then return 101 end
    if not Inv.Util.IsNumber(metadata.width, 1, 255) then return 102 end
    if not Inv.Util.IsNumber(metadata.height, 1, 255) then return 103 end
    if not Inv.Util.IsNumber(metadata.theme, 0, 255) then return 104 end
    if not Inv.Util.IsNumber(metadata.style, 0, 255) then return 105 end
    if not Inv.Util.StringOrNull(metadata.owner) then return 106 end
    if not Inv.Util.StringIsOfSize(metadata.owner, 1, 64) then return 107 end
    if not Inv.Util.IsBool(metadata.transient) then return 108 end
    if not Inv.Util.IsBool(overwrite) then return 109 end
    if metadata.transient and metadata.owner ~= nil then return 110 end


    --TODO: Log this, not print.
    --print("^6Attempting to create inventory with name: " .. name)
    
    local hash = sha256(name)
    
    --Check if the inventory hash exists, if it's in cache we now it exists.
    if Inv.Cache.HasInventory(hash) then
        return 0
    end

    -- We know for a fact that transient inventories will never have any data from the database.
    -- So we can just load it into cache (empty inventory) and call it good. 
    if metadata.transient then
        Inv.Cache.SetInventory(hash, metadata);
        return 1
    end

    -- If the inventory is not transient and not in cache yet...
    --  We must see if it's in the database, try loading the data from there and cache it.
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