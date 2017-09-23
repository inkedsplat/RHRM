function loadMinigames()
  loadMinigame = {}
  updateMinigame = {}
  drawMinigame = {}
  img = {}
  anim = {}
  quad = {}
  
  flow = data.options.karateka.startFlow
  
  --[[ REQUIRE ALL OF THE MINIGAMES ]]--
  local f = love.filesystem.getDirectoryItems("/resources/minigames") 
  local minigameFunc = {}
  for k,i in pairs(f) do
    for n,j in pairs(require("/resources/minigames/"..i:sub(1,i:len()-4))) do
      if n == 1 then
        loadMinigame[k] = j
      elseif n == 2 then
        updateMinigame[k] = j
      elseif n == 3 then
        drawMinigame[k] = j
      end
    end
  end
end

function newImageAssetFlipped(filename)                        
  if love.filesystem.exists("/tempAssets/"..filename) then                                       
    --print("temp")
    return love.graphics.newImage("/tempAssets/"..filename)
  end
  --print("original")
  return love.graphics.newImage("/resources/gfx/"..filename)
end
function newImageAssetUserOnly(filename)    
  if love.filesystem.exists("/tempAssets/"..filename) then                                       
    --print("user Image")
    return love.graphics.newImage("/tempAssets/"..filename)
  end
  return nil
end