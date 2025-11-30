-- MyCardGame/src/core/deck.lua
local Card = require("src.core.card")
local cardImageLocations = require("src.game.constants.card_image_locations")
local characterCards = require("src.game.constants.card_data.character_card_data")
local equipmentCards = require("src.game.constants.card_data.equipment_card_data")
local terrainCards = require("src.game.constants.card_data.terrain_card_data")

local Deck = {}

local function formatFileString(name)
    return string.format(cardImageLocations.CARD_IMAGES_ROOT .. "%s.png", name)
end

local function mergeCardCollections(first_collection, second_collection)
    local merged_collection = {}

    for i = 1, #first_collection do
        table.insert(merged_collection, first_collection[i])
    end
    for i = 1, #second_collection do
        table.insert(merged_collection, second_collection[i])
    end

    return merged_collection
end

local function createCardCollection()
    local cardCollection = characterCards.data;
    cardCollection = mergeCardCollections(cardCollection, equipmentCards.data)
    cardCollection = mergeCardCollections(cardCollection, terrainCards.data)
    return cardCollection
end

local function createCards(deck_data, cardCollection)
    for i = 1, #cardCollection do
        local card = cardCollection[i]
        local image_path = formatFileString(card.NAME)
        local new_card = Card.Create(image_path, card.TYPE)
        table.insert(deck_data.cards, new_card)
    end
end

local function createDeck(deck_data)
    local cardCollection = createCardCollection()
    createCards(deck_data, cardCollection)
end

-- Creates an empty deck data table
function Deck.create()
    return { cards = {} }
end

-- Populates a deck table. This modifies the table passed in.
function Deck.populate(deck_data)
    deck_data.cards = {} -- Clear existing cards

    createDeck(deck_data)
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