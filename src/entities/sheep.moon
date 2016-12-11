class
  ----------------------------------
  -- @leaders:
  -- list of game objects to run from
  ----------------------------------
  new: (@x, @y, @leaders={}) =>
    @sprite = game.sprites.sheep
    @w, @h  = @sprite\getWidth!, @sprite\getHeight! * 0.5

    @dx = 0
    @dy = 0

    @frc = 0.15
    @acc = 25

    @type  = "sheep"

    @dir_t = 3     -- seconds between dir change
    @t     = 0     -- dynamic timer thingy
    @lead  = false -- being herded ...
    @a     = math.random 0, 360 -- angle in which to move

    ----------------------------------
    -- can die
    ----------------------------------
    @enemy = true
    @dead  = false
    @naked = false

    @grow_time = 10
    @grow_t    = 0

    @hor_dir = 1

    world\add @, @x, @y, @w, @h

  update: (dt) =>
    return if @dead

    if @naked
      @grow_t -= dt

      if @grow_t <= 0
        @naked = false
        @sprite = game.sprites.sheep

    @lead = false
    @t   += dt
    for t, i in *@leaders
      a = math.atan2 @y - t.y, @x - t.x
      d = math.sqrt (@x - t.x)^2 + (@y - t.y)^2

      unless d > 80
        @lead = true

        @dx += (dt * (@acc * math.cos a) / (d * 0.05)) / #@leaders
        @dy += (dt * (@acc * math.sin a) / (d * 0.05)) / #@leaders

    unless @lead
      if @t >= @dir_t
        @a = math.random 0, 360 -- random angle
        @t = 0

      @dx += dt * (@acc / 15) * math.cos @a
      @dy += dt * (@acc / 15) * math.sin @a

    @hor_dir = math.sign @dx unless 0 == math.sign @dx

    @dx -= (@dx / @frc) * dt
    @dy -= (@dy / @frc) * dt

    @x, @y, @cols = world\move @, @x + @dx, @y + @dy

    for c, i in *@cols
      unless c.normal.y == 0
         @dy = 0
      else
        unless c.normal.x == 0
          @dx = 0

  cut: =>
    unless @naked
      @sprite = game.sprites.sheep_cut
      @grow_t = @grow_time

      @naked = true

      return 100 -- bitcoins
    else
      @dead   = true
      @sprite = game.sprites.sheep_cut_dead

      for i, v in ipairs game.sheep
        table.remove game.sheep, i if v == @

      @update = nil
      world\remove @

      game.sounds.scream\play!

      0

  die: =>
    @dead   = true
    @sprite = game.sprites.sheep_dead

    for i, v in ipairs game.sheep
      table.remove game.sheep, i if v == @

    @update = nil
    world\remove @

    game.sounds.scream\play!

  draw: =>
    with love.graphics
      .setColor 255, 255, 255
      .draw @sprite, @x, @y + @h / 2, 0, -@hor_dir, 1, @w / 2, @h / 2
