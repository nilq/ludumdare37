do
  local _class_0
  local Scissor, Gun
  local _base_0 = {
    update = function(self, dt)
      if self.dead then
        self.t = self.t - dt
        if self.t <= 0 then
          do
            local _with_0 = game
            _with_0.sheep = { }
            _with_0.enemies = { }
            local _list_0 = _with_0.game_objects
            for _index_0 = 1, #_list_0 do
              local g = _list_0[_index_0]
              world:remove(g)
            end
            _with_0.game_objects = { }
            _with_0.wave = 1
            _with_0.wave_thugs = 0
            _with_0.load_level("assets/levels/room.png")
          end
        end
        return 
      end
      if self.naked then
        self.grow_t = self.grow_t - dt
        if self.grow_t <= 0 then
          self.naked = false
          self.sprite = game.sprites.player
        end
      end
      if love.keyboard.isDown("right") then
        self.hor_dir = 1
        self.dx = self.dx + (self.acc * dt)
      end
      if love.keyboard.isDown("left") then
        self.hor_dir = -1
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
        _with_0.camera.x = math.lerp(_with_0.camera.x, self.x, dt * 2)
        _with_0.camera.y = math.lerp(_with_0.camera.y, self.y, dt * 2)
      end
      self.tools[self.current]:update(dt)
      self.tools[self.current].dir = self.hor_dir or 1
    end,
    cut = function(self)
      if not (self.naked) then
        self.sprite = game.sprites.player_cut
        self.grow_t = self.grow_time
        self.naked = true
      else
        self.dead = true
        self.sprite = game.sprites.player_cut_dead
        return game.sounds.scream:play()
      end
    end,
    draw = function(self)
      do
        local _with_0 = love.graphics
        _with_0.setColor(255, 255, 255)
        _with_0.draw(self.sprite, self.x + self.w / 2, self.y + self.h / 2, 0, self.hor_dir, 1, self.w / 2, self.h / 2)
        self.tools[self.current]:draw()
        return _with_0
      end
    end,
    key_press = function(self, key)
      if self.dead then
        return 
      end
      if key == "c" then
        local a = self.tools[self.current]:fire()
        if a then
          self.currency = self.currency + a
        end
      elseif key == "z" then
        do
          local _with_0 = game
          if not (self.currency - _with_0.sheep_cost < 0) then
            self.currency = self.currency - _with_0.sheep_cost
            _with_0.make_entity("sheep", (math.random(0, _with_0.world_w)), math.random(0, _with_0.world_h))
          end
          return _with_0
        end
      elseif key == "x" then
        do
          local _with_0 = game
          if not (self.currency - _with_0.ammo_cost < 0) then
            self.currency = self.currency - _with_0.ammo_cost
            self.tools[1].ammo = self.tools[1].ammo + 5
            self.tools[1].ammo = math.clamp(0, 10, self.tools[1].ammo)
          end
          return _with_0
        end
      else
        local n = tonumber(key)
        if n then
          n = math.clamp(1, #self.tools, n)
          self.current = n
        end
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y)
      self.x, self.y = x, y
      self.dx = 0
      self.dy = 0
      self.currency = 0
      self.frc = 0.15
      self.acc = 10
      self.sprite = game.sprites.player
      self.w, self.h = self.sprite:getWidth(), self.sprite:getHeight() * .5
      world:add(self, self.x, self.y, self.w, self.h)
      self.tools = {
        [1] = Gun(self.x, self.y, self.w / 1.1, self.h / 1.1, self.w / 2.2, self.h / 1.1, self),
        [2] = Scissor(self.x, self.y, self.w / 1.1, self.h / 1.1, self.w / 2.2, self.h / 1.1, self)
      }
      self.current = 1
      self.dead = false
      self.naked = false
      self.grow_time = 10
      self.grow_t = 0
      self.restart_t = 4
      self.t = 0
      self.health = 100
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
  Scissor = require("src/entities/scissor")
  Gun = require("src/entities/gun")
  return _class_0
end
