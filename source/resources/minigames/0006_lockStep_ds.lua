  local function lminigame()
    img = {
      sheet = newImageAssetFlipped("/Lock step/sheet.png"),
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
  
  local function uminigame(dt)

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
  
  local function dminigame()
    love.graphics.setCanvas(img.canv)
    
    if data.options.lockStep.paletteSwap == "yes" then
      setColorHex("000000",255)
    else
      local col = data.options.lockStep.colors
      setColorHex(col["bg"],255)
    end
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
  
  return {lminigame,uminigame,dminigame}