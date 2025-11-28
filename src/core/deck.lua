-- MyCardGame/src/core/deck.lua

local Card = require("src.core.card")

local Deck = {}

local function createHardCodedDeck(deck_data)
        local cardnames = {
        "cattle", "cowboy", "shotgun", "saloon_girl", "lowly_outlaw", "shabby_horse", "six_shooter", "snake_pit", "back_of_card"
    }

    for _, name in ipairs(cardnames) do
        local image_path = string.format("src/assets/images/cards/%s.png", name)
        local new_card = Card.create(image_path)
        table.insert(deck_data.cards, new_card)
    end
end

-- Creates an empty deck data table
function Deck.create()
    return { cards = {} }
end

-- Populates a deck table. This modifies the table passed in.
function Deck.populate(deck_data)
    deck_data.cards = {} -- Clear existing cards

    createHardCodedDeck(deck_data)
end

-- Shuffles the cards in the deck table.
function Deck.shuffle(deck_data)
    local n = #deck_data.cards
    for i = n, 2, -1 do
        local j = love.math.random(i)
        deck_data.cards[i], deck_data.cards[j] = deck_data.cards[j], deck_data.cards[i]
    end
end

-- Removes and returns the top card from the deck.
-- In pure FP, this would return a new deck table as well. For Lua, modifying is often more pragmatic.
function Deck.deal_card(deck_data)
    if #deck_data.cards > 0 then
        return table.remove(deck_data.cards) -- Removes and returns the last element
    else
        return nil
    end
end

function Deck.count(deck_data)
    return #deck_data.cards
end

return Deck