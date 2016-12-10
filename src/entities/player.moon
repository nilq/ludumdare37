class
  new: (@x, @y, @w, @h) =>
    world\add @, @x, @y, @w, @h

    @dx = 0
    @dy = 0

    @frc = 0.15
    @acc = 7

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
         @y = 0
      else
        unless c.normal.x == 0
          @x = 0

  draw: =>
    love.graphics.setColor 255, 0, 0
    love.graphics.rectangle "fill", @x, @y, @w, @h
