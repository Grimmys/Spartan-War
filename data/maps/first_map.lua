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