local function lminigame()
  img = {
    sheet = newImageAssetFlipped("/moai doo-woop/sheet.png")
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
    disappointTime = 0,
    y = 0
  }
  turn = 0
end

local function uminigame(dt)
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
  
  if o.disappointTime > 0 then
    o.disappointTime = o.disappointTime-dt*100
    o.head = 4
  end
  
  if o.pahTime > 0 then
    o.pahTime = o.pahTime-dt*100
    o.head = 3
  end
  
  --PLAYER MOAI
  local hit = 0
  local bearly = false
  
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
    bearly = i.bearly
  end
  
  if input["holdA"] then
    p.head = 1
    if input["pressA"] then
      snd.dooStart:stop()
      snd.dooStart:play()
      
      snd.doo:stop()
      
      if hit ~= 1 or bearly then
        misses = misses+1
        print("missed")
        snd.fail:stop()
        snd.fail:play()
        o.head = 4
        o.disappointTime = 100
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
    
    if hit ~= 2 or bearly then
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
    if hit ~= 3 or bearly then
      misses = misses+1
      print("missed")
      snd.fail:stop()
      snd.fail:play()
      o.head = 4
      o.disappointTime = 100
    end
  end
  
  if p.pahTime > 0 then
    p.pahTime = p.pahTime-dt*100
    p.head = 3
  end
end

local function dminigame()
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

return {lminigame,uminigame,dminigame}