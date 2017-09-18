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
    
    screen = "credits"
    loadCredits()
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

function loadCredits()
  credits = {
    "TheRhythmKid",
    "with game icons",
    "chrislo"..tostring(love.math.random(1,999)),
    "with some programming",
    "MarioFan5000",
    "with the tap trial sheet",
    "Minenice55",
    "with the fan club animations",
    "Pnegu123",
    "because he wanted to be in the credits",
  }
  creditStr = {{255,255,255},"with the help of these people:\n"}
  for k,i in pairs(credits) do
    if k/2 ~= math.floor(k/2) then
      table.insert(creditStr,{255,248,98})
      table.insert(creditStr,i.." ")
    else
      table.insert(creditStr,{255,255,255})
      table.insert(creditStr,i)
      local str = ", "
      if k == tableLength(credits) then
        str = ""
      elseif k == tableLength(credits)-2 then
        str = " and "
      end
      table.insert(creditStr,str)
    end
  end
  
  time = 5
end

function updateCredits(dt)
  time = time-dt
  if time <= 0 or love.keyboard.isDown("return") or love.keyboard.isDown("space") then
    creditStr = nil
    credits = nil
    loadMenu()
    screen = "menu"
  end
end

function drawCredits()
  setColorHex("000000")
  love.graphics.rectangle("fill",0,0,view.width,view.height)
  setColorHex("ffffff")
  love.graphics.printf({{255,255,255},"RHRM is a 'game' made by ",{255,248,98},"philip rousseau (inkedsplat)"},16,view.height/2-64,view.width-32,"center")
  love.graphics.printf((creditStr or "I AM ERROR"),16,view.height/2,view.width-32,"center")
  
  if time <= 1 then
    setColorHex("000000",(1-time)*255)
    love.graphics.rectangle("fill",0,0,view.width,view.height)
  end
end