local UI = {}

-- This is the sustainable math you are looking for.
-- It calculates the scale needed to squash/stretch ANY image into ANY box.
function UI.DrawImageToBox(image, x, y, targetWidth, targetHeight)
    local imgW = image:getWidth()
    local imgH = image:getHeight()

    -- Calculate the percentage needed to fit
    local scaleX = targetWidth / imgW
    local scaleY = targetHeight / imgH

    -- Draw with the calculated scale
    love.graphics.draw(image, x, y, 0, scaleX, scaleY)
end

return UI