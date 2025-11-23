-- MyCardGame/src/game/game_state.lua

-- NOTE: We moved the Deck require to the top level of the module
-- to ensure it's loaded correctly.
local Deck = require("src.core.deck")
local Hand = require("src.core.hand")
local GameState = {}

-- This function creates the initial state for the entire game.
function GameState.create()
    local initial_deck = Deck.create()
    local initial_hand = Hand.create()
    Deck.populate(initial_deck)
    Deck.shuffle(initial_deck)

    local new_state = {
        current_view = "menu", -- Replaces the global `current_state`
        
        -- Game-specific data
        deck = initial_deck,
        hand = initial_hand,
        board = {
            --{{}, {}, {}, {}, {}},
            --{{}, {}, {}, {}, {}},
            --{{}, {}, {}, {}, {}},
            --{{}, {}, {}, {}, {}},
            --{{}, {}, {}, {}, {}}
{false, false, false, false, false},
    {false, false, false, false, false},
    {false, false, false, false, false},
    {false, false, false, false, false},
    {false, false, false, false, false}
        },
        
        score = 0,
    }
    
    print("Initial GameState created with a 3x3 board.")
    return new_state
end

return GameState