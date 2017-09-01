local function lminigame()
  img = {
    onion = newImageAssetFlipped("/rhythm tweezers (GBA)/onion.png"),
    face = newImageAssetFlipped("/rhythm tweezers (GBA)/face.png"),
    roots = newImageAssetFlipped("/rhythm tweezers (GBA)/roots.png"),
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

local function uminigame(dt)
  for _,s in pairs(currentSounds) do
    if s.name == "call" then
      phase = "call"
      roots = {}
      responseTime = s.time+4
      rootMaker.x = rootMaker.startX
      rootMaker.y = rootMaker.startY
    end
  end
  
  for _,s in pairs(currentSounds) do
    --print(s.name)
    if s.name == "appear" then
      local r = {
        time = s.time+4,
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
        time = s.time+4,
        pluckTime = s.time+4.5,
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
  
  if data.beat >= responseTime and phase == "call" then
    phase = "response"
    rootMaker.x = rootMaker.startX
    rootMaker.y = rootMaker.startY
  end
  if data.beat >= responseTime+4 and phase == "response" then
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
        
        if data.beat > i.time-margin and data.beat < i.time+margin and input["pressANY"] then
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
          if data.beat > i.pluckTime and input["holdANY"] and i.held then
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

local function dminigame()
  setColorHex("f8f8f8")
  love.graphics.rectangle("fill",0,0,view.width,view.height)
  setColorHex("ffffff")
  love.graphics.draw(img.onion,view.width/2,view.height/2-30-math.max(onion.twitch,0)*2,0,3,3,img.onion:getWidth()/2,img.onion:getHeight()/2)
  
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

return {lminigame,uminigame,dminigame}