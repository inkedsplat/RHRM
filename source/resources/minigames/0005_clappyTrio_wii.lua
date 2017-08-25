  local function lminigame()
    img = {
      sheet = newImageAssetFlipped("/Clappy Trio (WII)/sheet.png")
    } 
    quad = {
      bg = love.graphics.newQuad(0,0,480,540,img.sheet:getWidth(),img.sheet:getHeight()),
      hair = love.graphics.newQuad(352,736,112,80,img.sheet:getWidth(),img.sheet:getHeight()),
      body = love.graphics.newQuad(432,544,48,32,img.sheet:getWidth(),img.sheet:getHeight()),
      tail = love.graphics.newQuad(432,576,64,32,img.sheet:getWidth(),img.sheet:getHeight()),
      handLeft = love.graphics.newQuad(0,656,48,48,img.sheet:getWidth(),img.sheet:getHeight()),
      handRight = love.graphics.newQuad(48,656,48,48,img.sheet:getWidth(),img.sheet:getHeight()),
      panelSide = love.graphics.newQuad(96,656,32,80,img.sheet:getWidth(),img.sheet:getHeight()),
      panel = love.graphics.newQuad(96+16,656,16,80,img.sheet:getWidth(),img.sheet:getHeight()),
      text = love.graphics.newQuad(0,736,352,80,img.sheet:getWidth(),img.sheet:getHeight()),
      cableEnd = love.graphics.newQuad(128,672,16,16,img.sheet:getWidth(),img.sheet:getHeight()),
      cable = love.graphics.newQuad(128,672-16,16,16,img.sheet:getWidth(),img.sheet:getHeight()),
    }
    
    claps = 0
    
    lions = {}
    for i = 0, 2 do
      lions[i] = {}
      lions[i].phase = 0
      lions[i].headAnim = newAnimationGroup(img.sheet)
      lions[i].headAnim:addAnimation("all",0,544,80,64,5,0)
      lions[i].LegsAnim = newAnimationGroup(img.sheet)
      lions[i].LegsAnim:addAnimation("all",0,608,80,48,3,0)
      lions[i].ArmsAnim = newAnimationGroup(img.sheet)
      lions[i].ArmsAnim:addAnimation("clap",240,624,64,112,4,0)
      lions[i].xscale = 1
      
      if i == 2 then
        lions[i].player = true
      end
    end
    resetTime = 0
    happyTime = 0
    playerSuccess = false
  end
  
  local function uminigame(dt)
    happyTime = happyTime-dt
    
    for _,i in pairs(currentSounds) do
      if i.name == "prepare" then
        playerSuccess = false
        lions[0].phase = 1
        lions[1].phase = 1
        lions[2].phase = 1
        claps = 0
      end
      if i.name == "clap" then
        playerSuccess = false
        if lions[claps] then
          lions[claps].phase = 2
          lions[claps].ArmsAnim:setFrame(0)
          lions[claps].xscale = 0.7
          resetTime = i.time+((100)*(60000/data.bpm))/1000
        end
        claps = claps+1
      end
      if i.name == "clapp" then
        resetTime = i.time+((1)*(60000/data.bpm))/1000
      end
    end
    
    for _,i in pairs(lions) do
      if i.ArmsAnim:getCurrentFrame() ~= 2 then
        i.ArmsAnim:update(dt)
      end
      
      if i.phase == 0 and happyTime > 0 then
        if playerSuccess then
          i.headAnim:setFrame(3)
        else
          if not i.player then
            i.headAnim:setFrame(4)
          end
        end
      else
        i.headAnim:setFrame(i.phase)
      end
      
      if i.player then
        if input["pressB"] then
          i.phase = 0
        end
      end
      
      if beat >= 5 and i.phase == 0 then
        i.LegsAnim:setFrame(1)
      else
        i.LegsAnim:setFrame(i.phase)
      end
      
      if i.xscale < 1 then
        i.xscale = i.xscale+0.1 
      end
    end
    
    local hit
    for _,i in pairs(currentHits) do
      if i.name == "clapp" then
        if i.bearly then
          hit = 1
        else
          hit = 2
        end
      end
    end
    
    if input["pressA"] then
      if hit == 2 then
        playerSuccess = true
      elseif hit == 1 then
        playerSuccess = false
        gameSnd.bearlyHit:stop()
        gameSnd.bearlyHit:play()
      else
        if minigameTime > ((0.5)*(60000/data.bpm))/1000 then
          playerSuccess = false
          happyTime = (2)*(60000/data.bpm)/1000
          gameSnd.bearlyHit:stop()
          gameSnd.bearlyHit:play()
          misses = misses +1
        end
      end
      lions[2].phase = 2
      lions[2].ArmsAnim:setFrame(0)
      lions[2].xscale = 0.7
      resetTime = data.music:tell()+((1)*(60000/data.bpm))/1000
    end
    
    if data.music:tell() > resetTime then
      for _,i in pairs(lions) do
        if i.phase == 2 then
          if not i.player then happyTime = (2)*(60000/data.bpm)/1000 end
          i.phase = 0
          i.xscale = 1
          claps = 0
        end
      end
    end
  end
  
  local function dminigame()
    love.graphics.draw(img.sheet,quad.bg)
    love.graphics.draw(img.sheet,quad.bg,view.width,0,0,-1,1)
    
    local dist = 128+32
    local yoff = -32
    for k,i in pairs(lions) do
      local bodyY = beat/2
      if i.phase == 1 or i.LegsAnim:getCurrentFrame() == 1 then
        bodyY = 8
      elseif i.phase == 2 then
        bodyY = -8
      end
      local headY = 0
      if data.options.clappyTrio.headBeat then
        headY = beat
      end

      
      love.graphics.draw(img.sheet,quad.tail,view.width/2-dist+dist*k,view.height-96-8+yoff+bodyY,0,i.xscale,2-i.xscale,64)
      i.LegsAnim:draw(view.width/2-dist+dist*k,view.height-64+yoff,0,1,1,80/2,80/2)
      love.graphics.draw(img.sheet,quad.body,view.width/2-dist+dist*k,view.height-96-8+yoff+bodyY,0,i.xscale,2-i.xscale,48/2,32/2)
      
      i.headAnim:draw(view.width/2-dist+dist*k,view.height-128+yoff+bodyY+headY,0,1,1,80/2,80/2)
      love.graphics.draw(img.sheet,quad.hair,view.width/2-dist+dist*k,view.height-128-24+yoff+bodyY+headY,0,i.xscale,2-i.xscale,112/2,80/2)
      
      if i.phase == 2 then
        i.ArmsAnim:draw(view.width/2-dist+dist*k,view.height-96-4+yoff+bodyY,0,i.xscale,2-i.xscale,64/2,112)
      else
        local b = beat
        if i.phase ~= 0 then
          b = 0
        end
        love.graphics.draw(img.sheet,quad.handLeft,view.width/2-dist+dist*k-12-b/5,view.height-128+yoff+bodyY-b/1.5,0,i.xscale,2-i.xscale,48,48/2)
        love.graphics.draw(img.sheet,quad.handRight,view.width/2-dist+dist*k+8+b/5,view.height-128+yoff+bodyY-b/1.5,0,i.xscale,2-i.xscale,0,48/2)
      end
    end
    
    love.graphics.draw(img.sheet,quad.panelSide,view.width/2-256-64,128)
    love.graphics.draw(img.sheet,quad.panelSide,view.width/2+256+64,128,0,-1,1)
    love.graphics.draw(img.sheet,quad.panel,view.width/2-256-48,128,0,(256+64)*1.9/16,1)
    love.graphics.draw(img.sheet,quad.text,view.width/2,128+8,0,1,1,352/2)
    
    love.graphics.draw(img.sheet,quad.cableEnd,view.width/2-256,128)
    love.graphics.draw(img.sheet,quad.cable,view.width/2-256,128,0,1,20,0,16)
    
    love.graphics.draw(img.sheet,quad.cableEnd,view.width/2+256,128)
    love.graphics.draw(img.sheet,quad.cable,view.width/2+256,128,0,1,20,0,16)
  end
  
  return {lminigame,uminigame,dminigame}