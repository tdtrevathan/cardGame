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

-- Add this to src/game/utils.lua

function Utils.get_board_slot_at_position(game_state, x, y)
    local cell_width = 90
    local cell_height = 120
    local cell_margin = 15
    local num_rows = #game_state.board
    local num_cols = #game_state.board[1]
    
    -- Must match the math in draw_board exactly
    local total_grid_width = (num_cols * cell_width) + ((num_cols - 1) * cell_margin)
    local total_grid_height = (num_rows * cell_height) + ((num_rows - 1) * cell_margin)
    local grid_offset_x = (love.graphics.getWidth() - total_grid_width) / 2
    local grid_offset_y = (love.graphics.getHeight() - total_grid_height) / 2

    for r = 1, num_rows do
        for c = 1, num_cols do
            local cell_x = grid_offset_x + (c - 1) * (cell_width + cell_margin)
            local cell_y = grid_offset_y + (r - 1) * (cell_height + cell_margin)

            if x >= cell_x and x <= cell_x + cell_width and
               y >= cell_y and y <= cell_y + cell_height then
                return r, c
            end
        end
    end
    return nil, nil
end

function CheckCollision(mouseX, mouseY, rectX, rectY, rectW, rectH)
    return mouseX >= rectX and mouseX <= rectX + rectW and
           mouseY >= rectY and mouseY <= rectY + rectH
end

return Utils