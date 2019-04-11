function Inv.Database.CreateInventory(hash, meta, data) 
    local owner = meta.owner
    local theme = meta.theme
    local style = meta.style
    local width = meta.dimensions.x
    local height = meta.dimensions.y

    if owner == nil then
        owner = "NULL"
    end

    if data == nil or data == {} then
        data = ""
    end

    local query = "INSERT INTO `inventory` VALUES (@0, @1, @2, @3, @4, @5, @6)"
    return Mesh.Database.Insert(query, hash, owner, theme, style, width, height, data)
end

function Inv.Database.HasInventory(name) 
    return false
end