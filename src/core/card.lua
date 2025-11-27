-- MyCardGame/src/core/card.lua
local UI = require("src.game.UI")
local card_dimensions = require("src.game.constants.card_dimensions")

local Card = {}

-- This isn't a constructor anymore. It's a factory function
-- that creates a data table representing a card.
function Card.create(suit, rank, value, image_path)
    local card_data = {
        suit = suit,
        rank = rank,
        value = value,
        image_path = image_path,
        image = nil, -- Will be loaded later
        is_face_up = false
    }
    -- print(string.format("Card data created: %s of %s", rank, suit))
    return card_data
end

-- Functions now take the card data table as the first argument.
function Card.load_image(card_data)
    if card_data.image_path and not card_data.image then
        local success, image_or_error = pcall(love.graphics.newImage, card_data.image_path)
        if success then
            card_data.image = image_or_error
            -- print("Loaded image for: " .. card_data.rank .. " of " .. card_data.suit)
        else
            print(string.format("Error loading image %s: %s", card_data.image_path, image_or_error))
        end
    end
end

function Card.draw(card_data, x, y)
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

function Card.flip(card_data)
    card_data.is_face_up = not card_data.is_face_up
end

function Card.to_string(card_data)
    return string.format("%s of %s (Value: %d)", card_data.rank, card_data.suit, card_data.value)
end

return Card