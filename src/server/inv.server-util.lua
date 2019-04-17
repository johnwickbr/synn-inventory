local LOG = false
local PRINT = true

function Inv.Util.StringEmptyOrNull(str)
    return Inv.Util.IsNull(str) or str == "" 
end

function Inv.Util.StringOrNull(str)
    return type(str) == "nil" or type(str) == "string"
end

function Inv.Util.StringIsOfSize(str, min, max) 
    if type(str) == "nil" then
        return false
    end

    return #str >= min and #str <= max
end

function Inv.Util.IsNull(obj)
    return type(obj) == "nil"
end

function Inv.Util.IsBool(bool)
    return bool == true or bool == false
end

function Inv.Util.IsNumber(num, min, max)
    return type(num) == "number" and num >= min and num <= max
end

function Inv.Util.LogInfo(func, message)
    if PRINT then
        print(string.format("^5[INFO] [%s]: %s^7", func, message))
    end
    
    --TODO: Log
end


function Inv.Util.LogWarning(func, message)
    if PRINT then
        print(string.format("^3[WARNING] [%s]: %s^7", func, message))
    end

        --TODO: Log
end

--TODO: Possible "NO_CHECK" flag, for performance or so.
function Inv.Util.CheckRequestInventoryParams(name, metadata, overwrite)

    if Inv.Util.StringEmptyOrNull(name) then 
        Inv.Util.LogWarning("RequestInventory", "The given name for this inventory was null or empty. got: " .. tostring(name))
        return false, 100 
    end

    if Inv.Util.IsNull(metadata) then 
        Inv.Util.LogWarning("RequestInventory", "The given metadata for " .. name .. " was empty or nil. got: " .. tostring(metadata))
        return false, 101 
    end

    if not Inv.Util.IsNumber(metadata.width, 1, 255) then 
        Inv.Util.LogWarning("RequestInventory", "The width metadata for inventory " .. name .. " was not a number, below 1 or higher than 255. got: " .. tostring(metadata.width))
        return false, 102 
    end

    if not Inv.Util.IsNumber(metadata.height, 1, 255) then 
        Inv.Util.LogWarning("RequestInventory", "The height metadata for inventory " .. name .. " was not a number, below 1 or higher than 255. got: " .. tostring(metadata.height))
        return false, 103 
    end

    if not Inv.Util.IsNumber(metadata.theme, 0, 255) then 
        Inv.Util.LogWarning("RequestInventory", "The theme metadata for inventory " .. name .. " was not a number, below 0 or higher than 255. got: " .. tostring(metadata.theme))
        return 104 
    end

    if not Inv.Util.IsNumber(metadata.style, 0, 255) then 
        Inv.Util.LogWarning("RequestInventory", "The style metadata for inventory " .. name .. " was not a number, below 0 or higher than 255. got: " .. tostring(metadata.style))
        return 105 
    end

    if not Inv.Util.StringOrNull(metadata.owner) then 
        Inv.Util.LogWarning("RequestInventory", "The owner metadata for inventory " .. name .. " was not nil or a string. got: " .. tostring(metadata.owner))
        return 106 
    else
        if not Inv.Util.IsNull(metadata.owner) then
            print(1)
            if not Inv.Util.StringIsOfSize(metadata.owner, 1, 64) then 
                Inv.Util.LogWarning("RequestInventory", "The owner metadata for inventory " .. name .. " cannot have more than 64 characters. got: " .. tostring(metadata.owner))
                return 107 
            end
        end
    end

    if not Inv.Util.IsBool(metadata.transient) then 
        Inv.Util.LogWarning("RequestInventory", "The transient metadata for inventory " .. name .. " is not a boolean. got: " .. tostring(metadata.transient))
        return 108 
    end

    if not Inv.Util.IsBool(overwrite) then 
        Inv.Util.LogWarning("RequestInventory", "The overwrite for inventory " .. name .. " is not a boolean. got: " .. tostring(overwrite))
        return 109 
    end

    if metadata.transient and metadata.owner ~= nil then 
        Inv.Util.LogWarning("RequestInventory", "Invalid state for inventory " .. name .. ", transient inventories cannot have a owner (because they can't possibly belong to anyone).")
        return 110 
    end

    return true, 0
end

function Inv.Util.CheckRegisterItemParams(name, data)

    if Inv.Util.StringEmptyOrNull(name) then 
        Inv.Util.LogWarning("RegisterItem", string.format("Invalid name for item %s, cannot be nil or empty. got: %s", name, name))
        return false, 100 
    end

    if not Inv.Util.StringIsOfSize(name, 1, 32) then
        Inv.Util.LogWarning("RegisterItem", string.format("Invalid name for item %s, name must be atleast 1 to 32 characters. got: %s", name, name))
        return false, 101
    end

    if not Inv.Util.StringOrNull(data.namePlural) then 
        Inv.Util.LogWarning("RegisterItem", string.format("Invalid namePlural for item %s, cannot be nil or empty. got: %s", name, data.namePlural))
        return false, 102 
    end

    if not Inv.Util.IsNull(data.namePlural) then
        if not Inv.Util.StringIsOfSize(data.namePlural, 1, 32) then
            Inv.Util.LogWarning("RegisterItem", string.format("Invalid namePlural for item %s, namePlural must be atleast 1 to 32 characters. got: %s", name, data.namePlural))
            return false, 103
        end
    else   
        if not Inv.Util.StringOrNull(data.namePlural) then 
            Inv.Util.LogWarning("RegisterItem", string.format("Invalid namePlural for item %s, cannot be nil or empty. got: %s", name, data.namePlural))
            return false, 102 
        end
    end
    
    if not Inv.Util.StringOrNull(data.description) then 
        Inv.Util.LogWarning("RegisterItem", string.format("Invalid description for item %s, must be nil or a string. got: %s", name, data.description))
        return false, 104
    end

    if Inv.Util.StringEmptyOrNull(data.image) then
        Inv.Util.LogWarning("RegisterItem", string.format("Invalid image for item %s, cannot be nil or empty.  got: %s", name, data.image))
        return false, 105
    end

    if not Inv.Util.IsNumber(data.weight, 0, 65536) then 
        Inv.Util.LogWarning("RegisterItem", string.format("Invalid weight for item %s, weight must be between 0 and 65536. got: %s", name, data.weight))
        return false, 106 
    end

    if not Inv.Util.IsNumber(data.stacksize, 0, 65536) then 
        Inv.Util.LogWarning("RegisterItem", string.format("Invalid stacksize for item %s, stacksize must be between 0 and 65536. got: %s", name, data.stacksize))
        return false, 107
    end

    return true, 0
end