local card_dimensions = require("src.game.constants.card_dimensions")

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

function UI.DrawCard(card_data, x, y)
    if card_data.is_face_up then
        if card_data.image then
            -- added hardcoded scalling temporarily
            UI.DrawImageToBox(card_data.image, x, y, card_dimensions.CARD_WIDTH, card_dimensions.CARD_HEIGHT)
        else
            -- Fallback drawing
            love.graphics.setColor(0.8, 0.8, 0.8)
            love.graphics.rectangle("fill", x, y, 70, 100)
            love.graphics.setColor(0, 0, 0)
            love.graphics.printf(card_data.rank .. "\n" .. card_data.suit, x + 5, y + 5, 60, "center")
        end
    else
        -- Draw card back
        love.graphics.setColor(0.5, 0.5, 1)
        love.graphics.rectangle("fill", x, y, 70, 100)
        love.graphics.setColor(1,1,1)
        love.graphics.printf("CARD", x, y + 40, 70, "center")
    end
    love.graphics.setColor(1, 1, 1) -- Reset color
end

function UI.DrawBoard(game_state)
    if not game_state.board then return end
    
    local cell_width = 90
    local cell_height = 120
    local cell_margin = 15
    
    local card_height = 100
    local card_width = 70

    local num_rows = 5 
    local num_cols = 5
    
    local total_grid_width = (num_cols * cell_width) + ((num_cols - 1) * cell_margin)
    local total_grid_height = (num_rows * cell_height) + ((num_rows - 1) * cell_margin)
    local grid_offset_x = (love.graphics.getWidth() - total_grid_width) / 2
    local grid_offset_y = (love.graphics.getHeight() - total_grid_height) / 2
    local card_offset_x = (cell_width - card_width)/ 2
    local card_offset_y = (cell_height - card_height) / 2
    
    for r = 1, num_rows do
        for c = 1, num_cols do
            local card_in_slot = game_state.board[r][c]
            
            local cell_x = grid_offset_x + (c - 1) * (cell_width + cell_margin)
            local cell_y = grid_offset_y + (r - 1) * (cell_height + cell_margin)
            
            if card_in_slot then
                UI.DrawCard(card_in_slot, cell_x + card_offset_x, cell_y + card_offset_y)
            else
                love.graphics.setColor(1, 1, 1, 0.2)
                love.graphics.rectangle("line", cell_x, cell_y, cell_width, cell_height)
            end
        end
    end
    love.graphics.setColor(1, 1, 1)
end

function UI.DrawHand(game_state)

    if game_state.hand == 0 then return end 

    local hand_y = love.graphics.getHeight() - 130 -- Position hand near the bottom
    local card_width = 70
    local card_spacing = 80                        -- Spacing between the start of each card

    -- Calculate the total width of the hand to center it
    local total_hand_width = (#game_state.hand * card_spacing) - (card_spacing - card_width)
    local hand_x_start = (love.graphics.getWidth() - total_hand_width) / 2

    for i, card_data in ipairs(game_state.hand) do
        local card_x = hand_x_start + (i - 1) * card_spacing
        -- Since Card.draw already exists, we can just call it with the right data and position
        UI.DrawCard(card_data, card_x, hand_y)
    end
end

return UI