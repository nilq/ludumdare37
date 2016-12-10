----------------------------------
-- for player, only
----------------------------------
class Bullet
  new: (@x, @y, @r, @force, @damage) =>
    @w, @h = 2, 2

    world\add @, @x, @y, @w, @h

  update: (dt) =>
    dx = dt * @force * math.cos @r
    dy = dt * @force * math.sin @r

    @x, @y, @cols = world\move @, @x + dx, @y + dy, -> "cross"

    for c, _ in *@cols
      if c.other.enemy
        c.other\die!

        for i, v in ipairs game.game_objects
          table.remove game.game_objects, i if v == @

        world\remove @ if world\hasItem @

  draw: =>
    with love.graphics
      .setColor 0, 0, 0
      .rectangle "fill", @x, @y, @w, @h

class
  new: (@x, @y, @ox, @oy, @ox1, @oy1, @mother) =>
    @sprite = game.sprites.gun
    @w, @h  = @sprite\getWidth!, @sprite\getHeight!

    @ammo   = 10
    @force  = 400
    @range  = 60  -- rotation stuff
    @damage = 50

    @ro = 0 -- recoil offset

    @rotation = 0

    @dir = 1

    @type = "gun"

  update: (dt) =>
    @x = @mother.x + @ox         unless @dir == -1
    @x = @mother.x + @ox1 * @dir unless @dir == 1
    @x += @ro

    @y = @mother.y + @oy

    @rotation = math.lerp @rotation, 0, dt * 10
    @ro       = math.lerp @ro, 0, dt * 10

  draw: =>
    with love.graphics
      .setColor 255, 255, 255
      .draw @sprite, @x + @w / 2, @y + @h / 2, @rotation, 1 * @dir, 1, @w / 2, @h / 2

  fire: =>
    unless @ammo <= 0
      bullet = Bullet @x + @w / 2, @y + @h / 2, @rotation, @force * @dir, @damage
      table.insert game.game_objects, bullet

      @rotation -= 0.75 * @dir
      @ro       -= 2    * @dir
      @ammo     -= 1
