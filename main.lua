-- MyCardGame/main.lua

-- No more global state variable here!

-- Require necessary modules
local GameManager = require("src.game.game_manager")
local GameState = require("src.game.game_state")
local FontManager = require("src.game.display.font_manager")

-- This variable will hold the single source of truth for our game.
local current_game_state

-- LÖVE Callbacks
-- main.lua (Top of file)
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

-- ... rest of your requires ...
function love.load()
    FontManager.load()
    love.window.setTitle("My Card Game")
    love.window.setMode(1200, 900, {resizable=false, vsync=true})

    -- Create the initial game state. This is the only time we "create" state.
    current_game_state = GameState.create()
    
    print("MyCardGame loaded.")
end

function love.update(dt)
    -- Update functions now receive the current state and return the new state.
    current_game_state = GameManager.update(current_game_state, dt)
end

function love.draw()
    -- The draw function is "read-only". It just looks at the current state to draw.
    GameManager.draw(current_game_state)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    end
    
    -- Input handlers also transform the game state.
    current_game_state = GameManager.handle_input(current_game_state, "keypressed", key, scancode)
end

function love.mousepressed(x, y, button, istouch, presses)
    current_game_state = GameManager.handle_input(current_game_state, "mousepressed", x, y, button)
end

function love.mousereleased(x, y, button, istouch, presses)
    current_game_state = GameManager.handle_input(current_game_state, "mousereleased", x, y, button)
end

print("main.lua parsed")