--[[ CROP STOMP ]]--
--[[ ADDED BY INKEDSPLAT ]]--

function lminigame()
  img = {
    sheet = newImageAssetFlipped("Crop Stomp/sheet.png"),
  }
  quad = {
    bg = love.graphics.newQuad(0,0,16,16,img.sheet:getWidth(),img.sheet:getHeight()),
    grass = love.graphics.newQuad(0,16,192,48,img.sheet:getWidth(),img.sheet:getHeight()),
  }
  cam  = {
    x = 0,
    y = 0,
  }
  p = {
    legs = newAnimationGroup(img.sheet)
  }
  p.legs:addAnimation("rightstep",0,64,80,96,12,100)
  p.legs:removeFrame("rightstep",9)
  p.legs:removeFrame("rightstep",9)
  p.legs:removeFrame("rightstep",9)
  
  p.legs:addAnimation("leftstep",0,160,80,96,12,100)
  p.legs:removeFrame("leftstep",9)
  p.legs:removeFrame("leftstep",9)
  p.legs:removeFrame("leftstep",9)
end

function uminigame(dt)
  p.legs:update(dt)
  
  if p.legs:isFinished() then
    if p.legs:getCurrentAnimation() == "rightstep" then
      p.legs:setAnimation("leftstep")
    elseif p.legs:getCurrentAnimation() == "leftstep" then
      p.legs:setAnimation("rightstep")
    end
  end
end

function dminigame()
  love.graphics.draw(img.sheet,quad.bg,0,0,0,view.width/16,view.height/16)
  
  love.graphics.draw(img.sheet,quad.grass,0,view.height-48*2,0,2,2)
  love.graphics.draw(img.sheet,quad.grass,192*2,view.height-48*2,0,2,2)
  love.graphics.draw(img.sheet,quad.grass,192*3,view.height-48*2,0,2,2)
  
  p.legs:draw(0,0,0,2,2)
end

return {lminigame,uminigame,dminigame}