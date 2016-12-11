class
  Scissor = require "src/entities/scissor"

  ----------------------------------
  -- @leaders:
  -- list of game objects to run from
  ----------------------------------
  new: (@x, @y, @leaders={}) =>
    @sprite = game.sprites.thug
    @w, @h  = @sprite\getWidth!, @sprite\getHeight! * .5

    @dx = 0
    @dy = 0

    @frc = 0.15
    @acc = 7

    @dir_t = 3     -- seconds between dir change
    @t     = 0     -- dynamic timer thingy
    @lead  = false -- being herded ...
    @a     = math.random 0, 360 -- angle in which to move

    @scissor = Scissor @x, @y, @w / 1.1, @h / 1.1, @w / 2.2, @h / 1.1, @ -- complete mess
    ----------------------------------
    -- enemy stuff
    ----------------------------------
    @enemy = true
    @dead  = false
    @naked = false

    ----------------------------------
    -- easter egg. easter egg right here.. idk
    ----------------------------------
    @grow_time = 100
    @grow_t    = 0

    @hor_dir = 1

    world\add @, @x, @y, @w, @h * 2

  reset: =>
    @dead  = false
    @naked = false
    @sprite = game.sprites.thug

    @leaders = {}

    world\add @, @x, @y, @w, @h * 2

  update: (dt) =>
    return if @dead

    if @naked
      @grow_t -= dt

      if @grow_t <= 0
        @naked = false
        @sprite = game.sprites.sheep

    @lead = false
    @t   += dt
    for t, _ in *game.sheep
      break if t == nil

      d = math.sqrt (@x - t.x)^2 + (@y - t.y)^2
      unless d > 80
        @a = math.atan2 @y - t.y, @x - (t.x + t.w / 4)
        @lead = true

        @dx -= (dt * (@acc * math.cos @a))
        @dy -= (dt * (@acc * math.sin @a))

        if d < 32
          @scissor\fire!

    unless @lead
      if @t >= @dir_t
        @a = math.random 0, 360 -- random angle
        @t = 0

      @dx += dt * (@acc) * math.cos @a
      @dy += dt * (@acc) * math.sin @a

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

    @scissor\update dt
    @scissor.dir = @hor_dir or 1

  die: =>
    @dead   = true
    @sprite = game.sprites.thug_dead

    for i, v in ipairs game.enemies
      table.remove game.enemies, i if v == @

    world\remove @
    @update = nil

    game.wave_thugs -= 1
    game.sounds.scream\play!

  cut: =>
    unless @naked
      @sprite = game.sprites.thug_cut
      @grow_t = @grow_time

      @naked = true

      return 10 -- bitcoins for le beard
    else
      @dead   = true
      @sprite = game.sprites.thug_cut_dead

      for i, v in ipairs game.enemies
        table.remove game.enemies, i if v == @

      world\remove @
      @update = nil

      game.wave_thugs -= 1
      game.sounds.scream\play!
      0

  draw: =>
    with love.graphics
      .setColor 255, 255, 255
      .draw @sprite, @x + @w / 2, @y + @h / 2, 0, @hor_dir, 1, @w / 2, @h / 2

    @scissor\draw!
