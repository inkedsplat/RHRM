  local function lminigame()
    img = {
      sheet = newImageAssetFlipped("/Fork Lifter/sheet.png")
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
  
  local function uminigame(dt)
    for _,i in pairs(currentSounds) do
      if i.name == "flick" then
        shoot = true
        shootEnd = i.time+((0.25)*(60000/data.bpm))/1000
      end
      if i.name == "zoom" then
        local s = {
          stabTime = i.time+((0.5)*(60000/data.bpm))/1000,
          x = 128+128+8,
          y = 256-16,
          z = 0
        }
        table.insert(peas,s)
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
      local hsp = 3110*3.35
      local vsp = 900*3.35
      local zsp = 10*3
      i.x = i.x+hsp*(data.bpm/60000)
      i.y = i.y+vsp*(data.bpm/60000)
      i.z = i.z+zsp*(data.bpm/60000)
      if i.x > view.width then
        table.remove(peas,k)
      end
    end
  end
  
  local function dminigame()
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
  
  return {lminigame,uminigame,dminigame}