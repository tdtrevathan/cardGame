-- MyCardGame/src/game/game_manager.lua

local Card = require("src.core.card")
local Deck = require("src.core.deck")
local Hand = require("src.core.hand")
local Utils = require("src.game.utils")
local SrceenViews = require("src.game.constants.screen_views")
local MainMenuDisplayHandler = require("src.game.display.main_menu_display_handler")

--==============================================================================
-- Private Helper Functions
--==============================================================================
local function draw_board(game_state)
    if not game_state.board then return end
    
    local cell_width = 90
    local cell_height = 120
    local cell_margin = 15
    
    local card_height = 100
    local card_width = 70

    local num_rows = 5 
    local num_cols = 5
    
    local total_grid_width = (num_cols * cell_width) + ((num_cols - 1) * cell_margin)
    local total_grid_height = (num_rows * cell_height) + ((num_rows - 1) * cell_margin)
    local grid_offset_x = (love.graphics.getWidth() - total_grid_width) / 2
    local grid_offset_y = (love.graphics.getHeight() - total_grid_height) / 2
    local card_offset_x = (cell_width - card_width)/ 2
    local card_offset_y = (cell_height - card_height) / 2
    
    for r = 1, num_rows do
        for c = 1, num_cols do
            local card_in_slot = game_state.board[r][c]
            
            local cell_x = grid_offset_x + (c - 1) * (cell_width + cell_margin)
            local cell_y = grid_offset_y + (r - 1) * (cell_height + cell_margin)
            
            if card_in_slot then
                Card.draw(card_in_slot, cell_x + card_offset_x, cell_y + card_offset_y)
            else
                love.graphics.setColor(1, 1, 1, 0.2)
                love.graphics.rectangle("line", cell_x, cell_y, cell_width, cell_height)
            end
        end
    end
    love.graphics.setColor(1, 1, 1)
end

local function draw_hand(game_state)

    if game_state.hand == 0 then return end 

    local hand_y = love.graphics.getHeight() - 130 -- Position hand near the bottom
    local card_width = 70
    local card_spacing = 80                        -- Spacing between the start of each card

    -- Calculate the total width of the hand to center it
    local total_hand_width = (#game_state.hand * card_spacing) - (card_spacing - card_width)
    local hand_x_start = (love.graphics.getWidth() - total_hand_width) / 2

    for i, card_data in ipairs(game_state.hand) do
        local card_x = hand_x_start + (i - 1) * card_spacing
        -- Since Card.draw already exists, we can just call it with the right data and position
        Card.draw(card_data, card_x, hand_y)
    end
end

local function get_card_at_position(game_state, x, y)
    local hand_y = love.graphics.getHeight() - 130
    local card_width = 70
    local card_height = 100 -- Assuming a standard card height
    local card_spacing = 80
    local total_hand_width = (#game_state.hand * card_spacing) - (card_spacing - card_width)
    local hand_x_start = (love.graphics.getWidth() - total_hand_width) / 2

    for i, card_data in ipairs(game_state.hand) do
        local card_x = hand_x_start + (i - 1) * card_spacing
        -- Check if the coordinates (x, y) are within the card's bounding box
        if x >= card_x and x < card_x + card_width and
            y >= hand_y and y < hand_y + card_height then
            return card_data, i, card_x, hand_y
        end
    end
    return nil -- No card found
end
--==============================================================================
-- Public GameManager Module
--==============================================================================
local GameManager = {}

function GameManager.update(game_state, dt)
    if game_state.dragging_card then
        local mouse_x, mouse_y = love.mouse.getPosition()
        -- Store current drag position for drawing
        game_state.current_drag_x = mouse_x - game_state.drag_offset_x
        game_state.current_drag_y = mouse_y - game_state.drag_offset_y
    end
    return game_state
end

function GameManager.draw(game_state)
    love.graphics.clear(0.2, 0.2, 0.2)

    if game_state.current_view == SrceenViews.GAME_SCREEN then
        draw_board(game_state)
        draw_hand(game_state)

        if game_state.dragging_card then
            Card.draw(game_state.dragging_card, 
                game_state.current_drag_x,
                game_state.current_drag_y)
        end

    elseif game_state.current_view == SrceenViews.MAIN_MENU then
        MainMenuDisplayHandler.DisplayMainMenu()
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Current View: " .. game_state.current_view, 10, 10)
end

function GameManager.handle_input(game_state, type, ...)
    local next_state = game_state
    local args = { ... }

    if type == "keypressed" then
        local key = args[1]
        if key == "p" then
            next_state.current_view = SrceenViews.GAME_SCREEN
        elseif key == "m" then
            next_state.current_view = SrceenViews.MAIN_MENU
        elseif key == "d" then
            print("--- DEBUG: Current Game State ---")
            print(Utils.inspect(game_state))
            print("---------------------------------")
        elseif key == "space" then
            if next_state.current_view == SrceenViews.GAME_SCREEN then
                if Hand.canDrawCard(next_state.hand) then
                    local dealt_card = Deck.deal_card(next_state.deck)
                    if dealt_card then
                        -- Load the image when the card is dealt
                        Card.load_image(dealt_card)
                        -- Make sure the card is face up to be visible in the hand
                        dealt_card.is_face_up = true
                        table.insert(next_state.hand, dealt_card)
                        print("Dealt card to hand: " ..
                            Card.to_string(dealt_card) .. ". Deck has " .. Deck.count(next_state.deck) .. " cards left.")
                    else
                        print("Cannot deal, deck is empty!")
                    end
                else
                    print("Hand size: " .. Hand.count(next_state.hand))
                    print("Hand is full")
                end
            end
        end
    end
    if type == "mousepressed" then
        local x, y, button = args[1], args[2], args[3]
        if button == 1 and next_state.current_view ==  SrceenViews.GAME_SCREEN then
            local card, index, card_x, card_y = get_card_at_position(next_state, x, y)
            if card then
                -- Start dragging
                next_state.dragging_card = card
                next_state.drag_offset_x = x - card_x
                next_state.drag_offset_y = y - card_y
                next_state.original_hand_index = index
                -- Temporarily remove the card from the hand so it doesn't draw in its original spot
                table.remove(next_state.hand, index)
            end
        end
    end
    if type == "mousereleased" then
        local x, y, button = args[1], args[2], args[3]

        if button == 1 and next_state.dragging_card then
            local card = next_state.dragging_card
            local card_dropped = false

            -- Check for Board Drop Zone (You'll need a helper for this!)
            local dropped_row, dropped_col = Utils.get_board_slot_at_position(next_state, x, y)

            if dropped_row and dropped_col and not next_state.board[dropped_row][dropped_col] then
                -- Drop successful: Place on board
                next_state.board[dropped_row][dropped_col] = card
                card_dropped = true
                print("Card placed on board at: " .. dropped_row .. ", " .. dropped_col)
            end

            -- Clean up drag state
            next_state.dragging_card = nil
            next_state.drag_offset_x = nil
            next_state.drag_offset_y = nil

            if not card_dropped then
                -- Drop failed (not on board or slot full): Return card to hand
                table.insert(next_state.hand, next_state.original_hand_index, card)
                print("Card returned to hand.")
            end
            next_state.original_hand_index = nil
        end
    end
    return next_state
end

return GameManager
