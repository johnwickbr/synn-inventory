function CreateInventory(name, metadata) 
    --TODO: Log this, not print.
    print("^6Attempting to create inventory with name: " .. name)
    
    local hash = sha256(name)
    
    --Check if the inventory hash exists...
    if Inv.Cache.HasInventory(hash) then
        return
    end

    -- We don't want to do any database operations for transient inventories.
    if not metadata.transient then 
        if Inv.Database.HasInventory(hash) then 
            return
        end
        
        Inv.Database.CreateInventory(hash, metadata)
    end
    
    Inv.Cache.SetInventory(hash, metadata);
    return hash
end