function lminigame()
  img = {
    bg = newImageAssetFlipped("/Blue birds/bg.png"),
    birds = newImageAssetFlipped("/Blue birds/birds.png")
  }
  quad = {
    bgFence = love.graphics.newQuad(0,0,512,80,img.bg:getWidth(),img.bg:getHeight()),
    bgGradiant = love.graphics.newQuad(24,80,486,103,img.bg:getWidth(),img.bg:getHeight()),
    commanderTree = love.graphics.newQuad(144,0,96,32,img.birds:getWidth(),img.birds:getHeight()),
    you = love.graphics.newQuad(240,0,64,32,img.birds:getWidth(),img.birds:getHeight()),
  }
  anim = {
    commander = newAnimationGroup(img.birds),
    bird = newAnimationGroup(img.birds),
    player = newAnimationGroup(img.birds),
  }
  anim.commander:addAnimation("speak",0,80,48,80,2,0)
  anim.commander:addAnimation("idle",0,0,48,80,3,0)
  anim.commander:addAnimation("angry",96,80,64,80,1,0)
  
  anim.bird:addAnimation("stretch",0,288,112,160,3,50)
  anim.bird:addAnimation("peck",256,160,64+16,128,5,25)
  anim.bird:addAnimation("idle",0,160,64,128,4,0)
  
  anim.player:addAnimation("stretch",0,288,112,160,3,50)
  anim.player:addAnimation("peck",256,160,64+16,128,5,25)
  anim.player:addAnimation("idle",0,160,64,128,4,0)
  
  snd = {
    peck = love.audio.newSource("/resources/sfx/Blue birds/peckPlayer.ogg"),
    peck2 = love.audio.newSource("/resources/sfx/Blue birds/stretchPlayer1.ogg"),
    stretch = love.audio.newSource("/resources/sfx/Blue birds/stretchPlayer2.ogg")
  }
  snd.peck:setVolume(0.5)
  snd.peck2:setVolume(0.5)
  snd.stretch:setVolume(0.5)
  
  speak = 0
  stretchTimer = 0
  stretchTime = 0
  postStretchTime = 0
  postStretchTimeOthers = 0
  
  stretchPhase = 0
  angry = 0
end

function uminigame(dt)
  angry = angry - dt
  for _,i in pairs(currentSounds) do
    print(i.name)
    if i.name:find("speak") then
      speak = 5
    end
    
    if i.name == "peck" then
      anim.bird:setAnimation("peck")
      snd.peck:stop()
      snd.peck:play()
    end
    
    if i.name == "stretch1" then
      anim.bird:setAnimation("peck")
      snd.peck2:stop()
      snd.peck2:play()
      anim.bird:setFrame(0)
      stretchPhase = 1
    end
    if i.name == "stretch2" then
      anim.bird:setAnimation("stretch")
      postStretchTimeOthers = data.music:tell()+((1)*(60000/data.bpm))/1000
      stretchPhase = 2
      snd.stretch:stop()
      snd.stretch:play()
    end
  end
  
  local peckHit
  local stretchHit
  for _,i in pairs(currentHits) do
    if i.name == "peck" or i.name == "stretch1" then
      if i.bearly then
        peckHit = 1
      else
        peckHit = 2
      end
    end
    if i.name == "stretch2" then
      if i.bearly then
        stretchHit = 1
      else
        stretchHit = 2
      end
    end
  end
  
  if input["pressA"] then
    if peckHit == 2 then
    
    elseif peckHit == 1 then
      gameSnd.bearlyHit:stop()
      gameSnd.bearlyHit:play()
      angry = ((2)*(60000/data.bpm))/1000
    else
      if minigameTime > ((0.5)*(60000/data.bpm))/1000 then
        gameSnd.bearlyHit:stop()
        gameSnd.bearlyHit:play()
        misses = misses + 1
        angry = ((2)*(60000/data.bpm))/1000
      end
    end
    anim.player:setFrame(0)
    anim.player:setAnimation("peck")
    stretchTimer = 0
    stretchTime = data.music:tell()+((1)*(60000/data.bpm))/1000
  end
  if input["holdA"] then
    anim.player:setFrame(0)
    stretchTimer = stretchTimer+dt
  end
  if input["releaseA"] then
    if data.music:tell() > stretchTime-bearlyMargin then
      if stretchHit == 2 then
        
      elseif stretchHit == 1 then
        angry = ((2)*(60000/data.bpm))/1000
        gameSnd.bearlyHit:stop()
        gameSnd.bearlyHit:play()
        snd.stretch:stop()
        snd.stretch:play()
      else
        if minigameTime > ((0.5)*(60000/data.bpm))/1000 then
          angry = ((2)*(60000/data.bpm))/1000
          misses = misses+1
          gameSnd.bearlyHit:stop()
          gameSnd.bearlyHit:play()
          snd.stretch:stop()
          snd.stretch:play()
        end
      end
      anim.player:setAnimation("stretch")
      postStretchTime = data.music:tell()+((1)*(60000/data.bpm))/1000
    end
  end
  
  anim.bird:update(dt)
  anim.player:update(dt)
  if angry > 0 then
    anim.commander:setAnimation("angry")
    anim.commander:setFrame(0)
  elseif speak > 0 then
    speak = speak-1
    anim.commander:setAnimation("speak")
    anim.commander:setFrame(0)
  else 
    anim.commander:setAnimation("idle")
    anim.commander:setFrame(math.min(math.floor(beat/3),2))
  end
  
  if stretchPhase == 0 then
    if anim.bird:getCurrentAnimation() ~= "peck" then
      anim.bird:setFrame(math.min(math.floor(beat/2),3))
    else
      if anim.bird:getCurrentFrame() == 4 then
        anim.bird:setAnimation("idle")
      end
    end
  elseif stretchPhase == 1 then
    anim.bird:setAnimation("peck")
    anim.bird:setFrame(0)
  elseif stretchPhase == 2 then
    if anim.bird:getCurrentFrame() == 2 then
      anim.bird:setFrame(2)
    end
    if data.music:tell() > postStretchTimeOthers then
      anim.bird:setAnimation("idle")
      stretchPhase = 0
    end
  end
  
  if anim.player:getCurrentAnimation() == "idle" then
    anim.player:setFrame(math.min(math.floor(beat/2),3))
  elseif anim.player:getCurrentAnimation() == "peck" then
    if anim.player:getCurrentFrame() == 4 then
      anim.player:setAnimation("idle")
    end
  elseif anim.player:getCurrentAnimation() == "stretch" then
    if anim.player:getCurrentFrame() == 2 then
      anim.player:setFrame(2)
    end
    if data.music:tell() > postStretchTime then
      anim.player:setAnimation("idle")
    end
  end
  
end

function dminigame()
  love.graphics.draw(img.bg,quad.bgGradiant,0,view.height+128+64,math.rad(-90),2,50)
  love.graphics.draw(img.bg,quad.bgFence,-1024+256,256-32,0,2,2)
  love.graphics.draw(img.bg,quad.bgFence,1024*2-512-64,256-32,0,-2,2)
  
  love.graphics.draw(img.birds,quad.commanderTree,-16,128+64+beat/10,0,2,2)
  anim.commander:draw(64,128+64-140+beat/5,0,2,2,0)
  
  local x = 0
  local y = 0
  if anim.bird:getCurrentAnimation() == "peck" then
    x = -30
  elseif anim.bird:getCurrentAnimation() == "stretch" then
    x = -32
    y = -40
  end
  
  anim.bird:draw(512-110+x,128+96+y,0,2,2,0)
  anim.bird:draw(512+x,128+96+y,0,2,2,0)
  
  local x = 0
  local y = 0
  if anim.player:getCurrentAnimation() == "peck" then
    x = -30
  elseif anim.player:getCurrentAnimation() == "stretch" then
    x = -32
    y = -40
  end
  
  anim.player:draw(512+110+x,128+96+y,0,2,2,0)
  love.graphics.draw(img.birds,quad.you,512+110+8,128+64+16+256,0,2,2)
end

return {lminigame,uminigame,dminigame}