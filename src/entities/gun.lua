local Bullet
do
  local _class_0
  local _base_0 = {
    update = function(self, dt)
      local dx = dt * self.force * math.cos(self.r)
      local dy = dt * self.force * math.sin(self.r)
      self.x, self.y, self.cols = world:move(self, self.x + dx, self.y + dy, function()
        return "cross"
      end)
      local _list_0 = self.cols
      for _index_0 = 1, #_list_0 do
        local c, _ = _list_0[_index_0]
        if c.other.enemy then
          c.other:die()
          for i, v in ipairs(game.game_objects) do
            if v == self then
              table.remove(game.game_objects, i)
            end
          end
          if world:hasItem(self) then
            world:remove(self)
          end
        end
      end
    end,
    draw = function(self)
      do
        local _with_0 = love.graphics
        _with_0.setColor(0, 0, 0)
        _with_0.rectangle("fill", self.x, self.y, self.w, self.h)
        return _with_0
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, r, force, damage)
      self.x, self.y, self.r, self.force, self.damage = x, y, r, force, damage
      self.w, self.h = 2, 2
      return world:add(self, self.x, self.y, self.w, self.h)
    end,
    __base = _base_0,
    __name = "Bullet"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Bullet = _class_0
end
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
      if not (self.ammo <= 0) then
        local bullet = Bullet(self.x + self.w / 2, self.y + self.h / 2, self.rotation, self.force * self.dir, self.damage)
        table.insert(game.game_objects, bullet)
        self.rotation = self.rotation - (0.75 * self.dir)
        self.ro = self.ro - (2 * self.dir)
        self.ammo = self.ammo - 1
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, ox, oy, ox1, oy1, mother)
      self.x, self.y, self.ox, self.oy, self.ox1, self.oy1, self.mother = x, y, ox, oy, ox1, oy1, mother
      self.sprite = game.sprites.gun
      self.w, self.h = self.sprite:getWidth(), self.sprite:getHeight()
      self.ammo = 30
      self.force = 400
      self.range = 60
      self.damage = 50
      self.ro = 0
      self.rotation = 0
      self.dir = 1
      self.type = "gun"
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
