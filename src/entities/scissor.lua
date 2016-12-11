do
  local _class_0
  local _base_0 = {
    update = function(self, dt)
      if not (self.dir == -1) then
        self.x = self.mother.x + self.ox
      end
      if not (self.dir == 1) then
        self.x = self.mother.x + self.ox1 * self.dir
      end
      self.x = self.x + self.ro
      self.y = self.mother.y + self.oy
      self.rotation = math.lerp(self.rotation, 0, dt * 10)
      self.ro = math.lerp(self.ro, 0, dt * 10)
      if self.cut then
        self.sprite = game.sprites.scissor_cut
        self.t = self.t - dt
        if self.t <= 0 then
          self.sprite = game.sprites.scissor
          self.cut = false
        end
      end
    end,
    draw = function(self)
      do
        local _with_0 = love.graphics
        _with_0.setColor(255, 255, 255)
        _with_0.draw(self.sprite, self.x + self.w / 2, self.y + self.h / 2, self.rotation, 1 * self.dir, 1, self.w / 2, self.h / 2)
        return _with_0
      end
    end,
    fire = function(self)
      if self.cut then
        return 
      end
      self.rotation = self.rotation - (0.75 * self.dir)
      self.ro = self.ro - (2 * self.dir)
      self.sprite = game.sprites.scissor_cut
      self.t = self.cut_time
      self.cut = true
      local _list_0 = game.sheep
      for _index_0 = 1, #_list_0 do
        local _continue_0 = false
        repeat
          local s, _ = _list_0[_index_0]
          if s == self.mother then
            _continue_0 = true
            break
          end
          local d = math.sqrt((self.x - (s.x + s.w / 4)) ^ 2 + (self.y - s.y) ^ 2)
          if d < s.w then
            local a = s:cut()
            return a
          end
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
      local _list_1 = game.enemies
      for _index_0 = 1, #_list_1 do
        local _continue_0 = false
        repeat
          local s, _ = _list_1[_index_0]
          if s == self.mother then
            _continue_0 = true
            break
          end
          local d = math.sqrt((self.x - (s.x + s.w / 4)) ^ 2 + (self.y - s.y) ^ 2)
          if d < s.h then
            local a = s:cut()
            return a
          end
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, ox, oy, ox1, oy1, mother)
      self.x, self.y, self.ox, self.oy, self.ox1, self.oy1, self.mother = x, y, ox, oy, ox1, oy1, mother
      self.sprite = game.sprites.scissor
      self.w, self.h = self.sprite:getWidth(), self.sprite:getHeight()
      self.cut_time = 0.35
      self.t = 0
      self.cut = false
      self.ro = 0
      self.rotation = 0
      self.dir = 1
      self.type = "scissor"
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
