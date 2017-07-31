function loadMenu()
  menu = {
    loadPhase = 0,
    remixIntro = love.audio.newSource("/resources/sfx/game/remixIntro.ogg"),
    remixIntroImg = love.graphics.newImage("/resources/gfx/game/remix.png"),
    remixIntroSize = 0.1
  }
end

function updateMenu(dt)
  if menu.loadPhase == 0 then
    if mouse.button.pressed[1] then
      local mx,my = love.mouse.getPosition()
      if my > 256-4 and my < 256+16 then
        menu.loadPhase = 1
      elseif my > 256+32-4 and my < 256+16+32 then
        screen = "editor"
      end
    end
  end
  if menu.loadPhase >= 3 and menu.loadPhase < 4 then
    menu.loadPhase = menu.loadPhase+0.003
    if menu.loadPhase < 3.5 and menu.remixIntroSize < 2 then
      menu.remixIntroSize = menu.remixIntroSize*2
    end
    print(menu.loadPhase)
  end
  if menu.loadPhase >= 4 then
    loadGameInputs()
    screen = "game"
  end
end

function drawMenu()
  if menu.loadPhase == 0 then
    setColorHex("a9a9a9")
    love.graphics.rectangle("fill",0,0,view.width,view.height)
    
    local mx,my = love.mouse.getPosition()
    love.graphics.setFont(fontBig)
    setColorHex("000000")
    if my > 256-4 and my < 256+16 then
      setColorHex("f0f0f0")
    end
    love.graphics.print("PLAY",64,256)
    
    setColorHex("000000")
    if my > 256+32-4 and my < 256+16+32 then
      setColorHex("f0f0f0")
    end
    love.graphics.print("CREATE",64,256+32)
    setColorHex("000000")
    love.graphics.setFont(font)
    love.graphics.print(version,8,view.height-16)
  else
    love.graphics.setFont(fontBig)
    setColorHex("000000")
    love.graphics.rectangle("fill",0,0,view.width,view.height)
    setColorHex("ffffff")
    
    love.graphics.print("press escape to cancel",16,view.height-32)
    
    if menu.loadPhase == 1 then
      love.graphics.print("DROP A REMIX DATA FILE (.rhrm) ONTO THE WINDOW",view.width/2-256-96,view.height/2)
    elseif menu.loadPhase == 2 then
      love.graphics.print("DROP THE CORRESPONDING .ogg,.wav or .mp3 FILE ONTO THE WINDOW ",view.width/2-256-128-96,view.height/2)
    elseif menu.loadPhase >= 3 and menu.loadPhase < 4 then
      love.graphics.draw(menu.remixIntroImg,view.width/2,view.height/2,0,menu.remixIntroSize,menu.remixIntroSize,menu.remixIntroImg:getWidth()/2,menu.remixIntroImg:getHeight()/2)
      
      if menu.loadPhase > 3.5 then
        setColorHex("000000",(menu.loadPhase-3.5)*255*3)
        love.graphics.rectangle("fill",0,0,view.width,view.height)
      end
    end
    
    love.graphics.setFont(font)
  end
end

function filedroppedMenu(file)
  local filename = file:getFilename()
  if menu.loadPhase == 1 then
    if string.lower(string.sub(filename,filename:len()-4)) == ".rhrm" then
      --load data
      if file:open("r") then
        --READ DATA
        local d = file:read()
        print(d)
        data = json.decode(d)
        for _,i in pairs(data.blocks) do
          if i.cues then
            for _,j in pairs(i.cues) do
              j.sound = cue[j.cueId]
            end
          end
          if i.hits then
            for _,j in pairs(i.hits) do
              j.sound = cue[j.cueId]
            end
          end
        end
        --create beatmap
        createBeatmap()
        menu.loadPhase = 2
      end
    end
  elseif menu.loadPhase == 2 then
    if string.lower(string.sub(filename,filename:len()-3)) == ".ogg" or string.lower(string.sub(filename,filename:len()-3)) == ".wav" or string.lower(string.sub(filename,filename:len()-3)) == ".mp3" then
      data.music = love.audio.newSource(file)
      data.music:setVolume(0.25)
      menu.remixIntro:stop()
      menu.remixIntro:play()
      menu.loadPhase = 3
    end
  end
end

function createBeatmap()
  data.beatmap = {
    sounds = {},
    inputs = {},
    switches = {},
  }
  for _,i in pairs(data.blocks) do
    if i.cues then
      for _,c in pairs(i.cues) do
        local s = {
          time = (((i.x+c.x)/64)*(60000/data.bpm))/1000,
          sound = c.sound,
          played = false,
          name = c.name
        }
        table.insert(data.beatmap.sounds,s)
      end
    end
    if i.hits then
      for _,c in pairs(i.hits) do
        local s = {
          time = (((i.x+c.x)/64)*(60000/data.bpm))/1000,
          input = c.input,
          played = false,
          sound = c.sound,
          name = c.name
        }
        --print(s.input)
        table.insert(data.beatmap.inputs,s)
      end  
    end
    
    if i.switch then
      local s = {
        time = (((i.x)/64)*(60000/data.bpm))/1000,
        minigame = i.minigame,
        played = false,
      }
      table.insert(data.beatmap.switches,s)
    end 
  end 
end

