-- MyCardGame/main.lua

-- No more global state variable here!

-- Require necessary modules
local GameManager = require("src.game.game_manager")
local GameState = require("src.game.game_state")
local FontManager = require("src.game.display.font_manager")

-- This variable will hold the single source of truth for our game.
local current_game_state

local push = require('src.core.push')

-- Define your "Design Resolution"
-- You code ONLY for these dimensions.
local VIRTUAL_WIDTH = 1280
local VIRTUAL_HEIGHT = 900

-- Define the actual window size (what the user sees initially)
local WINDOW_WIDTH = 1280
local WINDOW_HEIGHT = 900

-- LÖVE Callbacks
-- main.lua (Top of file)
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

-- ... rest of your requires ...
function love.load()

    -- Initialize the virtual resolution system
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true, -- Allow user to resize window
        pixelperfect = false
    })

    FontManager.load()
    love.window.setTitle("My Card Game")
    --love.window.setMode(1200, 900, {resizable=false, vsync=true})

    -- Create the initial game state. This is the only time we "create" state.
    current_game_state = GameState.create()
    
    print("MyCardGame loaded.")
end

function love.update(dt)
    -- Update functions now receive the current state and return the new state.
    current_game_state = GameManager.update(current_game_state, dt)
end

-- This handles the actual window resizing events from the OS
function love.resize(w, h)
    push:resize(w, h)
end

function love.draw()
    push:start()
    -- The draw function is "read-only". It just looks at the current state to draw.
    GameManager.draw(current_game_state)

    push:finish()
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