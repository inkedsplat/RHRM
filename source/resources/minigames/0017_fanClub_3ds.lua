--[[ FAN CLUB ]]--
--[[ ADDED BY INKEDSPLAT, ANIMATION BY MINENICE55 ]]--

function lminigame()
  img = {
    sheetSinger = newImageAssetFlipped("/fan club (3DS)/IdolAri.png"),
    sheetMonkey = newImageAssetFlipped("/fan club (3DS)/IdolCrowd.png"),
    sheetBg = newImageAssetFlipped("/fan club (3DS)/bg.png"),
  }
  for _,i in pairs(img) do
    i:setFilter("linear","linear")
  end
  quad = {
    stage = love.graphics.newQuad(2,2,340,164,img.sheetBg:getWidth(),img.sheetBg:getHeight()),
    stage2 = love.graphics.newQuad(346,2,340,164,img.sheetBg:getWidth(),img.sheetBg:getHeight()),
    degrade = love.graphics.newQuad(704,16,24,312,img.sheetBg:getWidth(),img.sheetBg:getHeight()),
    gurdur1 = love.graphics.newQuad(475,170,188,68,img.sheetBg:getWidth(),img.sheetBg:getHeight()),
    gurdur2 = love.graphics.newQuad(235,170,236,52,img.sheetBg:getWidth(),img.sheetBg:getHeight()),
    lights = love.graphics.newQuad(115,170,116,60,img.sheetBg:getWidth(),img.sheetBg:getHeight()),
    stairs = love.graphics.newQuad(2,170,109,116,img.sheetBg:getWidth(),img.sheetBg:getHeight()),
  }
  anim = {
    singer = newPieceAnimationGroup("/resources/gfx/fan club (3DS)/IdolAri.anim",img.sheetSinger,384,384),
    monkey = newPieceAnimationGroup("/resources/gfx/fan club (3DS)/IdolCrowd.anim",img.sheetMonkey,384,384),
    monkeyPlayer = newPieceAnimationGroup("/resources/gfx/fan club (3DS)/IdolCrowd.anim",img.sheetMonkey,384,384),
    monkeySystem = love.graphics.newParticleSystem( newImageAssetFlipped("/fan club (3DS)/particle1.png"), 50 ),
  }
  snd = {
    haiA = cue["fanClubAudienceHai"](),
    ka = cue["fanClubAudienceKamone1"](),
    mo = cue["fanClubAudienceKamone2"](),
    ne = cue["fanClubAudienceKamone3"](),
    jump = cue["fanClubAudienceKamone4"](),
  }
  for _,i in pairs(snd) do
    i:setVolume(0.5)
  end
  
  anim.singer:setAnimation(9)
  anim.monkey:setAnimation(13)
  anim.monkeyPlayer:setAnimation(13)
  monkeyY = 0
  monkeyVsp = 0
  monkeyYPlayer = 0
  monkeyVspPlayer = 0
  monkeyGrav = 1.25
  monkeyClapTimer = 0
  monkeyJumpPrep = false
  --anim.monkey:setAnimation(5)
  haiCount = 0
  
  anim.monkeySystem:setParticleLifetime(0.5,2)
  anim.monkeySystem:setEmissionRate(0)
  anim.monkeySystem:setLinearAcceleration( 0, 400, 0, 500 )
  anim.monkeySystem:setDirection(math.rad(-90))
  anim.monkeySystem:setSpread(math.rad(90))
  anim.monkeySystem:setSizeVariation(1)
  anim.monkeySystem:setSizes(1,1.5,1)
  anim.monkeySystem:setSpin( -10, 10 )
  anim.monkeySystem:setSpeed( 250, 500 )
  anim.monkeySystem:setPosition(0,128+64)
  anim.monkeySystem:stop()
  
  anim.playerSystem = anim.monkeySystem:clone()
end

function uminigame(dt)
  
  if beat == 10 then
    if anim.singer:getAnimation() == 9 then
      anim.singer:setAnimation(1)
    elseif anim.singer:getAnimation() == 13 then
      anim.singer:setAnimation(6)
    end
    
    if anim.monkey:getAnimation() == 13 or anim.monkey:getAnimation() == 1 then
      anim.monkey:setAnimation(1)
    end
    if anim.monkeyPlayer:getAnimation() == 13 or anim.monkeyPlayer:getAnimation() == 1 then
      anim.monkeyPlayer:setAnimation(1)
    end
  end
  for _,i in pairs(currentSounds) do
    if i.name == "hai" then
      anim.singer:setAnimation(3)
      haiCount = 0
    elseif i.name == "haiA" then
      anim.singer:setAnimation(4)
      anim.monkey:setAnimation(4)
      haiCount = haiCount+1
      snd.haiA:stop()
      snd.haiA:play()
      anim.monkeySystem:emit(5)
    end
    if i.name == "ooh" then
      anim.monkey:setAnimation(11)
      anim.monkeyPlayer:setAnimation(11)
      haiCount = 0
    end
    if i.name == "oohClap" then
      anim.monkey:setAnimation(4)
      haiCount = 99
      snd.haiA:stop()
      snd.haiA:play()
    end
    if i.name == "ka" then
      anim.singer:setAnimation(5)
    end
    if i.name == "mo" then
      anim.singer:setAnimation(7)
    end
    if i.name == "ne" then
      anim.singer:setAnimation(8)
    end
    if i.name == "kaA" then
      anim.singer:setAnimation(6)
      anim.monkey:setAnimation(4)
      haiCount = 0
      snd.ka:stop()
      snd.ka:play()
    end
    if i.name == "moA" then
      anim.singer:setAnimation(6)
      anim.monkey:setAnimation(4)
      snd.mo:stop()
      snd.mo:play()
    end
    if i.name == "neA" then
      anim.singer:setAnimation(6)
      anim.monkey:setAnimation(7)
      snd.ne:stop()
      snd.ne:play()
      
    end
    if i.name == "jump" then
      anim.singer:setAnimation(1)
      anim.monkey:setAnimation(9)
      monkeyVsp = -20
      jump = true
      snd.jump:stop()
      snd.jump:play()
    end
  end
  for _,i in pairs(currentHits) do
    if i.name == "neA" then
      anim.monkeyPlayer:setAnimation(7)
      monkeyJumpPrep = true
    end
  end
  anim.singer:update(dt)
  anim.monkey:update(dt)
  anim.monkeyPlayer:update(dt)
  
  anim.monkeySystem:update(dt)
  
  monkeyY = monkeyY+monkeyVsp
  if monkeyY >= 0 then
    monkeyY = 0
    --print(jump)
    if jump then
      jump = false
      anim.monkey:setAnimation(13)
    end
  else
    monkeyVsp = monkeyVsp+monkeyGrav
  end
  
  monkeyYPlayer = monkeyYPlayer+monkeyVspPlayer
  if monkeyYPlayer >= 0 then
    monkeyYPlayer = 0
    --print(jump)
    if jumpPlayer then
      jumpPlayer = false
      anim.monkeyPlayer:setAnimation(13)
    end
  else
    monkeyVspPlayer = monkeyVspPlayer+monkeyGrav
  end
  
  if anim.singer:animationEnd() then
    if anim.singer:getAnimation() == 1 then
      anim.singer:setAnimation(9)
    end
    if anim.singer:getAnimation() == 3 then
      anim.singer:setAnimation(10)
    end
    if anim.singer:getAnimation() == 4 then
      if haiCount < 4 then
        anim.singer:setAnimation(11)
      else
        anim.singer:setAnimation(1)
      end
    end
    if anim.singer:getAnimation() == 8 then
      anim.singer:setAnimation(12)
    end
    if anim.singer:getAnimation() == 6 then
      anim.singer:setAnimation(13)
    end
  end
  
  if anim.monkey:animationEnd() then
    --monkeys
    if anim.monkey:getAnimation() == 1 then
      anim.monkey:setAnimation(13)
    end
    if anim.monkey:getAnimation() == 5 then
      if haiCount < 4 then
        anim.monkey:setAnimation(14)
      else
        anim.monkey:setAnimation(13)
      end
    end
    if anim.monkey:getAnimation() == 4 then
      anim.monkey:setAnimation(5)
    end
    if anim.monkey:getAnimation() == 7 then
      anim.monkey:setAnimation(8)
    end
  end
  
  if input["pressA"] and anim.monkeyPlayer:getAnimation() ~= 8 then
    anim.monkeyPlayer:setAnimation(4)
  elseif input["releaseA"] and (anim.monkeyPlayer:getAnimation() == 8 or monkeyJumpPrep) then
    monkeyVspPlayer = -20
    jumpPlayer = true
    anim.monkeyPlayer:setAnimation(9)
    monkeyJumpPrep = false
  end
  
  if monkeyJumpPrep and (anim.monkeyPlayer:getAnimation() ~= 7 or anim.monkeyPlayer:getAnimation() ~= 8) then
    anim.monkeyPlayer:setAnimation(8)
  end
  
  if anim.monkeyPlayer:animationEnd() then
    --monkeys
    if anim.monkeyPlayer:getAnimation() == 1 then
      anim.monkeyPlayer:setAnimation(13)
    end
    if anim.monkeyPlayer:getAnimation() == 5 then
      if haiCount < 4 then
        anim.monkeyPlayer:setAnimation(14)
      else
        anim.monkeyPlayer:setAnimation(13)
      end
    end
    if anim.monkeyPlayer:getAnimation() == 4 then
      anim.monkeyPlayer:setAnimation(5)
    end
    if anim.monkeyPlayer:getAnimation() == 7 then
      anim.monkeyPlayer:setAnimation(8)
    end
  end
  
  if anim.monkeyPlayer:getAnimation() == 14 then
    monkeyClapTimer = monkeyClapTimer+dt
    if monkeyClapTimer > 0.4 then
      anim.monkeyPlayer:setAnimation(13)
    end
  else
    monkeyClapTimer = 0
  end
end

function dminigame()
  local stageOff = 64
  love.graphics.draw(img.sheetBg,quad.degrade,0,-128,0,view.width/24,view.width/312)
  love.graphics.draw(img.sheetBg,quad.stage2,view.width/2,view.height,0,5,2,330,124)
  love.graphics.draw(img.sheetBg,quad.stage2,view.width/2,view.height,0,-5,2,330,124)
  love.graphics.draw(img.sheetBg,quad.stage,view.width/2-1,96+stageOff,0,-2,2,330)
  love.graphics.draw(img.sheetBg,quad.stage,view.width/2+1,96+stageOff,0,2,2,330)
  setColorHex("ffffff",170)
  love.graphics.draw(img.sheetBg,quad.lights,view.width-116*2.5+3,64,0,2,2)
  love.graphics.draw(img.sheetBg,quad.lights,view.width-116*2.5+3-116*2+44,64+24,0,2,2)
  
  love.graphics.draw(img.sheetBg,quad.lights,(-116*2.5+3)*-1,64,0,-2,2)
  love.graphics.draw(img.sheetBg,quad.lights,(-116*2.5+3-116*2+44)*-1,64+24,0,-2,2)
  setColorHex("ffffff",255)
  love.graphics.draw(img.sheetBg,quad.gurdur2,view.width/2,48,0,2,2,236/2,52/2)
  love.graphics.draw(img.sheetBg,quad.gurdur2,view.width/2,128+32,0,2,2,236/2,52/2)
  love.graphics.draw(img.sheetBg,quad.lights,view.width-116*2,-64,0,3,3)
  love.graphics.draw(img.sheetBg,quad.lights,116*2,-64,0,-3,3)
  love.graphics.draw(img.sheetBg,quad.gurdur1,view.width/2-256,64,math.rad(-90),2,2,188/2,68/2)
  love.graphics.draw(img.sheetBg,quad.gurdur1,view.width/2+256,64,math.rad(-90),2,2,188/2,68/2)
  love.graphics.draw(img.sheetBg,quad.stairs,-12*2,110,0,2,2)
  love.graphics.draw(img.sheetBg,quad.stairs,view.width+12*2,110,0,-2,2)
  
  anim.singer:draw(view.width/2-(anim.singer:getWidth()/2)*1.25,-128+32+stageOff,0,1.25,1.25)
  
  local s = 1.5
  anim.monkey:draw((view.width/2-(anim.monkey:getWidth()/2)*s)-128,view.height-256-128-32+monkeyY,0,s,s)
  anim.monkey:draw((view.width/2-(anim.monkey:getWidth()/2)*s)-256,view.height-256-128-32+monkeyY,0,s,s)
  anim.monkey:draw((view.width/2-(anim.monkey:getWidth()/2)*s)-256-128,view.height-256-128-32+monkeyY,0,s,s)
  
  anim.monkey:draw((view.width/2-(anim.monkey:getWidth()/2)*s)+128,view.height-256-128-32+monkeyY,0,s,s)
  anim.monkey:draw((view.width/2-(anim.monkey:getWidth()/2)*s)+256,view.height-256-128-32+monkeyY,0,s,s)
  anim.monkey:draw((view.width/2-(anim.monkey:getWidth()/2)*s)+256+128,view.height-256-128-32+monkeyY,0,s,s)
  
  anim.monkey:draw((view.width/2-(anim.monkey:getWidth()/2)*s)-128-64,view.height-256-128-32+64+monkeyY,0,s,s)
  anim.monkey:draw((view.width/2-(anim.monkey:getWidth()/2)*s)-256-64,view.height-256-128-32+64+monkeyY,0,s,s)
  anim.monkey:draw((view.width/2-(anim.monkey:getWidth()/2)*s)-256-128-64,view.height-256-128-32+64+monkeyY,0,s,s)
  
  anim.monkey:draw((view.width/2-(anim.monkey:getWidth()/2)*s)+128+64,view.height-256-128-32+64+monkeyY,0,s,s)
  anim.monkeyPlayer:draw((view.width/2-(anim.monkey:getWidth()/2)*s)+256+64,view.height-256-128-32+64+monkeyYPlayer,0,s,s) --PLAYER
  anim.monkey:draw((view.width/2-(anim.monkey:getWidth()/2)*s)+256+128+64,view.height-256-128-32+64+monkeyY,0,s,s)
  
  love.graphics.draw(anim.monkeySystem,(view.width/2-(anim.monkey:getWidth()/2)*s)-128,view.height-256-128-32+monkeyY,0,s,s)
  love.graphics.draw(anim.monkeySystem,(view.width/2-(anim.monkey:getWidth()/2)*s)-256,view.height-256-128-32+monkeyY,0,s,s)
  love.graphics.draw(anim.monkeySystem,(view.width/2-(anim.monkey:getWidth()/2)*s)-256-128,view.height-256-128-32+monkeyY,0,s,s)
  
  love.graphics.draw(anim.monkeySystem,(view.width/2-(anim.monkey:getWidth()/2)*s)+128,view.height-256-128-32+monkeyY,0,s,s)
  love.graphics.draw(anim.monkeySystem,(view.width/2-(anim.monkey:getWidth()/2)*s)+256,view.height-256-128-32+monkeyY,0,s,s)
  love.graphics.draw(anim.monkeySystem,(view.width/2-(anim.monkey:getWidth()/2)*s)+256+128,view.height-256-128-32+monkeyY,0,s,s)
  
  love.graphics.draw(anim.monkeySystem,(view.width/2-(anim.monkey:getWidth()/2)*s)-128-64,view.height-256-128-32+64+monkeyY,0,s,s)
  love.graphics.draw(anim.monkeySystem,(view.width/2-(anim.monkey:getWidth()/2)*s)-256-64,view.height-256-128-32+64+monkeyY,0,s,s)
  love.graphics.draw(anim.monkeySystem,(view.width/2-(anim.monkey:getWidth()/2)*s)-256-128-64,view.height-256-128-32+64+monkeyY,0,s,s)
  
  love.graphics.draw(anim.monkeySystem,(view.width/2-(anim.monkey:getWidth()/2)*s)+128+64,view.height-256-128-32+64+monkeyY,0,s,s)
  love.graphics.draw(anim.monkeySystem,(view.width/2-(anim.monkey:getWidth()/2)*s)+256+64,view.height-256-128-32+64+monkeyYPlayer,0,s,s) --PLAYER
  love.graphics.draw(anim.monkeySystem,(view.width/2-(anim.monkey:getWidth()/2)*s)+256+128+64,view.height-256-128-32+64+monkeyY,0,s,s)
  
  --[[love.graphics.draw(anim.monkeySystem,(view.width/2-(anim.monkey:getWidth()/2)*s)-128,view.height-256-128-32)
  love.graphics.draw(anim.monkeySystem,(view.width/2-(anim.monkey:getWidth()/2)*s)-256,view.height-256-128-32)
  love.graphics.draw(anim.monkeySystem,(view.width/2-(anim.monkey:getWidth()/2)*s)-256-128,view.height-256-128-32)
  
  love.graphics.draw(anim.monkeySystem,(view.width/2-(anim.monkey:getWidth()/2)*s)+128,view.height-256-128-32)
  love.graphics.draw(anim.monkeySystem,(view.width/2-(anim.monkey:getWidth()/2)*s)+256,view.height-256-128-32)
  love.graphics.draw(anim.monkeySystem,(view.width/2-(anim.monkey:getWidth()/2)*s)+256+128,view.height-256-128-32)
  
  love.graphics.draw(anim.monkeySystem,(view.width/2-(anim.monkey:getWidth()/2)*s)-128-64,view.height-256-128-32+64)
  love.graphics.draw(anim.monkeySystem,(view.width/2-(anim.monkey:getWidth()/2)*s)-256-64,view.height-256-128-32+64)
  love.graphics.draw(anim.monkeySystem,(view.width/2-(anim.monkey:getWidth()/2)*s)-256-128-64,view.height-256-128-32+64)
  
  love.graphics.draw(anim.monkeySystem,(view.width/2-(anim.monkey:getWidth()/2)*s)+128+64,view.height-256-128-32+64)
  love.graphics.draw(anim.playerSystem,(view.width/2-(anim.monkey:getWidth()/2)*s)+256+64,view.height-256-128-32+64)
  love.graphics.draw(anim.monkeySystem,(view.width/2-(anim.monkey:getWidth()/2)*s)+256+128+64,view.height-256-128-32+64)]]
  --love.graphics.draw(anim.monkeySystem,view.width/2,view.height/2)
end

return {lminigame,uminigame,dminigame}