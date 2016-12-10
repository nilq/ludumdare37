class
  new: (@x, @y, @sx, @sy, @r, @wx,  @wy, @ww, @wh) =>
  set: =>
    with love.graphics
      .setScissor @wx, @wy, @ww, @wh

      .push!
      .translate @get_width! * 2, @get_height! * 2
      .rotate -@r
      .translate -@get_width! * 2, -@get_height! * 2

      .scale 1 / @sx, 1 / @sy
      .translate -@x, -@y

  unset: =>
    love.graphics.pop!
    love.graphics.setScissor!

  get_width: =>
    love.graphics.getWidth! * @sx

  get_height: =>
    love.graphics.getHeight! * @sy

  get_dimension: =>
    @get_width!, @get_height!
