local FontManager = require("src.game.display.font_manager")

local CardViewDisplayHandler= {}

function CardViewDisplayHandler.DisplayCardView()
-- 1. Set background/general color
    love.graphics.setColor(1, 1, 1, 1) 

    -- 2. Draw the Main Title
    local title_text = "🛠️ Card View: Under Construction"
    love.graphics.setFont(FontManager.header)
    local title_width = FontManager.header:getWidth(title_text)

    love.graphics.print(
        title_text, 
        (love.graphics.getWidth() - title_width) / 2, -- FIX: Using love.graphics.getWidth()
        love.graphics.getHeight() / 2 - 100 -- FIX: Using love.graphics.getHeight()
    )

  

    
    love.graphics.setFont(FontManager.body)
    
end

return CardViewDisplayHandler