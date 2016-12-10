----------------------------------
-- for player, only
----------------------------------
class
  new: (@x, @y, @ox, @oy, @ox1, @oy1, @mother) =>
    @sprite = game.sprites.scissor
    @w, @h  = @sprite\getWidth!, @sprite\getHeight!

    @cut_time = 0.35
    @t        = 0
    @cut      = false
    @ro       = 0

    @rotation = 0
    @dir = 1

    @type = "scissor"

  update: (dt) =>
    @x = @mother.x + @ox         unless @dir == -1
    @x = @mother.x + @ox1 * @dir unless @dir == 1
    @x += @ro

    @y = @mother.y + @oy

    @rotation = math.lerp @rotation, 0, dt * 10
    @ro       = math.lerp @ro, 0, dt * 10

    if @cut
      @sprite = game.sprites.scissor_cut

      @t  -= dt
      if @t <= 0
        @sprite = game.sprites.scissor
        @cut    = false

  draw: =>
    with love.graphics
      .setColor 255, 255, 255
      .draw @sprite, @x + @w / 2, @y + @h / 2, @rotation, 1 * @dir, 1, @w / 2, @h / 2

  fire: =>
    return if @cut

    @rotation -= 0.75 * @dir
    @ro       -= 2    * @dir

    @sprite = game.sprites.scissor_cut
    @t = @cut_time

    @cut = true

    for s, _ in *game.sheep
      break if s == @mother

      d = math.sqrt (@x - (s.x + s.w / 4))^2 + (@y - s.y)^2

      if d < s.w
        s\cut!
        return

    for s, _ in *game.enemies
      break if s == @mother

      d = math.sqrt (@x - (s.x + s.w / 4))^2 + (@y - s.y)^2

      if d < s.h
        s\cut!
        return
