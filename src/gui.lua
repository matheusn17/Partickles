local gui = {
  scale_x = 1,
  scale_y = 1,
  canvas = love.graphics.newCanvas(),
  render_area = {
    x = 0,
    y = 0,
    w = love.graphics.getWidth(),
    h = love.graphics.getHeight() - (love.graphics.getHeight() * 0.25),
    sx = 1,
    sy = 1
  }
}

gui.buttons = {
  void = {
    particle = "void"
  },
  water = {
    particle = "water"
  },
  rock = {
    particle = "rock"
  },
  mud = {
    particle = "mud"
  },
  terrain = {
    particle = "terrain"
  },
  oil = {
    particle = "oil"
  }
}

gui.pencil = {
  x = 0,
  y = 0,
  radius = 25,
  selectedParticle = "water"
}

gui.init = function (self)
  local canvas_w = self.canvas:getWidth()
  local canvas_h = self.canvas:getHeight()

  local button_w = canvas_w/((2 * self:getButtonLength()) + 1)
  local pos_w = 0
  
  -- Particle BTNs
  for key, button in pairs(self.buttons) do
    pos_w = pos_w + button_w

      button.x = pos_w
      button.y = canvas_h - (canvas_h/20 * 3)
      button.w = button_w
      button.h = button_w
      
    pos_w = pos_w + button_w
  end
end

gui.getButtonLength = function (self)
  local c = 0
  for _, __ in pairs(self.buttons) do
      c = c + 1
  end
  return c
end

gui.update = function (self, objs)
  self:updateCanvas(objs)
end

gui.updateCanvas = function (self, objs)
  -- Set and clear the canvas
  love.graphics.setCanvas(self.canvas)
  love.graphics.clear()
  
  for key, button in pairs(self.buttons) do
   local pt = objs.particles[key]
   
    -- Draw Buttons 
    love.graphics.setColor(pt.color.r, pt.color.g, pt.color.b)
    love.graphics.rectangle("fill", button.x, button.y, button.w, button.h)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", button.x, button.y, button.w, button.h)
    love.graphics.print(pt.name, button.x + button.w/2, button.y - 20, 0,1,1, love.graphics.getFont():getWidth(pt.name)/2)
        
  end
  
  -- Draw pencil
  self.pencil.x = love.mouse.getX()
  self.pencil.y = love.mouse.getY()
  local pt = objs.particles[self.pencil.selectedParticle]
  
  love.graphics.setColor(pt.color.r, pt.color.g, pt.color.b, 0.75)
  love.graphics.circle("fill", self.pencil.x / gui.scale_x, self.pencil.y / gui.scale_y, self.pencil.radius)
  love.graphics.setColor(1,1,1)
  love.graphics.circle("line", self.pencil.x / gui.scale_x, self.pencil.y / gui.scale_y, self.pencil.radius)

  -- Finish canvas and return to default canvas
  love.graphics.setColor(1,1,1,1)
  love.graphics.setCanvas()
  
end

return gui
