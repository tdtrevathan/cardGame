-- MyCardGame/src/core/card.lua

local Card = {}

-- This isn't a constructor anymore. It's a factory function
-- that creates a data table representing a card.
function Card.create(image_path)
    local card_data = {
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

function Card.flip(card_data)
    card_data.is_face_up = not card_data.is_face_up
end

function Card.to_string(card_data)
    return string.format("%s of %s (Value: %d)", card_data.rank, card_data.suit, card_data.value)
end

return Card