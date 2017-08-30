local pieceAnimationGroup = {}
pieceAnimationGroup.__index = pieceAnimationGroup

function newPieceAnimationGroup(filename,image,w,h)
  local g = {}
  local file = love.filesystem.newFile(filename)
  if file:open('r') then
    str = file:read()
    print(str)
    g = json.decode(str)
  end
  
  --[[local function readTable(t,step)
    step = step
    str = ""
    for n = 0,step do
      str = str.." "
    end
    for k,i in pairs(t) do
      print(str..tostring(k)..":"..tostring(i))
      if type(i) == "table" then
        readTable(i,step+1)
      end
    end
  end
  readTable(g,0)]]
  
  for _,i in pairs(g.sheet) do
    i.img = image
    for _,j in pairs(i.quad) do
      j.quad = love.graphics.newQuad(j.qx,j.qy,j.qw,j.qh,image:getWidth(),image:getHeight())
    end
  end
  
  g.frame = 0
  g.timer = 0
  g.currentAnim = 1
  g.canv = love.graphics.newCanvas(w,h)
  
  return setmetatable(g, pieceAnimationGroup)
end

function pieceAnimationGroup:update(dt)
  self.finished = false
  self.timer = self.timer+dt*1000
  if self.timer >= self.frameDuration then
    self.timer = 0
    self.frame = self.frame+1
    if self.frame > self.anim[self.currentAnim].endF then
      self.finished = true
      self.frame = self.anim[self.currentAnim].startF
    end
  end
end

function pieceAnimationGroup:animationEnd()
  return self.finished or false
end

function pieceAnimationGroup:draw(x,y,r,sx,sy,ox,oy,kx,ky)
  love.graphics.setCanvas(self.canv)
  love.graphics.clear()
  local offx = self.canv:getWidth()/2
  local offy = self.canv:getHeight()/2
  for _,i in pairs(self.sheet) do
    for _,j in pairs(i.quad) do
      if j.show[self.frame] then
        love.graphics.draw(i.img,j.quad,(j.x[self.frame] or 0)+offx,(j.y[self.frame] or 0)+offy,j.r[self.frame],1+j.sx[self.frame],1+j.sy[self.frame])
      end
    end
  end
  love.graphics.setCanvas(view.canvas)
  love.graphics.draw(self.canv,x,y,r,sx,sy,ox,oy,kx,ky)
  
  if self.debug then
    love.graphics.rectangle("line",y,x,self.canv:getWidth(),self.canv:getHeight())
  end
end

function pieceAnimationGroup:setAnimation(n)
  self.currentAnim = n
  self.timer = 0
  self.frame = self.anim[self.currentAnim].startF
end