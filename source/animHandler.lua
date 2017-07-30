--this animation handler was made by Inkedsplat (philip rousseau)
local animationGroup = {}
animationGroup.__index = animationGroup

function newAnimationGroup(image)
  local g = {}
  g.img = image
  g.img:setFilter("nearest","nearest")
  g.width = image:getWidth()
  g.height = image:getHeight()
  g.animations = {}
  g.frame = 0
  g.timer = 0
  g.currentAnimation = nil
  g.playing = true
  g.transition = false
  g.nextAnimation = nil
  g.finishing = false
  
  return setmetatable(g, animationGroup)
end

function animationGroup:addAnimation(id,x,y,w,h,frames,frameDuration)
  local a = {}
  a.length = frames
  a.id = id
  a.w = w
  a.h = h
  for i = 0, frames-1 do
    a[i] = {}
    a[i].quad = love.graphics.newQuad(x+i*w,y,w,h,self.width,self.height)
    a[i].duration = frameDuration or 100
  end
  table.insert(self.animations,a)
  self.currentAnimation = a
  
  return a
end

function animationGroup:update(dt)
  if self.playing then 
    self.timer = self.timer + dt*1000
  end
  
  if self.timer > self.currentAnimation[self.frame].duration then
    self.timer = self.timer-self.currentAnimation[self.frame].duration
    self.frame = self.frame+1
    if self.frame > self.currentAnimation.length-1 then
      self.frame = 0
    end
  end
  
end

function animationGroup:setAnimation(id)
  local id = id 
  local success = false
  
  if self.currentAnimation.id ~= id then
    for _,i in pairs(self.animations) do
      if i.id == id then
        self.currentAnimation = i
        self.frame = 0
        success = true
        self.finishing = false
      end
    end
    if not success then 
      print("an animation with id '"..tostring(id).."' doesn't exists")
    end
  end
end

function animationGroup:pause()
  self.playing = false
end

function animationGroup:play()
  self.playing = true
end

function animationGroup:animationExists(id)
  for _,i in pairs(self.animations) do
	if i.id == id then
	  return true
	end
  end
  return false
end

function animationGroup:getCurrentFrame()
  return self.frame
end

function animationGroup:setFrame(frame)
  self.frame = frame
  self.timer = 0
end

function animationGroup:getWidth()
  return self.currentAnimation.w
end

function animationGroup:getHeight()
  return self.currentAnimation.h
end

function animationGroup:getCurrentAnimation()
  return self.currentAnimation.id
end

function animationGroup:draw(x,y,r,sx,sy,ox,oy,kx,ky)
  love.graphics.draw(self.img,self.currentAnimation[self.frame].quad,x,y,r,sx,sy,ox,oy,kx,ky)
end


