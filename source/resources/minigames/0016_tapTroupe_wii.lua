--[[ TAP TROUPE ]]--
--[[ ADDED BY INKEDSPLAT ]]--

function lminigame()
  img = {
    sheet = newImageAssetFlipped("tap troupe/sheet.png"),
  }
  quad = {
    you = love.graphics.newQuad(416,176,96,48,img.sheet:getWidth(),img.sheet:getHeight()),
    body = love.graphics.newQuad(432,224,80,128,img.sheet:getWidth(),img.sheet:getHeight()),
    head = love.graphics.newQuad(416,352,96,112,img.sheet:getWidth(),img.sheet:getHeight()),
  }
  legAnim = {
    l = newPieceAnimationGroup("/resources/gfx/tap troupe/leg.anim",img.sheet,128,1024),
    r = newPieceAnimationGroup("/resources/gfx/tap troupe/leg.anim",img.sheet,128,1024),
    pl = newPieceAnimationGroup("/resources/gfx/tap troupe/leg.anim",img.sheet,128,1024),
    pr = newPieceAnimationGroup("/resources/gfx/tap troupe/leg.anim",img.sheet,128,1024)
  }
  p = {
    side = true,
    bounce = 0
  }
  o = {
    bounce = 0
  }
  ready = false
  
  tapperAmount = 4
end

function uminigame(dt)
  for _,i in pairs(currentSounds) do
    if i.name == "countIn" then
      for _,i in pairs(legAnim) do
        i:setAnimation(1)
      end
      o.bounce = 20
      p.bounce = 20
    end
    if i.name == "tap1" then
      legAnim.l:setAnimation(5)
      legAnim.r:setAnimation(3)
      o.bounce = 20
    end
    if i.name == "tap2" then
      legAnim.l:setAnimation(3)
      legAnim.r:setAnimation(5)
      o.bounce = 20
    end
    if i.name == "ready" then
      ready = true
    end
    if i.name == "tap3b" then
      ready = false
    end
  end
  
  if input["pressA"] then
    if not ready then
      p.side = not p.side
      if p.side then 
        legAnim.pl:setAnimation(3)
        legAnim.pr:setAnimation(5)
      else 
        legAnim.pl:setAnimation(5)
        legAnim.pr:setAnimation(3)
      end
    end
    p.bounce = 20
    
  end
  
  for _,i in pairs(legAnim) do
    i:update(dt)
  end
  
  if p.bounce > 0 then
    p.bounce = math.floor(p.bounce/2)
  end
  if o.bounce > 0 then
    o.bounce = math.floor(o.bounce/2)
  end
  
  if legAnim.l:getAnimation() == 1 then
    if legAnim.l:animationEnd() then
      legAnim.l:setAnimation(2)
      legAnim.r:setAnimation(2)
      legAnim.pl:setAnimation(2)
      legAnim.pr:setAnimation(2)
    end
  end
  
  for _,i in pairs(legAnim) do
    if i:getAnimation() == 3 then
      if i:animationEnd() then
        i:setAnimation(4)
      end
    end
    if i:getAnimation() == 5 then
      if i:animationEnd() then
        i:setAnimation(6)
      end
    end
  end
end

function dminigame()
  setColorHex("ffffff")
  love.graphics.rectangle("fill",0,0,view.width,view.height)
  
  for i = 1,tapperAmount do
    local dist = 150
    local baseX = 128
    local rLegOffset = 60
    local y = view.height/2+512+128 -16
    
    local lanim = legAnim.l
    local ranim = legAnim.r
    if i == tapperAmount then
      lanim = legAnim.pl
      ranim = legAnim.pr
    end
    
    lanim:draw(baseX+dist*i,y,0,1,1,lanim:getWidth(),lanim:getHeight())
    ranim:draw(baseX-rLegOffset+dist*i,y,0,-1,1,ranim:getWidth(),ranim:getHeight())
  end
  
  setColorHex("000000")
  local barSize = 110
  love.graphics.rectangle("fill",0,0,view.width,barSize)
  love.graphics.rectangle("fill",0,view.height-barSize,view.width,barSize)
  love.graphics.ellipse("fill",0,view.height-barSize+32,256,128)
  
  setColorHex("ffffff")
  for i = 1,tapperAmount do
    local ii = i
    i = tapperAmount-i
    local dist = 512
    local baseX = -256
    local baseY = view.height-80+96
    local baseS = 1
    local distS = 0.1
    
    local headYoff = 96
    local headXoff = 32
    
    local bounce = o.bounce 
    if i == tapperAmount-1 then
      bounce = p.bounce
    end
    bounce = bounce/2
    
    love.graphics.draw(img.sheet,quad.body,baseX+(dist*(baseS-distS*ii)),baseY+bounce,0,baseS-distS*i,baseS-distS*i,0,128)
    love.graphics.draw(img.sheet,quad.head,baseX+(dist*(baseS-distS*ii))+headXoff*(baseS-distS*i),baseY-(headYoff*(baseS-distS*i))+bounce,0,baseS-distS*i,baseS-distS*i,96/2,112)
  end
end

return {lminigame,uminigame,dminigame}