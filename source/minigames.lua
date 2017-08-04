function loadMinigames()
  loadMinigame = {}
  updateMinigame = {}
  drawMinigame = {}
  img = {}
  anim = {}
  quad = {}
  
  flow = data.options.karateka.startFlow

  --[[
    KARATEKA (GBA)
  ]]
  function lminigame()
    img = {
      lowerbody = love.graphics.newImage("/resources/gfx/karate man (GBA)/lowerbody.png"),
      objects = love.graphics.newImage("/resources/gfx/karate man (GBA)/objects.png"),
    }
    quad = {
      pot = love.graphics.newQuad(0,0,32,32,img.objects:getWidth(),img.objects:getHeight()),
      rock = love.graphics.newQuad(32,0,32,32,img.objects:getWidth(),img.objects:getHeight())
    }
    anim = {
      head = newAnimationGroup(love.graphics.newImage("/resources/gfx/karate man (GBA)/head.png")),
      upperBody = newAnimationGroup(love.graphics.newImage("/resources/gfx/karate man (GBA)/upperbody.png")),
      leftArm = newAnimationGroup(love.graphics.newImage("/resources/gfx/karate man (GBA)/upperbody.png")),
      flow = newAnimationGroup(love.graphics.newImage("/resources/gfx/karate man (GBA)/flow.png")),
    }
    snd = {
      ohYeah = love.audio.newSource("/resources/sfx/karate man (GBA)/ohYeah.ogg"),
      potHitFlow = love.audio.newSource("/resources/sfx/karate man (GBA)/potHitHighFlow.ogg"),
      potBreak = love.audio.newSource("/resources/sfx/karate man (GBA)/potBreak.ogg"),
    }
    anim.flow:addAnimation("anim",0,0,16,128,6,0)
    anim.head:addAnimation("happy",96,0,32,40,1,100)
    anim.head:addAnimation("very sad",64,0,32,40,1,100)
    anim.head:addAnimation("sad",32,0,32,40,1,100)
    anim.head:addAnimation("neutral",0,0,32,40,1,100)
    anim.upperBody:addAnimation("idle",0,0,50,50,1,100)
    anim.leftArm:addAnimation("punch",0,64,64,32,5,50)
    anim.leftArm:addAnimation("idle",0,64,64,32,1,100)
    surprised = 0
    
    pots = {}
    sounds = {}
    
    if not data.options.karateka.persistent then
      flow = data.options.karateka.startFlow
      print("NOT PERSISTENT")
      print(flow)
    end
  end
  function uminigame(dt)
    if not data.options.karateka.flow then
      flow = data.options.karateka.startFlow
    end
    
    anim.leftArm:update(dt)
    anim.flow:setFrame(math.min(flow,5))
    if surprised > 0 then
      surprised = surprised-2
    end
    
    if input["pressA"] then
      anim.leftArm:setAnimation("punch")
    end
    if anim.leftArm:getCurrentFrame() == 4 then
      anim.leftArm:setAnimation("idle")
    end
    
    for _,s in pairs(currentSounds) do
      if s.name == "pot throw" then
        local p = {
          rot = 0,
          y = -300,
          z = 10,
          vsp = 20*math.sqrt(119/data.bpm),
          x = 0,
          quad = quad.pot,
          flying = true,
          time = s.time+(64/128*(119/data.bpm))
        }
        table.insert(pots,p)
      end
      if s.name == "rock throw" then
        local p = {
          rot = 0,
          y = -300,
          z = 10,
          vsp = 20*math.sqrt(119/data.bpm),
          x = 0,
          quad = quad.rock,
          flying = true,
          time = s.time+(64/128*(119/data.bpm))
        }
        table.insert(pots,p)
      end
    end
    
    for k,i in pairs(sounds) do
      if data.music:tell() > i.time then
        --print("hi")
        i.sound:stop()
        i.sound:play()
        table.remove(sounds,k)
      end
    end
    
    for k,i in pairs(pots) do
      if i.fail then
        i.z = 0.75
          i.vsp = i.vsp-0.2
          if i.y > -100 then
            i.y = i.y + i.vsp 
            i.rot = i.rot+0.4*(data.bpm/119)
          end
      else
        if i.flying then
          i.vsp = i.vsp-0.55
          if i.y > -100 or i.z > 0 then
            i.y = i.y + i.vsp*(data.bpm/119)
            i.z = i.z-0.30*(data.bpm/119)
            i.x = i.x-6*(data.bpm/119)
          end
          
          local punch = 0
            local time = 0
            for _,i in pairs(currentHits) do
              if i.name == "punch" then
                time = i.time
                if i.bearly then
                  punch = 1
                else
                  punch = 2
                end
              end
            end
          if input["pressA"] then
            if time > i.time-bearlyMargin and time < i.time+bearlyMargin then
              if punch == 2 then
                i.flying = false
                i.vsp = 5
                anim.head:setAnimation("neutral")
                flow = flow+1
                if i.quad == quad.rock then
                  anim.head:setAnimation("happy")
                end
                if flow == 3 then
                  anim.head:setAnimation("happy")
                  local s = {
                    time = i.time+((0.5)*(60000/data.bpm))/1000,
                    sound = snd.ohYeah
                  }
                  table.insert(sounds,s)
                end
                if flow >= 5 and i.quad == quad.pot then
                  snd.potHitFlow:stop()
                  snd.potHitFlow:play()
                  i.vsp = 2
                  
                  local s = {
                    time = i.time+((1)*(60000/data.bpm))/1000,
                    sound = snd.potBreak
                  }
                  table.insert(sounds,s)
                end
              elseif punch == 1 then
                gameSnd.bearlyHit:stop()
                gameSnd.bearlyHit:play()
                i.fail = true
                i.vsp = 5
                anim.head:setAnimation("sad")
                flow = 0
              end
            end
          end
          --print(data.music:tell().." "..i.time.." "..tostring(data.music:tell() > i.time+bearlyMargin))
          if data.music:tell() > i.time+bearlyMargin then
            anim.head:setAnimation("very sad")
            surprised = 5
            flow = 0
          end
          
          if i.z <= -2 then
            table.remove(pots,k)
          end
        else
          i.z = 1
          if flow >= 5 then
            i.x = i.x+25
          else
            i.x = i.x+12
          end
          i.vsp = i.vsp-0.2
          i.y = i.y + i.vsp 
          i.rot = i.rot+0.4*(data.bpm/119)
           
          if i.x > view.width/2+30 then
            table.remove(pots,k)
          end
        end
      end
    end
  end
  function dminigame()
    setColorHex("f8e068")
    love.graphics.rectangle("fill",0,0,view.width,view.height)
    setColorHex("ffffff")
  
    local offsetx = 0
    if anim.leftArm:getCurrentFrame() > 2 and anim.leftArm:getCurrentFrame() <= 3 then
      offsetx = 2
      if flow >= 5 then
        offsetx = 4
      end
    end
    if anim.leftArm:getCurrentFrame() >= 1 and anim.leftArm:getCurrentFrame() <= 2 then
      offsetx = 4
      if flow >= 5 then
        offsetx = 6
      end
    end
    
    love.graphics.draw(img.lowerbody,128-32,view.height/2+16,0,2,2)
    
    if data.options.karateka.extremeBob then
      anim.leftArm:draw(128+48+offsetx/2,view.height/2-64+beat*10-(surprised),0,2,2)--
      anim.upperBody:draw(128-16+offsetx/2,view.height/2-64+beat*10-(surprised),0,2,2)--
      
      anim.head:draw(128+offsetx*1.5,view.height/2-128+beat*20-(surprised*2),0,2,2)--
    else
      anim.leftArm:draw(128+48+offsetx/2,view.height/2-64+beat/4-(surprised),0,2,2)
      anim.upperBody:draw(128-16+offsetx/2,view.height/2-64+beat/4-(surprised),0,2,2)
      
      anim.head:draw(128+offsetx*1.5+beat/5,view.height/2-128+beat/2-(surprised*2),0,2,2)
    end
    
    for _,i in pairs(pots) do
      love.graphics.draw(img.objects,i.quad,view.width/2+i.x-32,view.height/2-i.y,i.rot,1+i.z,math.max(1+i.z,0),16,16)
    end
    
    if data.options.karateka.flow then
      anim.flow:draw(32,view.height/2-128,0,2,2)
    end
    
  end
  loadMinigame[1] = lminigame
  updateMinigame[1] = uminigame
  drawMinigame[1] = dminigame
  --[[
    RYTHM TWEEZERS (GBA)
  ]]
  function lminigame()
    img = {
      onion = love.graphics.newImage("/resources/gfx/rhythm tweezers (GBA)/onion.png"),
      face = love.graphics.newImage("/resources/gfx/rhythm tweezers (GBA)/face.png"),
      roots = love.graphics.newImage("/resources/gfx/rhythm tweezers (GBA)/roots.png"),
    }
    quad = {
      mouth = {
        [0] = love.graphics.newQuad(82,32,82,48,img.face:getWidth(),img.face:getHeight()),
        [1] = love.graphics.newQuad(82*2,32,82,48,img.face:getWidth(),img.face:getHeight()),
        [2] = love.graphics.newQuad(0,32,82,48,img.face:getWidth(),img.face:getHeight()),
      },
      eye = {
        [0] = love.graphics.newQuad(6,0,16,32,img.face:getWidth(),img.face:getHeight()),
        [1] = love.graphics.newQuad(24,0,16,32,img.face:getWidth(),img.face:getHeight()),
        [2] = love.graphics.newQuad(43,0,16,32,img.face:getWidth(),img.face:getHeight()),
      },
      nose = {
        [0] = love.graphics.newQuad(80,0,64,32,img.face:getWidth(),img.face:getHeight()),
        [1] = love.graphics.newQuad(80+64,0,64,32,img.face:getWidth(),img.face:getHeight()),
      },
      moustache = {
        [0] = love.graphics.newQuad(208,0,32,32,img.face:getWidth(),img.face:getHeight()),
        [1] = love.graphics.newQuad(208+32,0,48,32,img.face:getWidth(),img.face:getHeight()),
      },
      pincette = {
        [0] = love.graphics.newQuad(0,64,32,48,img.roots:getWidth(),img.roots:getHeight()),
        [1] = love.graphics.newQuad(32,64,32,48,img.roots:getWidth(),img.roots:getHeight()),
      }
    }
    anim = {
      roots = newAnimationGroup(img.roots)
    }
    anim.roots:addAnimation("appear",32,0,16,32,4,100)
    
    snd = {
      pluckLong = love.audio.newSource("/resources/sfx/rhythm tweezers (GBA)/hairPluckLong2.ogg")
    }
    
    onion = {
      mouth = 0,
      eyes = 1,
      moustache = 0,
      twitch = 0
    }
    roots = {}
    fallingRoots = {}
    rootMaker = {
      x = view.width/2-(152*3)/2,
      y = 32*3,
      startX = view.width/2-(152*3)/2,
      startY = 32*3
    }

    
    phase = nil
    responseTime = 0
  end
  
  function uminigame(dt)
    for _,s in pairs(currentSounds) do
      if s.name == "call" then
        phase = "call"
        roots = {}
        responseTime = s.time+((4)*(60000/data.bpm))/1000
        rootMaker.x = rootMaker.startX
        rootMaker.y = rootMaker.startY
      end
    end
    
    for _,s in pairs(currentSounds) do
      --print(s.name)
      if s.name == "appear" then
        local r = {
          time = s.time+((4)*(60000/data.bpm))/1000,
          x = rootMaker.x,
          y = rootMaker.y,
          anim = newAnimationGroup(img.roots)
        }
        r.anim:addAnimation("idle",16,0,16,32,1,25)
        r.anim:addAnimation("appear",32,0,16,32,5,25)
        table.insert(roots,r)
      end
      if s.name == "appear long" then
        local r = {
          time = s.time+((4)*(60000/data.bpm))/1000,
          pluckTime = s.time+((4.5)*(60000/data.bpm))/1000,
          long = true,
          held = false,
          x = rootMaker.x,
          y = rootMaker.y,
          anim = newAnimationGroup(img.roots)
        }
        r.anim:addAnimation("idle",16,32,16,32,1,25)
        r.anim:addAnimation("held",16,0,16,32,1,25)
        r.anim:addAnimation("appear",32,32,16,32,5,50)
        table.insert(roots,r)
      end
    end
    
    if data.music:tell() > responseTime and phase == "call" then
      phase = "response"
      rootMaker.x = rootMaker.startX
      rootMaker.y = rootMaker.startY
    end
    if data.music:tell() > responseTime+((4)*(60000/data.bpm))/1000 and phase == "response" then
      phase = nil
      rootMaker.x = rootMaker.startX
      rootMaker.y = rootMaker.startY
    end
    
    if phase then
      --152*3 is the size of the onion
      rootMaker.x = rootMaker.x+(152*3*5.5)*(data.bpm/60000)
      rootMaker.y = math.sin((rootMaker.x-rootMaker.startX)/145)*(60*3)+rootMaker.startY

      --if phase == "response" then
        --remove roots
        for k,i in pairs(roots) do
          if i.held then
            i.anim:setAnimation("held")
            i.r = pointTowards(i.x,i.y,rootMaker.x,rootMaker.y-16)
            if input["releaseANY"] then
              i.held = false
              i.anim:setAnimation("idle")
            end
          end
          
          if data.music:tell() > i.time-margin and data.music:tell() < i.time+margin and input["pressANY"] then
            if i.long then
              i.held = true
            else
              table.remove(roots,k)
              onion.twitch = 2
              local r = {
                r = love.math.random(0,math.pi),
                anim = i.anim,
                x = i.x,
                y = i.y,
                vsp = 0
              }
              table.insert(fallingRoots,r)
            end
          end
          if i.long then
            if data.music:tell() > i.pluckTime and input["holdANY"] and i.held then
              table.remove(roots,k)
              
              local r = {
                r = love.math.random(0,math.pi),
                anim = i.anim,
                x = i.x,
                y = i.y,
                vsp = -3
              }
              table.insert(fallingRoots,r)
            end
          end
      end
    end
    
    for _,i in pairs(roots) do
      if not i.held then
        i.r = pointTowards(i.x,i.y,view.width/2-10,view.height/2-180)+math.rad(90)
      end
      i.anim:update(dt)
      if i.anim:getCurrentFrame() == 4 then
        i.anim:setAnimation("idle")
      end
    end
    
    for k,i in pairs(fallingRoots) do
      i.r = i.r+0.2
      i.vsp = i.vsp+1
      i.y = i.y+i.vsp
      
      if i.y > view.height then
        table.remove(fallingRoots,k)
      end
    end
    
    onion.twitch = onion.twitch-dt*10
  end
  
  function dminigame()
    setColorHex("f8f8f8")
    love.graphics.rectangle("fill",0,0,view.width,view.height)
    setColorHex("ffffff")
    love.graphics.draw(img.onion,view.width/2,view.height/2-30-math.max(onion.twitch,0)*4,0,3,3,img.onion:getWidth()/2,img.onion:getHeight()/2)
    
    if tableEmpty(roots) and phase == "response" then
      onion.mouth = 2
      onion.eyes = 0
      onion.moustache = 1
    else
      onion.moustache = 0
      if onion.twitch > 0 then
        onion.mouth = 1
        onion.eyes = 2
        onion.nose = 1
      else
        onion.mouth = 0
        onion.eyes = 1
        onion.nose = 0
      end
    end
    
    local qud = quad.nose[onion.nose or 0]
    local yoff = 180
    if onion.mouth == 2 then
      yoff = 190
    end
    love.graphics.draw(img.face,qud,view.width/2-10,view.height/2-yoff,0,3,3,64/2,32/2)
    
    qud = quad.mouth[onion.mouth]
    love.graphics.draw(img.face,qud,view.width/2-2,view.height/2-100,0,3,3,84/2,48/2)
    
    qud = quad.eye[onion.eyes]
    local xoff = -10
    local yoff = -250
    love.graphics.draw(img.face,qud,view.width/2-90+xoff+2,view.height/2+yoff,0,3,3,16/2,32/2)
    love.graphics.draw(img.face,qud,view.width/2+90+xoff,view.height/2+yoff,0,3,3,16/2,32/2)
    
    qud = quad.moustache[onion.moustache]
    local xoff = -100
    local yoff = -140
    if onion.mouth == 2 then
      yoff = -155
    end
    love.graphics.draw(img.face,qud,view.width/2-xoff+2,view.height/2+yoff,0,3,3,16/2,32/2)
    love.graphics.draw(img.face,qud,view.width/2+xoff,view.height/2+yoff,0,-3,3,16/2,32/2)
    
    for _,i in pairs(roots) do
      local scale = 0
      if i.held then
        scale = distance(i.x,i.y,rootMaker.x,rootMaker.y)/50
      end
      i.anim:draw(i.x,i.y,i.r or 0,3,3+scale,8,4)
    end
    for _,i in pairs(fallingRoots) do
      i.anim:draw(i.x,i.y,i.r or 0,3,3,8,16)
    end
    
    if input["holdANY"] then
      qud = quad.pincette[0]
    else
      qud = quad.pincette[1]
    end
    
    if phase == "response" then
      love.graphics.draw(img.roots,qud,rootMaker.x,rootMaker.y,pointTowards(rootMaker.x,rootMaker.y,view.width/2-10,view.height/2-180)+math.rad(90),3,3,16,-16)
    else
      love.graphics.draw(img.roots,qud,rootMaker.startX,rootMaker.startY,pointTowards(rootMaker.startX,rootMaker.startY,view.width/2-10,view.height/2-180)+math.rad(90),3,3,16,-32)
    end
    
    
    setColorHex("ff0000")
    --love.graphics.circle("fill",rootMaker.x,rootMaker.y,5)
  end
  
  loadMinigame[2] = lminigame
  updateMinigame[2] = uminigame
  drawMinigame[2] = dminigame
  
  function lminigame()
    img = {
      bg = love.graphics.newImage("/resources/gfx/Blue birds/bg.png"),
      birds = love.graphics.newImage("/resources/gfx/Blue birds/birds.png")
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
  
  loadMinigame[3] = lminigame
  updateMinigame[3] = uminigame
  drawMinigame[3] = dminigame
  
  function lminigame()
    img = {
      sheet = love.graphics.newImage("/resources/gfx/Fork Lifter/sheet.png")
    }
    quad = {
      bgGradiant = love.graphics.newQuad(784,848,14,168,img.sheet:getWidth(),img.sheet:getHeight()),
      handUp = love.graphics.newQuad(1,1,366,238,img.sheet:getWidth(),img.sheet:getHeight()),
      FingerUp = love.graphics.newQuad(89,441,86,70,img.sheet:getWidth(),img.sheet:getHeight()),
      
      handDown = love.graphics.newQuad(1,241,366,198,img.sheet:getWidth(),img.sheet:getHeight()),
      FingerDown = love.graphics.newQuad(1,441,86,70,img.sheet:getWidth(),img.sheet:getHeight()),
      
      handEat = love.graphics.newQuad(369,169,406,270,img.sheet:getWidth(),img.sheet:getHeight()),
      FingerEat = love.graphics.newQuad(777,249,158,70,img.sheet:getWidth(),img.sheet:getHeight()),
      
      fork = love.graphics.newQuad(937,249,86,310,img.sheet:getWidth(),img.sheet:getHeight()),
      
      orange = love.graphics.newQuad(729,465,46,46,img.sheet:getWidth(),img.sheet:getHeight()),
      orangeBubble = love.graphics.newQuad(777,321,70,70,img.sheet:getWidth(),img.sheet:getHeight()),
      orangeFlying = love.graphics.newQuad(777,393,38,46,img.sheet:getWidth(),img.sheet:getHeight()),
      
      handIdle = love.graphics.newQuad(697,561,102,182,img.sheet:getWidth(),img.sheet:getHeight()),
      handShoot = love.graphics.newQuad(577,561,102,182,img.sheet:getWidth(),img.sheet:getHeight()),
      bubble = love.graphics.newQuad(777,1,246,246,img.sheet:getWidth(),img.sheet:getHeight()),
    }
    peaCount = 0
    eat = false
    eatTime = 0
    eatTimeEnd = 0
    xEat = 0
    peas = {}
  end
  
  function uminigame(dt)
    for _,i in pairs(currentSounds) do
      if i.name == "flick" then
        local s = {
          stabTime = i.time+((2)*(60000/data.bpm))/1000,
          x = 128+128+8,
          y = 256-16,
          z = 0
        }
        table.insert(peas,s)
        shoot = true
        shootEnd = i.time+((0.25)*(60000/data.bpm))/1000
      end
      
      if i.name == "eatS" then
        eat = true
        eatTime = i.time+((0.5)*(60000/data.bpm))/1000
        eatTimeEnd = i.time+((1)*(60000/data.bpm))/1000
        xEat = 0
      end
    end
    
    for k,i in pairs(peas) do
      if data.music:tell() > i.stabTime-margin and data.music:tell() < i.stabTime+margin then
        if input["pressA"] then
          peaCount = peaCount+1
          print(peaCount)
          table.remove(peas,k)
        end
      end
    end
    
    if shoot then
      if data.music:tell() > shootEnd then
        shoot = false
      end
    end
    
    for k,i in pairs(peas) do
      local hsp = 3110
      local vsp = 900
      local zsp = 10
      i.x = i.x+hsp*(data.bpm/60000)
      i.y = i.y+vsp*(data.bpm/60000)
      i.z = i.z+zsp*(data.bpm/60000)
      if i.x > view.width then
        table.remove(peas,k)
      end
    end
  end
  
  function dminigame()
    setColorHex("ffffff")
    love.graphics.rectangle("fill",0,0,view.width,view.height)
    love.graphics.draw(img.sheet,quad.bgGradiant,0,view.height-(168*2),0,70,2)

    for _,i in pairs(peas) do
      love.graphics.draw(img.sheet,quad.orangeFlying,i.x,i.y,math.rad(90),i.z,i.z,38/2,46/2)
    end

    if eat then
      if data.music:tell() < eatTime then
        xEat = xEat+10000
      end
      if data.music:tell() > eatTime then
        xEat = xEat-10000
        peaCount = 0
      end
      if data.music:tell() > eatTimeEnd then
        eat = false
      end
      
      local x = math.sqrt(xEat)
      
      love.graphics.draw(img.sheet,quad.handEat,view.width+16+x,view.height/2-64-48,0,1,1,366,238/2)
      love.graphics.draw(img.sheet,quad.fork,view.width-128-64+x,view.height/2-128-48,math.rad(-90),1,1,86/2,310/2)
      love.graphics.draw(img.sheet,quad.FingerEat,view.width+16+20+x,view.height/2-16-8-64+10,0,1,1,366,238/2)
      
      for i = 1, peaCount do
        love.graphics.draw(img.sheet,quad.orange,view.width/2+156+256-12-12*i+x,view.height/2-128-16-8,math.rad(-90))
      end
    else
      if input["holdA"] then
        --DRAW HAND DOWN
        love.graphics.draw(img.sheet,quad.handDown,view.width+16,view.height/2-16-8,0,1,1,366,238/2)
        love.graphics.draw(img.sheet,quad.fork,view.width+8,view.height/2-128+48,0,1,1,366,238/2)
        love.graphics.draw(img.sheet,quad.FingerDown,view.width+16+10,view.height/2-16-8+64+10,0,1,1,366,238/2)
        
        for i = 1, peaCount do
          love.graphics.draw(img.sheet,quad.orange,view.width/2+128+14,view.height/2+64+4-12*i)
        end
      else
        --DRAW HAND UP
        love.graphics.draw(img.sheet,quad.handUp,view.width+16,view.height/2-64,0,1,1,366,238/2)
        love.graphics.draw(img.sheet,quad.fork,view.width+8,view.height/2-128,0,1,1,366,238/2)
        love.graphics.draw(img.sheet,quad.FingerUp,view.width+22+2,view.height/2+1,0,1,1,366,238/2)
        
        for i = 1, peaCount do
          love.graphics.draw(img.sheet,quad.orange,view.width/2+128+14,view.height/2+64+4-12*i-48)
        end
      end
    end
    
    if shoot then
      love.graphics.draw(img.sheet,quad.handShoot,128+64-10,128-10,math.rad(90+45),1,1,102/2,182/2)
    else
      love.graphics.draw(img.sheet,quad.handIdle,128+64-10,128-10,math.rad(90+45),1,1,102/2,182/2)
      love.graphics.draw(img.sheet,quad.orangeBubble,128+64+16,128+32,math.rad(90+45),1,1,70/2,70/2)
    end
    love.graphics.draw(img.sheet,quad.bubble,64,0)
  end
  
  loadMinigame[4] = lminigame
  updateMinigame[4] = uminigame
  drawMinigame[4] = dminigame
  
  function lminigame()
    img = {
      sheet = love.graphics.newImage("/resources/gfx/Clappy Trio (WII)/sheet.png")
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
  
  function uminigame(dt)
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
  
  function dminigame()
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

  loadMinigame[5] = lminigame
  updateMinigame[5] = uminigame
  drawMinigame[5] = dminigame

  function lminigame()
    img = {
      sheet = love.graphics.newImage("/resources/gfx/Lock step/sheet.png"),
      canv = love.graphics.newCanvas(view.width,view.height)
    }
    snd = {
      on = love.audio.newSource("/resources/sfx/Lock step/stepOn.ogg"),
      off = love.audio.newSource("/resources/sfx/Lock step/stepOff.ogg")
    }
    if data.options.lockStep.paletteSwap == "yes" then
      shaders = {
        palSwap = love.graphics.newShader("/resources/shaders/paletteSwap.fs")
      }
    end
    snd.on:setVolume(0.5)
    snd.off:setVolume(0.5)
    zoom = 2
    
    
    
    pAnim = newAnimationGroup(img.sheet)
    local anim = pAnim:addAnimation("onBeat",0,0,48,64,8,10)
    anim[4].duration = 250
    local anim = pAnim:addAnimation("offBeat",0,64,48,64,8,10)
    anim[4].duration = 250
    pAnim:addAnimation("countIn",0,128,48,80,5,30)
    pAnim:addAnimation("idle",0,0,48,64,1,0)
    
    
    oAnim = newAnimationGroup(img.sheet)
    local anim = oAnim:addAnimation("onBeat",0,0,48,64,8,10)
    anim[4].duration = 250
    local anim = oAnim:addAnimation("offBeat",0,64,48,64,8,10)
    anim[4].duration = 250
    oAnim:addAnimation("countIn",0,128,48,80,5,30)
    oAnim:addAnimation("idle",0,0,48,64,1,0)
  end
  
  function uminigame(dt)

    for _,i in pairs(currentSounds) do
      if i.name == "countIn" then
        oAnim:setAnimation("countIn")
        oAnim:setFrame(0)
        pAnim:setAnimation("countIn")
        pAnim:setFrame(0)
      end
      if i.name == "step on" then
        oAnim:setAnimation("onBeat")
        oAnim:setFrame(0)
        snd.on:stop()
        snd.on:play()
      end
      if i.name == "step off" then
        oAnim:setAnimation("offBeat")
        oAnim:setFrame(0)
        snd.off:stop()
        snd.off:play()
      end
      if i.name:find("zoom") then
        --print("HAI HAI HAI Z-ZOOM")
        if tonumber((i.name):sub(5)) then
          zoom = tonumber((i.name):sub(5))
          --print("NUMBAH "..tonumber((i.name):sub(5)))
        else
          if i.name == "zoom+" then
            zoom = zoom +1
          elseif i.name == "zoom-" then
            if zoom > 1 then
              zoom = zoom -1
            end
          end
        end
        --print(zoom)
      end
    end
    
    oAnim:update(dt)
    
    if oAnim:getCurrentAnimation() == "countIn" then
      if oAnim:getCurrentFrame() == 3 then
        oAnim:setFrame(3)
      end
    elseif oAnim:getCurrentFrame() == 7 then
      oAnim:setFrame(0)
      oAnim:setAnimation("idle")
    end
    
    local step = 0
    for _,i in pairs(currentHits) do
      if i.name == "step on" then
        step = 2
      end
      if i.name == "step off" then
        step = 4
      end
    end
    
    pAnim:update(dt)
    
    
    if input["pressA"] and step == 2 then
      pAnim:setAnimation("onBeat")
      pAnim:setFrame(0)
    end
    if input["pressA"] and step == 4 then
      pAnim:setAnimation("offBeat")
      pAnim:setFrame(0)
    end
    
    if pAnim:getCurrentAnimation() == "countIn" then
      if pAnim:getCurrentFrame() == 3 then
        pAnim:setFrame(3)
      end
    elseif pAnim:getCurrentFrame() == 7 then
      pAnim:setFrame(0)
      pAnim:setAnimation("idle")
    end
  end
  
  function dminigame()
    love.graphics.setCanvas(img.canv)
    
    setColorHex("000000",255)
    love.graphics.rectangle("fill",0,0,view.width,view.height)
    
    local xoff = 0
    local yoff = 16
    setColorHex("ffffff")
    local y = view.height/2+yoff
    local x = view.width/2-oAnim:getWidth()
    while x > -oAnim:getWidth() do
      oAnim:draw(x,y,0,1,1,oAnim:getWidth()/2,oAnim:getHeight()/2)
      x = x-oAnim:getWidth()
    end
    
    y = view.height/2+yoff
    x = view.width/2+oAnim:getWidth()
    while x < view.width+oAnim:getWidth() do
      oAnim:draw(x,y,0,1,1,oAnim:getWidth()/2,oAnim:getHeight()/2)
      x = x+oAnim:getWidth()
    end
    
    local loops = 1
    y = view.height/2-oAnim:getHeight()+yoff
    while y > 0 do 
      
      x = -oAnim:getWidth()/2*loops
      while x < view.width+oAnim:getWidth() do
        oAnim:draw(x,y,0,1,1,oAnim:getWidth()/2,oAnim:getHeight()/2)
        x = x+oAnim:getWidth()
      end
      loops = loops+1
      y = y-oAnim:getHeight()
    end
    
    local loops = 1
    y = view.height/2+oAnim:getHeight()+yoff
    while y < view.height+oAnim:getHeight() do 
      
      x = -oAnim:getWidth()/2*loops
      while x < view.width+oAnim:getWidth() do
        oAnim:draw(x,y,0,1,1,oAnim:getWidth()/2,oAnim:getHeight()/2)
        x = x+oAnim:getWidth()
      end
      loops = loops+1
      y = y+oAnim:getHeight()
    end
    
    --DRAW PLAYER
    pAnim:draw(view.width/2,view.height/2+yoff,0,1,1,pAnim:getWidth()/2,pAnim:getHeight()/2)
    
    --reset canvas
    love.graphics.setCanvas(view.canvas)
    
    --set shader 
    if data.options.lockStep.paletteSwap == "yes" then
      local col = data.options.lockStep.colors
      local colTable = {}
      for k,i in pairs(col) do
        colTable[k] = hex2rgb(i,true)
      end
      shaders.palSwap:sendColor("_colors",colTable["bg"],colTable["marcher0"],colTable["marcher1"],colTable["marcher2"],colTable["marcher2"])
      love.graphics.setShader(shaders.palSwap)
    end
    
    love.graphics.draw(img.canv,view.width/2,view.height/2,0,zoom,zoom,view.width/2,view.height/2)
    --reset shader
    love.graphics.reset()
    love.graphics.setCanvas(view.canvas)
  end
  
  loadMinigame[6] = lminigame
  updateMinigame[6] = uminigame
  drawMinigame[6] = dminigame
  
  function lminigame()
    img = {
      sheet = love.graphics.newImage("/resources/gfx/screw bots/sheet.png")
    }
    quad = {
      clawTop = love.graphics.newQuad(0,0,64,64,img.sheet:getWidth(),img.sheet:getHeight()),
      clawBottom = love.graphics.newQuad(64,0,48,48,img.sheet:getWidth(),img.sheet:getHeight()),
      clawCable = love.graphics.newQuad(64,48,16,16,img.sheet:getWidth(),img.sheet:getHeight()),
      claw = {
        [0] = love.graphics.newQuad(0,464,144,80,img.sheet:getWidth(),img.sheet:getHeight()),
        [1] = love.graphics.newQuad(0,464+80*1,144,80,img.sheet:getWidth(),img.sheet:getHeight()),
        [2] = love.graphics.newQuad(0,464+80*2,144,80,img.sheet:getWidth(),img.sheet:getHeight()),--love.graphics.newQuad(0,464+80*3,144,80,img.sheet:getWidth(),img.sheet:getHeight()),
        [3] = love.graphics.newQuad(0,464+80,1,1,img.sheet:getWidth(),img.sheet:getHeight()),--love.graphics.newQuad(0,464+80*4,144,80,img.sheet:getWidth(),img.sheet:getHeight()),
        [4] = love.graphics.newQuad(0,464+80,1,1,img.sheet:getWidth(),img.sheet:getHeight()),
        [5] = love.graphics.newQuad(0,464+80*3,144,80,img.sheet:getWidth(),img.sheet:getHeight()),
        [6] = love.graphics.newQuad(0,464+80*4,144,80,img.sheet:getWidth(),img.sheet:getHeight()),
        [7] = love.graphics.newQuad(0,464+80*5,144,80,img.sheet:getWidth(),img.sheet:getHeight()),
      },
      clawR = {
        [0] = love.graphics.newQuad(144,464,144,111,img.sheet:getWidth(),img.sheet:getHeight()),
        [1] = love.graphics.newQuad(144,464+111*1,144,111,img.sheet:getWidth(),img.sheet:getHeight()),
        [2] = love.graphics.newQuad(144,464+111*2,144,111,img.sheet:getWidth(),img.sheet:getHeight()),
        [3] = love.graphics.newQuad(144,464+111*3,144,111,img.sheet:getWidth(),img.sheet:getHeight()),
        [4] = love.graphics.newQuad(144,464+111*3,144,111,img.sheet:getWidth(),img.sheet:getHeight()),
        [5] = love.graphics.newQuad(144,464+111*4,144,111,img.sheet:getWidth(),img.sheet:getHeight()),
        [6] = love.graphics.newQuad(144,464+111*5,144,111,img.sheet:getWidth(),img.sheet:getHeight()),
        [7] = love.graphics.newQuad(144,464+111*6,144,111,img.sheet:getWidth(),img.sheet:getHeight()),
      },
      craneTop = love.graphics.newQuad(176,0,64,32,img.sheet:getWidth(),img.sheet:getHeight()),
      craneTopBottom = love.graphics.newQuad(240,16,176,32,img.sheet:getWidth(),img.sheet:getHeight()),
      craneTopMiddle = love.graphics.newQuad(240,0,176,16,img.sheet:getWidth(),img.sheet:getHeight()),
      craneBottom = love.graphics.newQuad(0,400,336,64,img.sheet:getWidth(),img.sheet:getHeight()),
      
      craneClaw1 = love.graphics.newQuad(224,48,48,16,img.sheet:getWidth(),img.sheet:getHeight()),
      craneClaw2 = love.graphics.newQuad(224-48,48-16,48,16,img.sheet:getWidth(),img.sheet:getHeight()),
      craneClaw3 = love.graphics.newQuad(224-48,48,48,16,img.sheet:getWidth(),img.sheet:getHeight()),
      craneClaw4 = love.graphics.newQuad(416,0,32,48,img.sheet:getWidth(),img.sheet:getHeight()),
    
      blackBot = {
        body = love.graphics.newQuad(592-16,0,64,64,img.sheet:getWidth(),img.sheet:getHeight()),
        head = {
          [0] = love.graphics.newQuad(336,400+96,64,48,img.sheet:getWidth(),img.sheet:getHeight()),
          [1] = love.graphics.newQuad(336+64,400+96,64,48,img.sheet:getWidth(),img.sheet:getHeight()),
          [2] = love.graphics.newQuad(336+64*2,400+96,64,48,img.sheet:getWidth(),img.sheet:getHeight()),
          [3] = love.graphics.newQuad(336+64*3,400+96,64,48,img.sheet:getWidth(),img.sheet:getHeight()),
          [4] = love.graphics.newQuad(336,400+48+96,64,48,img.sheet:getWidth(),img.sheet:getHeight()),
          [5] = love.graphics.newQuad(336+64,400+48+96,64,48,img.sheet:getWidth(),img.sheet:getHeight()),
          [6] = love.graphics.newQuad(336+64*2,400+48+96,64,48,img.sheet:getWidth(),img.sheet:getHeight()),
          [7] = love.graphics.newQuad(336+64*3,400+48+96,64,48,img.sheet:getWidth(),img.sheet:getHeight()),
          [8] = love.graphics.newQuad(336+64*4,400+96,64,48,img.sheet:getWidth(),img.sheet:getHeight()),
        },
        screw = love.graphics.newQuad(608,112+16,32,64,img.sheet:getWidth(),img.sheet:getHeight()),
        arm = love.graphics.newQuad(448,0,16,32,img.sheet:getWidth(),img.sheet:getHeight()),
        hand = love.graphics.newQuad(464,0,32,32,img.sheet:getWidth(),img.sheet:getHeight()),
      },
      whiteBot = {
        body = love.graphics.newQuad(592-16,64,64,64,img.sheet:getWidth(),img.sheet:getHeight()),
        head = {
          [0] = love.graphics.newQuad(336,400,64,48,img.sheet:getWidth(),img.sheet:getHeight()),
          [1] = love.graphics.newQuad(336+64,400,64,48,img.sheet:getWidth(),img.sheet:getHeight()),
          [2] = love.graphics.newQuad(336+64*2,400,64,48,img.sheet:getWidth(),img.sheet:getHeight()),
          [3] = love.graphics.newQuad(336+64*3,400,64,48,img.sheet:getWidth(),img.sheet:getHeight()),
          [4] = love.graphics.newQuad(336,400+48,64,48,img.sheet:getWidth(),img.sheet:getHeight()),
          [5] = love.graphics.newQuad(336+64,400+48,64,48,img.sheet:getWidth(),img.sheet:getHeight()),
          [6] = love.graphics.newQuad(336+64*2,400+48,64,48,img.sheet:getWidth(),img.sheet:getHeight()),
          [7] = love.graphics.newQuad(336+64*3,400+48,64,48,img.sheet:getWidth(),img.sheet:getHeight()),
          [8] = love.graphics.newQuad(336+64*4,400,64,48,img.sheet:getWidth(),img.sheet:getHeight()),
        },
        screw = love.graphics.newQuad(576,112+16,32,64,img.sheet:getWidth(),img.sheet:getHeight()),
        arm = love.graphics.newQuad(496,0,16,32,img.sheet:getWidth(),img.sheet:getHeight()),
        hand = love.graphics.newQuad(512,0,32,32,img.sheet:getWidth(),img.sheet:getHeight()),
      }
    }
    anim = {
      conveyerBelt = newAnimationGroup(img.sheet)
    }
    anim.conveyerBelt:addAnimation("normal",0,80*4,576,80,1,100)
    anim.conveyerBelt:addFrame("normal",0,80*3,576,80,100)
    anim.conveyerBelt:addFrame("normal",0,80*2,576,80,100)
    anim.conveyerBelt:addFrame("normal",0,80,576,80,100)
    
    snd = {
      oh = love.audio.newSource("/resources/sfx/screw bots/oh.ogg"),
      yea = love.audio.newSource("/resources/sfx/screw bots/yea.ogg"),
      lets = love.audio.newSource("/resources/sfx/screw bots/lets.ogg"),
      go = love.audio.newSource("/resources/sfx/screw bots/go.ogg") 
    }
    
    crane = {
      phase = 0,
      rot = 45,
      rot1 = (-45/2),
      rot2 = (-45/1.5),
      rot3 = 45,
      bot = "nil"
    }
    --crane.maxPhase = crane.phase

    claw = {
      spin = false,
      lengthAdd = 0,
      rot = 25,
      f = 0
    }
    
    sounds = {}
    
    bots = {}
    
    clawLengthBase = 128
    clawLengthAdd = 0
  end
  
  function uminigame(dt)
    for k,i in pairs(sounds) do
      if data.music:tell() > i.time then
        i.sound:stop()
        i.sound:play()
        table.remove(sounds,k)
      end
    end
    
    for _,i in pairs(currentSounds) do
      if i.name == "cBlack1" or i.name == "cWhite1" then
        crane.phase = 1
        if i.name == "cBlack1" then
          crane.bot = "black"
        end
        if i.name == "cWhite1" then
          crane.bot = "white"
        end
      end
      if i.name == "cBlack2" or i.name == "cWhite2" then
        crane.phase = 2
      end
      if i.name == "dBlack" then
        claw.prepare = true
        
        crane.bot = nil
        crane.phase = 0
        local b = {
          color = "black",
          x = 128+592-64-32-24,
          moving = true,
          time = i.time+(1)*(60000/data.bpm)/1000, 
          headHeight = 40,
          f = 0,
          bounce = 20,
          complete = false,
          armRot = 0,
          released = i.time+(500)*(60000/data.bpm)/1000, 
        }
        table.insert(bots,b)
      end
      if i.name == "dWhite" then
        claw.prepare = true
        
        crane.bot = nil
        crane.phase = 0
        local b = {
          color = "white",
          x = 128+592-64-32-24,
          moving = true,
          time = i.time+(1)*(60000/data.bpm)/1000, 
          headHeight = 15,
          f = 0,
          bounce = 20,
          complete = false,
          armRot = 0,
          released = i.time+(500)*(60000/data.bpm)/1000, 
        }
        table.insert(bots,b)
      end
    end
    
    
    anim.conveyerBelt:update(dt)
    
    --[[if mouse.button.pressed[1] then
      crane.phase = crane.phase+1
      if crane.phase > crane.maxPhase then
        crane.phase = 0
      end
    end]]
    
    if crane.phase == 0 then
      crane.rot = (crane.rot+45)/2
      crane.rot1 = (crane.rot1+(-45/2))/2
      crane.rot2 = (crane.rot2+(-45/1.75))/2
      crane.rot3 = (crane.rot3+45*1.5)/2
    elseif crane.phase == 1 then
      crane.rot = (crane.rot+(-45))/2
      crane.rot1 = (crane.rot1+(-90))/2
      crane.rot2 = (crane.rot2+(-45/1.5))/2
      crane.rot3 = (crane.rot3+45)/2
    elseif crane.phase == 2 then
      crane.rot = (crane.rot+45)/2
      crane.rot1 = (crane.rot1+(-45/2))/2
      crane.rot2 = (crane.rot2+(-45/1.10))/2
      crane.rot3 = (crane.rot3+45)/2
    end
    
    local hit = 0
    local time = 0
    local col = "red"
    local bearly = false
    for _,i in pairs(currentHits) do
      if i.name == "sBlack" or i.name == "sWhite" then
        hit = 1
        time = i.time
        col = "black"
        bearly = i.bearly
      end
      if i.name == "compBlack" or i.name == "compWhite" then
        hit = 2
        time = i.time
        col = "white"
        bearly = i.bearly
      end
    end
    
    if input["pressAB"] and hit == 1 then
        claw.spin = true
        claw.prepare = false
    end
    if input["releaseAB"] and hit == 2 then
        claw.spin = false
    end
    --claw.rot = 0
    --claw.f = claw.f +0.02
    --print(claw.f)
    --if claw.f > 7 then
    --  claw.f = 0
    --end
    
    if claw.prepare then
      claw.rot = (claw.rot+45)/2
      clawLengthAdd = (clawLengthAdd-64)/2
    elseif not claw.spin then
      clawLengthAdd = (clawLengthAdd+0)/2
      claw.rot = (claw.rot+25)/2
    else
      claw.rot = 0

    end
    
    for _,i in pairs(bots) do
      local spd = 5300
      local headSpd = 480
    
      if i.moving then
        i.x = i.x-spd*(data.bpm/60000)
        
        if time > i.time-margin and time < i.time+margin and hit == 1 then
          i.moving = false
          i.x = view.width/3
          claw.spin = true
        end
      else
        if input["holdAB"] then
          i.headHeight = i.headHeight-headSpd*(data.bpm/60000)
          
          clawLengthAdd = -i.headHeight+128
          
          i.f = i.f+0.5
          if i.f > 7 then
            i.f = 0
          end
          
          claw.f = math.floor(i.f)
        end
        if input["releaseAB"] then
          i.released = data.music:tell()
          i.moving = true 
          claw.f = 0
          claw.spin = false
          misses = misses +1
        end
      end
      if i.color == "black" then
        if time > i.time+(2)*(60000/data.bpm)/1000-margin and time < i.time+(2)*(60000/data.bpm)/1000+margin and hit == 2 and not bearly and not (i.released < i.time+(2)*(60000/data.bpm)/1000-margin) then
          i.armRot = 90-45+90
          
          i.moving = true
          i.f = 8
          claw.f = 0
          i.headHeight = -16
          i.complete = true
          
          local s = {
            time = i.time+(2.5)*(60000/data.bpm)/1000,
            sound = snd.oh
          }
          table.insert(sounds,s)
          local s = {
            time = i.time+(3)*(60000/data.bpm)/1000 ,
            sound = snd.yea
          }
          table.insert(sounds,s)
        end
        if data.music:tell() > i.time+(2)*(60000/data.bpm)/1000+bearlyMargin then
          i.moving = true
          claw.f = 0
          claw.spin = false
        end
      else
        if time > i.time+(1)*(60000/data.bpm)/1000-margin and time < i.time+(1)*(60000/data.bpm)/1000+margin and hit == 2 and not bearly and not (i.released < i.time+(1)*(60000/data.bpm)/1000-margin)  then
          i.armRot = 90-45+90
          
          i.moving = true
          i.f = 8
          claw.f = 0
          i.headHeight = -16
          i.complete = true
          
          local s = {
            time = i.time+(1.5)*(60000/data.bpm)/1000,
            sound = snd.lets
          }
          table.insert(sounds,s)
          local s = {
            time = i.time+(2)*(60000/data.bpm)/1000 ,
            sound = snd.go
          }
          table.insert(sounds,s)
        end
        if data.music:tell() > i.time+(1)*(60000/data.bpm)/1000+bearlyMargin then
          i.moving = true
          claw.f = 0
          claw.spin = false
        end
      end
    end
  end
  
  function dminigame()
    setColorHex("ffffff")
    love.graphics.rectangle("fill",0,0,view.width,view.height)
    
    --draw back claw
    local clawLength = clawLengthBase+clawLengthAdd
    local clawRotation = claw.rot
    love.graphics.draw(img.sheet,quad.claw[math.floor(claw.f)],view.width/3+8,clawLength+32+6,math.rad(clawRotation),1,1,144/2,18)
    
    for _,i in pairs(bots) do
      if i.complete then
        i.bounce = beat
      end
      local bounce = i.bounce
      if i.bounce > 0 then
        i.bounce = i.bounce-1
      end
      if i.color == "black" then
        love.graphics.draw(img.sheet,quad.blackBot.screw,i.x,view.height-64-128-i.headHeight-5+bounce/2,0,1,1,32/2,0)
        
        love.graphics.draw(img.sheet,quad.blackBot.arm,i.x-20,view.height-32-16-128+bounce/2,math.rad(i.armRot),1,1,16/2,0)
        love.graphics.draw(img.sheet,quad.blackBot.hand,i.x-20+math.cos(math.rad(i.armRot+90))*30,view.height-32-16-128+bounce/2+math.sin(math.rad(i.armRot+90))*30,math.rad(i.armRot),1,1,16,16)
        
        love.graphics.draw(img.sheet,quad.blackBot.arm,i.x+20,view.height-32-16-128+bounce/2,math.rad(-i.armRot),1,1,16/2,0)
        love.graphics.draw(img.sheet,quad.blackBot.hand,i.x+20-math.cos(math.rad(-i.armRot+270))*30,view.height-32-16-128+bounce/2-math.sin(math.rad(-i.armRot+270))*30,math.rad(-i.armRot),1,1,16,16)
        
        love.graphics.draw(img.sheet,quad.blackBot.body,i.x,view.height-128+10,0,1,1,64/2,64)
        love.graphics.draw(img.sheet,quad.blackBot.head[math.floor(i.f)],i.x,view.height-64-128-i.headHeight+10+bounce,0,1,1,64/2,48)
      elseif i.color == "white" then
        love.graphics.draw(img.sheet,quad.whiteBot.screw,i.x,view.height-64-128-i.headHeight-5+bounce/2,0,1,1,32/2,0)
        
        love.graphics.draw(img.sheet,quad.whiteBot.arm,i.x-20,view.height-32-16-128+bounce/2,math.rad(i.armRot),1,1,16/2,0)
        love.graphics.draw(img.sheet,quad.whiteBot.hand,i.x-20+math.cos(math.rad(i.armRot+90))*30,view.height-32-16-128+bounce/2+math.sin(math.rad(i.armRot+90))*30,math.rad(i.armRot),1,1,16,16)
        
        love.graphics.draw(img.sheet,quad.whiteBot.arm,i.x+20,view.height-32-16-128+bounce/2,math.rad(-i.armRot),1,1,16/2,0)
        love.graphics.draw(img.sheet,quad.whiteBot.hand,i.x+20-math.cos(math.rad(-i.armRot+270))*30,view.height-32-16-128+bounce/2-math.sin(math.rad(-i.armRot+270))*30,math.rad(-i.armRot),1,1,16,16)
        
        love.graphics.draw(img.sheet,quad.whiteBot.body,i.x,view.height-128+10,0,1,1,64/2,64)
        love.graphics.draw(img.sheet,quad.whiteBot.head[math.floor(i.f)],i.x,view.height-64-128-i.headHeight+10+bounce,0,1,1,64/2,48)
      end
    end
    
    anim.conveyerBelt:draw(128,view.height-128)
    anim.conveyerBelt:draw(128+16-2,view.height-128+80-8,0,-1,-1)

    local rot = crane.rot

    local x = view.width
    local y = (view.height/2)
    
    local mx,my = love.mouse.getPosition()
    local dist = 296-32
    local distMid = 296-96
    local distTop = 296-64
    local xTop = x+math.cos(math.rad(180+rot))*dist
    local yTop = y+math.sin(math.rad(180+rot))*dist
    
    local rot1 = crane.rot1--math.deg(pointTowards(mx,my,x+math.cos(math.rad(180+rot))*dist,y+math.sin(math.rad(180+rot))*dist))
    
    local dist1 = 296-64-16-8
    local xAdd = math.cos(math.rad(180+rot1))*dist1
    local yAdd = math.sin(math.rad(180+rot1))*dist1
    local craneClawY = 40
    local craneClawX = 16
    local craneClawRot = crane.rot2 -- -45/2--math.deg(pointTowards(mx,my,x+math.cos(math.rad(180+rot))*dist,y+math.sin(math.rad(180+rot))*dist))
    local craneClawRot1 = crane.rot3 --90--love.math.random(360)
    local dist2 = 44
    
    --CRANE TOP
    love.graphics.draw(img.sheet,quad.craneClaw1,xTop+xAdd,yTop+yAdd,math.rad(-90),1,1,48,8)
    
    love.graphics.draw(img.sheet,quad.craneClaw3,xTop+xAdd-craneClawX,yTop+yAdd+craneClawY,math.rad(craneClawRot),1,1,48,8)
    love.graphics.draw(img.sheet,quad.craneClaw3,xTop+xAdd+craneClawX,yTop+yAdd+craneClawY,-math.rad(craneClawRot),-1,1,48,8)
    
    love.graphics.draw(img.sheet,quad.craneClaw2,xTop+xAdd,yTop+yAdd+craneClawY,0,1,1,48/2,8)
    
    love.graphics.draw(img.sheet,quad.craneClaw4,xTop+xAdd-48/2+8-math.cos(math.rad(craneClawRot))*dist2,yTop+yAdd+craneClawY-math.sin(math.rad(craneClawRot))*dist2,math.rad(craneClawRot+craneClawRot1),1,1,8,12)
    love.graphics.draw(img.sheet,quad.craneClaw4,xTop+xAdd+48/2+8+math.cos(math.rad(craneClawRot))*dist2-16,yTop+yAdd+craneClawY-math.sin(math.rad(craneClawRot))*dist2,-math.rad(craneClawRot+craneClawRot1),-1,1,8,12)
    
    if crane.bot == "black" then
        local x = xTop+xAdd
        local y = yTop+yAdd
        local headHeight = 40
        
        y = y+128+96-16
        
        love.graphics.draw(img.sheet,quad.blackBot.screw,x,y-64-headHeight-5,0,1,1,32/2,0)
        
        love.graphics.draw(img.sheet,quad.blackBot.arm,x-20,y-32-16,math.rad(0),1,1,16/2,0)
        love.graphics.draw(img.sheet,quad.blackBot.hand,x-20+math.cos(math.rad(0+90))*30,y-32-16+math.sin(math.rad(0+90))*30,math.rad(0),1,1,16,16)
        
        love.graphics.draw(img.sheet,quad.blackBot.arm,x+20,y-32-16,math.rad(0),1,1,16/2,0)
        love.graphics.draw(img.sheet,quad.blackBot.hand,x+20-math.cos(math.rad(0+270))*30,y-32-16-math.sin(math.rad(0+270))*30,math.rad(0),1,1,16,16)        
      
        love.graphics.draw(img.sheet,quad.blackBot.body,x,y+10,0,1,1,64/2,64)
        love.graphics.draw(img.sheet,quad.blackBot.head[0],x,y-64-headHeight+10,0,1,1,64/2,48)
    elseif crane.bot == "white" then
        local x = xTop+xAdd
        local y = yTop+yAdd
        local headHeight = 40
        
        y = y+128+96-16
        
        love.graphics.draw(img.sheet,quad.whiteBot.screw,x,y-64-headHeight-5,0,1,1,32/2,0)
        
        love.graphics.draw(img.sheet,quad.whiteBot.arm,x-20,y-32-16,math.rad(0),1,1,16/2,0)
        love.graphics.draw(img.sheet,quad.whiteBot.hand,x-20+math.cos(math.rad(0+90))*30,y-32-16+math.sin(math.rad(0+90))*30,math.rad(0),1,1,16,16)
        
        love.graphics.draw(img.sheet,quad.whiteBot.arm,x+20,y-32-16,math.rad(0),1,1,16/2,0)
        love.graphics.draw(img.sheet,quad.whiteBot.hand,x+20-math.cos(math.rad(0+270))*30,y-32-16-math.sin(math.rad(0+270))*30,math.rad(0),1,1,16,16)   
        
        love.graphics.draw(img.sheet,quad.whiteBot.body,x,y-16,0,1,1,64/2,64)
        love.graphics.draw(img.sheet,quad.whiteBot.head[0],x,y-64-headHeight+10,0,1,1,64/2,48)
    end
    
    --setColorHex("ff0000")
      --love.graphics.circle("fill",xTop+xAdd-craneClawX+math.cos(craneClawRot)*dist2,yTop+yAdd+craneClawY+math.sin(craneClawRot)*dist2-5,3)
      --setColorHex("ffffff")
    
    --CRANE MIDDLE
    love.graphics.draw(img.sheet,quad.craneTopMiddle,x+math.cos(math.rad(180+rot))*dist,y+math.sin(math.rad(180+rot))*dist,math.rad(rot1),1,1,distMid,8)
    love.graphics.draw(img.sheet,quad.craneTop,xTop,yTop,math.rad(rot1),1,1,distTop,16)
    love.graphics.draw(img.sheet,quad.craneTopBottom,x+math.cos(math.rad(180+rot))*dist,y+math.sin(math.rad(180+rot))*dist,math.rad(rot1),1,1,96+32,16)
    
    --CRANE BOTTOM
    love.graphics.draw(img.sheet,quad.craneBottom,x,y,math.rad(rot),1,1,296,32)
    

    love.graphics.draw(img.sheet,quad.clawCable,view.width/3,0,0,1,clawLength/16,8,0)
    
    
    love.graphics.draw(img.sheet,quad.clawTop,view.width/3,0,math.rad(-90),1,1,64,32)
    
    if claw.f == 0 then
      love.graphics.draw(img.sheet,quad.clawR[math.floor(claw.f)],view.width/3,clawLength+8,math.rad(-clawRotation),1,1,88,28)
    else
      love.graphics.draw(img.sheet,quad.clawR[math.floor(claw.f)],view.width/3,clawLength+8,math.rad(-clawRotation),1,1,144/2,18)
    end
    --love.graphics.draw(img.sheet,quad.claw[0],view.width/3+10,clawLength+32,math.rad(-clawRotation),-1,1,48,16)
    
    if math.floor(claw.f) == 0 then
      love.graphics.draw(img.sheet,quad.clawBottom,view.width/3,clawLength,math.rad(90),1,1,0,48/2)
    end
  end
  
  loadMinigame[7] = lminigame
  updateMinigame[7] = uminigame
  drawMinigame[7] = dminigame
  
  function lminigame()
    img = {
      sheet = love.graphics.newImage("/resources/gfx/moai doo-woop/sheet.png")
    }
    quad = {
      bg1 = love.graphics.newQuad(896,0,480,567,img.sheet:getWidth(),img.sheet:getHeight()),
      fg = love.graphics.newQuad(288,0,480,176+16,img.sheet:getWidth(),img.sheet:getHeight()),
      
      body = love.graphics.newQuad(0,0,208,208,img.sheet:getWidth(),img.sheet:getHeight()),
      bow = love.graphics.newQuad(208,0,80,96,img.sheet:getWidth(),img.sheet:getHeight()),
      head = {
        [0] = love.graphics.newQuad(0,208,224,288,img.sheet:getWidth(),img.sheet:getHeight()),
        [1] = love.graphics.newQuad(224,208,224,288,img.sheet:getWidth(),img.sheet:getHeight()),
        [2] = love.graphics.newQuad(224*2,208,224,288,img.sheet:getWidth(),img.sheet:getHeight()),
        [3] = love.graphics.newQuad(224*3,208,224,288+32,img.sheet:getWidth(),img.sheet:getHeight()),
        [4] = love.graphics.newQuad(0,512,224,288+32,img.sheet:getWidth(),img.sheet:getHeight()),
      },
      
      birdBody = love.graphics.newQuad(768,0,128,64,img.sheet:getWidth(),img.sheet:getHeight()),
      birdLegs = {
        [0] = love.graphics.newQuad(768,64,48,48,img.sheet:getWidth(),img.sheet:getHeight()),
        [1] = love.graphics.newQuad(768+48,64,48,48,img.sheet:getWidth(),img.sheet:getHeight()),
      }
    }
    snd = {
      dooStart = love.audio.newSource("/resources/sfx/moai doo woop/dooRStart.ogg"),
      doo = love.audio.newSource("/resources/sfx/moai doo woop/dooR.ogg"),
      woop = love.audio.newSource("/resources/sfx/moai doo woop/woopR.ogg"),
      pah = love.audio.newSource("/resources/sfx/moai doo woop/pahR.ogg"),
      fail = love.audio.newSource("/resources/sfx/game/bearlyHit.ogg")
    }
    snd.fail:setVolume(0.25)
    p = {
      head = 0,
      releaseTime = 0,
      pahTime = 0,
      y = 128+96
    }
    o = {
      head = 0,
      releaseTime = 0,
      pahTime = 0,
      disapointTime = 0,
      y = 0
    }
    turn = 0
  end
  
  function uminigame(dt)
    --height
    if turn == 0 then
      p.y = p.y + (128+96 - p.y) * ((2)*(data.bpm/6000))
      o.y = o.y + (0 - o.y) * ((2)*(data.bpm/6000))
    else
      o.y = o.y + (128+96 - o.y) * ((2)*(data.bpm/6000))
      p.y = p.y + (0 - p.y) * ((2)*(data.bpm/6000))
    end
    --OTHER MOAI
    
    for _,i in pairs(currentSounds) do
      if i.name == "dooLStart" then
        o.head = 1
      end
      if i.name == "wopL" then
        o.head = 2
        o.releaseTime = 10
      end
      if i.name == "pahL" then
        o.head = 3
        o.pahTime = 10
      end
      if i.name == "switch" then
        turn = 1-turn
      end
    end
    
    if o.releaseTime > 0 then
      o.releaseTime = o.releaseTime-dt*100
      o.head = 2
    elseif o.head ~= 1 then
      o.head = 0
    end
    
    if o.disapointTime > 0 then
      o.disapointTime = o.disapointTime-dt*100
      o.head = 4
    end
    
    if o.pahTime > 0 then
      o.pahTime = o.pahTime-dt*100
      o.head = 3
    end
    
    --PLAYER MOAI
    local hit = 0
    
    for _,i in pairs(currentHits) do
      if i.name == "dooRStart" then
        hit = 1
      end
      if i.name == "wopR" then
        hit = 2
      end
      if i.name == "pahR" then
        hit = 3
        print("PAH")
      end
    end
    
    if input["holdA"] then
      p.head = 1
      if input["pressA"] then
        snd.dooStart:stop()
        snd.dooStart:play()
        
        snd.doo:stop()
        
        if hit ~= 1 then
          misses = misses+1
          print("missed")
          snd.fail:stop()
          snd.fail:play()
          o.head = 4
          o.disapointTime = 100
        end
      end
      snd.doo:play()
    else
      p.head = 0
    end
    
    if input["releaseA"] then
      snd.doo:stop()
      snd.woop:stop()
      snd.woop:play()
      p.releaseTime = 10
      
      if hit ~= 2 then
        misses = misses+1
        print("missed")
      end
    end
    
    if p.releaseTime > 0 then
      p.releaseTime = p.releaseTime-dt*100
      p.head = 2
    end
    
    if input["pressB"] then
      snd.pah:stop()
      snd.pah:play()
      p.pahTime = 10
      if hit ~= 3 then
        misses = misses+1
        print("missed")
        snd.fail:stop()
        snd.fail:play()
        o.head = 4
        o.disapointTime = 100
      end
    end
    
    if p.pahTime > 0 then
      p.pahTime = p.pahTime-dt*100
      p.head = 3
    end
  end
  
  function dminigame()
    setColorHex("3CFDFF")
    love.graphics.rectangle("fill",0,0,view.width,view.height)
    
    setColorHex("ffffff")
    
    love.graphics.draw(img.sheet,quad.bg1,0,view.height,0,1,1,0,567)
    love.graphics.draw(img.sheet,quad.bg1,view.width,view.height,0,-1,1,0,567)
    
    local y = o.y
    local dist = 256+128
    
    love.graphics.draw(img.sheet,quad.body,view.width/2-dist,view.height-300+y)
    love.graphics.draw(img.sheet,quad.head[o.head],view.width/2-dist+32,view.height-480+y)
    
    y = p.y
    
    love.graphics.draw(img.sheet,quad.body,view.width/2+dist,view.height-300+y,0,-1,1)
    love.graphics.draw(img.sheet,quad.head[p.head],view.width/2+dist-32,view.height-480+y,0,-1,1)
    
    
    local bowX = -110
    local bowY = -200
    if p.head == 1 then
      bowX = -120
      bowY = -190
    end
    if p.head == 2 then
      bowX = -115
      bowY = -192
    end
    if p.head == 3 then
      bowX = -130
      bowY = -180
    end
    love.graphics.draw(img.sheet,quad.bow,view.width/2+dist+bowX,view.height-300+bowY+y)
    
    local birdY = math.ceil(beat/10)*7
    local birdLegs = 1-math.ceil(beat/10)
    
    local xb = 0
    local yb = 0
    
    if o.head == 1 then
      xb = 8
      yb = 9
    end
    if o.head == 2 then
      xb = 8/2
      yb = 9/2+1
    end
    if o.head == 3 then
      xb = 12
      yb = 9*2
    end
    
    love.graphics.draw(img.sheet,quad.birdLegs[birdLegs],view.width/2-dist+80+xb,view.height-740+(128+96)*2-y+yb)
    love.graphics.draw(img.sheet,quad.birdBody,view.width/2-dist+50+xb,view.height-780+(128+96)*2-y+birdY+yb)
    
    love.graphics.draw(img.sheet,quad.fg,0,view.height,0,1,1,0,176+16)
    love.graphics.draw(img.sheet,quad.fg,view.width,view.height,0,-1,1,0,176+16)
    
    love.graphics.draw(img.sheet,quad.birdLegs[birdLegs],64,view.height-120)
    love.graphics.draw(img.sheet,quad.birdBody,32,view.height-160+birdY)
    
    love.graphics.draw(img.sheet,quad.birdLegs[birdLegs],view.width-32,view.height-70,0,-1,1)
    love.graphics.draw(img.sheet,quad.birdBody,view.width,view.height-110+birdY,0,-1,1)
  end
  
  loadMinigame[8] = lminigame
  updateMinigame[8] = uminigame
  drawMinigame[8] = dminigame
  
  function lminigame()
    img = {
      bg = love.graphics.newImage("/resources/gfx/cheer readers/bg.png"),
      sheet = love.graphics.newImage("/resources/gfx/cheer readers/sheet.png"),
      showOff = {
        [0] = love.graphics.newImage("/resources/gfx/cheer readers/showOff0.png"),
        [1] = love.graphics.newImage("/resources/gfx/cheer readers/showOff1.png"),
        [2] = love.graphics.newImage("/resources/gfx/cheer readers/showOff2.png"),
      },
      canv = love.graphics.newCanvas(view.width,view.height),
    }
    img.sheet:setFilter("linear","linear")
    quad = {
      benchSide = love.graphics.newQuad(0,0,48,222,img.sheet:getWidth(),img.sheet:getHeight()),
      benchMid = love.graphics.newQuad(48,0,16,222,img.sheet:getWidth(),img.sheet:getHeight()),
      leg = love.graphics.newQuad(64,0,48,112,img.sheet:getWidth(),img.sheet:getHeight()),
      skirt = { 
        [0] = love.graphics.newQuad(64,112,64,48,img.sheet:getWidth(),img.sheet:getHeight()),
        [1] = love.graphics.newQuad(128,112,64,48,img.sheet:getWidth(),img.sheet:getHeight()),
      },
      body = { 
        [0] = love.graphics.newQuad(64,160,48,64,img.sheet:getWidth(),img.sheet:getHeight()),
        [1] = love.graphics.newQuad(128,160,48,64,img.sheet:getWidth(),img.sheet:getHeight()),
      },
      head = love.graphics.newQuad(112,0,64,64,img.sheet:getWidth(),img.sheet:getHeight()),
      book = {
        ["white"] = {
          [0] = love.graphics.newQuad(176+16,0,96,80,img.sheet:getWidth(),img.sheet:getHeight()),
          [1] = love.graphics.newQuad(176+16+96,0,96,80,img.sheet:getWidth(),img.sheet:getHeight()),
          [2] = love.graphics.newQuad(176+16+96,0,96,80,img.sheet:getWidth(),img.sheet:getHeight()),
        },
        ["black"] = {
          [0] = love.graphics.newQuad(176+16,80,96,80,img.sheet:getWidth(),img.sheet:getHeight()),
          [1] = love.graphics.newQuad(176+16+96,80,96,80,img.sheet:getWidth(),img.sheet:getHeight()),
          [2] = love.graphics.newQuad(176+16+96,80,96,80,img.sheet:getWidth(),img.sheet:getHeight()),
        },
        [0] = love.graphics.newQuad(576,0,96,112,img.sheet:getWidth(),img.sheet:getHeight()),
      },
      hand = {
        [0] = love.graphics.newQuad(176+16,160,48,48,img.sheet:getWidth(),img.sheet:getHeight()),
        [1] = love.graphics.newQuad(176+16+48,160,48,48,img.sheet:getWidth(),img.sheet:getHeight()),
        [2] = love.graphics.newQuad(176+16+48+48,160,48,48,img.sheet:getWidth(),img.sheet:getHeight()),
      },
      forearm = {
        [0] = love.graphics.newQuad(320+16,160,80,16,img.sheet:getWidth(),img.sheet:getHeight()),
        [1] = love.graphics.newQuad(320+16,160+16,80,16,img.sheet:getWidth(),img.sheet:getHeight()),
        [2] = love.graphics.newQuad(320+16,160+16*3,80,16,img.sheet:getWidth(),img.sheet:getHeight()),
      },
      backarm = {
        [0] = love.graphics.newQuad(320+16,160+32,80,16,img.sheet:getWidth(),img.sheet:getHeight()),
      },
      eyes = {
        [0] = love.graphics.newQuad(512,160,48,32,img.sheet:getWidth(),img.sheet:getHeight()),
      } ,
      mouth = {
        [0] = love.graphics.newQuad(512,192,16,16,img.sheet:getWidth(),img.sheet:getHeight()),
      },
      hair = {
        [0] = love.graphics.newQuad(0,224,80,80,img.sheet:getWidth(),img.sheet:getHeight()),
        [1] = love.graphics.newQuad(80,224,80,80,img.sheet:getWidth(),img.sheet:getHeight()),
        [2] = love.graphics.newQuad(80*2,224,80,80,img.sheet:getWidth(),img.sheet:getHeight()),
        [3] = love.graphics.newQuad(80*3,224,80,80,img.sheet:getWidth(),img.sheet:getHeight()),
        [4] = love.graphics.newQuad(80*4,224,80,80,img.sheet:getWidth(),img.sheet:getHeight()),
        [5] = love.graphics.newQuad(80*5,224,80,80,img.sheet:getWidth(),img.sheet:getHeight()),
        [6] = love.graphics.newQuad(80*6,224,80,80,img.sheet:getWidth(),img.sheet:getHeight()),
        [7] = love.graphics.newQuad(80*7,224,80,80,img.sheet:getWidth(),img.sheet:getHeight()),
        [8] = love.graphics.newQuad(80*8,224,80,80,img.sheet:getWidth(),img.sheet:getHeight()),
      },
      backhair = {
        [0] = love.graphics.newQuad(0,224+80,80,80,img.sheet:getWidth(),img.sheet:getHeight()),
        [1] = love.graphics.newQuad(80,224+80,80,80,img.sheet:getWidth(),img.sheet:getHeight()),
        [2] = love.graphics.newQuad(80*2,224+80,80,80,img.sheet:getWidth(),img.sheet:getHeight()),
        [3] = love.graphics.newQuad(80*3,224+80,80,80,img.sheet:getWidth(),img.sheet:getHeight()),
        [4] = love.graphics.newQuad(80*4,224+80,80,80,img.sheet:getWidth(),img.sheet:getHeight()),
        [5] = love.graphics.newQuad(80*5,224+80,80,80,img.sheet:getWidth(),img.sheet:getHeight()),
        [6] = love.graphics.newQuad(80*6,224+80,80,80,img.sheet:getWidth(),img.sheet:getHeight()),
        [7] = love.graphics.newQuad(80*7,224+80,80,80,img.sheet:getWidth(),img.sheet:getHeight()),
        [8] = love.graphics.newQuad(80*8,224+80,80,80,img.sheet:getWidth(),img.sheet:getHeight()),
      },
      glasses = {
        [0] = love.graphics.newQuad(464,160,48,32,img.sheet:getWidth(),img.sheet:getHeight()), 
        [1] = love.graphics.newQuad(464-48,160,48,32,img.sheet:getWidth(),img.sheet:getHeight()), 
        [2] = love.graphics.newQuad(464,160+32,48,32,img.sheet:getWidth(),img.sheet:getHeight()), 
        [3] = love.graphics.newQuad(464-48,160+32,48,32,img.sheet:getWidth(),img.sheet:getHeight()), 
      },
      showOff = {
        [1] = love.graphics.newQuad(0,0,144,96,img.sheet:getWidth(),img.showOff[0]:getHeight()), 
        [2] = love.graphics.newQuad(144*1,0,144,96,img.sheet:getWidth(),img.showOff[0]:getHeight()), 
        [3] = love.graphics.newQuad(144*2,0,144,96,img.sheet:getWidth(),img.showOff[0]:getHeight()), 
        [4] = love.graphics.newQuad(144*3,0,144,96,img.sheet:getWidth(),img.showOff[0]:getHeight()), 
        
        [5] = love.graphics.newQuad(0,96,144,96,img.sheet:getWidth(),img.showOff[0]:getHeight()), 
        [6] = love.graphics.newQuad(144*1,96,144,96,img.sheet:getWidth(),img.showOff[0]:getHeight()), 
        [7] = love.graphics.newQuad(144*2,96,144,96,img.sheet:getWidth(),img.showOff[0]:getHeight()), 
        [8] = love.graphics.newQuad(144*3,96,144,96,img.sheet:getWidth(),img.showOff[0]:getHeight()), 
        
        [9] = love.graphics.newQuad(0,96*2,144,96,img.sheet:getWidth(),img.showOff[0]:getHeight()), 
        [10] = love.graphics.newQuad(144*1,96*2,144,96,img.sheet:getWidth(),img.showOff[0]:getHeight()), 
        [11] = love.graphics.newQuad(144*2,96*2,144,96,img.sheet:getWidth(),img.showOff[0]:getHeight()), 
        [12] = love.graphics.newQuad(144*3,96*2,144,96,img.sheet:getWidth(),img.showOff[0]:getHeight()), 
        
        [13] = love.graphics.newQuad(144*4,0,144,96,img.sheet:getWidth(),img.showOff[0]:getHeight()), 
      }
    }
    snd = {
      bearly = love.audio.newSource("/resources/sfx/game/bearlyHit.ogg")
    }
    
    --if not girls then
    
      girls = {}
      
      local w = 138
      local h = 96
      local xoff = 128
      local yoff = 290
      local id_ = 2048
      for n = 1, 12 do
        local g = {
          x = n*w+xoff,
          y = h+yoff,
          p = 0,
          book = "white",
          n = n,
          countIn = true,
          id = id_,
          hair = love.math.random(0,7),
          glasses = love.math.random(0,3),
          spin = 0,
          spinDir = 1,
          bounce = 0,
          showOff = false,
          showOffNum = 0,
          failAdd = 0
        }
        if n == 12 then
          g.hair = 8
          g.player = true
        end
        id_ = id_/2
        local nn = n
        while nn > 4 do
          nn = nn - 4
          g.y = g.y+h
          g.x = g.x-4*w
        end
        table.insert(girls,g)
      end
    --end
    flip = 0
    zoom = 1
    zoomTarget = 1
  end
  
  function uminigame(dt)
    zoom = (zoom+zoomTarget)/2
    
    for _,i in pairs(currentSounds) do
      if i.name == "one" then
        flip = 3840
      end
      if i.name == "two" then
        flip = 240
      end
      if i.name == "three" then
        flip = 15
      end
      
      if i.name == "its" then
        flip = 2184
      end
      if i.name == "up" then
        flip = 1092
      end
      if i.name == "to" then
        flip = 546
      end
      if i.name == "you" then
        flip = 273
      end
      
      if i.name == "o" then
        for _,i in pairs(girls) do
          i.bounce = 5
        end
      end
      if i.name == "kay" then
        for _,i in pairs(girls) do
          i.bounce = 5
        end
      end
      
      if i.name == "its2" then
        for _,i in pairs(girls) do
          i.showOff = false
          if i.countIn then
            i.countIn = false
          end
          i.fastSpin = true
        end
        zoomTarget = 0.8
      end
      if i.name == "on" then
        local showOffNum = love.math.random(0,2)
        for _,i in pairs(girls) do
          i.fastSpin = false
          i.showOff = true
          i.showOffNum = showOffNum
        end
        zoomTarget = 1.5
      end
      if i.name == "zoomReset" then
        zoomTarget = 1
        i.book = "black"
      end
    end
    
    for _,i in pairs(girls) do
      if flip >= i.id then
        flip = flip - i.id
        i.bounce = 5
        print("flip",flip,i.id,flip+i.id)
        if not i.player then
          i.showOff = false
          if i.countIn then
            i.countIn = false
          end
        
          i.spin = 1
          i.spinDir = 1
        end
      end
    end
    
    local hit = 0
    local bearly = false
    for _,i in pairs(currentHits) do
      if i.name == "its2" then
        for _,p in pairs(girls) do
          if p.player then
            p.failAdd = 0
          end
        end
        hit = 1
        if i.bearly then
          bearly = true
        end
      end
      if i.name == "on" then
        hit = 1
        if i.bearly then
          bearly = true
        end
      end
      if i.bearly then
        bearly = true
      end
    end
    
    if hit == 1 and bearly then
      for _,i in pairs(girls) do
        if i.player then
          i.failAdd = 1
        end
      end
    end
    
    if bearly then
      snd.bearly:stop()
      snd.bearly:play()
    end
    
    if input["pressA"] then
      for _,i in pairs(girls) do
        if i.player then
          i.bounce = 5
          i.showOff = false
          if i.countIn then
            i.countIn = false
          end
          
          i.spin = 1
          i.spinDir = 1
        end
      end
    end
    
  end
  
  function dminigame()
    love.graphics.setCanvas(img.canv)
    
    love.graphics.draw(img.bg,view.width/2,view.height,0,1.1,1.1,0,img.bg:getHeight())
    love.graphics.draw(img.bg,view.width/2,view.height,0,-1.1,1.1,0,img.bg:getHeight())
    
    local yoff = 50
    love.graphics.draw(img.sheet,quad.benchSide,128,view.height+yoff,0,1,1,0,222)
    love.graphics.draw(img.sheet,quad.benchMid,128+48,view.height+yoff,0,42,1,0,222)
    love.graphics.draw(img.sheet,quad.benchSide,view.width-128,view.height+yoff,0,-1,1,0,222)
    
    local h = 105
    love.graphics.draw(img.sheet,quad.benchSide,128-32,view.height+h+yoff,0,1,1,0,222)
    love.graphics.draw(img.sheet,quad.benchMid,128+48-32,view.height+h+yoff,0,46,1,0,222)
    love.graphics.draw(img.sheet,quad.benchSide,view.width-128+32,view.height+h+yoff,0,-1,1,0,222)
    
    
    local legdist = 32
    for _,i in pairs(girls) do
      local bounce = i.bounce
      if i.countIn then
        bounce = beat
      else
        if i.bounce > 0 then
          i.bounce = i.bounce-1
        end
      end
      
      local body = 0
      if not i.countIn and not i.showOff then
        body = 1
      end
      
      yHair = bounce
      xHair = 0
      if i.hair == 0 then
        yHair = yHair+4
      elseif i.hair == 1 then
        xHair = xHair+1
      elseif i.hair == 2 then
        yHair = yHair+2
      elseif i.hair == 4 then
        yHair = yHair+2
        love.graphics.draw(img.sheet,quad.backhair[i.hair],i.x-4*body+xHair,i.y-150+yHair+8,0,1,1,80/2,80)
      elseif i.hair == 7 then
        xHair = xHair+1
      elseif i.hair == 6 then
        love.graphics.draw(img.sheet,quad.backhair[i.hair],i.x-4*body+xHair,i.y-150+yHair+8,0,1,1,80/2,80)
      elseif i.hair == 5 then
        xHair = xHair+1
        love.graphics.draw(img.sheet,quad.backhair[i.hair],i.x-4*body+xHair-24,i.y-150+yHair,0,1,1,80/2,80)
        love.graphics.draw(img.sheet,quad.backhair[i.hair],i.x-4*body+xHair+24,i.y-150+yHair,0,-1,1,80/2,80)
      elseif i.hair == 8 then
        xHair = xHair+1
        love.graphics.draw(img.sheet,quad.backhair[i.hair],i.x-4*body+xHair,i.y-150+yHair,0,1,1,80/2,80)
      end
      
      if not i.countIn == true and not i.showOff then
        local xoff = 8
        love.graphics.draw(img.sheet,quad.forearm[1],i.x+96/2-xoff,i.y-190-bounce,math.rad(-80),1,1,80,16/2)
        love.graphics.draw(img.sheet,quad.backarm[0],i.x+96/2+4-xoff-40,i.y-145-bounce,math.rad(22),0.54,1,8,16/2)
      elseif i.showOff then
        love.graphics.draw(img.sheet,quad.backarm[0],i.x-96/2+4+40-10,i.y-145+bounce,math.rad(-142),1,1,8,16/2)
        love.graphics.draw(img.sheet,quad.forearm[2],i.x-96/2-16,i.y-188+bounce,math.rad(180+45),1,1,80,16/2)
        love.graphics.draw(img.sheet,quad.backarm[0],i.x+96/2-4-40+10,i.y-145+bounce,math.rad(142+180),1,1,8,16/2)
        love.graphics.draw(img.sheet,quad.forearm[2],i.x+96/2+16,i.y-188+bounce,math.rad(-180-45+180),1,1,80,16/2)
      end
      
      love.graphics.draw(img.sheet,quad.leg,i.x-legdist,i.y+16,0,1,1,0,112)
      love.graphics.draw(img.sheet,quad.leg,i.x+legdist,i.y+16,0,-1,1,0,112)
      
      love.graphics.draw(img.sheet,quad.skirt[body],i.x,i.y-96+bounce,0,1,1,64/2,48/2)
      love.graphics.draw(img.sheet,quad.body[body],i.x-8*body,i.y-100+bounce,0,1,1,48/2,64)
      love.graphics.draw(img.sheet,quad.head,i.x-4*body,i.y-150+bounce,0,1,1,64/2,64)
      
      --face
      love.graphics.draw(img.sheet,quad.eyes[0],i.x-4*body,i.y-180+bounce,0,1,1,48/2,32/2)
      love.graphics.draw(img.sheet,quad.mouth[0],i.x-4*body,i.y-165+bounce,0,1,1,16/2,16/2)
      love.graphics.draw(img.sheet,quad.glasses[i.glasses],i.x-4*body,i.y-180+bounce,0,1,1,48/2,32/2)
      
      love.graphics.draw(img.sheet,quad.hair[i.hair],i.x-4*body+xHair,i.y-150+yHair,0,1,1,80/2,80)
      
      if i.hair == 2 then
        love.graphics.draw(img.sheet,quad.backhair[i.hair],i.x-4*body+xHair+24,i.y-150+yHair-24,0,1,1,80/2,80)
      end
      
      --ARMS AND BOOK
      print(i.showOff)
      if i.showOff then
        love.graphics.draw(img.showOff[i.showOffNum],quad.showOff[i.n+i.failAdd],i.x,i.y-163+yHair-24,0,1,1,144/2,96)
        love.graphics.draw(img.sheet,quad.book[0],i.x+96/2-16,i.y-180+bounce,0,1,1,96/2,112)
        love.graphics.draw(img.sheet,quad.book[0],i.x-96/2+16,i.y-180+bounce,0,-1,1,96/2,112)
        
        love.graphics.draw(img.sheet,quad.hand[1],i.x-96/2-16,i.y-200+bounce,0,1,1,48/2,48/2)
        love.graphics.draw(img.sheet,quad.hand[1],i.x+96/2+16,i.y-200+bounce,0,-1,1,48/2,48/2)
        
      else
        if i.countIn == true then
          love.graphics.draw(img.sheet,quad.book[i.book][i.spin],i.x,i.y-112+bounce,math.rad(90),1,1,96/2,80/2)
          
          love.graphics.draw(img.sheet,quad.forearm[1],i.x-16,i.y-112+bounce,math.rad(-12),1,1,80/2,16/2)
          love.graphics.draw(img.sheet,quad.forearm[1],i.x+16,i.y-112+bounce,math.rad(12),-1,1,80/2,16/2)
          
          love.graphics.draw(img.sheet,quad.hand[0],i.x-96/2+16,i.y-132+bounce,0,1,1,48/2,48/2)
          love.graphics.draw(img.sheet,quad.hand[0],i.x+96/2-16,i.y-136+bounce,0,-1,1,48/2,48/2)
        else
          local xoff = 8
          love.graphics.draw(img.sheet,quad.forearm[1],i.x-96/2+4-xoff,i.y-223-bounce,math.rad(-95),0.9,1,80,16/2)
          love.graphics.draw(img.sheet,quad.backarm[0],i.x-96/2+4-xoff+40,i.y-145-bounce,math.rad(-142),0.9,1,8,16/2)
          
          love.graphics.draw(img.sheet,quad.book[i.book][i.spin],i.x-xoff,i.y-236-bounce,0,1,1,96/2,80/2)
          
          love.graphics.draw(img.sheet,quad.hand[1+math.ceil(i.spin/3)],i.x-96/2+4-xoff,i.y-236-bounce,math.rad(20),1,1,48/2,48/2)
          
          love.graphics.draw(img.sheet,quad.hand[1+math.ceil(i.spin/3)],i.x+96/2-4-xoff,i.y-202-bounce,math.rad(-20),-1,1,48/2,48/2)
        end
      end
      
      if i.spin ~= 0 then
        i.spin = i.spin + i.spinDir
      else
        if i.fastSpin then 
          i.spin = 1
          i.spinDir = 1
        end
      end
      if i.spin == 3 then
        i.spinDir = -1
        i.spin = 2
        --change book
        if i.book == "black" then
          i.book = "white"
        elseif i.book == "white" then
          i.book = "black"
        end
      end
      
      --[[setColorHex("ff0000")
      --love.graphics.circle("line",i.x,i.y,3)
      setColorHex("ffffff")
      --love.graphics.print(i.hair,i.x-5,i.y-220)
      love.graphics.print(i.id,i.x-5+3,i.y-205)
      love.graphics.print(i.id,i.x-5-3,i.y-205)
      love.graphics.print(i.id,i.x-5,i.y-205+3)
      love.graphics.print(i.id,i.x-5,i.y-205-3)
      
      setColorHex("000000")
      love.graphics.print(i.id,i.x-5,i.y-205)
      setColorHex("ffffff")]]
    end
   
    love.graphics.reset()
    love.graphics.setCanvas(view.canvas)
    love.graphics.draw(img.canv,view.width/2,view.height/2,0,zoom,zoom,view.width/2,view.height/2)
  end
  
  loadMinigame[9] = lminigame
  updateMinigame[9] = uminigame
  drawMinigame[9] = dminigame
  drawMinigame[9] = dminigame
end