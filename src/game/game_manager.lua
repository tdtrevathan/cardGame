-- MyCardGame/src/game/game_manager.lua

local Card = require("src.core.card")
local Deck = require("src.core.deck") -- We need this to deal cards
local Utils = require("src.game.utils")

--==============================================================================
-- Private Helper Functions
--==============================================================================
local function draw_board(game_state)
    -- ... (this function remains unchanged from before)
    if not game_state.board or #game_state.board == 0 then return end
    local cell_width = 90
    local cell_height = 120
    local cell_margin = 15
    local num_rows = #game_state.board
    local num_cols = #game_state.board[1]
    local total_grid_width = (num_cols * cell_width) + ((num_cols - 1) * cell_margin)
    local total_grid_height = (num_rows * cell_height) + ((num_rows - 1) * cell_margin)
    local grid_offset_x = (love.graphics.getWidth() - total_grid_width) / 2
    local grid_offset_y = (love.graphics.getHeight() - total_grid_height) / 2
    for r, row in ipairs(game_state.board) do
        for c, card_in_slot in ipairs(row) do
            local cell_x = grid_offset_x + (c - 1) * (cell_width + cell_margin)
            local cell_y = grid_offset_y + (r - 1) * (cell_height + cell_margin)
            if card_in_slot then
                Card.draw(card_in_slot, cell_x, cell_y)
            else
                love.graphics.setColor(1, 1, 1, 0.2)
                love.graphics.rectangle("line", cell_x, cell_y, cell_width, cell_height)
            end
        end
    end
    love.graphics.setColor(1, 1, 1)
end

-- NEW FUNCTION: Draws the cards in the player's hand
local function draw_hand(game_state)
    if #game_state.hand == 0 then return end -- Don't draw if hand is empty

    local hand_y = love.graphics.getHeight() - 130 -- Position hand near the bottom
    local card_width = 70
    local card_spacing = 80 -- Spacing between the start of each card

    -- Calculate the total width of the hand to center it
    local total_hand_width = (#game_state.hand * card_spacing) - (card_spacing - card_width)
    local hand_x_start = (love.graphics.getWidth() - total_hand_width) / 2

    for i, card_data in ipairs(game_state.hand) do
        local card_x = hand_x_start + (i - 1) * card_spacing
        -- Since Card.draw already exists, we can just call it with the right data and position
        Card.draw(card_data, card_x, hand_y)
    end
end


--==============================================================================
-- Public GameManager Module
--==============================================================================
local GameManager = {}

function GameManager.update(game_state, dt)
    return game_state
end

function GameManager.draw(game_state)
    love.graphics.clear(0.2, 0.2, 0.2)
    
    if game_state.current_view == "playing" then
        draw_board(game_state)
        draw_hand(game_state) -- <<< CALL THE NEW DRAW HAND FUNCTION
    elseif game_state.current_view == "menu" then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Welcome to My Card Game!", love.graphics.getWidth()/2 - 100, love.graphics.getHeight()/2 - 10)
    end
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Current View: " .. game_state.current_view .. " (Press SPACE to deal)", 10, 10)
end

function GameManager.handle_input(game_state, type, ...)
    local next_state = game_state
    local args = {...}

    if type == "keypressed" then
        local key = args[1]
        if key == "p" then
            next_state.current_view = "playing"
        elseif key == "m" then
            next_state.current_view = "menu"
        elseif key == "d" then
            print("--- DEBUG: Current Game State ---")
            print(Utils.inspect(game_state))
            print("---------------------------------")
        -- VVV ADD THIS KEYPRESS TO DEAL A CARD VVV
        elseif key == "space" then
            if next_state.current_view == "playing" then
                local dealt_card = Deck.deal_card(next_state.deck)
                if dealt_card then
                    -- Load the image when the card is dealt
                    Card.load_image(dealt_card)
                    -- Make sure the card is face up to be visible in the hand
                    dealt_card.is_face_up = true
                    table.insert(next_state.hand, dealt_card)
                    print("Dealt card to hand: " .. Card.to_string(dealt_card) .. ". Deck has " .. Deck.count(next_state.deck) .. " cards left.")
                else
                    print("Cannot deal, deck is empty!")
                end
            end
        end
    end

    return next_state
end

return GameManager