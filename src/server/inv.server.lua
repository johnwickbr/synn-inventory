

function CreateInventory(name, data) 
    local hash = sha256(name)
    
    --Check if the inventory hash exists...
    if Inv.Cache.HasInventory(hash) or Inv.Database.HasInventory(hash) then
        return
    end

    --Create the database.
    Inv.Database.CreateInventory(hash, data);
    Inv.Database.SetInventory(hash, data);

    return hash
end

