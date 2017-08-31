--[[ I LOVE TAP! (TAP TRIAL GBA)]]--
--[[ ADDED BY INKEDSPLAT ]]--

function lminigame()
  img = {
    sheet = newImageAssetFlipped("/tap trial (GBA)/sheet.png"),
    pCanv = love.graphics.newCanvas(128,128)
  }
  quad = {
    bg = love.graphics.newQuad(0,0,256,160,img.sheet:getWidth(),img.sheet:getHeight())
  }
  --[[ DEFINE THE PLAYER (ONLY ANIMATIONS !)]]--
  playerAnim = newPieceAnimationGroup("/resources/gfx/tap trial (GBA)/player.anim",img.sheet,128,256)
  playerAnim.frameDuration = 40
  p = {
    sx = 1
  }
  --1 = IDLE
  --3 = HEAD BOB
  --4 = PREPARE TAP
  --5 = PREPARE TAP IDLE
  --6 = TAP
  
  monkeyAnim = newPieceAnimationGroup("/resources/gfx/tap trial (GBA)/monkey.anim",img.sheet,128,256)
  monkeyAnim.frameDuration = 40
  m = {
    sx = 1,
    tapEnd = true,
  }
  --1 = IDLE
  --2 = HEAD BOB
  --3 = PREPARE TAP
  --4 = TAP
  --5 = PREPARE TAP 2 
  --6 = PREPARE TRIPLE TAP 1
  --7 = PREPARE TRIPLE TAP 2
  --8 = PREPARE TRIPLE TAP 2 IDLE
  --9 = 1 TRIPLE TAP
  --10 = PREPARE TAP IDLE
end

function uminigame(dt)
  playerAnim:update(dt)
  monkeyAnim:update(dt)
  
  --[[ PLAYER ANIMATIONS ]]--
  --[[ anyone up to making an animation tree editor eh ? ]]--
  for _,i in pairs(currentSounds) do
    if i.name == "ook" then
      playerAnim:setAnimation(4)
      p.sx = 1
      monkeyAnim:setAnimation(3)
      m.sx = 1
    end
    if i.name == "ook1" then
      playerAnim:setAnimation(4)
      p.sx = -1
      monkeyAnim:setAnimation(3)
      m.sx = -1
    end
    if i.name == "ook2" then
      monkeyAnim:setAnimation(5)
    end
    if i.name == "ookee1" then
      playerAnim:setAnimation(7)
      monkeyAnim:setAnimation(6)
      m.sx = 1
    end
    if i.name == "ookee2" then
      playerAnim:setAnimation(8)
      monkeyAnim:setAnimation(7)
    end
    
    if i.name == "tap" then
      monkeyAnim:setAnimation(4)
    end
    if i.name == "tap1" then
      monkeyAnim:setAnimation(9)
      m.tapEnd = false
      m.sx = 1
    end
    if i.name == "tap2" then
      monkeyAnim:setAnimation(9)
      m.sx = -1
    end
    if i.name == "tap3" then
      monkeyAnim:setAnimation(9)
      m.tapEnd = true
      m.sx = 1
    end
  end
  
  if input["pressA"] then
    playerAnim:setAnimation(6)
  end
  
  for _,i in pairs(currentHits) do
    if i.name == "tap" then
      playerAnim:setAnimation(6)
    end
    if i.name == "tap1" then
      playerAnim:setAnimation(10)
      p.sx = 1
    end
    if i.name == "tap2" then
      playerAnim:setAnimation(10)
      p.sx = -1
    end
    if i.name == "tap3" then
      playerAnim:setAnimation(10)
      p.sx = 1
    end
  end
  
  if playerAnim:getAnimation() == 1 then
    if beat == 10 then
      playerAnim:setAnimation(3)
    end
  elseif playerAnim:getAnimation() == 3 then
    if playerAnim:animationEnd() then
      playerAnim:setAnimation(1)
    end
  elseif playerAnim:getAnimation() == 4 then
    if playerAnim:animationEnd() then
      playerAnim:setAnimation(5)
    end
  elseif playerAnim:getAnimation() == 6 then
    if playerAnim:animationEnd() then
      playerAnim:setAnimation(1)
      p.sx = 1
    end
  elseif playerAnim:getAnimation() == 8 then
    if playerAnim:animationEnd() then
      playerAnim:setAnimation(9)
    end
  elseif playerAnim:getAnimation() == 10 then
    if playerAnim:animationEnd() then
      playerAnim:setAnimation(1)
    end
  end
  
  if monkeyAnim:getAnimation() == 1 then
    if beat == 10 then
      monkeyAnim:setAnimation(2)
    end
  elseif monkeyAnim:getAnimation() == 2 then
    if monkeyAnim:animationEnd() then
      monkeyAnim:setAnimation(1)
    end
  elseif monkeyAnim:getAnimation() == 3 then
    if monkeyAnim:animationEnd() then
      monkeyAnim:setAnimation(10)
    end
  elseif monkeyAnim:getAnimation() == 4 then
    if monkeyAnim:animationEnd() then
      monkeyAnim:setAnimation(1)
    end
  elseif monkeyAnim:getAnimation() == 5 then
    if monkeyAnim:animationEnd() then
      monkeyAnim:setAnimation(3)
    end
  elseif monkeyAnim:getAnimation() == 7 then
    if monkeyAnim:animationEnd() then
      monkeyAnim:setAnimation(8)
    end
  elseif monkeyAnim:getAnimation() == 9 then
    if monkeyAnim:animationEnd() then
      if m.tapEnd == true then
        monkeyAnim:setAnimation(1)
      else
        monkeyAnim:setAnimation(11)
      end
    end
  end
end

function dminigame()
  --[[
    ALWAYS SET SX AND SY TO 4!
  ]]--
  --[[ DRAW THE BG ]]--
  love.graphics.draw(img.sheet,quad.bg,view.width/2+32,view.height/2,0,4,4,256/2,160/2)

  playerAnim:draw(512+64+64,256+128+32,0,4*p.sx,4,playerAnim:getWidth()/2,playerAnim:getHeight()/2)
  
  monkeyAnim:draw(440,418,0,4*m.sx,4,playerAnim:getWidth()/2,playerAnim:getHeight()/2)
  monkeyAnim:draw(280,418,0,4*m.sx,4,playerAnim:getWidth()/2,playerAnim:getHeight()/2)
end

return {lminigame,uminigame,dminigame}