export gamera = require "kit/lib/gamera"
----------------------------------
-- the game state
----------------------------------
export game = {
  game_objects: {}
  ----------------------------------
  -- specifics - references
  ----------------------------------
  sheep: {}
  scale: 32

  bullets: {}

  world_w: 500
  world_h: 400
}

game.load = ->
  with game
    .camera     = gamera.new 0, 0, .world_w, .world_h
    .camera\setWindow 0, 0, love.graphics.getWidth!, love.graphics.getHeight!
    .camera\setScale 2

    .map_camera = gamera.new 0, 0, .world_w, .world_h
    .map_camera\setWindow love.graphics.getWidth! - 260, 10, 250, 180
    .map_camera\setScale 0.2

    .load_level "assets/levels/room.png"
    .init_sheep!

game.update = (dt) ->
  ----------------------------------
  -- sorry world .. not good. not good
  ----------------------------------
  with game
    table.sort .game_objects, (a, b) ->
      a.y < b.y

    for g in *.game_objects
      g\update dt if g.update

      g.x = math.clamp 0, .world_w - g.w, g.x if g.x
      g.y = math.clamp 0, .world_h - g.h * 2, g.y if g.y

    for b in *.bullets
      b.x += b.dx
      b.y += b.dy

game.draw = ->
  with game
    love.graphics.setColor 0, 0, 0
    love.graphics.rectangle "fill", .map_camera\getWindow!

    .camera\draw ->
      .draw_stuff!
    .map_camera\draw ->
      .draw_stuff!

    love.graphics.setColor 0, 0, 0
    love.graphics.rectangle "line", .map_camera\getWindow!
  ----------------------------------
  -- debug
  ----------------------------------
  fps = string.format "%07.2f", 1 / love.timer.getAverageDelta!
  mem = string.format "%013.4f", collectgarbage "count"

  love.graphics.print "FPS: #{fps}", 0, 0
  love.graphics.print "MEM: #{mem}", 0, 16

game.draw_stuff = ->
  with game
    love.graphics.setColor 255, 255, 255
    love.graphics.rectangle "fill", 0, 0, .world_w, .world_h
    for g in *.game_objects
      g\draw! if g.draw

    for b in *.bullets
      love.graphics.setColor 0, 0, 0
      love.graphics.rectangle "fill", 2, 2, b.x, b.y

----------------------------------
-- load level from image data
----------------------------------
game.map_stuff = {
  "player": {r: 255, g: 0, b: 0}
  "sheep": {r: 0, g: 255, b: 0}
}

game.load_level = (path) ->
  with game
    image = love.image.newImageData path

    for x = 1, image\getWidth!
      for y = 1, image\getHeight!

        rx, ry = x - 1, y - 1
        r, g, b = image\getPixel rx, ry

        for k, v in pairs .map_stuff
          if r == v.r and g == v.g and b == v.b
            .make_entity k, .scale * rx, .scale * ry


game.init_sheep = ->
  with game
    for s, _ in *.sheep
      s.leaders[#s.leaders + 1] = .player

game.make_entity = (id, x, y) ->
  import Player, Sheep from require "src/entities"

  switch id
    when "player"
      player = Player x, y, 21, 21 -- bad res
      ----------------------------------
      -- do things with player here ...
      ----------------------------------
      game.player = player
      table.insert game.game_objects, player

    when "sheep"
      sheep = Sheep x, y
      table.insert game.game_objects, sheep
      table.insert game.sheep,        sheep

love.mousepressed = (x, y, button) ->
  with game
    for g in *.game_objects
      g\mouse_press x, y, button if g.mouse_press

love.keypressed = (key) ->
  with game
    for g in *.game_objects
      g\key_press key if g.key_press

game
