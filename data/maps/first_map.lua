----- GENERAL OBSTACLES -----

first_map_obstacles = {
  {x = 3, y = 3},
  {x = 4, y = 3},
  {x = 6, y = 3},
  {x = 7, y = 3},
  {x = 8, y = 3},
  {x = 9, y = 3},
  {x = 10, y = 3},
  {x = 11, y = 3},
  {x = 13, y = 3},
  {x = 14, y = 3},
}

-- Walls on the bottom of the castle
for i = 2, 15 do
  table.insert(first_map_obstacles, {x = i, y = 14})
end

-- Left bottom cliff
for i = 0, 27 do
  for j = 17, 18 do
    table.insert(first_map_obstacles, {x = i, y = j})
  end
end

-- Middle bottom cliff
for i = 28, 32 do
  for j = 16, 17 do
    table.insert(first_map_obstacles, {x = i, y = j})
  end
end

-- Middle bottom cliff
for i = 29, 30 do
  for j = 14, 15 do
    table.insert(first_map_obstacles, {x = i, y = j})
  end
end

----- OBSTACLES BASED ON DIRECTION -----

first_map_directed_obstacles = {}

----- OBSTACLES BASED ON DIRECTION (ON BOTH SIDES) -----

first_map_double_directed_obstacles = {}

--- Outside castle's walls

-- Left upper walls
for j = 2, 6 do
  table.insert(first_map_double_directed_obstacles, {first = {x = 1, y = j}, sec = {x = 2, y = j}})
end

-- Left lower walls
for j = 9, 13 do
  table.insert(first_map_double_directed_obstacles, {first = {x = 1, y = j}, sec = {x = 2, y = j}})
end

-- Top walls
for i = 2, 14 do
  table.insert(first_map_double_directed_obstacles, {first = {x = i, y = 1}, sec = {x = i, y = 2}})
end

-- Right upper walls
for j = 2, 6 do
  table.insert(first_map_double_directed_obstacles, {first = {x = 15, y = j}, sec = {x = 14, y = j}})
end

-- Right lower walls
for j = 9, 13 do
  table.insert(first_map_double_directed_obstacles, {first = {x = 15, y = j}, sec = {x = 14, y = j}})
end

--- Inside castle's walls

-- Left upper walls (to interior)
table.insert(first_map_double_directed_obstacles, {first = {x = 2, y = 4}, sec = {x = 3, y = 4}})
table.insert(first_map_double_directed_obstacles, {first = {x = 2, y = 6}, sec = {x = 3, y = 6}})

-- Left lower walls (to interior)
table.insert(first_map_double_directed_obstacles, {first = {x = 2, y = 9}, sec = {x = 3, y = 9}})
table.insert(first_map_double_directed_obstacles, {first = {x = 2, y = 11}, sec = {x = 3, y = 11}})
table.insert(first_map_double_directed_obstacles, {first = {x = 2, y = 12}, sec = {x = 3, y = 12}})

-- Right upper walls (to interior)
table.insert(first_map_double_directed_obstacles, {first = {x = 15, y = 4}, sec = {x = 14, y = 4}})
table.insert(first_map_double_directed_obstacles, {first = {x = 15, y = 6}, sec = {x = 14, y = 6}})

-- Right lower walls (to interior)
table.insert(first_map_double_directed_obstacles, {first = {x = 15, y = 9}, sec = {x = 14, y = 9}})
table.insert(first_map_double_directed_obstacles, {first = {x = 15, y = 11}, sec = {x = 14, y = 11}})
table.insert(first_map_double_directed_obstacles, {first = {x = 15, y = 12}, sec = {x = 14, y = 12}})

-- Rempart to main door
-- first top
table.insert(first_map_double_directed_obstacles, {first = {x = 2, y = 6}, sec = {x = 2, y = 7}})
table.insert(first_map_double_directed_obstacles, {first = {x = 15, y = 6}, sec = {x = 15, y = 7}})
-- first down
table.insert(first_map_double_directed_obstacles, {first = {x = 2, y = 9}, sec = {x = 2, y = 8}})
table.insert(first_map_double_directed_obstacles, {first = {x = 15, y = 9}, sec = {x = 15, y = 8}})