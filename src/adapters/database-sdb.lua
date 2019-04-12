function Inv.Database.CreateInventory(hash, meta) 
    local query = "INSERT INTO `inventory` VALUES (@0, @1, @2, @3, @4, @5)"
    return Synn.Database.Insert(query, 
        hash, meta.owner, meta.theme, meta.style,
        meta.width, meta.height
    );
end

function Inv.Database.HasInventory(hash, owner) 
    local query = "SELECT EXISTS(SELECT 1 FROM `inventory` WHERE uiid=@0 LIMIT 1)"
    local result = Synn.Database.FetchScalar(query, hash, owner)

    if result == 1 then 
        return true 
    else 
        return false 
    end
end