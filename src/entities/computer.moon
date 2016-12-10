class
  new: (@x, @y) =>
    @sprite = love.graphics.newImage "assets/sprites/misc/computer.png"
    @w, @h  = @sprite\getWidth!, @sprite\getHeight! * .5

    world\add @, @x, @y, @w, @h

  draw: =>
    with love.graphics
      .setColor 255, 255, 255
      .draw @sprite, @x, @y, 0, 1, 1, @w / 2, @h / 2
