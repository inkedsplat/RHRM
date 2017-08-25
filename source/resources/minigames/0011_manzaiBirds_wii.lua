function lminigame()
  img = {
    bg = newImageAssetFlipped("/manzai birds/bg.png"),
    sheet = newImageAssetFlipped("/manzai birds/sheet.png"),
    canv = love.graphics.newCanvas(view.width,view.height)
  }
  img.bg:setFilter("linear","linear")
  quad = {
    bg = love.graphics.newQuad(0,0,464,528,img.bg:getWidth(),img.bg:getHeight()),
    fg = love.graphics.newQuad(0,528,464,64,img.bg:getWidth(),img.bg:getHeight()),
    mircophone = love.graphics.newQuad(464,0,64,272,img.bg:getWidth(),img.bg:getHeight()),
    light = love.graphics.newQuad(528,0,224,592,img.bg:getWidth(),img.bg:getHeight()),
    audience = love.graphics.newQuad(0,592,960,96,img.bg:getWidth(),img.bg:getHeight()),
    p = {
      body = love.graphics.newQuad(0,0,64,96,img.sheet:getWidth(),img.sheet:getHeight()),
      foot = love.graphics.newQuad(128,0,48,48,img.sheet:getWidth(),img.sheet:getHeight()),
      eye = love.graphics.newQuad(0,96,32,16,img.sheet:getWidth(),img.sheet:getHeight()),
    },
    o = {
      body = love.graphics.newQuad(0,112,112,112,img.sheet:getWidth(),img.sheet:getHeight()),
      neckThing = love.graphics.newQuad(112,112,96,112,img.sheet:getWidth(),img.sheet:getHeight()),
      head = love.graphics.newQuad(0,112*2,64,64,img.sheet:getWidth(),img.sheet:getHeight()),
      knee = love.graphics.newQuad(64,272,32,32,img.sheet:getWidth(),img.sheet:getHeight()),
      foot = love.graphics.newQuad(208,144,64,64,img.sheet:getWidth(),img.sheet:getHeight()),
      tail = love.graphics.newQuad(224,64,48,64+16,img.sheet:getWidth(),img.sheet:getHeight()),
      wing = love.graphics.newQuad(160,64,48,48,img.sheet:getWidth(),img.sheet:getHeight()),
      eye = love.graphics.newQuad(96,272,32,32,img.sheet:getWidth(),img.sheet:getHeight()),
    }
  }
  anim = {
    p = {
      beak = newAnimationGroup(img.sheet),
      lwing = newAnimationGroup(img.sheet),
      rwing = newAnimationGroup(img.sheet),
    },
    o = {
      beak = newAnimationGroup(img.sheet),
    },
  }
  anim.p.beak:addAnimation("idle",64,0,64,32,1,100)
  
  anim.p.lwing:addAnimation("idle",128,48,32,48,1,100)
  anim.p.rwing:addAnimation("idle",128,48,32,48,1,100)

  anim.o.beak:addAnimation("talk",64,224,64,48,3,100)
  anim.o.beak:addAnimation("idle",64,224,64,48,1,100)
  anim.o.beak.img:setFilter("linear","linear")
end

function uminigame(dt)
  for _,i in pairs(currentSounds) do
    if i.name == "talk" then
      anim.o.beak:setAnimation("talk")
    end
    if i.name == "hai1" then
      anim.o.beak:setAnimation("idle")
    end
  end
  
  anim.o.beak:update(dt)
end  
  
function dminigame()
  local scale = 1.095
  love.graphics.draw(img.bg,quad.bg,0,0,0,scale,scale)
  love.graphics.draw(img.bg,quad.bg,view.width,0,0,-scale,scale)
  
  love.graphics.setCanvas(img.canv)
  setColorHex("000000")
  love.graphics.rectangle("fill",0,0,view.width,view.height)
  setColorHex("ffffff")
  love.graphics.draw(img.bg,quad.light,view.width/2-24,-128-64)
  love.graphics.draw(img.bg,quad.light,view.width/2+24,-128-64,0,-1,1)
  setColorHex("000000")
  love.graphics.rectangle("fill",0,0,view.width,45)
  setColorHex("ffffff")
  love.graphics.setCanvas(view.canvas)
  
  --RIGHT BIRD
  local yoff = -8
  
  local rot = 0
  local beakY = 0
  local eyeX = 0
  local eyeY = 0
  if anim.o.beak:getCurrentFrame() == 1 then
    rot = 4
    eyeX = 1
  elseif anim.o.beak:getCurrentFrame() == 2 then
    rot = 6
    beakY = -8
    eyeX = 2
  end
  
  love.graphics.draw(img.sheet,quad.o.foot,view.width/2+96-24,view.height/2+96-16-8,0,1,1,44,8)
  love.graphics.draw(img.sheet,quad.o.knee,view.width/2+96-24,view.height/2+96-16+beat/2+yoff,0,1,1,32/2,32/2)
  
  love.graphics.draw(img.sheet,quad.o.tail,view.width/2+96+96-16,view.height/2+32+beat/2+yoff+64,0,1,1,112/2,112/2)
  love.graphics.draw(img.sheet,quad.o.body,view.width/2+96,view.height/2+32+beat/2+yoff,0,1,1,112/2,112/2)
  love.graphics.draw(img.sheet,quad.o.wing,view.width/2+96+32,view.height/2+32+beat/2+yoff,0,1,1,16,16)
  
  love.graphics.draw(img.sheet,quad.o.foot,view.width/2+96+24,view.height/2+96-16-8,0,1,1,44,8)
  love.graphics.draw(img.sheet,quad.o.knee,view.width/2+96+24,view.height/2+96-16+beat/2+yoff,0,1,1,32/2,32/2)
  
  love.graphics.draw(img.sheet,quad.o.neckThing,view.width/2+96-16-beat/7,view.height/2+32+beat/2+yoff,0,1,1,112/2,112/2)
  love.graphics.draw(img.sheet,quad.o.head,view.width/2+96-16-beat/5,view.height/2+32+8+beat/2+yoff,0,1,1,112/2,112/2)
  
  love.graphics.draw(img.sheet,quad.o.eye,view.width/2+96-16-beat/5-16+eyeX,view.height/2+8+beat/2+yoff+eyeY,-math.rad(45/4),1,1,16,16)
  love.graphics.draw(img.sheet,quad.o.eye,view.width/2+96-16-32-12-beat/5+eyeX,view.height/2+5+beat/2+yoff+eyeY,math.rad(45/4),1,1,16,16)
  
  anim.o.beak:draw(view.width/2+96-64-beat/5,view.height/2+12+8+beat/2+yoff+beakY,math.rad(rot),1,1,32,16)
  --LEFT BIRD
  anim.p.rwing:draw(view.width/2-96+20,view.height/2+64+beat/1.8,0,-1,1,16,16)
  
  love.graphics.draw(img.sheet,quad.p.foot,view.width/2-96-10,view.height/2+96-8,0,1,1,48/2,16)
  love.graphics.draw(img.sheet,quad.p.foot,view.width/2-96+14,view.height/2+96-8,0,-1,1,48/2,16)
  
  love.graphics.draw(img.sheet,quad.p.body,view.width/2-96,view.height/2+48+beat/2,0,1,1,64/2,96/2)
  
  anim.p.lwing:draw(view.width/2-96-20,view.height/2+64+beat/1.8,0,1,1,16,16)
  
  love.graphics.draw(img.sheet,quad.p.eye,view.width/2-96-4,view.height/2+48-8+beat/2,0,1,1,32/2,16/2)
  love.graphics.draw(img.sheet,quad.p.eye,view.width/2-96+20,view.height/2+48-10+beat/2,0,-1,1,32/2,16/2)
  anim.p.beak:draw(view.width/2-96+12,view.height/2+48+beat/2,0,1,1,16,16)
  --FG
  love.graphics.draw(img.bg,quad.mircophone,view.width/2,-32,0,1,1,32)
  local off = 8
  love.graphics.draw(img.bg,quad.fg,off,0,0,scale,scale)
  love.graphics.draw(img.bg,quad.fg,view.width-off,0,0,-scale,scale)
  
  love.graphics.draw(img.bg,quad.audience,view.width/2+16,view.height,0,scale,scale,960/2,96)
  
  setColorHex("ffffff",50)
  love.graphics.draw(img.canv)
  setColorHex("ffffff",255)
end

return {lminigame,uminigame,dminigame}