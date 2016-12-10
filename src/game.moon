love.graphics.setBackgroundColor 255, 255, 255
----------------------------------
-- the game state
----------------------------------
export game = {
  game_objects: {}
  scale: 32
}

game.load = ->
  with game
    .load_level "assets/levels/room.png"

game.update = (dt) ->
  with game
    for g in *.game_objects
      g\update dt if g.update

game.draw = ->
  with game
    for g in *.game_objects
      g\draw! if g.draw
  ----------------------------------
  -- debug
  ----------------------------------
  fps = string.format "%07.2f", 1 / love.timer.getAverageDelta!
  mem = string.format "%013.4f", collectgarbage "count"

  love.graphics.setColor 0, 0, 0

  love.graphics.print "FPS: #{fps}", 0, 0
  love.graphics.print "MEM: #{mem}", 0, 16

----------------------------------
-- load level from image data
----------------------------------
game.map_stuff = {
  "player": {r: 255, g: 0, b: 0}
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


game.make_entity = (id, x, y) ->
  import Player from require "src/entities"

  switch id
    when "player"
      player = Player x, y, 21, 21 -- bad res
      ----------------------------------
      -- do things with player here ...
      ----------------------------------
      table.insert game.game_objects, player

game
