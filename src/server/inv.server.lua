function CreateInventory(name, meta) 
    --TODO: Log this, not print.
    print("^6Attempting to create inventory with name: " .. name .. "^7")
    
    local hash = sha256(name)
    
    --Check if the inventory hash exists...
    if Inv.Cache.HasInventory(hash) then
        return
    end

    if Inv.Database.HasInventory(hash) then 
        return
    end

    --Make this compatible with the database.
    if meta.owner == nil then
        meta.owner = "NULL"
    end

    -- Generate inventory data.
    local data = {}

    --Create the database and cache the created inventory.
    Inv.Database.CreateInventory(hash, meta, json.encode(data));
    Inv.Cache.SetInventory(hash, meta);

    return hash
end