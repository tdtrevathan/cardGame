local card_dimensions = require("src.game.constants.card_dimensions")
local board_dimensions = require("src.game.constants.board_dimensions")
local card_position_calculator = require("src.game.card_position_calculator")

local UI = {}

-- This is the sustainable math you are looking for.
-- It calculates the scale needed to squash/stretch ANY image into ANY box.
function UI.DrawImageToBox(image, x, y, targetWidth, targetHeight)
    local imgW = image:getWidth()
    local imgH = image:getHeight()

    -- Calculate the percentage needed to fit
    local scaleX = targetWidth / imgW
    local scaleY = targetHeight / imgH

    -- Draw with the calculated scale
    love.graphics.draw(image, x, y, 0, scaleX, scaleY)
end

function UI.DrawCard(card_data, x, y, width, height)

    local image_to_draw = nil

    if card_data.is_face_up then
        image_to_draw = card_data.image
    else
        image_to_draw = card_data.back_image
    end
    if image_to_draw then
        UI.DrawImageToBox(
            image_to_draw,
            x,
            y,
            width,
            height)
    else
        -- Fallback drawing
        love.graphics.setColor(0.8, 0.8, 0.8)
        love.graphics.rectangle("fill", x, y, 70, 100)
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(card_data.rank .. "\n" .. card_data.suit, x + 5, y + 5, 60, "center")
    end

    love.graphics.setColor(1, 1, 1) -- Reset color
end

function UI.DrawBoard(game_state)
    if not game_state.board then return end
    
    local total_grid_width = (board_dimensions.NUM_COLS * board_dimensions.CELL_WIDTH) + ((board_dimensions.NUM_COLS - 1) * board_dimensions.CELL_MARGIN)
    local total_grid_height = (board_dimensions.NUM_ROWS * board_dimensions.CELL_HEIGHT) + ((board_dimensions.NUM_ROWS - 1) * board_dimensions.CELL_MARGIN)
    local grid_offset_x = (love.graphics.getWidth() - total_grid_width) / 2
    local grid_offset_y = (love.graphics.getHeight() - total_grid_height) / 2
    local card_offset_x = (board_dimensions.CELL_WIDTH - card_dimensions.CARD_WIDTH)/ 2
    local card_offset_y = (board_dimensions.CELL_HEIGHT - card_dimensions.CARD_HEIGHT) / 2
    local card_width = card_dimensions.CARD_WIDTH
    local card_height = card_dimensions.CARD_HEIGHT
    
    for r = 1, board_dimensions.NUM_ROWS do
        for c = 1, board_dimensions.NUM_COLS do
            local card_in_slot = game_state.board[r][c]
            local cell_x = grid_offset_x + (c - 1) * (board_dimensions.CELL_WIDTH + board_dimensions.CELL_MARGIN)
            local cell_y = grid_offset_y + (r - 1) * (board_dimensions.CELL_HEIGHT + board_dimensions.CELL_MARGIN)
            
            if card_in_slot then
                if card_in_slot.hover_is_active then
                    card_offset_x = card_offset_x + card_dimensions.HOVER_X_OFFSET
                    card_offset_y = card_offset_y + card_dimensions.HAND_Y_OFFSET
                    card_width = card_width * card_dimensions.HOVER_SCALAR
                    card_height = card_height * card_dimensions.HOVER_SCALAR
                end
                UI.DrawCard(
                    card_in_slot,
                    cell_x + card_offset_x,
                    cell_y + card_offset_y,
                    card_width,
                    card_height)
            else
                love.graphics.setColor(1, 1, 1, 0.2)
                love.graphics.rectangle("line", cell_x, cell_y, board_dimensions.CELL_WIDTH, board_dimensions.CELL_HEIGHT)
                love.graphics.setColor(1, 1, 1)
            end
        end
    end
end

function UI.DrawHand(game_state)
    local card_width = card_dimensions.CARD_WIDTH
    local card_height = card_dimensions.CARD_HEIGHT
    local card_offset_x = 0
    local card_offset_y = 0

    if game_state.hand == 0 then return end 

    local hand_position = card_position_calculator.CalculateHandPosition(game_state)

    for i, card_data in ipairs(game_state.hand) do
        local card_x = hand_position.X + (i - 1) * card_dimensions.CARD_SPACING
        -- Since Card.draw already exists, we can just call it with the right data and position

        if card_data.hover_is_active then
            card_offset_x = card_offset_x + card_dimensions.HOVER_X_OFFSET
            card_offset_y = card_offset_y + card_dimensions.HAND_Y_OFFSET
            card_width = card_width * card_dimensions.HOVER_SCALAR
            card_height = card_height * card_dimensions.HOVER_SCALAR
        end
        UI.DrawCard(
            card_data,
            card_x + card_offset_x,
            hand_position.Y + card_offset_y,
            card_width,
            card_height)
    end
end

return UI