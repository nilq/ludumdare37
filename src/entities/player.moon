class
  Gun = require "src/entities/gun"

  new: (@x, @y) =>
    @dx = 0
    @dy = 0

    @frc = 0.15
    @acc = 10
    ----------------------------------
    -- sprite stuff - res inference
    ----------------------------------
    @sprite = love.graphics.newImage "assets/sprites/player/player_stand.png"
    @w, @h  = @sprite\getWidth!, @sprite\getHeight! * .5

    world\add @, @x, @y, @w, @h
    @gun = Gun @x, @y, @w / 1.1, @h / 1.1, @w / 2.2, @h / 1.1, @ -- complete mess

  update: (dt) =>
    @dx += @acc * dt if love.keyboard.isDown "d"
    @dx -= @acc * dt if love.keyboard.isDown "a"

    @dy += @acc * dt if love.keyboard.isDown "s"
    @dy -= @acc * dt if love.keyboard.isDown "w"

    @dx -= (@dx / @frc) * dt
    @dy -= (@dy / @frc) * dt

    @x, @y, @cols = world\move @, @x + @dx, @y + @dy

    for c, i in *@cols
      unless c.normal.y == 0
         @dy = 0
      else
        unless c.normal.x == 0
          @dx = 0
    ----------------------------------
    -- sprite calculations
    ----------------------------------
    @hor_dir = math.sign @dx unless 0 == math.sign @dx
    ----------------------------------
    -- camera stuff
    ----------------------------------
    with game
      wx, wy, ww, wh = .camera\getWorld!

      .camera.x = math.lerp .camera.x, wx + @x + ww / 4, dt
      .camera.y = math.lerp .camera.y, wy + @y + wh / 4, dt

      @gun\update dt
      @gun.dir = @hor_dir or 1

  draw: =>
    with love.graphics
      .setColor 255, 255, 255
      .draw @sprite, @x + @w / 2, @y + @h / 2, 0, @hor_dir, 1, @w / 2, @h / 2

      @gun\draw!

  mouse_press: (x, y, button) =>
    @gun\fire!
