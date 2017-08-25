local function lminigame()
  img = {
    bg = newImageAssetFlipped("/cheer readers/bg.png"),
    sheet = newImageAssetFlipped("/cheer readers/sheet.png"),
    showOff = {
      [0] = newImageAssetFlipped("/cheer readers/showOff0.png"),
      [1] = newImageAssetFlipped("/cheer readers/showOff1.png"),
      [2] = newImageAssetFlipped("/cheer readers/showOff2.png"),
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
  anim = {
    mouth = newAnimationGroup(img.sheet)
  }
  anim.mouth:addAnimation("idle",512,192,16,16,1,100)
  
  anim.mouth:addAnimation("one",560,160,16,16,5,50)
  anim.mouth:addAnimation("two",560,160+16,16,16,6,50)
  anim.mouth:addAnimation("three",560,160+32,16,16,5,50)
  anim.mouth:addAnimation("up",560,160+48,16,16,5,50)
  anim.mouth:addAnimation("ra",640,160,16,16,5,50)

  
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
  flip = {}
  zoom = 1
  zoomTarget = 1
end

local function uminigame(dt)
  zoom = (zoom+zoomTarget)/2
  
  for _,i in pairs(currentSounds) do
    if i.name == "onec" then
      flip[1] = true
      flip[2] = true
      flip[3] = true
      flip[4] = true
      anim.mouth:setAnimation("one")
    end
    if i.name == "twoc" then
      flip[5] = true
      flip[6] = true
      flip[7] = true
      flip[8] = true
      anim.mouth:setAnimation("two")
    end
    if i.name == "threec" then
      flip[9] = true
      flip[10] = true
      flip[11] = true
      anim.mouth:setAnimation("three")
    end
    
    if i.name == "its" then
      flip[1] = true
      flip[5] = true
      flip[9] = true
      anim.mouth:setAnimation("three")
    end
    if i.name == "up" then
      flip[2] = true
      flip[6] = true
      flip[10] = true
      anim.mouth:setAnimation("up")
    end
    if i.name == "to" then
      flip[3] = true
      flip[7] = true
      flip[11] = true
      anim.mouth:setAnimation("two")
    end
    if i.name == "you" then
      flip[4] = true
      flip[8] = true
      anim.mouth:setAnimation("two")
    end
    
    if i.name == "ra" then
      flip[1] = true
      anim.mouth:setAnimation("ra")
    end
    if i.name == "ra2" then
      flip[2] = true
      flip[5] = true
      anim.mouth:setAnimation("ra")
    end
    if i.name == "sis" then
      flip[3] = true
      flip[6] = true
      flip[9] = true
      anim.mouth:setAnimation("three")
    end
    if i.name == "boom" then
      flip[4] = true
      flip[7] = true
      flip[10] = true
      anim.mouth:setAnimation("ra")
    end
    if i.name == "ba" then
      flip[8] = true
      flip[11] = true
      anim.mouth:setAnimation("ra")
    end
    if i.name == "BOOM" then
      anim.mouth:setAnimation("ra")
    end
    
    if i.name == "go" then
      flip[1] = true
      anim.mouth:setAnimation("one")
    end
    if i.name == "read" then
      flip[2] = true
      flip[5] = true
      anim.mouth:setAnimation("three")
    end
    if i.name == "a" then
      flip[3] = true
      flip[6] = true
      flip[9] = true
      anim.mouth:setAnimation("ra")
    end
    if i.name == "bunch" then
      flip[4] = true
      flip[7] = true
      flip[10] = true
      anim.mouth:setAnimation("up")
    end
    if i.name == "of" then
      flip[8] = true
      flip[11] = true
      anim.mouth:setAnimation("one")
    end
    if i.name == "books" then
      anim.mouth:setAnimation("one")
    end
    
    if i.name == "o" then
      for _,i in pairs(girls) do
        i.bounce = 5
      end
      anim.mouth:setAnimation("one")
    end
    if i.name == "kay" then
      for _,i in pairs(girls) do
        i.bounce = 5
      end
      anim.mouth:setAnimation("three")
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
      anim.mouth:setAnimation("three")
    end
    if i.name == "on" then
      local showOffNum = love.math.random(0,2)
      for _,i in pairs(girls) do
        i.fastSpin = false
        i.showOff = true
        i.showOffNum = showOffNum
      end
      zoomTarget = 1.5
      anim.mouth:setAnimation("one")
    end
    if i.name == "zoomReset" then
      zoomTarget = 1
    end
  end
  
  for _,i in pairs(girls) do
    if flip[i.n] then
      flip[i.n] = nil
      i.bounce = 5
      --print("flip",flip,i.id,flip+i.id)
      if not i.player then
        if i.showOff then
          i.book = "black"
        end
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
        if i.showOff then
          i.book = "black"
        end
        i.showOff = false
        if i.countIn then
          i.countIn = false
        end
        
        i.spin = 1
        i.spinDir = 1
      end
    end
  end
  --mouth animation
  anim.mouth:update(dt)
  if anim.mouth:getCurrentFrame() == anim.mouth:getLength(anim.mouth:getCurrentAnimation())-1 then
    anim.mouth:setAnimation("idle")
  end
end

local function dminigame()
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
    anim.mouth:draw(i.x-4*body,i.y-165+bounce,0,1,1,anim.mouth:getWidth()/2,anim.mouth:getHeight()/2)--love.graphics.draw(img.sheet,quad.mouth[0],i.x-4*body,i.y-165+bounce,0,1,1,16/2,16/2)
    love.graphics.draw(img.sheet,quad.glasses[i.glasses],i.x-4*body,i.y-180+bounce,0,1,1,48/2,32/2)
    
    love.graphics.draw(img.sheet,quad.hair[i.hair],i.x-4*body+xHair,i.y-150+yHair,0,1,1,80/2,80)
    
    if i.hair == 2 then
      love.graphics.draw(img.sheet,quad.backhair[i.hair],i.x-4*body+xHair+24,i.y-150+yHair-24,0,1,1,80/2,80)
    end
    
    --ARMS AND BOOK
    --print(i.showOff)
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
    love.graphics.print(i.n,i.x-5+3,i.y-205)
    love.graphics.print(i.n,i.x-5-3,i.y-205)
    love.graphics.print(i.n,i.x-5,i.y-205+3)
    love.graphics.print(i.n,i.x-5,i.y-205-3)
    
    setColorHex("000000")
    love.graphics.print(i.n,i.x-5,i.y-205)
    setColorHex("ffffff")]]
  end
 
  love.graphics.reset()
  love.graphics.setCanvas(view.canvas)
  love.graphics.draw(img.canv,view.width/2,view.height/2,0,zoom,zoom,view.width/2,view.height/2)
end

return {lminigame,uminigame,dminigame}