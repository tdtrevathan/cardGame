-- MyCardGame/src/cards/deck.lua

local Card = require("src.cards.card") -- Assuming card.lua is in the same directory or accessible path

local Deck = {}
Deck.__index = Deck

--[[
    Constructor for a new Deck object.
    Initializes an empty array to hold card objects.
    @return (table) The new deck object.
--]]
function Deck:new()
    local instance = setmetatable({}, Deck)
    instance.cards = {} -- Initialize an empty list of cards
    print("New empty deck created.")
    return instance
end

--[[
    Adds a single Card object to the deck.
    @param card (table) The Card object to add.
--]]
function Deck:addCard(card)
    table.insert(self.cards, card)
    -- print("Added card to deck: " .. card:toString())
end

--[[
    Populates the deck with a standard 52-card set.
    Assumes Card:new(suit, rank, value) structure.
    (Does not handle Jokers or special cards unless Card module is adapted).
--]]
function Deck:populateStandard52()
    self.cards = {} -- Clear existing cards
    local suits = {"Hearts", "Diamonds", "Clubs", "Spades"}
    local ranks = {
        {rank="2", value=2}, {rank="3", value=3}, {rank="4", value=4}, {rank="5", value=5},
        {rank="6", value=6}, {rank="7", value=7}, {rank="8", value=8}, {rank="9", value=9},
        {rank="10", value=10}, {rank="J", value=10}, {rank="Q", value=10}, {rank="K", value=10},
        {rank="A", value=11} -- Ace value might be game-dependent (e.g., 1 or 11)
    }

    for _, suit in ipairs(suits) do
        for _, rank_info in ipairs(ranks) do
            -- Assuming no specific image paths for now, can be added later or in Card:new
            local image_path = string.format("assets/images/cards/%s_%s.png", string.lower(suit), string.lower(rank_info.rank))
            local new_card = Card:new(suit, rank_info.rank, rank_info.value, image_path)
            self:addCard(new_card)
        end
    end
    print("Deck populated with 52 standard cards.")
end

--[[
    Shuffles the deck using the Fisher-Yates algorithm.
--]]
function Deck:shuffle()
    local n = #self.cards
    for i = n, 2, -1 do
        local j = love.math.random(i) -- LÖVE's random number generator (1 to i inclusive)
        self.cards[i], self.cards[j] = self.cards[j], self.cards[i]
    end
    print("Deck shuffled.")
end

--[[
    Deals (removes and returns) the top card from the deck.
    Returns nil if the deck is empty.
    @return (table|nil) The Card object from the top of the deck, or nil if empty.
--]]
function Deck:dealCard()
    if #self.cards > 0 then
        local card = table.remove(self.cards) -- Removes and returns the last element
        -- print("Dealt card: " .. card:toString())
        return card
    else
        print("Deck is empty. Cannot deal card.")
        return nil
    end
end

--[[
    Returns the number of cards currently in the deck.
    @return (number) The count of cards.
--]]
function Deck:count()
    return #self.cards
end

--[[
    Loads images for all cards in the deck.
    Useful after populating or adding cards that have image_path set.
--]]
function Deck:loadCardImages()
    print("Loading images for all cards in deck...")
    for _, card in ipairs(self.cards) do
        if card.loadImage then -- Check if the card object has the loadImage method
            card:loadImage()
        end
    end
    print("Finished attempting to load card images.")
end


return Deck
