TILE_SIZE = 64
MAP_WIDTH = TILE_SIZE * 50
MAP_HEIGHT = TILE_SIZE * 50

-- For now, there is only the map displayed on the window, limited to 30 tiles, and rescaled
SCALING = 0.5
EFF_TILE_SIZE = TILE_SIZE * SCALING
TILES_LIMIT_W = 35
TILES_LIMIT_H = 20
BORDER_SIZE_W = 50
BORDER_SIZE_H = 100
WINDOW_WIDTH = EFF_TILE_SIZE * TILES_LIMIT_W + BORDER_SIZE_W * 2
WINDOW_HEIGHT = EFF_TILE_SIZE * TILES_LIMIT_H + BORDER_SIZE_H * 2

-- Buttons size
END_B_SIZE_W = 256
END_B_SIZE_H = 128

-- Game paramaters (actually, they are fixed)
TEAM_COLORS = {
    "red",
    "black"
  }

function love.load()
  --Window configuration
  if not love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT) then
    print("An error occured during setting window")
  end
  
  --Loading images
    --Indicators
    possible_move = love.graphics.newImage("graphics/grid_indicators/move.png")
    
    --Button's frame
    button_sprite = love.graphics.newImage("graphics/interface/end_button.png")
  
  --Map creation
  map_sprite = love.graphics.newImage("graphics/maps/first_map.png")
  map = Map:new{pos = {x = BORDER_SIZE_W, y = BORDER_SIZE_H}, size = {width = MAP_WIDTH, height = MAP_HEIGHT}, sprite = map_sprite}
  --Change relative map for future units
  Unit.relative_to = map
  --Part of the map visible at screen
  map.screen_part = love.graphics.newQuad(0, 0, TILE_SIZE * TILES_LIMIT_W, TILE_SIZE * TILES_LIMIT_H, MAP_WIDTH, MAP_HEIGHT)
  
  --Load map's obstacles
  require("data/maps/first_map")
  for i, pos in ipairs(first_map_obstacles) do
    table.insert(map.obstacles, {x = EFF_TILE_SIZE * pos.x + map.pos.x, y = EFF_TILE_SIZE * pos.y + map.pos.y})
  end
  
  --First units (for testing) creation
    -- red is first team, black is second team
  units_by_side = {}
  for i, _ in ipairs(TEAM_COLORS) do
    units_by_side[i] = {}
  end
  units = {}
      -- One red soldier at (0, 0)
      unit = Soldier:new{pos = {x = 0, y = 0}, side = 1}
      table.insert(units, unit)
      table.insert(units_by_side[1], unit)
      
      -- One red lancer at (3, 2)
      unit = Lancer:new{pos = {x = EFF_TILE_SIZE * 3, y = EFF_TILE_SIZE * 2}, side = 1}
      table.insert(units, unit)
      table.insert(units_by_side[1], unit)
      
      -- One black soldier at (6, 5)
      unit = Soldier:new{pos = {x = EFF_TILE_SIZE * 6, y = EFF_TILE_SIZE * 5}, side = 2}
      table.insert(units, unit)
      table.insert(units_by_side[2], unit)

  map.units = units
  
  --Buttons
    --End turn
  end_turn_b = Button:new{pos = {x = WINDOW_WIDTH - (END_B_SIZE_W + 100) * SCALING, y = WINDOW_HEIGHT - (END_B_SIZE_H + 50) * SCALING}, size = {width = END_B_SIZE_W * SCALING, height = END_B_SIZE_H * SCALING}, sprite = button_sprite, title = "End Turn"}

  --Side which is currently playing
  side_turn = 1
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
      square:draw()
    end
  end
  
  --Displaying buttons
    --End Turn button
  end_turn_b:draw()
end

--GLOBAL GAME FUNCTIONS

function changeTurn()
  local nbPlayers = #TEAM_COLORS
  if side_turn == nbPlayers then
    side_turn = 1
  else
    side_turn = side_turn + 1
  end
  
  --Allow all units to be played again
  for _, u in ipairs(units_by_side[side_turn]) do
    u.has_acted = false
  end
end

--ARRAY METHODS

function equality(a, b)
  if a == b then
    return true
  elseif type(a) == "table" and type(b) == "table" and #a == #b then
    for k, v in pairs(a) do
      if not equality(a[k], b[k]) then
        return false
      end
    end
  else
    return false
  end
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
Entity = {pos = {x = 0, y = 0}, size = {width = 0, height = 0}, sprite = "", relative_to = nil}
function Entity:draw()
  love.graphics.draw(self.sprite, self.pos.x, self.pos.y, 0, SCALING, SCALING)
end

function Entity:isTouched(x, y)
  return x >= self.pos.x and x < self.pos.x + self.size.width and y >= self.pos.y and y < self.pos.y + self.size.height
end

--Constructor for new entity
function Entity:new(o)
  ent = o or {}
  setmetatable(ent, self)
  self.__index = self
  if ent.relative_to then
    ent.pos.x = ent.pos.x + ent.relative_to.pos.x
    ent.pos.y = ent.pos.y + ent.relative_to.pos.y
  end
  return ent
end

--Square's prototype
Square = Entity:new()
Square.size = {width = EFF_TILE_SIZE, height = EFF_TILE_SIZE}

--Button's prototype
Button = Entity:new()
Button.title = "None"
function Button:draw()
  love.graphics.draw(self.sprite, self.pos.x, self.pos.y, 0, SCALING, SCALING)
  font = love.graphics.newFont(26)
  love.graphics.setFont(font)
  --White text
  love.graphics.setColor(255, 255, 255)
  love.graphics.print(self.title, self.pos.x + self.size.width / 2 - font:getWidth(self.title) / 2, self.pos.y + self.size.height / 2 - font:getHeight() / 2)
  
  --Reset initial color
  love.graphics.setColor(255, 255, 255)
end


--Unit's prototype
Unit = Entity:new()
Unit.move = 0
Unit.size = {width = EFF_TILE_SIZE, height = EFF_TILE_SIZE}
Unit.sprite = love.graphics.newImage("graphics/units/square.png")
Unit.color_sprites = {}
Unit.has_acted = false

function Unit:accessibleSquares(map)
  --Check if the calcul hasn't be already done
  if not self.available_moves then
    local squares = {Square:new{pos = self.pos}}
    
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
  end
  
  return self.available_moves
end

function Unit:unselect()
  --Reset available moves
  self.available_moves = nil
end

function Unit:moveTo(square)
  --Change the position of the unit
  self.pos = square.pos
  
  --Reset available moves
  self.available_moves = nil
end

--Function to create specific unit's prototype
--  @return prototype 
function createUnitPrototype(unit_data)
  local unit_proto = Unit:new()
  unit_proto.move = unit_data.move
  unit_proto.color_sprites = {
    red = love.graphics.newImage(unit_data.red_sprite),
    black = love.graphics.newImage(unit_data.black_sprite)
  }
  function unit_proto:new(o)
    ent = Unit:new(o)
    ent.move = unit_proto.move
    ent.sprite = unit_proto.color_sprites[TEAM_COLORS[ent.side]]
    return ent
  end
  return unit_proto
end

--Soldier
  --Load soldier's data
require("data/units/soldier")
  --Create soldier's prototype
Soldier = createUnitPrototype(Soldier_data)

--Lancer
  --Load lancer's data
require("data/units/lancer")
  --Create lancer's prototype
Lancer = createUnitPrototype(Lancer_data)

--Map's prototype
Map = Entity:new()
Map.screen_part = {}
Map.obstacles = {}
Map.units = {}

function Map:draw()
  love.graphics.draw(self.sprite, self.screen_part, self.pos.x, self.pos.y, 0, SCALING, SCALING)
end

function Map:isTouched(x, y)
  local _, _, w, h = self.screen_part:getViewport()
  w = w * SCALING
  h = h * SCALING
  return x >= self.pos.x and x < self.pos.x + w and y >= self.pos.y and y < self.pos.y + h
end

function Map:squareIsEmpty(square)
  --Checking if square is not beyond map limit
  if square.pos.x >= map.pos.x and square.pos.x < map.size.width and square.pos.y >= map.pos.y and square.pos.y < map.size.height then
    --Checking if there is no obstacle on the square
    for i, o in ipairs(self.obstacles) do
      if square.pos.x == o.x and square.pos.y == o.y then
        return false
      end
    end
    --Checking if there is no other unit on the square
    for i, u in ipairs(self.units) do
      if square.pos.x == u.pos.x and square.pos.y == u.pos.y then
        return false
      end
    end
    return true
  end
  return false
end

--Method to check all available squares next to the one given
function Map:nextAvailableSquares(sq)
  local directions = {{x = 1, y = 0}, {x = -1, y = 0}, {x = 0, y = 1}, {x = 0, y = -1}} --The directions of the next squares 

  local squares = {} --Array for available squares
  for i, dir in ipairs(directions) do
    local square = Square:new{pos = {x = sq.pos.x + dir.x * EFF_TILE_SIZE, y = sq.pos.y + dir.y * EFF_TILE_SIZE}, sprite = possible_move} --Square to test
    if self:squareIsEmpty(square) then
      table.insert(squares, square)
    end
  end
  return squares --Return all empty squares
end

--EVENTS

function love.mousepressed(x, y, button)
   if button == 1 then
      --Check if click is on map
      if map:isTouched(x, y) then
        if selected_unit then
          selected_unit:unselect()
          selected_unit = nil
        end
        for i, u in ipairs(units) do
          if u:isTouched(x, y) and u.side == side_turn and not u.has_acted then
            selected_unit = u
            return
          end
        end
      end
      --Check if click is on a button
      if end_turn_b:isTouched(x, y) then
        changeTurn()
      end
   end
   
   if button == 2 then
     if selected_unit then
      local available_moves = selected_unit:accessibleSquares(map)
      for i, square in ipairs(available_moves) do
        if square:isTouched(x, y) then
          selected_unit:moveTo(square)
          selected_unit.has_acted = true
          selected_unit = nil
          return
        end
      end
     end
    end
end