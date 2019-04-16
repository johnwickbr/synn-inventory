--[[
    Returns a interger determining what happened:
        -1 ->  Input error, see console for more information.
         0  -> We loaded the inventory or was already loaded.
         1  -> We created the inventory.
         2  -> We overwrote the existing inventory.

    Errors: 
        1000 -> Name is nil or empty.
        1001 -> No metadata supplied.
        1002 -> Invalid width.
        1003 -> Invalid height.
        1004 -> Invalid theme.
        1005 -> Invalid style.
        1006 -> Invalid owner.
        1007 -> Wrong owner size.
        1008 -> Wrong transient bit.
        1009 -> Wrong overwrite bit.
]]
function RequestInventory(name, metadata, overwrite) 

    -- Check if all the inputs are valid.
    if Inv.Util.StringEmptyOrNull(name) then return 1000 end
    if Inv.Util.IsNull(metadata) then return 1001 end
    if not Inv.Util.IsNumber(metadata.width, 1, 255) then return 1002 end
    if not Inv.Util.IsNumber(metadata.height, 1, 255) then return 1003 end
    if not Inv.Util.IsNumber(metadata.theme, 0, 255) then return 1004 end
    if not Inv.Util.IsNumber(metadata.style, 0, 255) then return 1005 end
    if not Inv.Util.StringOrNull(metadata.owner) then return 1006 end
    if not Inv.Util.StringIsOfSize(metadata.owner, 1, 255) then return 1007 end
    if not Inv.Util.IsBool(metadata.transient) then return 1008 end
    if not Inv.Util.IsBool(overwrite) then return 1009 end


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