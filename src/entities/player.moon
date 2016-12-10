class
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
    -- camera stuff
    ----------------------------------
    with game
      wx, wy, ww, wh = .camera\getWindow!

      .camera.x = math.lerp .camera.x, wx + @x + ww / 13, dt
      .camera.y = math.lerp .camera.y, wy + @y + wh / 13, dt
    ----------------------------------
    -- sprite calculations
    ----------------------------------
    @hor_dir = math.sign @dx unless 0 == math.sign @dx

  draw: =>
    with love.graphics
      .setColor 255, 255, 255
      .draw @sprite, @x, @y, 0, @hor_dir, 1, @w / 2, @h / 2
