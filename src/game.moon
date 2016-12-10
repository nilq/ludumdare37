export gamera        = require "kit/lib/gamera"
----------------------------------
-- the game state
----------------------------------
export game = {
  game_objects: {}
  ----------------------------------
  -- specifics - references
  ----------------------------------
  sheep:   {}
  enemies: {}
  bullets: {}

  sprites: {}

  scale: 32

  world_w: 350
  world_h: 200
}

game.load = ->
  with game
    .camera     = gamera.new 0, 0, .world_w, .world_h
    .camera\setWindow 0, 0, love.graphics.getWidth!, love.graphics.getHeight!
    .camera\setScale 3

    .map_camera = gamera.new 0, 0, .world_w, .world_h
    .map_camera\setWindow love.graphics.getWidth! - 260, 10, 250, 180
    .map_camera\setScale 0.2

    .grass_sprite = love.graphics.newImage "assets/sprites/misc/grass.png"
    .grass_sprite\setWrap "repeat", "repeat"

    .grass_quad = love.graphics.newQuad 0, 0, .world_w, .world_h, .grass_sprite\getWidth!, .grass_sprite\getHeight!

    .sprites = {
      sheep: love.graphics.newImage "assets/sprites/misc/sheep.png"
      sheep_cut: love.graphics.newImage "assets/sprites/misc/sheep_cut.png"
      sheep_dead: love.graphics.newImage "assets/sprites/misc/dead_sheep.png"
      sheep_cut_dead: love.graphics.newImage "assets/sprites/misc/dead_sheep_naked.png"

      player: love.graphics.newImage "assets/sprites/player/player_stand.png"

      thug: love.graphics.newImage "assets/sprites/misc/thug.png"
      thug_dead: love.graphics.newImage "assets/sprites/misc/dead_thug.png"

      scissor: love.graphics.newImage "assets/sprites/guns/scissor.png"
      scissor_cut: love.graphics.newImage "assets/sprites/guns/scissor_cut.png"

      gun: love.graphics.newImage "assets/sprites/guns/gun.png"
    }

    .load_level "assets/levels/room.png"
    .init_stuff!

game.update = (dt) ->
  ----------------------------------
  -- sorry world .. not good. not good
  ----------------------------------
  with game
    table.sort .game_objects, (a, b) ->
      a.y < b.y

    for g in *.game_objects
      continue if g == nil

      g\update dt if g.update

      g.x = math.clamp 0, .world_w - g.w, g.x if g.x
      g.y = math.clamp -g.h, .world_h - g.h * 2, g.y if g.y

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
    love.graphics.draw .grass_sprite, .grass_quad, 0, 0

    for g in *.game_objects
      continue if g == nil
      g\draw! if g.draw

    for b in *.bullets
      love.graphics.setColor 0, 0, 0
      love.graphics.rectangle "fill", 2, 2, b.x, b.y

----------------------------------
-- load level from image data
----------------------------------
game.map_stuff = {
  "player": {r: 255, g: 0,   b: 0}
  "sheep":  {r: 0,   g: 255, b: 0}
  "enemy":  {r: 0,   g: 0,   b: 255}
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


game.init_stuff = ->
  with game
    for s, _ in *.sheep
      s.leaders[#s.leaders + 1] = .player
    for e, _ in *.enemies
      e.leaders = .sheep

game.make_entity = (id, x, y) ->
  import Player, Sheep, Enemy from require "src/entities"

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

    when "enemy"
      enemy = Enemy x, y
      table.insert game.game_objects, enemy
      table.insert game.enemies,      enemy

love.mousepressed = (x, y, button) ->
  with game
    for g in *.game_objects
      g\mouse_press x, y, button if g.mouse_press

love.keypressed = (key) ->
  with game
    for g in *.game_objects
      g\key_press key if g.key_press

game
