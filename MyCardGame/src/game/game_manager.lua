-- MyCardGame/src/game/game_manager.lua

local GameManager = {}

--[[
    Initializes the GameManager.
    This function is called once when the game loads.
    It's a good place to set up initial game states, load resources specific to game management,
    or initialize any systems the game manager will oversee.
--]]
function GameManager:init()
    print("GameManager initialized.")
    -- Example: Set up initial game variables or load specific game manager assets
    self.score = 0
    self.current_level = 1
    -- Further initialization for game states could go here
    -- For example, initializing a state machine if you use one:
    -- self.state_machine = StateMachine:new({
    --     ['menu'] = MenuState:new(),
    --     ['playing'] = PlayingState:new(self),
    --     ['game_over'] = GameOverState:new(self)
    -- })
    -- self.state_machine:change('menu')
end

--[[
    Updates the GameManager state.
    This function is called every frame.
    'dt' is the time delta since the last frame, useful for time-based calculations and animations.
--]]
function GameManager:update(dt)
    -- This is where you would update the current game state.
    -- For example, if you have a state machine:
    -- if self.state_machine then
    --     self.state_machine:update(dt)
    -- end

    -- For now, just a placeholder print statement that could be removed or commented out later.
    -- print("GameManager update, dt: " .. dt) -- This will print every frame, can be noisy.
end

--[[
    Draws game elements managed by GameManager.
    This function is called every frame after love.update.
    It's used for rendering visuals that are part of the overall game management,
    or for delegating drawing to the current game state.
--]]
function GameManager:draw()
    -- This is where you would draw elements based on the current game state.
    -- For example, if you have a state machine:
    -- if self.state_machine then
    --     self.state_machine:draw()
    -- end

    -- Placeholder text to show GameManager's draw is active.
    -- love.graphics.setColor(0, 1, 0) -- Green
    -- love.graphics.print("GameManager Draw", 10, 30)
end

--[[
    Handles input events (keyboard and mouse).
    'type' can be "keypressed", "keyreleased", "mousepressed", "mousereleased", "mousemoved", etc.
    'key_or_x' is the key for keyboard events, or mouse x-coordinate for mouse events.
    'y_or_button' is the scancode for keypressed (or nil), or mouse y-coordinate for mouse events (or button index).
--]]
function GameManager:handle_input(type, key_or_x, y_or_button_or_scancode, ...)
    -- print("GameManager received input: ", type, key_or_x, y_or_button_or_scancode)

    -- Delegate input handling to the current game state if using a state machine
    -- if self.state_machine then
    --     self.state_machine:handle_input(type, key_or_x, y_or_button_or_scancode, ...)
    -- end

    if type == "keypressed" then
        local key = key_or_x
        -- local scancode = y_or_button_or_scancode
        -- if key == "r" then
            -- print("R key pressed - GameManager could react here, e.g., restart game")
        -- end
    elseif type == "mousepressed" then
        local x, y, button = key_or_x, y_or_button_or_scancode, select(3, ...)
        -- print(string.format("Mouse pressed at (%d, %d) with button %d - GameManager", x, y, button))
    end
end

return GameManager
