function love.load()
   image = love.graphics.newImage("graphics/maps/first_map.png")
   imgX = 0
   imgY = 0
   love.graphics.setBackgroundColor(255,255,255)
   width = 45 * 50 * 0.25
   height = 45 * 50 * 0.25
   success = love.window.setMode(width, height)
end

function love.draw()
    love.graphics.draw(image, imgX, imgY, 0, 0.25, 0.25)
end