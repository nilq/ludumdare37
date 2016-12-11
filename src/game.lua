gamera = require("kit/lib/gamera")
math.randomseed(os.time())
game = {
  game_objects = { },
  sheep = { },
  enemies = { },
  bullets = { },
  pool = { },
  sprites = { },
  scale = 32,
  world_w = 625,
  world_h = 450,
  wave = 0,
  wave_thugs = 0,
  t = 4,
  wave_t = 4,
  new_wave = true
}
game.load = function()
  do
    game.game_objects = { }
    game.player = { }
    game.sheep = { }
    game.enemies = { }
    game.camera = gamera.new(0, 0, game.world_w, game.world_h)
    game.camera:setWindow(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    game.camera:setScale(3)
    game.map_camera = gamera.new(0, 0, game.world_w, game.world_h)
    game.map_camera:setWindow(love.graphics.getWidth() - 260, 10, 250, 180)
    game.map_camera:setScale(0.2)
    game.grass_sprite = love.graphics.newImage("assets/sprites/misc/grass.png")
    game.grass_sprite:setWrap("repeat", "repeat")
    game.grass_quad = love.graphics.newQuad(0, 0, game.world_w, game.world_h, game.grass_sprite:getWidth(), game.grass_sprite:getHeight())
    game.sprites = {
      sheep = love.graphics.newImage("assets/sprites/misc/sheep.png"),
      sheep_cut = love.graphics.newImage("assets/sprites/misc/sheep_cut.png"),
      sheep_dead = love.graphics.newImage("assets/sprites/misc/dead_sheep.png"),
      sheep_cut_dead = love.graphics.newImage("assets/sprites/misc/dead_sheep_naked.png"),
      player = love.graphics.newImage("assets/sprites/player/player_stand.png"),
      player_cut = love.graphics.newImage("assets/sprites/player/player_cut.png"),
      player_cut_dead = love.graphics.newImage("assets/sprites/player/player_cut_dead.png"),
      thug = love.graphics.newImage("assets/sprites/misc/thug.png"),
      thug_cut = love.graphics.newImage("assets/sprites/misc/thug_cut.png"),
      thug_dead = love.graphics.newImage("assets/sprites/misc/dead_thug.png"),
      thug_cut_dead = love.graphics.newImage("assets/sprites/misc/dead_thug_naked.png"),
      scissor = love.graphics.newImage("assets/sprites/guns/scissor.png"),
      scissor_cut = love.graphics.newImage("assets/sprites/guns/scissor_cut.png"),
      coin = love.graphics.newImage("assets/sprites/misc/coin.png"),
      gun = love.graphics.newImage("assets/sprites/guns/gun.png")
    }
    local Enemy
    Enemy = require("src/entities").Enemy
    game.load_level("assets/levels/room.png")
    do
      for i = 1, 300 do
        local e = Enemy(-1337, -1337, game.sheep)
        table.insert(game.pool, e)
      end
    end
    return game
  end
end
game.update = function(dt)
  do
    table.sort(game.game_objects, function(a, b)
      if a.dead and not b.dead then
        return true
      elseif b.dead and not a.dead then
        return false
      else
        return a.y < b.y
      end
    end)
    local _list_0 = game.game_objects
    for _index_0 = 1, #_list_0 do
      local _continue_0 = false
      repeat
        local g = _list_0[_index_0]
        if g == nil then
          _continue_0 = true
          break
        end
        if g.update then
          g:update(dt)
        end
        if g.x then
          g.x = math.clamp(0, game.world_w - g.w, g.x)
        end
        if g.y then
          g.y = math.clamp(-g.h, game.world_h - g.h * 2, g.y)
        end
        _continue_0 = true
      until true
      if not _continue_0 then
        break
      end
    end
    local _list_1 = game.bullets
    for _index_0 = 1, #_list_1 do
      local b = _list_1[_index_0]
      b.x = b.x + b.dx
      b.y = b.y + b.dy
    end
    if game.wave_thugs == 0 and not game.new_wave then
      game.t = game.wave_t
      game.new_wave = true
    end
    if game.new_wave then
      game.t = game.t - dt
      if game.t <= 0 then
        game.wave = game.wave + 1
        game.new_wave = false
        game.load_wave()
      end
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
    game.draw_hud()
  end
  love.graphics.setColor(0, 0, 0)
  local fps = string.format("%07.2f", 1 / love.timer.getAverageDelta())
  local mem = string.format("%013.4f", collectgarbage("count"))
  love.graphics.print("FPS: " .. tostring(fps), 0, 0)
  return love.graphics.print("MEM: " .. tostring(mem), 0, 16)
end
game.draw_stuff = function()
  do
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(game.grass_sprite, game.grass_quad, 0, 0)
    local _list_0 = game.game_objects
    for _index_0 = 1, #_list_0 do
      local _continue_0 = false
      repeat
        local g = _list_0[_index_0]
        if g == nil then
          _continue_0 = true
          break
        end
        if g.draw then
          g:draw()
        end
        _continue_0 = true
      until true
      if not _continue_0 then
        break
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
game.draw_hud = function()
  do
    local _with_0 = love.graphics
    local font = _with_0.getFont()
    for i, v in ipairs(game.player.tools) do
      local font_w = font:getWidth(i)
      local font_h = font:getHeight(i)
      if i == game.player.current then
        _with_0.setColor(200, 200, 255)
      else
        _with_0.setColor(200, 200, 200)
      end
      _with_0.rectangle("fill", 10 + (i - 1) * 74, love.graphics.getHeight() - 74, 64, 64)
      _with_0.setColor(100, 100, 100)
      _with_0.rectangle("fill", 10 + (i - 1) * 74 - 5, love.graphics.getHeight() - 74 - 5, 20, 20)
      _with_0.setColor(0, 0, 0)
      _with_0.print(i, 10 + (i - 1) * 74 - 5 + font_w / 3.5, love.graphics.getHeight() - 74 - 5 + font_h / 4.5)
      local sprite = game.player.tools[i].sprite
      _with_0.setColor(255, 255, 255)
      _with_0.draw(sprite, 10 + (i - 1) * 74 - 5 + 32 + sprite:getWidth() / 2, love.graphics.getHeight() - 74 - 5 + 32 + sprite:getHeight() / 2, 0, 4, 4, sprite:getWidth() / 2, sprite:getHeight() / 2)
      _with_0.setColor(0, 0, 0)
      if v.type == "gun" then
        _with_0.print(tostring(v.ammo) .. "/30", 10 + (i - 1) * 74 - 5 + 32 + sprite:getWidth() / 2 - 5, love.graphics.getHeight() - 74 - 5 + 32 + sprite:getHeight() / 2)
      end
    end
    local text = ""
    if game.new_wave then
      text = tostring(string.format("%02.2f", game.t)) .. " SECONDS UNTIL NEXT WAVE"
    else
      text = "WAVE: " .. tostring(game.wave)
    end
    _with_0.setColor(200, 200, 200)
    _with_0.rectangle("fill", _with_0.getWidth() / 2 - (_with_0.getFont():getWidth(text)) / 2 - 5, 15, (_with_0.getFont():getWidth(text)) + 5, 20)
    _with_0.setColor(0, 0, 0)
    _with_0.print(text, _with_0.getWidth() / 2 - (_with_0.getFont():getWidth(text)) / 2, 20)
    local cx, cy = _with_0.getWidth() - 260, _with_0.getHeight() / 3
    text = tostring(string.format("%09.0f", game.player.currency))
    _with_0.print(text, cx, cy + 6)
    _with_0.setColor(255, 255, 0)
    _with_0.print("$$$", cx + (font:getWidth(text)), cy + 6)
    _with_0.setColor(0, 0, 0)
    text = tostring(string.format("%09.0f", #game.sheep - 1))
    _with_0.print(text, cx, cy + 22)
    _with_0.setColor(255, 255, 0)
    _with_0.print("(living)sheep", cx + (font:getWidth(text)), cy + 22)
    return _with_0
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
  },
  ["enemy"] = {
    r = 0,
    g = 0,
    b = 255
  }
}
game.load_wave = function()
  do
    game.enemies = { }
    for i = 1, game.wave * 3 do
      local thug = game.pool[(i + game.wave * 3) % #game.pool]
      if thug.dead then
        thug:reset()
      end
      world:update(thug, (math.random(0, game.world_w)), math.random(0, game.world_h))
      table.insert(game.enemies, thug)
      table.insert(game.game_objects, thug)
      game.wave_thugs = game.wave_thugs + 1
    end
    return game
  end
end
game.load_level = function(path)
  do
    game.enemies = { }
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
  local Player, Sheep, Enemy
  do
    local _obj_0 = require("src/entities")
    Player, Sheep, Enemy = _obj_0.Player, _obj_0.Sheep, _obj_0.Enemy
  end
  local _exp_0 = id
  if "player" == _exp_0 then
    local player = Player(x, y, 21, 21)
    game.player = player
    table.insert(game.game_objects, player)
    return table.insert(game.sheep, player)
  elseif "sheep" == _exp_0 then
    local sheep = Sheep(x, y, {
      game.player
    })
    table.insert(game.game_objects, sheep)
    return table.insert(game.sheep, sheep)
  elseif "enemy" == _exp_0 then
    local enemy = Enemy(x, y, game.sheep)
    table.insert(game.game_objects, enemy)
    table.insert(game.enemies, enemy)
    game.wave_thugs = game.wave_thugs + 1
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
love.keypressed = function(key)
  do
    local _list_0 = game.game_objects
    for _index_0 = 1, #_list_0 do
      local g = _list_0[_index_0]
      if g.key_press then
        g:key_press(key)
      end
    end
    return game
  end
end
return game
