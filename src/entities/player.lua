do
  local _class_0
  local Gun
  local _base_0 = {
    update = function(self, dt)
      if love.keyboard.isDown("right") then
        self.dx = self.dx + (self.acc * dt)
      end
      if love.keyboard.isDown("left") then
        self.dx = self.dx - (self.acc * dt)
      end
      if love.keyboard.isDown("down") then
        self.dy = self.dy + (self.acc * dt)
      end
      if love.keyboard.isDown("up") then
        self.dy = self.dy - (self.acc * dt)
      end
      self.dx = self.dx - ((self.dx / self.frc) * dt)
      self.dy = self.dy - ((self.dy / self.frc) * dt)
      self.x, self.y, self.cols = world:move(self, self.x + self.dx, self.y + self.dy)
      local _list_0 = self.cols
      for _index_0 = 1, #_list_0 do
        local c, i = _list_0[_index_0]
        if not (c.normal.y == 0) then
          self.dy = 0
        else
          if not (c.normal.x == 0) then
            self.dx = 0
          end
        end
      end
      if not (0 == math.sign(self.dx)) then
        self.hor_dir = math.sign(self.dx)
      end
      do
        local _with_0 = game
        local wx, wy, ww, wh = _with_0.camera:getWorld()
        _with_0.camera.x = math.lerp(_with_0.camera.x, self.x, dt)
        _with_0.camera.y = math.lerp(_with_0.camera.y, self.y, dt)
      end
      self.gun:update(dt)
      self.gun.dir = self.hor_dir or 1
    end,
    cut = function(self)
      return print("how is this even possible?")
    end,
    draw = function(self)
      do
        local _with_0 = love.graphics
        _with_0.setColor(255, 255, 255)
        _with_0.draw(self.sprite, self.x + self.w / 2, self.y + self.h / 2, 0, self.hor_dir, 1, self.w / 2, self.h / 2)
        self.gun:draw()
        return _with_0
      end
    end,
    key_press = function(self, key)
      if key == "c" then
        return self.gun:fire()
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y)
      self.x, self.y = x, y
      self.dx = 0
      self.dy = 0
      self.frc = 0.15
      self.acc = 10
      self.sprite = game.sprites.player
      self.w, self.h = self.sprite:getWidth(), self.sprite:getHeight() * .5
      world:add(self, self.x, self.y, self.w, self.h)
      self.gun = Gun(self.x, self.y, self.w / 1.1, self.h / 1.1, self.w / 2.2, self.h / 1.1, self)
      self.health = 100
      self.ammo = self.gun.ammo
    end,
    __base = _base_0,
    __name = nil
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  Gun = require("src/entities/scissor")
  return _class_0
end
