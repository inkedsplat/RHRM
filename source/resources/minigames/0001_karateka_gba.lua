function lminigame()
  img = {
    lowerbody = newImageAssetFlipped("/karate man (GBA)/lowerbody.png"),
    objects = newImageAssetFlipped("/karate man (GBA)/objects.png"),
    clothes = newImageAssetUserOnly("/karate man (GBA)/clothes.png"),
  }
  quad = {
    pot = love.graphics.newQuad(0,0,32,32,img.objects:getWidth(),img.objects:getHeight()),
    rock = love.graphics.newQuad(32,0,32,32,img.objects:getWidth(),img.objects:getHeight())
  }
  if img.clothes then
    quad.hat = love.graphics.newQuad(0,0,96,96,img.clothes:getWidth(),img.clothes:getHeight())
    quad.pants = love.graphics.newQuad(96,0,96,96,img.clothes:getWidth(),img.clothes:getHeight())
    quad.shirt = love.graphics.newQuad(0,96,96,96,img.clothes:getWidth(),img.clothes:getHeight())
  end
  anim = {
    head = newAnimationGroup(newImageAssetFlipped("/karate man (GBA)/head.png")),
    upperBody = newAnimationGroup(newImageAssetFlipped("/karate man (GBA)/upperbody.png")),
    leftArm = newAnimationGroup(newImageAssetFlipped("/karate man (GBA)/upperbody.png")),
    flow = newAnimationGroup(newImageAssetFlipped("/karate man (GBA)/flow.png")),
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
        vsp = 20*math.sqrt(119/bpm),
        x = 0,
        quad = quad.pot,
        flying = true,
        time = s.time+1
      }
      table.insert(pots,p)
    end
    if s.name == "rock throw" then
      local p = {
        rot = 0,
        y = -300,
        z = 10,
        vsp = 20*math.sqrt(119/bpm),
        x = 0,
        quad = quad.rock,
        flying = true,
        time = s.time+1
      }
      table.insert(pots,p)
    end
  end
  
  for k,i in pairs(sounds) do
    if data.beat >= i.time then
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
          i.rot = i.rot+0.4*(bpm/119)
        end
    else
      if i.flying then
        i.vsp = i.vsp-0.55
        if i.y > -100 or i.z > 0 then
          i.y = i.y + i.vsp*(bpm/119)
          i.z = i.z-0.30*(bpm/119)
          i.x = i.x-6*(bpm/119)
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
          if data.beat > i.time-bearlyMargin and data.beat < i.time+bearlyMargin then
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
                  time = i.time,
                  sound = snd.ohYeah
                }
                table.insert(sounds,s)
              end
              if flow >= 5 and i.quad == quad.pot then
                snd.potHitFlow:stop()
                snd.potHitFlow:play()
                i.vsp = 2
                
                local s = {
                  time = i.time,
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
        if data.beat > i.time+bearlyMargin then
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
        i.rot = i.rot+0.4*(bpm/119)
         
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
  if quad.pants then
    love.graphics.draw(img.clothes,quad.pants,128-32-32,view.height/2+16-48+6,0,2,2)
  end
  
  if data.options.karateka.extremeBob then
    anim.leftArm:draw(128+48+offsetx/2,view.height/2-64+beat*10-(surprised),0,2,2)
    anim.upperBody:draw(128-16+offsetx/2,view.height/2-64+beat*10-(surprised),0,2,2)
    
    anim.head:draw(128+offsetx*1.5+beat/5,view.height/2-128+beat*20-(surprised*2),0,2,2)
    
    if quad.hat then
      love.graphics.draw(img.clothes,quad.hat,128+offsetx*1.5+beat/5+32,view.height/2-128+beat*20-(surprised*2)+40,0,2,2,96/2,96/2)
    end
  else
    anim.leftArm:draw(128+48+offsetx/2,view.height/2-64+beat/4-(surprised),0,2,2)
    anim.upperBody:draw(128-16+offsetx/2,view.height/2-64+beat/4-(surprised),0,2,2)
    
    anim.head:draw(128+offsetx*1.5+beat/5,view.height/2-128+beat/2-(surprised*2),0,2,2)
    if quad.hat then
      love.graphics.draw(img.clothes,quad.shirt,128-16+offsetx/2-50,view.height/2-64+beat/4-(surprised)-49,0,2,2)
      
      love.graphics.draw(img.clothes,quad.hat,128+offsetx*1.5+beat/5+32,view.height/2-128+beat/2-(surprised*2)+40,0,2,2,96/2,96/2)
    end
  end
  
  for _,i in pairs(pots) do
    love.graphics.draw(img.objects,i.quad,view.width/2+i.x-32,view.height/2-i.y,i.rot,1+i.z,math.max(1+i.z,0),16,16)
  end
  
  if data.options.karateka.flow then
    anim.flow:draw(32,view.height/2-128,0,2,2)
  end
end

return {lminigame, uminigame, dminigame}