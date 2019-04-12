function Inv.Database.CreateInventory(hash, meta, data) 
    local query = "INSERT INTO `inventory` VALUES (@0, @1, @2, @3, @4, @5, @6)"
    return Synn.Database.Insert(query, 
        hash, meta.owner, meta.theme, meta.style,
        meta.width, meta.height, data
    );
end

function Inv.Database.HasInventory(name) 
    return false
end