-- MyCardGame/src/core/card.lua
local card_image_locations = require("src.game.constants.card_image_locations")

local Card = {}

local function loadImage(image_path)
    local success, image_or_error = pcall(love.graphics.newImage, image_path)
    if success then
        return image_or_error
    else
        print(string.format("Error loading image %s: %s", image_path, image_or_error))
    end
end

function Card.Create(image_path, card_type)
    local card_data = {
        image_path = image_path,
        back_image_path = card_image_locations.CARD_BACK_LOCATION,
        image = nil, -- Will be loaded later
        back_image = nil, -- Will be loaded later
        is_face_up = false,
        type = card_type
    }
    return card_data
end

function Card.LoadImage(card_data)
    if card_data.image_path and not card_data.image then
        card_data.image = loadImage(card_data.image_path)
    end
    if card_data.back_image_path and not card_data.back_image then
        card_data.back_image = loadImage(card_data.back_image_path)
    end
end

function Card.Flip(card_data)
    card_data.is_face_up = not card_data.is_face_up
end

function Card.ToString(card_data)
    return string.format("%s of %s (Value: %d)", card_data.rank, card_data.suit, card_data.value)
end

return Card