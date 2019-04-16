function Inv.Util.StringEmptyOrNull(str)
    return Inv.Util.IsNull(str) or str == "" 
end

function Inv.Util.StringOrNull(str)
    return Inv.Util.IsNull(str) or type(str) == "string"
end

function Inv.Util.StringIsOfSize(str, min, max) 
    return #str >= min and #str <= max
end

function Inv.Util.IsNull(obj)
    return type(obj) == nil
end

function Inv.Util.IsBool(bool)
end

function Inv.Util.IsNumber(num, min, max)
    return type(num) == "number" and num >= max and num <= max
end