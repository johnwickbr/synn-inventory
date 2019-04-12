function CreateInventory(name, meta) 
    --TODO: Log this, not print.
    --      Should contain some info on how or what created the inventory.
    print("^6Attempting to create inventory with name: " .. name .. "^7")
    
    local hash = sha256(name)

    --Make this compatible with the database.
    if meta.owner == nil then
        meta.owner = "NULL"
    end

    --TODO: Friendly user facing asserts (i.e. no stacktrace)
    --      Technical details should be printed to a log. (server side).
    assert(type(meta.theme) == "number")
    assert(type(meta.style) == "number")
    assert(type(meta.width) == "number")
    assert(type(meta.height) == "number")
    assert(type(meta.owner) == "string")

    assert(meta.theme >= 0 and meta.theme < 256)
    assert(meta.style >= 0 and meta.style < 256)
    assert(meta.width >= 1 and meta.width < 256)
    assert(meta.height >= 1 and meta.height < 256)

    assert(meta.owner ~= "")
    assert(#meta.owner > 0 and #meta.owner <= 64)

    --Check if the inventory hash exists...
    if Inv.Cache.HasInventory(hash) then
        print("^6".. name .. " is already cached!^7")
        return
    end

    if Inv.Database.HasInventory(hash, meta.owner) then 
        print("^6".. name .. " is already in database!^7")
        return
    end

    -- Generate inventory data.
    local data = {}

    local i = 0
    for x = 1, meta.width do
        for y = 1, meta.height do 
            local index = (meta.width * (x-1) + (y-1)) + 1
            data[index] = { item = "", count = 0 }
        end
    end

    local dataDatabase = Inv.Util.ToUnlabledTable(data)

    --Create the database and cache the created inventory.
    Inv.Database.CreateInventory(hash, meta, dataDatabase);
    Inv.Cache.SetInventory(hash, meta, data);

    print("^6Created inventory: ".. name .. "^7")
    return hash
end