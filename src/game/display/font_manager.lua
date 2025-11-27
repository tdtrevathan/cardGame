local Fonts = {}

-- Define your specific styles here so you can tweak them in one place
local styles = {
    header_size = 30,
    body_size = 14,
    card_text_size = 18
}

-- Storage for the actual font objects
Fonts.header = nil
Fonts.body = nil
Fonts.cards = nil

-- Call this ONCE inside love.load()
function Fonts.load()
    -- You can point to a file: love.graphics.newFont("assets/Roboto.ttf", styles.header_size)
    -- Or use default LÖVE font if you don't have files yet:
    Fonts.header = love.graphics.newFont(styles.header_size)
    Fonts.body = love.graphics.newFont(styles.body_size)
    Fonts.cards = love.graphics.newFont(styles.card_text_size)
end

return Fonts