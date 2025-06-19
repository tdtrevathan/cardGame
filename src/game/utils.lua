local Utils = {}

--[[
    A function to "pretty-print" any Lua variable, especially tables.
    It handles nested tables and formats the output with indentation.
    
    @param value: The variable to inspect.
    @param indent_level (optional): The starting indentation level for formatting.
]]
function Utils.inspect(value, indent_level)
    indent_level = indent_level or 0
    local indent = string.rep("  ", indent_level)

    if type(value) == "table" then
        local s = indent .. "{\n"
        for k, v in pairs(value) do
            s = s .. indent .. "  " .. "[" .. tostring(k) .. "]" .. " = "
            s = s .. Utils.inspect(v, indent_level + 1) .. ",\n"
        end
        return s .. indent .. "}"
    elseif type(value) == "string" then
        return '"' .. tostring(value) .. '"'
    else
        return tostring(value)
    end
end

return Utils