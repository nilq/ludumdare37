do
  local _class_0
  local _base_0 = {
    update = function(self, dt)
      if self.dead then
        return 
      end
      if self.naked then
        self.grow_t = self.grow_t - dt
        if self.grow_t <= 0 then
          self.naked = false
          self.sprite = game.sprites.sheep
        end
      end
      self.lead = false
      self.t = self.t + dt
      local _list_0 = self.leaders
      for _index_0 = 1, #_list_0 do
        local t, i = _list_0[_index_0]
        local a = math.atan2(self.y - t.y, self.x - t.x)
        local d = math.sqrt((self.x - t.x) ^ 2 + (self.y - t.y) ^ 2)
        if not (d > 80) then
          self.lead = true
          self.dx = self.dx + ((dt * (self.acc * math.cos(a)) / (d * 0.05)) / #self.leaders)
          self.dy = self.dy + ((dt * (self.acc * math.sin(a)) / (d * 0.05)) / #self.leaders)
        end
      end
      if not (self.lead) then
        if self.t >= self.dir_t then
          self.a = math.random(0, 360)
          self.t = 0
        end
        self.dx = self.dx + (dt * (self.acc / 15) * math.cos(self.a))
        self.dy = self.dy + (dt * (self.acc / 15) * math.sin(self.a))
      end
      if not (0 == math.sign(self.dx)) then
        self.hor_dir = math.sign(self.dx)
      end
      self.dx = self.dx - ((self.dx / self.frc) * dt)
      self.dy = self.dy - ((self.dy / self.frc) * dt)
      self.x, self.y, self.cols = world:move(self, self.x + self.dx, self.y + self.dy)
      local _list_1 = self.cols
      for _index_0 = 1, #_list_1 do
        local c, i = _list_1[_index_0]
        if not (c.normal.y == 0) then
          self.dy = 0
        else
          if not (c.normal.x == 0) then
            self.dx = 0
          end
        end
      end
    end,
    cut = function(self)
      if not (self.naked) then
        self.sprite = game.sprites.sheep_cut
        self.grow_t = self.grow_time
        self.naked = true
        return 100
      else
        self.dead = true
        self.sprite = game.sprites.sheep_cut_dead
        for i, v in ipairs(game.sheep) do
          if v == self then
            table.remove(game.sheep, i)
          end
        end
        self.update = nil
        world:remove(self)
        game.sounds.scream:play()
        return 0
      end
    end,
    die = function(self)
      self.dead = true
      self.sprite = game.sprites.sheep_dead
      for i, v in ipairs(game.sheep) do
        if v == self then
          table.remove(game.sheep, i)
        end
      end
      self.update = nil
      world:remove(self)
      return game.sounds.scream:play()
    end,
    draw = function(self)
      do
        local _with_0 = love.graphics
        _with_0.setColor(255, 255, 255)
        _with_0.draw(self.sprite, self.x, self.y + self.h / 2, 0, -self.hor_dir, 1, self.w / 2, self.h / 2)
        return _with_0
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, leaders)
      if leaders == nil then
        leaders = { }
      end
      self.x, self.y, self.leaders = x, y, leaders
      self.sprite = game.sprites.sheep
      self.w, self.h = self.sprite:getWidth(), self.sprite:getHeight() * 0.5
      self.dx = 0
      self.dy = 0
      self.frc = 0.15
      self.acc = 25
      self.type = "sheep"
      self.dir_t = 3
      self.t = 0
      self.lead = false
      self.a = math.random(0, 360)
      self.enemy = true
      self.dead = false
      self.naked = false
      self.grow_time = 10
      self.grow_t = 0
      self.hor_dir = 1
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
