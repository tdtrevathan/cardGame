-- MyCardGame/src/game/game_state.lua

local Deck = require("src.core.deck")
local Hand = require("src.core.hand")
local SrceenViews = require("src.game.screen_views")
local GameState = {}

function GameState.create()
    local initial_deck = Deck.create()
    local initial_hand = Hand.create()
    Deck.populate(initial_deck)
    Deck.shuffle(initial_deck)

    local new_state = {
        current_view = SrceenViews.MAIN_MENU,
        
        deck = initial_deck,
        hand = initial_hand,
        board = {
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

function GameState.handIsEmpty()
    return Hand == 0;
end

return GameState