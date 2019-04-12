function Inv.Util.ToUnlabledTable(data) 
    local newData = {}

    for i = 1, #data do
        table.insert(newData, {data[i].item, data[i].count});
    end

    return json.encode(newData)
end