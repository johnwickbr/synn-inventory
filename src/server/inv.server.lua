function CreateInventory(name, metadata) 
    --TODO: Log this, not print.
    print("^6Attempting to create inventory with name: " .. name)
    
    local hash = sha256(name)
    
    --Check if the inventory hash exists...
    if Inv.Cache.HasInventory(hash) then
        return
    end

    if Inv.Database.HasInventory(hash) then 
        return
    end

    --Create the database.
    Inv.Database.CreateInventory(hash, metadata);
    Inv.Cache.SetInventory(hash, metadata);

    return hash
end

