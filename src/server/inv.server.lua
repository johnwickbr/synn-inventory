function CreateInventory(name, data) 
    local hash = sha256(name)

    return hash
end

