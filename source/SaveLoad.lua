function updateSavescreen(dt)
  local mx, my = love.mouse.getPosition()
  local k = 0
  for _,i in pairs(files) do
    if love.filesystem.isDirectory("remixes/"..i) then
      if my > 96+24*k and my < 96+24*(k+1)-1 then
        if mouse.button.pressed[1] then
          entry = i
          if exportRemixBool then
            exportRemix()
          end
        end
      end
      k = k+1
    end
  end
end

function drawSavescreen()
  setColorHex(editor.scheme.bg)
  love.graphics.rectangle("fill",view.width/2-256,view.height/2-256,256*2,256*2)
  setColorHex(editor.scheme.grid)
  love.graphics.rectangle("line",view.width/2-256,view.height/2-256,256*2,256*2)
  love.graphics.setFont(fontBig)
  if exportRemixBool then
    printNew("EXPORT REMIX",view.width/2-128,32)
    love.graphics.setFont(font)
    love.graphics.printf("choose the remix you want to export",view.width/2-256,48,512,"center")
  elseif loadRemixBool then
    printNew("LOAD REMIX",view.width/2-128,32)
  else
    printNew("SAVE REMIX",view.width/2-128,32)
  end
  love.graphics.setFont(font)
  
  if not exportRemixBool then
    printNew(entry,view.width/2-128,64)
  end
  
  local k = 0
  local mx, my = love.mouse.getPosition()
  for _,i in pairs(files) do
      if love.filesystem.isDirectory("remixes/"..i) then
        
      if my > 96+24*k and my < 96+24*(k+1)-1 then
        setColorHex("303030")
      else
        setColorHex("000000")
      end
      
      printNew(i,view.width/2-128,96+24*k)
      k = k+1
    end
  end
end

function love.textinput(t)
  if screen == "save" then
    if not loadRemixBool then
      entry = entry..t
    end
  elseif screen == "remixOptions" then
    textinputRemixOptions(t)
  elseif screen == "init" then
    textInputInit(t)
  end
end

function loadRemix()
  local dir = "/remixes/"..entry.."/beatmap.rhrm"
  if love.filesystem.exists(dir) then
    local file = love.filesystem.newFile(dir)
    editorLoadBeatmap(file)
    print("beatmap was successfully loaded")
  end
  
  local f = love.filesystem.getDirectoryItems("/remixes/"..entry)
  for _,i in pairs(f) do
    if i:sub(1,5) == "music" then
      dir = "/remixes/"..entry.."/"..i
    end
  end
  print(dir)
  if love.filesystem.exists(dir) then
    local file = love.filesystem.newFile(dir)
    editorLoadMusic(file)
    print("music was successfully loaded")
  end
  
  dir = "/remixes/"..entry.."/assets.gfx"
  if love.filesystem.exists(dir) then
    local file = love.filesystem.newFile(dir)
    editorLoadAssets(file)
    print("assets were successfully loaded")
  end
  
  love.window.setTitle("RHRM - "..version.." - "..entry)
end

function saveRemix()
  --save with "entry" as it's name
  data.dir = entry
  if not data.author then
    data.autor = pref.username
  end
  
  local dir = "/remixes/"..entry
  if not love.filesystem.exists(dir) then
    love.filesystem.createDirectory(dir)
  end
  
  local d = writeData(data)
  love.filesystem.write(dir.."/beatmap.rhrm",d)
  if love.filesystem.exists(dir.."/beatmap.rhrm") then
    print("the beatmap was succesfully saved!")
  end
  
  local filename 
  local f = love.filesystem.getDirectoryItems("/temp")
  for _,i in pairs(f) do
    if i:sub(1,5) == "music" then
      filename = i
    end
  end
  if filename then
    local file = love.filesystem.newFile("temp/"..filename)
    if file:open("r") then
      d = file:read()
      love.filesystem.write(dir.."/"..filename,d)
      if love.filesystem.exists(dir.."/"..filename) then
        print("the music was succesfully saved!")
      end
    end
  else
    print("no music was found")
  end
  
  if love.filesystem.exists("temp/assets.gfx") then
    file = love.filesystem.newFile("temp/assets.gfx")
    if file:open("r") then
      d = file:read()
      love.filesystem.write(dir.."/assets.gfx",d)
      if love.filesystem.exists(dir.."/assets.gfx") then
        print("the assets was succesfully saved!")
      end
    end
  end
  love.window.setTitle("RHRM - "..version.." - "..entry)
end

function exportRemix()
  local userDir = love.filesystem.getUserDirectory()
  
  local destPath = userDir..[[Desktop\]]..entry..".zip"
  
  local path = userDir..[[AppData\Roaming\rhythmHeavenRemixMaker\remixes\]]..entry..[[\beatmap.rhrm]]
  
  local script = [[Compress-Archive -Path ]]..path..[[ -DestinationPath ]]..destPath
  executePowershell(script)
  
  for _,i in pairs(love.filesystem.getDirectoryItems("/remixes/"..entry)) do
    if i ~= "beatmap.rhrm" then
      path = userDir..[[AppData\Roaming\rhythmHeavenRemixMaker\remixes\]]..entry..[[\]]..i
      script = [[Compress-Archive -Path ]]..path..[[ -Update -DestinationPath ]]..destPath
      executePowershell(script)
    end
  end
  
  script = [[Rename-Item -Path "]]..destPath..[[" -NewName "]]..entry..[[.brhrm"]]
  executePowershell(script)
  
  print("YOUR REMIX WAS EXPORTED TO YOUR DESKTOP AS "..entry..".brhrm")
  screen = "editor"
end

function writeData(t)
  --print("SAVE START")
  --remove some userdata values
  local music = t.music
  t.beatmap = nil
  t.music = nil
  for _,i in pairs(t.blocks) do
    if i.cues then
      for _,j in pairs(i.cues) do
        j.sound = nil
        --print(j.name,j.sound)
      end
    end
    if i.hits then
      for _,j in pairs(i.hits) do
        j.sound = nil
        --print(j.name,j.sound)
      end
    end
  end
  
  --encode a json string
  str = json.encode(t)
  
  --put the userdata values back in
  t.music = music
  for _,i in pairs(t.blocks) do
    if i.cues then
      for _,j in pairs(i.cues) do
        j.sound = cue[j.cueId]()
      end
    end
    if i.hits then
      for _,j in pairs(i.hits) do
        j.sound = cue[j.cueId]()
      end
    end
  end
  
  return str
end

function loadRemixOptions()
  subcategories = {
    [1] = "general",
    [2] = "karate man (GBA)",
    [3] = "clappy trio (WII)",
    [4] = "lock step",
  }
  subCount = 1
  subcategory = "general"
  textinputs = {} 
  toggleButtons = {} 
  createOptionsTextinputs(1)
end

function updateRemixOptions(dt)
  local mx,my = love.mouse.getPosition()
  
  if mx > view.width/2+128-8 and mx < view.width/2+128+16 and my > 60-8 and my < 60+16 then
    if mouse.button.pressed[1] then
      subCount = subCount+1
      if subCount > tableLength(subcategories) then
        subCount = 1
      end
      subcategory = subcategories[subCount]
      textinputs = {} 
      toggleButtons = {} 
      createOptionsTextinputs(subCount)
    end
  end
  if mx > view.width/2-128-8 and mx < view.width/2-128+16 and my > 60-8 and my < 60+16 then
    if mouse.button.pressed[1] then
      subCount = subCount-1
      if subCount <= 0 then
        subCount = tableLength(subcategories)
      end
      subcategory = subcategories[subCount]
      textinputs = {} 
      toggleButtons = {} 
      createOptionsTextinputs(subCount)
    end
  end
  
  for _,i in pairs(textinputs) do
    if mouse.button.pressed[1] then
      i.selected = false
    end
    
    if mx > i.x and mx < i.x+i.w and my > i.y and my < i.y+i.h then
      i.hover = true
      if mouse.button.pressed[1] then
        i.selected = true
      end
    else
      i.hover = false
    end
  end
  for _,i in pairs(toggleButtons) do
    if mx > i.x+192 and mx < i.x+192+16 and my > i.y and my < i.y+16 then
      i.hover = true
      if mouse.button.pressed[1] then
        i.val = not i.val
        --print(i.val)
      end
    else
      i.hover = false
    end
  end
  
  if subcategory == "general" then
    for _,i in pairs(textinputs) do
      if i.name == "name" then
        data.options.name = i.text
      elseif i.name == "header" then
        data.options.header = i.text
      elseif i.name == "try again" then
        data.options.rating["tryAgain"] = i.text
      elseif i.name == "ok" then
        data.options.rating["ok"] = i.text
      elseif i.name == "superb" then
        data.options.rating["superb"] = i.text
      elseif i.name == "end fade out time" then
        data.options.endFadeOutTime = tonumber(i.text)
      elseif i.name == "minigame fade time" then
        data.options.minigameFadeTime = tonumber(i.text)
      elseif i.name == "misses for ok" then
        data.options.okRating = tonumber(i.text)
      elseif i.name == "misses for try again" then
        data.options.tryAgainRating = tonumber(i.text)
      elseif i.name == "BPM" then
        data.bpm = tonumber(i.text)
      end
    end
  elseif subcategory == "karate man (GBA)" then
    for _,i in pairs(textinputs) do
      if i.name == "start value" then
        data.options.karateka.startFlow = tonumber(i.text)
      end
    end
    for _,i in pairs(toggleButtons) do
      if i.name == "flow" then
        data.options.karateka.flow = i.val
      elseif i.name == "persistent" then
        data.options.karateka.persistent = i.val
      elseif i.name == "extreme bob" then
        data.options.karateka.extremeBob = i.val
      end
    end
  elseif subcategory == "lock step" then
    for _,i in pairs(textinputs) do
      if i.name == "BG (hex)" then
        data.options.lockStep.colors["bg"] = i.text
      elseif i.name == "stepper outline (hex)" then
        data.options.lockStep.colors["marcher0"] = i.text
      elseif i.name == "stepper left (hex)" then
        data.options.lockStep.colors["marcher1"] = i.text
      elseif i.name == "stepper right (hex)" then
        data.options.lockStep.colors["marcher2"] = i.text
      elseif i.name == "use palette swap" then
        data.options.lockStep.paletteSwap = i.text
      end
    end
  elseif subcategory == "clappy trio (WII)" then
    for _,i in pairs(toggleButtons) do
      if i.name == "head bob" then
        data.options.clappyTrio.headBeat = i.val
      end
    end
  end
end

--[[
createToggleButton(view.width/2-256+16,128,"head bob",data.options.clappyTrio.headBeat)
]]

function drawRemixOptions()
  local mx,my = love.mouse.getPosition()
  
  setColorHex(editor.scheme.bg)
  love.graphics.rectangle("fill",view.width/2-256,view.height/2-256,256*2,256*2)
  setColorHex(editor.scheme.grid)
  love.graphics.rectangle("line",view.width/2-256,view.height/2-256,256*2,256*2)
  love.graphics.setFont(fontBig)
  printNew("REMIX OPTIONS",view.width/2-96,32)
  love.graphics.setFont(font)
  printNew(subcategory,view.width/2-32,64)
  
  love.graphics.setFont(fontBig)
  
  setColorHex("000000")
  if mx > view.width/2-128-8 and mx < view.width/2-128+16 and my > 60-8 and my < 60+16 then
    setColorHex("ffffff")
  end
  printNew("<",view.width/2-128,60)
  
  setColorHex("000000")
  if mx > view.width/2+128-8 and mx < view.width/2+128+16 and my > 60-8 and my < 60+16 then
    setColorHex("ffffff")
  end
  printNew(">",view.width/2+128,60)
  love.graphics.setFont(font)
  
  for _,i in pairs(textinputs) do
    if i.selected or i.hover then
      setColorHex("ffffff")
    else
      setColorHex("dadada")
    end
    love.graphics.rectangle("fill",i.x+128+64,i.y,i.w,i.h)
    setColorHex("000000")
    printNew(i.text,i.x+4+128+64,i.y+3)
    printNew(i.name,i.x,i.y+3)
  end
  
  for _,i in pairs(toggleButtons) do
    if i.hover then
      setColorHex("ffffff")
    else
      setColorHex("dadada")
    end
    love.graphics.rectangle("fill",i.x+128+64,i.y,16,16)
    if i.val == true then
      setColorHex("616bda")
      love.graphics.rectangle("fill",i.x+128+64+2,i.y+2,12,12)
    end
    setColorHex("000000")
    printNew(i.name,i.x,i.y+3)
  end
end

function textinputRemixOptions(t)
  for _,i in pairs(textinputs) do
    if i.selected then
      if i.number then
        if tonumber(t) or t == "." then
          i.text = i.text..t
        end
      else
        i.text = i.text..t
      end
    end
  end
end

function keypressedRemixOptions(key)
  for _,i in pairs(textinputs) do
    if i.selected then
      if key == "backspace" then
        if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
          i.text = ""
        else
          i.text = string.sub(i.text,1,i.text:len()-1)
        end
      elseif key == "enter" then
        i.selected = false
      end
    end
    if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
      if key == "v" then
        if i.selected then
          i.text = love.system.getClipboardText()
        end
      end
    end
  end
  if key == "escape" then
    screen = "editor"
  end
end

function createTextInput(x,y,w,h,name,text,number)
  local i = {
    x = x,
    y = y,
    w = w,
    h = h,
    text = text or "",
    selected = false,
    name = name or "",
    number = number
  }
  table.insert(textinputs,i)
end

function createToggleButton(x,y,name,val)
  local i = {
    x = x,
    y = y,
    name = name or "",
    val = val
  }
  table.insert(toggleButtons,i)
end

function createMultiselectButton(x,y,name,val,default)
  local i = {
    x = x,
    y = y,
    name = name or "",
    val = val,
    default = default or 1,
  }
  table.insert(multiselectButtons,i)
end

function createOptionsTextinputs(subcat)
  if subcategory == "general" then
    createTextInput(view.width/2-256+16,128,256,16,"name",data.options.name)
    createTextInput(view.width/2-256+16,128+32,256,16,"BPM",tostring(data.bpm),true)
    createTextInput(view.width/2-256+16,128+32+32,256,16,"header",data.options.header)
    createTextInput(view.width/2-256+16,128+32+32+32,256,16,"try again",data.options.rating["tryAgain"])
    createTextInput(view.width/2-256+16,128+32+32+32+24,256,16,"ok",data.options.rating["ok"])
    createTextInput(view.width/2-256+16,128+32+32+32+24*2,256,16,"superb",data.options.rating["superb"])
    createTextInput(view.width/2-256+16,128+32+32+32+24*2+32,256,16,"misses for ok",tostring(data.options.okRating),true)
    createTextInput(view.width/2-256+16,128+32+32+32+24*3+32,256,16,"misses for try again",tostring(data.options.tryAgainRating),true)
    createTextInput(view.width/2-256+16,128+32+32+32+24*4+32+12,256,16,"end fade out time",tostring(data.options.endFadeOutTime),true)
    createTextInput(view.width/2-256+16,128+32+32+32+24*5+32+12,256,16,"minigame fade time",tostring(data.options.minigameFadeTime),true)
  elseif subcategory == "karate man (GBA)" then
    createToggleButton(view.width/2-256+16,128,"flow",data.options.karateka.flow)
    createToggleButton(view.width/2-256+16,128+24,"persistent",data.options.karateka.persistent)
    createToggleButton(view.width/2-256+16,128+24*2+32,"extreme bob",data.options.karateka.extremeBob)
    createTextInput(view.width/2-256+16,128+24*2,256,16,"start value",tostring(data.options.karateka.startFlow),true)
  elseif subcategory == "lock step" then
    createTextInput(view.width/2-256+16,128,256,16,"BG (hex)",data.options.lockStep.colors["bg"])
    createTextInput(view.width/2-256+16,128+24,256,16,"stepper outline (hex)",data.options.lockStep.colors["marcher0"])
    createTextInput(view.width/2-256+16,128+24*2,256,16,"stepper left (hex)",data.options.lockStep.colors["marcher1"])
    createTextInput(view.width/2-256+16,128+24*3,256,16,"stepper right (hex)",data.options.lockStep.colors["marcher2"])
    createTextInput(view.width/2-256+16,128+24*3+32,256,16,"use palette swap",data.options.lockStep.paletteSwap)
  elseif subcategory == "clappy trio (WII)" then
    createToggleButton(view.width/2-256+16,128,"head bob",data.options.clappyTrio.headBeat)
  end
end
--[[
elseif i.name == "extreme bob" then
        data.options.karateka.extremeBob = i.val
      end
]]
os.execute()