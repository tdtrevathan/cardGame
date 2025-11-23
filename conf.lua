-- MyCardGame/conf.lua

function love.conf(t)
    t.window.title = "My Card Game"
    t.window.width = 1200
    t.window.height = 900
    t.window.resizable = false -- Window is not resizable

    -- For LÖVE 0.11.x and above, enable vsync like this:
    t.window.vsync = 1

    -- For LÖVE 0.10.x and below, vsync is often enabled by default or set like this:
    -- t.screen.vsync = true

    t.modules.joystick = true
    t.modules.audio = true
    t.modules.keyboard = true
    t.modules.event = true
    t.modules.image = true
    t.modules.graphics = true
    t.modules.timer = true
    t.modules.mouse = true
    t.modules.sound = true
    t.modules.physics = false -- Not typically needed for a card game
    t.modules.touch = true
    t.modules.video = false -- Not typically needed
    t.modules.thread = true
    t.modules.font = true -- Enable font module
    t.console = true
    print("conf.lua loaded and applied.")
end
