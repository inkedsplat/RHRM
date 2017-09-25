function loadLibrary()
  tempRemixList = love.filesystem.getDirectoryItems("library")
  remixList = {}
  for k,i in pairs(tempRemixList) do 
    local file = love.filesystem.newFile("library/"..i)
    local filename = i
    if string.lower(string.sub(filename,filename:len()-5)) == ".brhrm" then
      table.insert(remixList,{filename = filename})
    end
  end
  selection = 0
  tempRemixList = nil
end

function updateLibrary(dt)
  local mx, my = love.mouse.getPosition()
  updateMenu(dt)
  for k,i in pairs(remixList) do
    if my > 32+48*k and my < 32+48*k+64 then
      selection = k
    end
  end
  if my > 32+48*tableLength(remixList)+64 or my < 32+48+16 then
    selection = -1
  end
end

function drawLibrary()
  local mx, my = love.mouse.getPosition()
  drawMenu()
  setColorHex("000000",200)
  love.graphics.rectangle("fill",16,16,view.width-32,view.height-32)
  love.graphics.setFont(fontBig)
  setColorHex("ffffff",255)
  love.graphics.printf("library",0,16,view.width,"center")
  
  for k,i in pairs(remixList) do
    if selection == k then
      setColorHex("FFFFFF",255)
    else
      setColorHex("6F6F6F",255)
    end
    love.graphics.print(i.filename,32,32+48*k)
  end
end

function unloadLibrary()
  
end
