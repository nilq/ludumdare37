class
  new: (@x, @y, @sx, @sy, @r) =>
  set: =>
    with love.graphics
      .push!
      .translate @get_width! * 2, @get_height! * 2
      .rotate -@r
      .translate -@get_width! * 2, -@get_height! * 2

      .scale 1 / @sx, 1 / @sy
      .translate -@x, -@y

  unset: =>
    love.graphics.pop!

  get_width: =>
    love.graphics.getWidth! * @sx

  get_height: =>
    love.graphics.getHeight! * @sy

  get_dimension: =>
    @get_width!, @get_height!
