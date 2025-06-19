-- MyCardGame/src/core/deck.lual

local Hand = {}
local maxHandSize = 5

-- Creates an empty hand data table
function Hand.create()
    return { cards = {} }
end

function Hand.canDrawCard(hand_data)
    return #hand_data < maxHandSize
end

function Hand.count(hand_data)
    return #hand_data
end

return Hand