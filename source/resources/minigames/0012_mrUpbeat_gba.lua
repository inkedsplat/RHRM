function lminigame()
  img = {
    sheet = newImageAssetFlipped("/mrUpbeat/sheet.png")
  }
  quad = {
    needle = {
      center = love.graphics.newQuad(16,0,16,16,img.sheet:getWidth(),img.sheet:getHeight()),
      handle = love.graphics.newQuad(0,0,16,16,img.sheet:getWidth(),img.sheet:getHeight()),
      head = love.graphics.newQuad(48,0,16,16,img.sheet:getWidth(),img.sheet:getHeight()),
      line = love.graphics.newQuad(32,0,16,16,img.sheet:getWidth(),img.sheet:getHeight()),
    },
    headWoosh = love.graphics.newQuad(64,0,32,16,img.sheet:getWidth(),img.sheet:getHeight()),
  }
  
  needle = {
    rot = -12,
    targetRot = 180+12,
    dir = 0
  }
  player = {
    bodyAnim = newAnimationGroup(img.sheet),
    headAnim = newAnimationGroup(img.sheet),
    lampAnim = newAnimationGroup(img.sheet),
    headX = 0,
    headY = 0,
    flip = 1,
    headWoosh = 0,
    nextHit = 0,
    targetFlip = 1
  }
  player.bodyAnim:addAnimation("step",0,16,32,32,3,50)
  player.bodyAnim:addAnimation("hurt",96,16,32,32,3,100)
  player.bodyAnim:addAnimation("hurt2",96,16+32,32,32,3,100)
  player.bodyAnim:addAnimation("idle",64,16,32,32,1,100)
  
  player.headAnim:addAnimation("expressions",0,48,16,16,2,0)
  
  player.lampAnim:addAnimation("blink",0,64,8,16,5,100)
  player.lampAnim:addAnimation("idle",24+8,64,8,16,1,0)
end

function uminigame(dt)
  for _,i in pairs(currentSounds) do
    if i.name == "metroR" then
      needle.rot = -12
      needle.targetRot = 180+12
      needle.dir = -1
      player.nextHit = i.time+((0.5)*(bpm/6000))
      player.targetFlip = -1
    end
    if i.name == "metroL" then
      needle.rot = 180+12
      needle.targetRot = -12
      needle.dir = 1
      player.nextHit = i.time+((0.5)*(bpm/6000))
      player.targetFlip = 1
    end
    if i.name == "ding" then
      needle.dir = 0
    end
    if i.name == "beep" or i.name == "step" then
      player.lampAnim:setAnimation("blink")
    end
  end
  --[[NEEDLE]]--
  local spd = 2500
  spd = spd*(bpm/60000)
  needle.rot = needle.rot+needle.dir*spd
  
  player.bodyAnim:update(dt)
  player.lampAnim:update(dt)
  player.headWoosh = player.headWoosh-dt*100
  
  local bearly = false
  local hit = false
  for _,i in pairs(currentHits) do
    if i.name == "step" then
      bearly = i.bearly
      hit = true
    end
  end
  
  if input["pressA"] then
    player.flip = (player.targetFlip or player.flip*-1)
    if bearly then
      player.bodyAnim:setAnimation("hurt")
      player.headAnim:setFrame(1)
    else
      player.bodyAnim:setAnimation("step")
      player.headAnim:setFrame(0)
    end
    if hit then
      player.nextHit = 0
    end
    player.headWoosh = 5
  end
  if player.nextHit ~= 0 then
    if data.music:tell() > player.nextHit+bearlyMargin*3 then
      
      if player.flip == player.targetFlip then
        player.bodyAnim:setAnimation("hurt2")
      else
        player.headWoosh = 5
        player.bodyAnim:setAnimation("hurt")
      end
      player.headAnim:setFrame(1)
      player.nextHit = 0
      
      player.flip = player.targetFlip
    end
  end
  
  if player.bodyAnim:getCurrentAnimation() ~= "idle" and player.bodyAnim:getCurrentFrame() == player.bodyAnim:getLength(player.bodyAnim:getCurrentAnimation())-1 then
    player.bodyAnim:setAnimation("idle")
  end
  if player.lampAnim:getCurrentAnimation() == "blink" and player.lampAnim:getCurrentFrame() == 4 then
    player.lampAnim:setAnimation("idle")
  end
  
  if player.bodyAnim:getCurrentFrame() == 0 then
    player.headX = -51
    player.headY = -24
  end
  if player.bodyAnim:getCurrentAnimation() == "hurt2" then
    if player.bodyAnim:getCurrentFrame() == 0 then
      player.headY = player.headY+3
    end
    if player.bodyAnim:getCurrentFrame() == 1 then
      player.headY = player.headY-3
    end
  end
end

function dminigame()
  setColorHex("f3f3f3")
  love.graphics.rectangle("fill",0,0,view.width,view.height)
  
  local rot = math.rad(needle.rot)
  local length = 256+96-16  
  love.graphics.draw(img.sheet,quad.needle.center,view.width/2,view.height-16,rot,3,3,8,8)
  love.graphics.draw(img.sheet,quad.needle.handle,view.width/2-math.cos(rot)*8,view.height-16-math.sin(rot)*8,rot,40,3,16,8)
  love.graphics.draw(img.sheet,quad.needle.line,view.width/2+math.cos(rot)*8,view.height-16+math.sin(rot)*8,rot,length/16,3,0,8)
  love.graphics.draw(img.sheet,quad.needle.head,view.width/2+math.cos(rot)*length,view.height-16+math.sin(rot)*length,rot,3,3,0,8)
  
  local yoff = -128
  
  player.bodyAnim:draw(view.width/2,view.height/2+yoff,0,3*player.flip,3,24,16)
  
  if player.headWoosh > 0 then
    love.graphics.draw(img.sheet,quad.headWoosh,view.width/2,view.height/2+yoff+player.headY-math.floor(10/3)*3,0,3*-player.flip,3,16-3,8)
  end
  
  player.lampAnim:draw(view.width/2+player.headX*player.flip,view.height/2+yoff+player.headY-math.floor(36/3)*3,0,3*player.flip,3,4,4)
  player.headAnim:draw(view.width/2+player.headX*player.flip,view.height/2+yoff+player.headY,0,3*player.flip,3,8,8)
end

return {lminigame,uminigame,dminigame}