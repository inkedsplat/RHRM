local function lminigame()
  img = {
    sheet = newImageAssetFlipped("/screw bots/sheet.png")
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

local function uminigame(dt)
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
    if i.name == "c1.5" then
      crane.phase = 1.5
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
  elseif crane.phase == 1.5 then
    crane.rot = (crane.rot+(70))/2
    crane.rot1 = (crane.rot1+(-70))/2
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

local function dminigame()
  setColorHex("ffffff")
  love.graphics.rectangle("fill",0,0,view.width,view.height)
  
  --draw back claw
  local clawLength = clawLengthBase+clawLengthAdd
  local clawRotation = claw.rot
  love.graphics.draw(img.sheet,quad.claw[math.floor(claw.f)],view.width/3+8,clawLength+32+6,math.rad(clawRotation),1,1,144/2,18)
  
  for _,i in pairs(bots) do
    if i.complete then
      i.bounce = beat/5
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

return {lminigame,uminigame,dminigame}