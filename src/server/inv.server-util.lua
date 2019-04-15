local uint8_message = "Expected a uint8, where type is a number and in range of %d to %d (all inclusive), got: %s"
local str_message = "Expected a string with which is not empty, got: %s"

function Inv.Util.assert_check(asserts) 
    local failed = false
    for i = 1, #asserts do
        --Possible ommit other assert functions invocations
        if not asserts[i]() then
            failed = true
        end
    end

    return failed
end

function Inv.Util.assert_uint8(value)
    local m = string.format(uint8_message, 0, 255, tostring(value))
    _assert(type(value) == "number", m)
    _assert(value >= 0, m)
    _assert(value < 256, m)
end

-- NOTE: nzi -> Non-zero indexed, starting at 1 to 255
function Inv.Util.assert_uint8_non_zero_index(value)
    local m = string.format(uint8_message, 1, 255, tostring(value))
    _assert(type(value) == "number", m)
    _assert(value >= 1, m)
    _assert(value < 256, m)
end

function Inv.Util.assert_string_or_nil(value)
    local m = string.format(str_message, tostring(value))
    _assert(type(value) == "string" or type(value) == "nil", m)
end

function Inv.Util.assert_string_not_empty(value)
    local m = string.format(str_message, tostring(value))
    _assert(type(value) == "string", m)
    _assert(value ~= "", m)
end

function _assert(cond, message) 
    --print(debug.traceback())
    if not cond then 
        print("^3[ASSERT FAIL]" .. message .. "^7") 
        return false
    end

    return true
end