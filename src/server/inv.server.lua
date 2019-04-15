--[[
    Returns a interger determining what happened:
        -1 ->  Input error, see console for more information.
         0  -> We loaded the inventory or was already loaded.
         1  -> We created the inventory.
         2  -> We overwrote the existing inventory.
]]
function RequestInventory(name, metadata, overwrite) 
    -- Do sanity checking on the input variables.
    local valid = Inv.Util.assert_check({
        Inv.Util.assert_string_not_empty(name),
        Inv.Util.assert_string_or_nil(metadata.owner),
        Inv.Util.assert_uint8(metadata.theme),
        Inv.Util.assert_uint8(metadata.style),
        Inv.Util.assert_uint8_non_zero_index(metadata.width),
        Inv.Util.assert_uint8_non_zero_index(metadata.height)
    });

    if not valid then
        return -1
    end

    --TODO: Log this, not print.
    print("^6Attempting to create inventory with name: " .. name)
    
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