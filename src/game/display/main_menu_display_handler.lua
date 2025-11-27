local HomeScreenText = require("src.game.constants.home_screen_text")
local FontManager = require("src.game.display.font_manager")

local MainMenuDisplayHandler= {}

function MainMenuDisplayHandler.DisplayMainMenu()
    love.graphics.setColor(1, 1, 1)

    love.graphics.setFont(FontManager.header)
    love.graphics.print(HomeScreenText.title, 
        love.graphics.getWidth() / 2 - 200,
        love.graphics.getHeight() / 2 - 100)

    love.graphics.setFont(FontManager.body)
    love.graphics.print(HomeScreenText.navigationOptions, 
        love.graphics.getWidth() / 2 - 100,
        love.graphics.getHeight() / 2 - 10)
end

return MainMenuDisplayHandler