-- MyCardGame/src/game/game_manager.lua

local GameManager = {}

-- The update function now takes the current state and returns the next state.
function GameManager.update(game_state, dt)
    local next_state = game_state -- Start with the current state

    if next_state.current_view == "playing" then
        -- game_logic_update(next_state, dt)
    elseif next_state.current_view == "menu" then
        -- menu_logic_update(next_state, dt)
    end
    
    -- It's crucial to return the state, even if it hasn't changed.
    return next_state
end

-- The draw function takes the current state and renders it.
function GameManager.draw(game_state)
    -- Clear the screen
    love.graphics.clear(0.2, 0.2, 0.2) -- Dark gray
    
    love.graphics.setColor(1, 1, 1) -- White
    love.graphics.print("Welcome to My Card Game!", love.graphics.getWidth()/2 - 100, love.graphics.getHeight()/2 - 10)
    love.graphics.print("Current View: " .. game_state.current_view, 10, 10)

    if game_state.current_view == "playing" then
        -- draw_game_elements(game_state)
    elseif game_state.current_view == "menu" then
        -- draw_menu_elements(game_state)
    end
end

-- The input handler also takes the current state and returns the new state.
function GameManager.handle_input(game_state, type, ...)
    local next_state = game_state
    local args = {...}

    if type == "keypressed" then
        local key = args[1]
        if key == "p" then
            next_state.current_view = "playing"
            print("View changed to: playing")
        elseif key == "m" then
            next_state.current_view = "menu"
            print("View changed to: menu")
        end
    elseif type == "mousepressed" then
        -- Handle mouse input later
    end

    return next_state
end


return GameManager