gamera = require("kit/lib/gamera")
game = {
  game_objects = { },
  sheep = { },
  scale = 32,
  bullets = { },
  world_w = 500,
  world_h = 400
}
game.load = function()
  do
    game.camera = gamera.new(0, 0, game.world_w, game.world_h)
    game.camera:setWindow(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    game.camera:setScale(2)
    game.map_camera = gamera.new(0, 0, game.world_w, game.world_h)
    game.map_camera:setWindow(love.graphics.getWidth() - 260, 10, 250, 180)
    game.map_camera:setScale(0.2)
    game.load_level("assets/levels/room.png")
    game.init_sheep()
    return game
  end
end
game.update = function(dt)
  do
    table.sort(game.game_objects, function(a, b)
      return a.y < b.y
    end)
    local _list_0 = game.game_objects
    for _index_0 = 1, #_list_0 do
      local g = _list_0[_index_0]
      if g.update then
        g:update(dt)
      end
      if g.x then
        g.x = math.clamp(0, game.world_w - g.w, g.x)
      end
      if g.y then
        g.y = math.clamp(0, game.world_h - g.h * 2, g.y)
      end
    end
    local _list_1 = game.bullets
    for _index_0 = 1, #_list_1 do
      local b = _list_1[_index_0]
      b.x = b.x + b.dx
      b.y = b.y + b.dy
    end
    return game
  end
end
game.draw = function()
  do
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", game.map_camera:getWindow())
    game.camera:draw(function()
      return game.draw_stuff()
    end)
    game.map_camera:draw(function()
      return game.draw_stuff()
    end)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", game.map_camera:getWindow())
  end
  local fps = string.format("%07.2f", 1 / love.timer.getAverageDelta())
  local mem = string.format("%013.4f", collectgarbage("count"))
  love.graphics.print("FPS: " .. tostring(fps), 0, 0)
  return love.graphics.print("MEM: " .. tostring(mem), 0, 16)
end
game.draw_stuff = function()
  do
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("fill", 0, 0, game.world_w, game.world_h)
    local _list_0 = game.game_objects
    for _index_0 = 1, #_list_0 do
      local g = _list_0[_index_0]
      if g.draw then
        g:draw()
      end
    end
    local _list_1 = game.bullets
    for _index_0 = 1, #_list_1 do
      local b = _list_1[_index_0]
      love.graphics.setColor(0, 0, 0)
      love.graphics.rectangle("fill", 2, 2, b.x, b.y)
    end
    return game
  end
end
game.map_stuff = {
  ["player"] = {
    r = 255,
    g = 0,
    b = 0
  },
  ["sheep"] = {
    r = 0,
    g = 255,
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
game.init_sheep = function()
  do
    local _list_0 = game.sheep
    for _index_0 = 1, #_list_0 do
      local s, _ = _list_0[_index_0]
      s.leaders[#s.leaders + 1] = game.player
    end
    return game
  end
end
game.make_entity = function(id, x, y)
  local Player, Sheep
  do
    local _obj_0 = require("src/entities")
    Player, Sheep = _obj_0.Player, _obj_0.Sheep
  end
  local _exp_0 = id
  if "player" == _exp_0 then
    local player = Player(x, y, 21, 21)
    game.player = player
    return table.insert(game.game_objects, player)
  elseif "sheep" == _exp_0 then
    local sheep = Sheep(x, y)
    table.insert(game.game_objects, sheep)
    return table.insert(game.sheep, sheep)
  end
end
love.mousepressed = function(x, y, button)
  do
    local _list_0 = game.game_objects
    for _index_0 = 1, #_list_0 do
      local g = _list_0[_index_0]
      if g.mouse_press then
        g:mouse_press(x, y, button)
      end
    end
    return game
  end
end
return game
