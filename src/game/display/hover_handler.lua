local Utils = require("src.game.utils")
local card_dimensions = require("src.game.constants.card_dimensions")
local card_position_calculator = require("src.game.card_position_calculator")
local board_dimensions = require("src.game.constants.board_dimensions")
local push = require('src.core.push')

local HoverHandler = {}

function HoverHandler.CheckHandHover(current_state)
    -- 1. Get Mouse Position converted to Virtual Resolution
    -- push:toGame returns nil if mouse is in the black bars, so we default to 0,0
    local mx, my = push:toGame(love.mouse.getPosition())
    if mx == nil or my == nil then return end

    local hand_position = card_position_calculator.CalculateHandPosition(current_state)

    -- 2. Loop BACKWARDS through the hand (Top card first)
    for i = #current_state.hand, 1, -1 do
        local card_x = hand_position.X + (i - 1) * card_dimensions.CARD_SPACING

        if CheckCollision(mx, my, card_x, hand_position.Y, card_dimensions.CARD_WIDTH, card_dimensions.CARD_HEIGHT) then
            current_state.hand[i].hover_is_active = true
            break     -- We found the top-most card, stop checking!
        else
            current_state.hand[i].hover_is_active = false
        end
    end
end

function HoverHandler.ResetBoardHover(next_state)
    for r = 1, board_dimensions.NUM_ROWS do
        for c = 1, board_dimensions.NUM_COLS do
            local card_in_slot = next_state.board[r][c]

            if card_in_slot then
                next_state.board[r][c].hover_is_active = false
            end
        end
    end
end

function HoverHandler.ResetHandHover(next_state)
    for i = 1, #next_state.hand do
        next_state.hand[i].hover_is_active = false
    end
end

function HoverHandler.ResetHover(next_state)
    HoverHandler.ResetHandHover(next_state)
    HoverHandler.ResetBoardHover(next_state)
end

function HoverHandler.CheckBoardHover(current_state)
    -- 1. Get Mouse Position converted to Virtual Resolution
    -- push:toGame returns nil if mouse is in the black bars, so we default to 0,0
    local mx, my = push:toGame(love.mouse.getPosition())
    if mx == nil or my == nil then return end

    HoverHandler.ResetBoardHover(current_state)

    local hover_row, hover_col = Utils.get_board_slot_at_position(current_state, mx, my)

    if hover_row and hover_col and current_state.board[hover_row][hover_col] then
        current_state.board[hover_row][hover_col].hover_is_active = true
    end
end

return HoverHandler