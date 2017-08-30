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
  anim = newPieceAnimationGroup("/resources/gfx/tap trial (GBA)/player.anim",img.sheet,128,128)
  --1 = IDLE
  --3 = HEAD BOB
  --4 = PREPARE TAP
  --6 = PREPARE TAP IDLE
  --6 = TAP
end

function uminigame(dt)
  anim:update(dt)
end

function dminigame()
  --[[
    ALWAYS SET SX AND SY TO 4!
  ]]--
  --[[ DRAW THE BG ]]--
  love.graphics.draw(img.sheet,quad.bg,view.width/2+32,view.height/2,0,4,4,256/2,160/2)

  anim:draw(0,0,0,4,4)
end

return {lminigame,uminigame,dminigame}