function loadInit()
  entry = ""
end

function updateInit(dt)
  
end

function keypressedInit(key)
  if key == "backspace" then
    entry = entry:sub(1,entry:len()-1)
  elseif key == "return" and entry ~= "" then
    pref = {
      username = entry
    }
    local str = json.encode(pref)
    love.filesystem.write("preferences.sav",str)
    entry = ""
    
    screen = "menu"
    loadMenu()
  end
end

function textInputInit(t)
  entry = entry..t
end

function drawInit()
  setColorHex("000000")
  love.graphics.rectangle("fill",0,0,view.width,view.height)
  setColorHex("ffffff")
  love.graphics.setFont(font)
  love.graphics.printf("This username will be displayed on remixes you make",0,view.height/2-32,view.width,"center")
  love.graphics.printf("press enter to continue",-16,view.height-32,view.width,"right")
  love.graphics.setFont(fontBig)
  love.graphics.printf("CHOOSE A USERNAME:",0,view.height/2-96,view.width,"center")
  love.graphics.printf(entry,0,view.height/2,view.width,"center")
end