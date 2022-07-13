chunk = {
  --vars
    image = nil,
    imageData = nil,
    particles = nil,
    size_x = 0,
    size_y = 0,
    
  --metadata
    cycles_count = 0
  }

chunk.init = function (sx, sy, default_particle)
      if default_particle == nil then
        default_particle = {
          name = "void",
          density = 0,
          color = {r = 0, g = 0, b = 0, a = 0},
          fluid = true,
          skip = true
        }
      end
      
      chunk.imageData = love.image.newImageData(sx, sy)
      chunk.size_x = sx
      chunk.size_y = sy
            
      chunk.particles = {}
      for x = 1, sx do
        chunk.particles[x] = {}
        for y = 1, sy do
          chunk.particles[x][y] = default_particle
        end
      end
    end
    
chunk.update = function (steps)  
      for i = 1, steps do
        for x = chunk.size_x, 1, -1 do
          for y = chunk.size_y, 1, -1 do
            chunk.updateParticle(x, y)
          end
        end
      end
      chunk.image = love.graphics.newImage(chunk.imageData)
    end
    
    
chunk.updateParticle = function (x, y)
      if((y+1) > chunk.size_y) then
        return nil
      end
  
      local p = chunk.getParticle(x, y)
      local dp = chunk.getParticle(x, y+1)
      
      if p.skip then
        return nil
      end
            
      if p.density > dp.density and dp.fluid then
        chunk.setParticle(x, y, dp)
        chunk.setParticle(x, y+1, p)
        return nil
      end
      
      local rand = floor(random(0, 100))
      
      local sig = 1

      if(rand >= 50) then
        sig = -1
      end
      
      
      local i = sig
      if chunk.size_x>=(x+i) and (x+i)>0 then 
        local rdp = chunk.getParticle(x+i, y+1)
        
        if rdp.fluid and rdp.density < p.density then
          chunk.setParticle(x, y, rdp)
          chunk.setParticle(x+i, y+1, p)
          
          -- There is no much memory usage
          -- Processing time blottleneck is negligible
          -- Safe to use recursive function
          chunk.updateParticle(x+i, y+1)
          return nil
        end
        
        i = i + sig
        while(chunk.size_x>=(x+i) and (x+i)>0) do
          rdp = chunk.getParticle(x+i, y+1)
          if rdp.fluid and p.fluid and rdp.density < p.density then
            chunk.setParticle(x, y, rdp)
            chunk.setParticle(x+i, y+1, p)
            chunk.updateParticle(x+i, y+1)
            return nil
          end
          i = i+sig
        end
        
        rdp = chunk.getParticle(x+sig, y) 
        if rdp.fluid and p.fluid then
          chunk.setParticle(x, y, rdp)
          chunk.setParticle(x+sig, y, p)
          return nil
        end    
      end      
    end
    
chunk.getParticle = function (x, y)
     return chunk.particles[x][y]
    end
  
chunk.setParticle = function (x, y, pt)
      chunk.particles[x][y] = pt
      chunk.imageData:setPixel(x-1, y-1, pt.color.r, pt.color.g, pt.color.b, pt.color.a)
    end
    
chunk.insertParticle = function (x, y, pt)
      chunk.setParticle(x, y, pt)
    end
    
chunk.PaintWithPencil = function (x, y, radius, pt)             
  local sqrt = math.sqrt
  local w = x + radius
  local h = y + radius
  x = x - radius
  y = y - radius
  --print(radius)
  for i = x, w do
    for j = y, h do
    -- relative x and y
    local rx = i - radius - x
    local ry = j - radius - y
      local pitagoras = ((rx*rx) + (ry*ry))/radius
      local isInRadius = pitagoras <= radius
        if isInRadius and
          (pcall(function () chunk.getParticle(i, j) end)) and
          (chunk.getParticle(i, j) ~= nil) and
          (chunk.getParticle(i, j) ~= pt) then
                      
            pcounter[pt.name] = pcounter[pt.name] + 1
            pcounter[chunk.getParticle(i, j).name] = pcounter[chunk.getParticle(i, j).name] - 1
            
            chunk.setParticle(i, j, pt)

        end
    end
  end 
end
    
return chunk
