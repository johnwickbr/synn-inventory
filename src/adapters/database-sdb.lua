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

function Inv.Database.HasItem(name)
    local query = "SELECT EXISTS(SELECT 1 FROM `item` WHERE code_name=@0 LIMIT 1)"
    local result = Synn.Database.FetchScalar(query, name)

    if result == 1 then 
        return true 
    else 
        return false 
    end
end

function Inv.Database.LoadItem(name)
    
end

function Inv.Database.CreateItem(name, data)
    local query = "INSERT INTO `item` VALUES (NULL, @0, @1, @2, @3, @4, @5, @6)"
    return Synn.Database.Insert(query, 
        data.name, data.namePlural, name, 
        data.description, data.image, data.weight, 
        data.stacksize
    )
end