TILE_SIZE = 64
MAP_WIDTH = TILE_SIZE * 50
MAP_HEIGHT = TILE_SIZE * 50

-- For now, there is only the map displayed on the window, limited to 30 tiles, and rescaled
SCALING = 0.5
EFF_TILE_SIZE = TILE_SIZE * SCALING
TILES_LIMIT_W = 35
TILES_LIMIT_H = 25
WINDOW_WIDTH = EFF_TILE_SIZE * TILES_LIMIT_W
WINDOW_HEIGHT = EFF_TILE_SIZE * TILES_LIMIT_H

function love.load()
  --Window configuration
  if not love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT) then
    print("An error occured during setting window")
  end
  
  --Map creation
  map = Entity:new{pos = {x = 0, y = 0}, size = {width = MAP_WIDTH, height = MAP_HEIGHT}, sprite = "graphics/maps/first_map.png"}
  
  --First units (for testing) creation
  UNITS_POS = {{x = 0, y = 0}, {x = EFF_TILE_SIZE * 3, y = EFF_TILE_SIZE * 2}, {x = EFF_TILE_SIZE * 6, y = EFF_TILE_SIZE * 5}}
  units = {}
  for i = 1, 4 do
    unit = Entity:new{pos = UNITS_POS[i], size = {width = EFF_TILE_SIZE, height = EFF_TILE_SIZE}, sprite = "graphics/units/square.png"}
    table.insert(units, unit)
  end
  print(units)
end

function love.draw()
  map:draw()
  
  for i, u in ipairs(units) do
    u:draw()
  end
end

--Entity's prototype
Entity = {pos = {x = 0, y = 0}, size = {width = 0, height = 0}, sprite = ""}

function Entity:draw()
  love.graphics.draw(self.sprite, self.pos.x, self.pos.y, 0, SCALING, SCALING)
end

--Constructor for new entity
function Entity:new(o)
  ent = o or {}
  setmetatable(ent, self)
  self.__index = self
  if ent.sprite ~= "" then
    ent.sprite = love.graphics.newImage(ent.sprite)
  end
  return ent
end