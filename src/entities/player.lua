do
  local _class_0
  local _base_0 = {
    update = function(self, dt)
      if love.keyboard.isDown("d") then
        self.dx = self.dx + (self.acc * dt)
      end
      if love.keyboard.isDown("a") then
        self.dx = self.dx - (self.acc * dt)
      end
      if love.keyboard.isDown("s") then
        self.dy = self.dy + (self.acc * dt)
      end
      if love.keyboard.isDown("w") then
        self.dy = self.dy - (self.acc * dt)
      end
      self.dx = self.dx - ((self.dx / self.frc) * dt)
      self.dy = self.dy - ((self.dy / self.frc) * dt)
      self.x, self.y, self.cols = world:move(self, self.x + self.dx, self.y + self.dy)
      local _list_0 = self.cols
      for _index_0 = 1, #_list_0 do
        local c, i = _list_0[_index_0]
        if not (c.normal.y == 0) then
          self.y = 0
        else
          if not (c.normal.x == 0) then
            self.x = 0
          end
        end
      end
      do
        local _with_0 = game
        local ww, wh = _with_0.camera:get_dimension()
        _with_0.camera.x = math.lerp(_with_0.camera.x, self.x - ww / 2, dt)
        _with_0.camera.y = math.lerp(_with_0.camera.y, self.y - wh / 2, dt)
      end
      if not (0 == math.sign(self.dx)) then
        self.hor_dir = math.sign(self.dx)
      end
    end,
    draw = function(self)
      love.graphics.setColor(255, 255, 255)
      return love.graphics.draw(self.sprite, self.x, self.y, 0, self.hor_dir, 1, self.w / 2, self.h / 2)
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
      self.sprite = love.graphics.newImage("assets/sprites/player/player_stand.png")
      self.w, self.h = self.sprite:getWidth(), self.sprite:getHeight()
      return world:add(self, self.x, self.y, self.w, self.h)
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
  return _class_0
end
