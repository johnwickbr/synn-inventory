function RegisterInventory(name, metadata) 

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
        return ""
    end

    --TODO: Log this, not print.
    print("^6Attempting to create inventory with name: " .. name)
    
    local hash = sha256(name)
    
    --Check if the inventory hash exists...
    if Inv.Cache.HasInventory(hash) then
        return ""
    end

    -- We don't want to do any database operations for transient inventories.
    if not metadata.transient then 
        if Inv.Database.HasInventory(hash) then 
            return ""
        end
        
        Inv.Database.CreateInventory(hash, metadata)
    end
    
    Inv.Cache.SetInventory(hash, metadata);
    return hash
end