local number_message = "Expected a uint8, where type is a number and in range of %d to %d (all inclusive), got: %s"
local str_message = "Expected a string with which is not empty, got: %s"

function Inv.Util.assert_check(asserts) 
    local failedIndexes = {}
    local failed = false
    for i = 1, #asserts do
        --Possible ommit other assert functions invocations
        if not asserts[i] then
            failed = true
            table.insert(failedIndexes, i)
        end
    end

    if failed then
        print("^3[ASSERT CHECK]: Failed assert index: " .. json.encode(failedIndexes) .. "^7") 
    end

    return failed, failedIndexes
end

function Inv.Util.assert_number(value, min, max)
    local m = string.format(number_message, min, max, tostring(value))

    return (
        _assert(type(value) == "number", m) and
        _assert(value >= min, m) and
        _assert(value <= max, m)
    )
end

function Inv.Util.assert_string_or_nil(value)
    local m = string.format(str_message, tostring(value))

    return (
        _assert(type(value) == "string" or type(value) == "nil", m)
    )
end

function Inv.Util.assert_string_not_empty(value)
    local m = string.format(str_message, tostring(value))

    return ( 
        _assert(type(value) == "string", m) and
        _assert(value ~= "", m)
    )
end

function _assert(cond, message) 
    --print(debug.traceback())
    if not cond then 
        print("^3[ASSERT FAIL]: " .. message .. "^7") 
        return false
    end

    return true
end