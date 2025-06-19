-- MyCardGame/src/core/deck.lua

local Card = require("src.cards.card")

local Deck = {}

-- Creates an empty deck data table
function Deck.create()
    return { cards = {} }
end

-- Populates a deck table. This modifies the table passed in.
function Deck.populate(deck_data)
    deck_data.cards = {} -- Clear existing cards
    local suits = {"Hearts", "Diamonds", "Clubs", "Spades"}
    local ranks = {
        {rank="2", value=2}, {rank="3", value=3}, {rank="4", value=4}, {rank="5", value=5},
        {rank="6", value=6}, {rank="7", value=7}, {rank="8", value=8}, {rank="9", value=9},
        {rank="10", value=10}, {rank="J", value=10}, {rank="Q", value=10}, {rank="K", value=10},
        {rank="A", value=11}
    }

    for _, suit in ipairs(suits) do
        for _, rank_info in ipairs(ranks) do
            local image_path = string.format("assets/images/cards/%s_%s.png", string.lower(suit), string.lower(rank_info.rank))
            local new_card = Card.create(suit, rank_info.rank, rank_info.value, image_path)
            table.insert(deck_data.cards, new_card)
        end
    end
    print("Deck populated with 52 standard cards.")
end

-- Shuffles the cards in the deck table.
function Deck.shuffle(deck_data)
    local n = #deck_data.cards
    for i = n, 2, -1 do
        local j = love.math.random(i)
        deck_data.cards[i], deck_data.cards[j] = deck_data.cards[j], deck_data.cards[i]
    end
    print("Deck shuffled.")
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