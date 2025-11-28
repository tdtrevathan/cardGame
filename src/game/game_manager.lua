-- MyCardGame/src/game/game_manager.lua

local Card = require("src.core.card")
local Deck = require("src.core.deck")
local Hand = require("src.core.hand")
local Utils = require("src.game.utils")
local UI = require("src.game.UI")
local SrceenViews = require("src.game.constants.screen_views")
local MainMenuDisplayHandler = require("src.game.display.main_menu_display_handler")
local CardViewDisplayHandler = require("src.game.display.card_view_display_handler")
local card_dimensions = require("src.game.constants.card_dimensions")

--==============================================================================
-- Private Helper Functions
--==============================================================================
local function get_card_at_position(game_state, x, y)
    local hand_y = love.graphics.getHeight() - 130
    local card_spacing = 80
    local total_hand_width = (#game_state.hand * card_spacing) - (card_spacing - card_dimensions.CARD_WIDTH)
    local hand_x_start = (love.graphics.getWidth() - total_hand_width) / 2

    for i, card_data in ipairs(game_state.hand) do
        local card_x = hand_x_start + (i - 1) * card_spacing
        -- Check if the coordinates (x, y) are within the card's bounding box
        if x >= card_x and x < card_x + card_dimensions.CARD_WIDTH and
            y >= hand_y and y < hand_y + card_dimensions.CARD_HEIGHT then
            return card_data, i, card_x, hand_y
        end
    end
    return nil -- No card found
end

local function handleMousePress(game_state, type,  ...)

            local next_state = game_state
            local args = { ... }
            local x, y, button = args[1], args[2], args[3]

-- Right-Click Logic: Set the card for preview
    if button == 2 and next_state.current_view == SrceenViews.GAME_SCREEN then
        local card, _, _, _ = get_card_at_position(next_state, x, y)
        if card then
            -- Set the card to be previewed on the right-click press
            next_state.preview_card = card
            -- Crucially, since the right-click *starts* the preview, 
            -- we stop here and don't proceed to the dragging logic.
            return next_state
        end
    end

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
local function handleMouseRelease(game_state, type, ...)
    local next_state = game_state
    local args = { ... }

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
local function handleDrawCard(next_state)
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
        UI.DrawBoard(game_state)
        UI.DrawHand(game_state)

        if game_state.dragging_card then
            UI.DrawCard(game_state.dragging_card, 
                game_state.current_drag_x,
                game_state.current_drag_y)
        end

    elseif game_state.current_view == SrceenViews.CARD_SCREEN then
        CardViewDisplayHandler.DisplayCardView()    
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
        elseif key == "v" then
            next_state.current_view = SrceenViews.CARD_SCREEN
        elseif key == "m" then
            next_state.current_view = SrceenViews.MAIN_MENU
        elseif key == "d" then
            print("--- DEBUG: Current Game State ---")
            print(Utils.inspect(game_state))
            print("---------------------------------")
        elseif key == "space" then
            if next_state.current_view == SrceenViews.GAME_SCREEN then
                handleDrawCard(next_state)
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
        elseif key == "enter" then
            if next_state.current_view == SrceenViews.GAME_SCREEN then
                
            end
        end
    end
    if type == "mousepressed" then
        handleMousePress(game_state, type, ...)
    end
    if type == "mousereleased" then
        handleMouseRelease(game_state, type, ...)
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
