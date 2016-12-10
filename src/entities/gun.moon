----------------------------------
-- for player, only
----------------------------------
class Bullet
  new: (@x, @y, @r, @force, @damage) =>
    @w, @h = 2, 2

  update: (dt) =>
    @x += dt * @force * math.cos @r
    @y += dt * @force * math.sin @r

  draw: =>
    with love.graphics
      .setColor 0, 0, 0
      .rectangle "fill", @x, @y, @w, @h

class
  new: (@x, @y, @ox, @oy, @ox1, @oy1, @mother) =>
    @sprite = love.graphics.newImage "assets/sprites/guns/gun.png"
    @w, @h  = @sprite\getWidth!, @sprite\getHeight!

    @ammo   = 10
    @force  = 100
    @range  = 60  -- rotation stuff
    @damage = 50

    @rotation = 0

    @dir = 1

  update: (dt) =>
    @x = @mother.x + @ox unless @dir == -1
    @x = @mother.x + @ox1 * @dir unless @dir == 1

    @y = @mother.y + @oy

  draw: =>
    with love.graphics
      .setColor 255, 255, 255
      .draw @sprite, @x + @w / 2, @y + @h / 2, @rotation, 1 * @dir, 1, @w / 2, @h / 2

  fire: =>
    bullet = Bullet @x + @w / 2, @y + @h / 2, @rotation, @force, @damage
    table.insert game.game_objects, bullet

    @ammo -= 1
