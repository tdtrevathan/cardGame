-- MyCardGame/src/cards/card.lua

local Card = {}
Card.__index = Card -- For metatable-based OOP

--[[
    Constructor for a new Card object.
    @param suit (string) The suit of the card (e.g., "Hearts", "Spades").
    @param rank (string) The rank of the card (e.g., "A", "K", "10").
    @param value (number) The numerical value of the card for game logic (e.g., Ace=11, K=10).
    @param image_path (string, optional) Path to the card's image.
    @return (table) The new card object.
--]]
function Card:new(suit, rank, value, image_path)
    local instance = setmetatable({}, Card)
    instance.suit = suit
    instance.rank = rank
    instance.value = value
    instance.image_path = image_path -- e.g., "assets/images/cards/heart_ace.png"
    instance.image = nil -- To store the loaded LÖVE image object later
    instance.is_face_up = false -- Cards often start face down

    print(string.format("Card created: %s of %s, Value: %d", rank, suit, value))
    return instance
end

--[[
    Loads the card's image.
    This should be called after LÖVE's graphics module is ready.
    Typically called when the card is added to a deck or needs to be displayed.
--]]
function Card:loadImage()
    if self.image_path and not self.image then
        -- Error handling for image loading can be added here
        local success, image_or_error = pcall(love.graphics.newImage, self.image_path)
        if success then
            self.image = image_or_error
            print("Loaded image for: " .. self.rank .. " of " .. self.suit)
        else
            print(string.format("Error loading image %s: %s", self.image_path, image_or_error))
            -- Optionally, set a placeholder image or handle the error
        end
    elseif not self.image_path then
        print("No image path specified for: " .. self.rank .. " of " .. self.suit)
    end
end

--[[
    Draws the card at the specified coordinates (x, y).
    (Placeholder - actual image loading and drawing will require images to exist
     and this method to be called at the right time with a loaded image.)
--]]
function Card:draw(x, y)
    if self.is_face_up then
        if self.image then
            love.graphics.draw(self.image, x, y)
        else
            -- Fallback drawing if image is not loaded
            love.graphics.setColor(0.8, 0.8, 0.8) -- Light gray for card back/placeholder
            love.graphics.rectangle("fill", x, y, 70, 100) -- Placeholder card size
            love.graphics.setColor(0, 0, 0) -- Black for text
            love.graphics.printf(self.rank .. "" .. self.suit, x + 5, y + 5, 60, "center")
            -- print(string.format("Drawing placeholder for %s of %s at (%d, %d)", self.rank, self.suit, x, y))
        end
    else
        -- Draw card back
        love.graphics.setColor(0.5, 0.5, 1) -- Blue for card back
        love.graphics.rectangle("fill", x, y, 70, 100) -- Placeholder card back
        love.graphics.setColor(1,1,1)
        love.graphics.printf("CARD", x, y + 40, 70, "center")

    end
    -- Reset color to white for other drawing operations
    love.graphics.setColor(1, 1, 1)
end

--[[
    Flips the card (toggles is_face_up).
--]]
function Card:flip()
    self.is_face_up = not self.is_face_up
    print(string.format("%s of %s is now %s", self.rank, self.suit, self.is_face_up and "Face Up" or "Face Down"))
end

--[[
    Returns a string representation of the card.
    @return (string) Description of the card.
--]]
function Card:toString()
    return string.format("%s of %s (Value: %d)", self.rank, self.suit, self.value)
end

return Card
