local card_dimensions = require("src.game.constants.card_dimensions")
local hand_dimensions = require("src.game.constants.hand_dimensions")

local CardPositionCalculator = {}

function CardPositionCalculator.CalculateHandPosition(game_state)
    local hand_y = love.graphics.getHeight() + hand_dimensions.HAND_Y_OFFSET              

    -- Calculate the total width of the hand to center it
    local total_hand_width = (#game_state.hand * card_dimensions.CARD_SPACING) - (card_dimensions.CARD_SPACING - card_dimensions.CARD_WIDTH)
    local hand_x_start = (love.graphics.getWidth() - total_hand_width) / 2

    local handCoordinates = {
        X = hand_x_start,
        Y = hand_y
    } 

    return handCoordinates
end

return CardPositionCalculator