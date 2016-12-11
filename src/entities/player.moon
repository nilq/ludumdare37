class
  Scissor = require "src/entities/scissor"
  Gun     = require "src/entities/gun"

  new: (@x, @y) =>
    @dx = 0
    @dy = 0

    @currency = 0

    @frc = 0.15
    @acc = 10
    ----------------------------------
    -- sprite stuff - res inference
    ----------------------------------
    @sprite = game.sprites.player
    @w, @h  = @sprite\getWidth!, @sprite\getHeight! * .5

    world\add @, @x, @y, @w, @h

    ----------------------------------
    -- Tools
    ----------------------------------
    @tools = {
      [1]: Gun     @x, @y, @w / 1.1, @h / 1.1, @w / 2.2, @h / 1.1, @ -- complete mess
      [2]: Scissor @x, @y, @w / 1.1, @h / 1.1, @w / 2.2, @h / 1.1, @ -- complete mess
    }

    @current = 1

    ----------------------------------
    -- cut stuff
    ----------------------------------
    @dead  = false
    @naked = false

    @grow_time = 10
    @grow_t    = 0

    ----------------------------------
    -- things with indicators
    ----------------------------------
    @health = 100

  update: (dt) =>
    return if @dead

    if @naked
      @grow_t -= dt

      if @grow_t <= 0
        @naked = false
        @sprite = game.sprites.player

    if love.keyboard.isDown "right"
      @hor_dir = 1
      @dx     += @acc * dt

    if love.keyboard.isDown "left"
      @hor_dir = -1
      @dx     -= @acc * dt

    if love.keyboard.isDown "down"
        @dy += @acc * dt

    if love.keyboard.isDown "up"
      @dy -= @acc * dt

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

      .camera.x = math.lerp .camera.x, @x, dt * 2
      .camera.y = math.lerp .camera.y, @y, dt * 2

    @tools[@current]\update dt
    @tools[@current].dir = @hor_dir or 1

  cut: =>
    unless @naked
      @sprite = game.sprites.player_cut
      @grow_t = @grow_time

      @naked = true
    else
      @dead   = true
      @sprite = game.sprites.player_cut_dead

  draw: =>
    with love.graphics
      .setColor 255, 255, 255
      .draw @sprite, @x + @w / 2, @y + @h / 2, 0, @hor_dir, 1, @w / 2, @h / 2

      @tools[@current]\draw!

  key_press: (key) =>
    return if @dead

    if key == "c"
      a = @tools[@current]\fire!

      @currency += a if a
    elseif key == "z" -- sheep
      with game
        unless @currency - .sheep_cost < 0
          @currency -= .sheep_cost

          .make_entity "sheep", (math.random 0, .world_w), math.random 0, .world_h
    elseif key == "x" -- ammo
      with game
        unless @currency - .ammo_cost < 0
          @currency -= .ammo_cost

          ----------------------------------
          -- tfw you code 'slam'
          ----------------------------------
          @tools[1].ammo += 5
    else
      n = tonumber key
      if n
        n = math.clamp 1, #@tools, n
        @current = n
