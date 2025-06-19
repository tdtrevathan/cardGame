-- MyCardGame/src/game_state.lua

local Deck = require("src.cards.deck") -- We will refactor Deck next

local GameState = {}

-- This function creates the initial state for the entire game.
function GameState.create()
    local initial_deck = Deck.create()
    -- For now, we won't populate it, just show the structure
    -- Deck.populate(initial_deck, "standard_52") -- We'll make this more generic later
    -- Deck.shuffle(initial_deck)

    local new_state = {
        current_view = "menu", -- Replaces the global `current_state`
        
        -- Game-specific data
        deck = initial_deck,
        hand = {},
        board = {
            -- Example of a 3x3 board, initialized to nil (empty)
            {nil, nil, nil},
            {nil, nil, nil},
            {nil, nil, nil},
        },
        
        score = 0,
        -- etc.
    }
    
    print("Initial GameState created.")
    return new_state
end

return GameState