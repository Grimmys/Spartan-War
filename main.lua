TILE_SIZE = 64
MAP_WIDTH = TILE_SIZE * 50
MAP_HEIGHT = TILE_SIZE * 50

-- For now, there is only the map displayed on the window, limited to 30 tiles, and rescaled
SCALING = 0.25
TILES_LIMIT = 50
WINDOW_WIDTH = TILE_SIZE * SCALING * TILES_LIMIT
WINDOW_HEIGHT = TILE_SIZE * SCALING * TILES_LIMIT

function love.load()
   map = love.graphics.newImage("graphics/maps/first_map.png") -- Loading of the first map
   mapX = 0
   mapY = 0
    if not love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT) then
      print("An error occured during setting window")
    end
end

function love.draw()
    love.graphics.draw(map, mapX, mapY, 0, SCALING, SCALING) -- Displaying map, according to ratio
end