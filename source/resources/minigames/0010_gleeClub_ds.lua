function lminigame()
  img = {
    sheet = newImageAssetFlipped("/glee club/sheet.png")
  }
  quad = {
    bg = love.graphics.newQuad(0,0,960,540,img.sheet:getWidth(),img.sheet:getHeight())
  }
  anim = {
    
  } 
  kids = {}
  local p
  for i = 0,2 do
    p = {
      x = view.width/2-32+128*i,
      y = view.height/2-128-64+16*i,
      anim = newAnimationGroup(img.sheet)
    }
    p.anim:addAnimation("idle",960,112,48,80,3)
    
    table.insert(kids,p)
  end
  p.player = true
  
  conductor = {
    anim = newAnimationGroup(img.sheet),
    x = view.width/2-256,
    y = view.height/2,
  }
  conductor.anim:addAnimation("idle",960,0,64,112,3)
end

function uminigame(dt)
  for _,i in pairs(kids) do
    i.anim:update(dt)
  end
  conductor.anim:update(dt)
end

function dminigame()
  love.graphics.draw(img.sheet,quad.bg)
  for _,i in pairs(kids) do
    i.anim:draw(i.x,i.y,0,3,3)
  end
  
  conductor.anim:draw(conductor.x,conductor.y,0,3,3)
end

return {lminigame,uminigame,dminigame}