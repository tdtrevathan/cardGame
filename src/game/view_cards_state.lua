
local Deck = require("src.core.deck")
local SrceenViews = require("src.game.constants.screen_views")
local ViewState = {}

function ViewState.create()
    local initial_deck = Deck.create()
  
    Deck.populate(initial_deck)


    local new_state = {
        current_view = SrceenViews.CARD_SCREEN,
        deck = initial_deck,

        board = {
            {false, false, false, false, false}

        },
        
        score = 0,
    }
    
    print("Initial ViewState created with a line of cards.")
    return new_state
end


return ViewState