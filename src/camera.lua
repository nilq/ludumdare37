do
  local _class_0
  local _base_0 = {
    set = function(self)
      do
        local _with_0 = love.graphics
        _with_0.setScissor(self.wx, self.wy, self.ww, self.wh)
        _with_0.push()
        _with_0.translate(self:get_width() * 2, self:get_height() * 2)
        _with_0.rotate(-self.r)
        _with_0.translate(-self:get_width() * 2, -self:get_height() * 2)
        _with_0.scale(1 / self.sx, 1 / self.sy)
        _with_0.translate(-self.x, -self.y)
        return _with_0
      end
    end,
    unset = function(self)
      love.graphics.pop()
      return love.graphics.setScissor()
    end,
    get_width = function(self)
      return love.graphics.getWidth() * self.sx
    end,
    get_height = function(self)
      return love.graphics.getHeight() * self.sy
    end,
    get_dimension = function(self)
      return self:get_width(), self:get_height()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, sx, sy, r, wx, wy, ww, wh)
      self.x, self.y, self.sx, self.sy, self.r, self.wx, self.wy, self.ww, self.wh = x, y, sx, sy, r, wx, wy, ww, wh
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
