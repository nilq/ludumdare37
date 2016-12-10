game = {
  game_objects = { },
  scale = 32
}
game.load = function()
  do
    game.load_level("assets/levels/room.png")
    return game
  end
end
game.update = function(dt)
  do
    local _list_0 = game.game_objects
    for _index_0 = 1, #_list_0 do
      local g = _list_0[_index_0]
      if g.update then
        g:update(dt)
      end
    end
    return game
  end
end
game.draw = function()
  do
    local _list_0 = game.game_objects
    for _index_0 = 1, #_list_0 do
      local g = _list_0[_index_0]
      if g.draw then
        g:draw()
      end
    end
    return game
  end
end
game.map_stuff = {
  ["player"] = {
    r = 255,
    g = 0,
    b = 0
  }
}
game.load_level = function(path)
  do
    local image = love.image.newImageData(path)
    for x = 1, image:getWidth() do
      for y = 1, image:getHeight() do
        local rx, ry = x - 1, y - 1
        local r, g, b = image:getPixel(rx, ry)
        for k, v in pairs(game.map_stuff) do
          if r == v.r and g == v.g and b == v.b then
            game.make_entity(k, game.scale * rx, game.scale * ry)
          end
        end
      end
    end
    return game
  end
end
game.make_entity = function(id, x, y)
  local Player
  Player = require("src/entities").Player
  local _exp_0 = id
  if "player" == _exp_0 then
    local player = Player(x, y, 21, 21)
    return table.insert(game.game_objects, player)
  end
end
return game
