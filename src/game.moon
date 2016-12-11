export gamera        = require "kit/lib/gamera"
math.randomseed os.time!
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

  pool: {}

  sprites: {}

  scale: 32

  world_w: 625
  world_h: 450

  wave: 0
  wave_thugs: 0

  t: 4
  wave_t: 4
  new_wave: true
}

game.load = ->
  with game
    .game_objects = {}
    .player       = {}
    .sheep        = {}
    .enemies      = {}

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
      sheep:           love.graphics.newImage "assets/sprites/misc/sheep.png"
      sheep_cut:       love.graphics.newImage "assets/sprites/misc/sheep_cut.png"
      sheep_dead:      love.graphics.newImage "assets/sprites/misc/dead_sheep.png"
      sheep_cut_dead:  love.graphics.newImage "assets/sprites/misc/dead_sheep_naked.png"

      player:          love.graphics.newImage "assets/sprites/player/player_stand.png"
      player_cut:      love.graphics.newImage "assets/sprites/player/player_cut.png"
      player_cut_dead: love.graphics.newImage "assets/sprites/player/player_cut_dead.png"

      thug:            love.graphics.newImage "assets/sprites/misc/thug.png"
      thug_cut:        love.graphics.newImage "assets/sprites/misc/thug_cut.png"
      thug_dead:       love.graphics.newImage "assets/sprites/misc/dead_thug.png"
      thug_cut_dead:   love.graphics.newImage "assets/sprites/misc/dead_thug_naked.png"

      scissor:         love.graphics.newImage "assets/sprites/guns/scissor.png"
      scissor_cut:     love.graphics.newImage "assets/sprites/guns/scissor_cut.png"

      gun:             love.graphics.newImage "assets/sprites/guns/gun.png"
    }

    import Enemy from require "src/entities"

    .load_level "assets/levels/room.png"

    with game
      for i = 1, 300
        e = Enemy -1337, -1337, .sheep
        table.insert .pool, e

game.update = (dt) ->
  ----------------------------------
  -- sorry world .. not good. not good
  ----------------------------------
  with game
    table.sort .game_objects, (a, b) ->
      if a.dead and not b.dead
        return true
      elseif b.dead and not a.dead
        return false
      else
        a.y < b.y

    for g in *.game_objects
      continue if g == nil

      g\update dt if g.update

      g.x = math.clamp 0, .world_w - g.w, g.x if g.x
      g.y = math.clamp -g.h, .world_h - g.h * 2, g.y if g.y

    for b in *.bullets
      b.x += b.dx
      b.y += b.dy

    if .wave_thugs == 0 and not .new_wave
      .t        = .wave_t
      .new_wave = true

    if .new_wave
      .t -= dt

      if .t <= 0
        .wave    += 1
        .new_wave = false

        .load_wave!

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

    .draw_hud!
  ----------------------------------
  -- debug
  ----------------------------------
  love.graphics.setColor 0, 0, 0
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

game.draw_hud = ->
  with love.graphics
    font   = .getFont!
    for i, v in ipairs game.player.tools
      font_w = font\getWidth  i
      font_h = font\getHeight i

      if i == game.player.current
        .setColor 200, 200, 255
      else
        .setColor 200, 200, 200

      .rectangle "fill", 10 + (i - 1) * 74, love.graphics.getHeight! - 74, 64, 64

      .setColor 100, 100, 100
      .rectangle "fill", 10 + (i - 1) * 74 - 5, love.graphics.getHeight! - 74 - 5, 20, 20

      .setColor 0, 0, 0
      .print i, 10 + (i - 1) * 74 - 5 + font_w / 3.5, love.graphics.getHeight! - 74 - 5 + font_h / 4.5

      sprite = game.player.tools[i].sprite

      .setColor 255, 255, 255
      .draw sprite, 10 + (i - 1) * 74 - 5 + 32 + sprite\getWidth! / 2, love.graphics.getHeight! - 74 - 5 + 32 + sprite\getHeight! / 2, 0, 4, 4, sprite\getWidth! / 2, sprite\getHeight! / 2

      .setColor 0, 0, 0
      .print "#{v.ammo}/30", 10 + (i - 1) * 74 - 5 + 32 + sprite\getWidth! / 2 - 5, love.graphics.getHeight! - 74 - 5 + 32 + sprite\getHeight! / 2 if v.type == "gun"

    text = ""
    if game.new_wave
      text = "#{string.format "%02.2f", game.t} SECONDS UNTIL NEXT WAVE"
    else
      text = "WAVE: #{game.wave}"

    .setColor 200, 200, 200
    .rectangle "fill", .getWidth! / 2 - (.getFont!\getWidth text) / 2 - 5, 15, (.getFont!\getWidth text) + 5, 20

    .setColor 0, 0, 0
    .print text, .getWidth! / 2 - (.getFont!\getWidth text) / 2, 20


----------------------------------
-- load level from image data
----------------------------------
game.map_stuff = {
  "player": {r: 255, g: 0,   b: 0}
  "sheep":  {r: 0,   g: 255, b: 0}
  "enemy":  {r: 0,   g: 0,   b: 255}
}

game.load_wave = ->
  with game
    .enemies = {}

    for i = 1, .wave * 3
      thug = .pool[(i + .wave * 3) % #.pool]

      thug\reset! if thug.dead -- also adds to world

      world\update thug, (math.random 0, .world_w), math.random 0, .world_h

      table.insert .enemies, thug
      table.insert .game_objects, thug

      .wave_thugs += 1

game.load_level = (path) ->
  with game
    .enemies = {}

    image = love.image.newImageData path

    for x = 1, image\getWidth!
      for y = 1, image\getHeight!

        rx, ry = x - 1, y - 1
        r, g, b = image\getPixel rx, ry

        for k, v in pairs .map_stuff
          if r == v.r and g == v.g and b == v.b
            .make_entity k, .scale * rx, .scale * ry

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
      ----------------------------------
      -- dirty hack plz
      ----------------------------------
      table.insert game.sheep, player -- lel

    when "sheep"
      sheep = Sheep x, y, {game.player}
      table.insert game.game_objects, sheep
      table.insert game.sheep,        sheep

    when "enemy"
      enemy = Enemy x, y, game.sheep
      table.insert game.game_objects, enemy
      table.insert game.enemies,      enemy

      game.wave_thugs += 1

love.mousepressed = (x, y, button) ->
  with game
    for g in *.game_objects
      g\mouse_press x, y, button if g.mouse_press

love.keypressed = (key) ->
  with game
    for g in *.game_objects
      g\key_press key if g.key_press

game
