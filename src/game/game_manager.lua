-- MyCardGame/src/game/game_manager.lua

local Card = require("src.cards.card")

--==============================================================================
-- Private Helper Functions
--==============================================================================
local function draw_board(game_state)
    if not game_state.board or #game_state.board == 0 then
        return -- Exit if there's no board to draw
    end

    local cell_width = 90
    local cell_height = 120
    local cell_margin = 15

    local num_rows = #game_state.board
    local num_cols = #game_state.board[1]
    local total_grid_width = (num_cols * cell_width) + ((num_cols - 1) * cell_margin)
    local total_grid_height = (num_rows * cell_height) + ((num_rows - 1) * cell_margin)
    local grid_offset_x = (love.graphics.getWidth() - total_grid_width) / 2
    local grid_offset_y = (love.graphics.getHeight() - total_grid_height) / 2

    for r, row in ipairs(game_state.board) do
        for c, card_in_slot in ipairs(row) do
            local cell_x = grid_offset_x + (c - 1) * (cell_width + cell_margin)
            local cell_y = grid_offset_y + (r - 1) * (cell_height + cell_margin)
           -- if card_in_slot then
            --    Card.draw(card_in_slot, cell_x, cell_y)
            --else
                love.graphics.setColor(1, 1, 1, 0.2)
                -- THE ONLY CHANGE IS HERE: Removed the last two arguments for rounded corners.
                love.graphics.rectangle("line", cell_x, cell_y, cell_width, cell_height, 5, 5)
            --end
        end
    end
    love.graphics.setColor(1, 1, 1)
end

--==============================================================================
-- Public GameManager Module
--==============================================================================
local GameManager = {}

function GameManager.update(game_state, dt)
    return game_state
end

function GameManager.draw(game_state)
    love.graphics.clear(0.2, 0.2, 0.2)
    
    if game_state.current_view == "playing" then
        draw_board(game_state)
    elseif game_state.current_view == "menu" then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Welcome to My Card Game!", love.graphics.getWidth()/2 - 100, love.graphics.getHeight()/2 - 10)
    end
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Current View: " .. game_state.current_view .. " (Press 'p' for playing, 'm' for menu)", 10, 10)
end

function GameManager.handle_input(game_state, type, ...)
    local next_state = game_state
    local args = {...}

    if type == "keypressed" then
        local key = args[1]
        if key == "p" then
            next_state.current_view = "playing"
        elseif key == "m" then
            next_state.current_view = "menu"
        end
    end

    return next_state
end

return GameManager