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
  
  --Loading images
  possible_move = love.graphics.newImage("graphics/grid_indicators/move.png")
  
  --Map creation
  map = Map:new{pos = {x = 0, y = 0}, size = {width = MAP_WIDTH, height = MAP_HEIGHT}, sprite = "graphics/maps/first_map.png"}
  
  --First units (for testing) creation
  UNITS_POS = {{x = 0, y = 0}, {x = EFF_TILE_SIZE * 3, y = EFF_TILE_SIZE * 2}, {x = EFF_TILE_SIZE * 6, y = EFF_TILE_SIZE * 5}}
  units = {}
  for i = 1, 4 do
    unit = Unit:new{pos = UNITS_POS[i], size = {width = EFF_TILE_SIZE, height = EFF_TILE_SIZE}, sprite = "graphics/units/square.png", move = 3}
    table.insert(units, unit)
  end
end

function love.draw()
  map:draw()
  
  -- Displaying all units on screen
  for i, u in ipairs(units) do
    u:draw()
  end
  
  --Displaying posible movement for the selected unit
  if selected_unit then
    squares = selected_unit:accessibleSquares(map)
    for i, square in ipairs(squares) do
      love.graphics.draw(possible_move, square.x, square.y, 0, SCALING, SCALING)
    end
  end
end

--ARRAY METHODS

function equality(a, b)
  if a == b then
    return true
  elseif type(a) == "table" and type(b) == "table" then
    for k, v in pairs(a) do
      if a[k] ~= b[k] then
        return false
      end
    end
    for k, v in pairs(b) do
      if a[k] ~= b[k] then
        return false
      end
    end
  else
    return false
  end
  print("IT'S EQUALS !")
  return true
end

--Clone a table
function table.clone(org)
  return {unpack(org)}
end

--Check existence
function arrayContains(arr, value)
  for i, el in ipairs(arr) do
    if equality(el, value) then
      return true
    end
  end
  return false
end

--Set's sum
function setSum(a, b)
  local c = table.clone(a)
  for i, el in ipairs(b) do
    if not arrayContains(c, el) then
      table.insert(c, el)
    end
  end
  return c
end

--CLASSES

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

--Unit's prototype
Unit = Entity:new()
Unit.move = 0

function Unit:isTouched(x, y)
  return x >= self.pos.x and x < self.pos.x + self.size.width and y >= self.pos.y and y < self.pos.y + self.size.height
end

function Unit:accessibleSquares(map)
  --Check if the calcul hasn't be already done
  if not self.available_moves then
    local squares = {self.pos}
    
    --Check for available squares, according to unit's move limit
    local prev_squares = squares
    for i = 1, self.move do
      local new_squares = {}
      for i, pos in ipairs(prev_squares) do
        new_squares = setSum(new_squares, map:nextAvailableSquares(pos))
      end
      prev_squares = new_squares
      squares = setSum(squares, prev_squares)
    end
    
    --Remove unit's square
    table.remove(squares, 1)
    self.available_moves = squares
    print("BEGIN")
    for i, pos in ipairs(self.available_moves) do
      print(pos.x / EFF_TILE_SIZE, pos.y / EFF_TILE_SIZE)
    end
    print("END")
  end
  
  return self.available_moves
end

--Map's prototype
Map = Entity:new()
Map.obstacles = {}
Map.units = {}

--Method to check all available squares next to the one given
function Map:nextAvailableSquares(pos)
  local directions = {{x = 1, y = 0}, {x = -1, y = 0}, {x = 0, y = 1}, {x = 0, y = -1}} --The directions of the next squares 

  local squares = {} --Array for available squares
  for i, dir in ipairs(directions) do
    local square = {x = pos.x + dir.x * EFF_TILE_SIZE, y = pos.y + dir.y * EFF_TILE_SIZE} --Square to test
    local available = true
    --Checking if there is no obstacle on the square
    for i, o in ipairs(self.obstacles) do
      if square.x == o.x and square.y == o.y then
        available = false
        break
      end
    end
    if available then
      table.insert(squares, square)
    end
  end
  return squares --Return all empty squares
end

--EVENTS

function love.mousepressed(x, y, button)
   if button == 1 then
      selected_unit = nil
      for i, u in ipairs(units) do
        if u:isTouched(x, y) then
          selected_unit = u
          return
        end
      end
   end
end