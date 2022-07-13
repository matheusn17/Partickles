function love.load()
  
  love.graphics.setDefaultFilter("nearest", "nearest")
  math.randomseed(os.time())
  random = math.random
  floor = math.floor
  window_height = love.graphics.getHeight()
  window_width = love.graphics.getWidth()
  
  objs = {}  
  objs.particles = require("particles")
  
  chunk = require("chunk")
  chunk.init(100, 75)
  chunk.scale_x = window_width*(1/chunk.size_x)
  chunk.scale_y = (0.75 * window_height)*(1/chunk.size_y)
  chunk.image = love.graphics.newImage(chunk.imageData)
  
  gui = require("gui")
  gui:init()
  gui:update(objs)
  
  timer = 0
  pcounter = { total = chunk.size_x * chunk.size_y}
  print(pcounter.total)
  for k, p in pairs(objs.particles) do
    pcounter[k] = 0
  end
  
  for x = chunk.size_x, 1, -1 do
    for y = chunk.size_y, 1, -1 do
      pcounter[chunk.getParticle(x, y).name] = pcounter[chunk.getParticle(x, y).name] + 1
    end
  end
  
end

function love.update(dt)
  timer = timer + dt
  if timer > 0.04 then
    chunk.update(1)
    timer = 0
  end
end

function love.draw()
  local cra = gui.render_area
    
  love.graphics.draw(chunk.image, cra.x, cra.y, 0, cra.w / chunk.size_x * cra.sx, cra.h / chunk.size_y * cra.sy)
  love.graphics.rectangle("line", cra.x, cra.y, cra.w * cra.sx, cra.h * cra.sy)
  love.graphics.draw(gui.canvas, 0, 0 , 0, gui.scale_x, gui.scale_y)
  
  local pos_w = 0
  local w = 0
  for k, p in pairs(objs.particles) do
    w = pcounter[p.name] * window_width * (1/pcounter.total)
    love.graphics.setColor(p.color.r, p.color.g, p.color.b)
    love.graphics.rectangle("fill", pos_w, window_height - 10, w, 10)
    
    if pcounter[p.name] > 0 and p.name ~= "void" then
      love.graphics.print(pcounter[p.name], pos_w + (w/2), window_height - 30, 0,1,1, love.graphics.getFont():getWidth(p.name)/2)
    end
    
    pos_w = pos_w + w
  end
  
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.rectangle("line", 0, window_height - 10, window_width, 10)
end

function love.resize(w, h)
  window_height = h
  window_width = w
  
  gui.render_area.sx = window_width*(1/gui.render_area.w)
  gui.render_area.sy = window_height*(1/gui.render_area.h * 0.75)
  
  gui.scale_x = window_width*(1/gui.canvas:getWidth())
  gui.scale_y = window_height*(1/gui.canvas:getHeight())
end

function love.wheelmoved(x, y)
  if y > 0 then
    gui.pencil.radius = gui.pencil.radius + 5
    if gui.pencil.radius > 75 then gui.pencil.radius = 75 end
  elseif y < 0 then
    gui.pencil.radius = gui.pencil.radius - 5
    if gui.pencil.radius < 15 then gui.pencil.radius = 15 end
  end
  
  gui:update(objs)
end

function love.mousepressed(x, y, btn)
  -- Handle chunk interaction
  if btn == 1 then
    isPainting = true
    paintIt(x, y)
  end
    
  -- Handle buttons
  for key, button in pairs(gui.buttons)do
    if x >= button.x and x <= (button.x + button.w) and
       y >= button.y and y <= (button.y + button.h) then
        gui.pencil.selectedParticle = key
    end
  end
       
end

function love.mousemoved(x, y,dx, dy, istouch)
  paintIt(x, y)
  gui:update(objs)
end

function love.mousereleased(x, y, btn, istouch, presses)
  if btn == 1 then
    isPainting = false
  end
end

-- non Love2d functions

function paintIt(x, y)
  if isPainting then
    local cra = gui.render_area
    if x >= gui.render_area.x and x <= (gui.render_area.x + gui.render_area.w) and
      y >= gui.render_area.y and y <= (gui.render_area.y + gui.render_area.h) then  
        local p = gui.pencil
        local converted_x = p.x / (cra.w / chunk.size_x)
        local converted_y = p.y / (cra.h / chunk.size_y)
        local converted_radius = p.radius / (cra.h / chunk.size_y)
        local pcount = 0
        
        chunk.PaintWithPencil(converted_x - (converted_x%1), converted_y - (converted_y%1), converted_radius, objs.particles[p.selectedParticle])
      
    end
  end
end

