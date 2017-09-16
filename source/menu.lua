function loadMenu()
  love.graphics.setDefaultFilter("nearest","nearest")
  menu = {
    loadPhase = 0,
    remixIntro = love.audio.newSource("/resources/sfx/game/remixIntro.ogg"),
    remixIntroImg = love.graphics.newImage("/resources/gfx/game/remix.png"),
    remixIntroSize = 0.1,
    
    img = {
      logo = love.graphics.newImage("/resources/gfx/menu/logo.png"),
      buttonSheet = love.graphics.newImage("/resources/gfx/menu/buttons.png"),
      baristaSheet = love.graphics.newImage("/resources/gfx/menu/barista.png")
    },
    buttons = {},
    stars = {}
  }
  menu.quad = {
    buttonOn = love.graphics.newQuad(0,0,256,32,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
    buttonOff = love.graphics.newQuad(0,32,256,32,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
    baristaBox = love.graphics.newQuad(160,96,48,32,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
    
    play = love.graphics.newQuad(0,64,96,32,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
    create = love.graphics.newQuad(96,64,144,32,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
    library = love.graphics.newQuad(0,96,160,32,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
    
    star = {
      [0] = love.graphics.newQuad(240,64,16,16,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
      [1] = love.graphics.newQuad(240,64+16,16,16,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
      [2] = love.graphics.newQuad(208,96,24,20,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
      [3] = love.graphics.newQuad(208+24,96,24,20,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
      [4] = love.graphics.newQuad(208,116,5,5,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
      [5] = love.graphics.newQuad(208+5,116,5,5,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
    }
  }
  
  for i = 1,50 do
    local t = {
      quad = menu.quad.star[love.math.random(0,5)],
      y = love.math.random(16,view.height-16),
      x = love.math.random(16,view.width-16),
      r = 0,--love.math.random(-0.1,0.1),
      side = 0
    }
    table.insert(menu.stars,t)
  end
  
  local x = view.width/2-256
  local y = 128+64
  local dist = 96
  
  local t = {
    x = x,
    y = y,
    on = false,
    text = menu.quad.play,
    tw = 96,
    bounce = 0,
    bounceOld = 0,
    barista = newAnimationGroup(menu.img.baristaSheet)
  }
  t.barista:addAnimation("anim",0,0,32,32,6,100)
  table.insert(menu.buttons,t)
  local t = {
    x = x,
    y = y+dist,
    on = false,
    text = menu.quad.create,
    tw = 144,
    bounce = 0,
    bounceOld = 0
  }
  table.insert(menu.buttons,t)
  local t = {
    x = x,
    y = y+dist*2,
    on = false,
    text = menu.quad.library,
    tw = 160,
    bounce = 0,
    bounceOld = 0
  }
  table.insert(menu.buttons,t)
end

function updateMenu(dt)
  if menu.loadPhase == 0 then
    
    local mx,my = love.mouse.getPosition()
    for _,i in pairs(menu.buttons) do
      
      i.bounce = i.bounce-1*sign(i.bounce)
      if i.barista then
        i.barista:update(dt)
      end
      
      if mx > i.x and mx < i.x+512 and my > i.y and my < i.y+64 then
        if not i.on then
          i.on = true
          i.bounce = -10
        end
      else
        if i.on then
          i.on = false
          i.bounce = 8
        end
      end

    end
    --[[if mouse.button.pressed[1] then
      local mx,my = love.mouse.getPosition()
      if my > 256-4 and my < 256+16 then
        deleteTempFiles()
        love.window.setTitle("RHRM - "..version)
        menu.loadPhase = 1
      elseif my > 256+32-4 and my < 256+16+32 then
        screen = "editor"
      end
    end]]
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
    setColorHex("5096ff")
    love.graphics.rectangle("fill",0,0,view.width,view.height)
    
    setColorHex("ffffff")
    for _,i in pairs(menu.stars) do
      love.graphics.draw(menu.img.buttonSheet,i.quad,i.x+i.side*(view.width-256),i.y,i.r,2,2)
    end
    
    for _,i in pairs(menu.buttons) do
      local q = menu.quad.buttonOff
      if i.on then
        q = menu.quad.buttonOn
      end
      i.bounceOld = (i.bounce+i.bounceOld)/2
      local bounce = i.bounceOld
      
      love.graphics.draw(menu.img.buttonSheet,q,i.x,i.y+bounce,0,2,2)
      
      love.graphics.draw(menu.img.buttonSheet,i.text,i.x+256,i.y+bounce,0,2,2,i.tw/2)
      
      if i.on then
        love.graphics.draw(menu.img.buttonSheet,menu.quad.baristaBox,i.x-46*2,i.y+bounce,0,2,2)
        if i.barista then
          i.barista:draw(i.x-40*2,i.y+bounce,0,2,2)
        end
      end
    end
    
    --[[local mx,my = love.mouse.getPosition()
    love.graphics.setFont(fontBig)
    setColorHex("000000")
    if my > 256-4 and my < 256+16 then
      setColorHex("f0f0f0")
    end
    printNew("PLAY",64,256)
    
    setColorHex("000000")
    if my > 256+32-4 and my < 256+16+32 then
      setColorHex("f0f0f0")
    end
    printNew("CREATE",64,256+32)
    setColorHex("000000")
    love.graphics.setFont(font)
    
    setColorHex("ffffff")
    love.graphics.draw(menu.img.logo,view.width/2,0,0,0.25,0.25,menu.img.logo:getWidth()/2,0)]]
    setColorHex("000000")
    printNew(version.." welcome "..pref.username.."!",8,view.height-16)
  else
    love.graphics.setFont(fontBig)
    setColorHex("000000")
    love.graphics.rectangle("fill",0,0,view.width,view.height)
    setColorHex("ffffff")
    
    printNew("press escape to cancel",16,view.height-32)
    
    if menu.loadPhase == 1 then
      printNew("DROP A BUNDLED REMIX DATA FILE (.brhrm)\nONTO THE WINDOW",32,view.height/2,0,1,1)
    elseif menu.loadPhase == 2 then
      printNew("DROP THE CORRESPONDING .ogg,.wav or .mp3 FILE\nONTO THE WINDOW ",32,view.height/2)
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
  if string.lower(string.sub(filename,filename:len()-5)) == ".brhrm" then
    if file:open("r") then
      local d = file:read()
      if not love.filesystem.exists("temp") then
        love.filesystem.createDirectory("temp")
      end
      success, message = love.filesystem.write("temp/remix.brhrm",d)

      if success then
        love.filesystem.mount("temp/remix.brhrm","temp",true)
        
        local nFile
        local nd
        --[[for _,i in pairs(love.filesystem.getDirectoryItems("temp")) do
          nFile = love.filesystem.newFile("temp/"..i)
          
          if nFile:open("r") then
            nd = nFile:read()
            love.filesystem.write("temp/"..i,nd)
          end
        end]]
        
        --love.filesystem.unmount("temp/remix.brhrm")
        
        for _,i in pairs(love.filesystem.getDirectoryItems("temp")) do
          print(i)
          nFile = love.filesystem.newFile("temp/"..i)
          if string.lower(string.sub(i,i:len()-3)) == ".ogg" or string.lower(string.sub(i,i:len()-3)) == ".wav" or string.lower(string.sub(i,i:len()-3)) == ".mp3" then
            editorLoadMusic(nFile)
            print("loaded music")
          elseif string.lower(string.sub(i,i:len()-4)) == ".rhrm" then
            editorLoadBeatmap(nFile)
            createBeatmap()
            print("loaded beatmap")
          elseif string.lower(string.sub(i,i:len()-3)) == ".gfx" then
            editorLoadAssets(nFile)
            print("loaded assets")
          end
        end
        
      else
        print("THERE WAS AN ERROR WHILE LOADING:")
        print(message)
      end
    end
    menu.loadPhase = 3
  end
end

function createBeatmap()
  if not data.musicStart then
    data.musicStart = 0
  end
    --generate beatmap
    data.beatmap = {
      sounds = {},
      inputs = {},
      switches = {},
    }
    for _,i in pairs(data.blocks) do
      if i.pitchShift then
        if i.cues then
          for _,j in pairs(i.cues) do
            j.sound:setPitch(i.pitch)
          end
        end
        if i.hits then
          for _,j in pairs(i.hits) do
            j.sound:setPitch(i.pitch)
          end
        end
      end
      
      if i.cues then
        for _,c in pairs(i.cues) do
          local s = {
            time = (((i.x+c.x)/64)*(60000/data.bpm))/1000,
            beat = (i.x+c.x)/64,
            sound = c.sound,
            played = false,
            name = c.name,
            loop = c.loop,
            silent = c.silent
          }
          if c.pitchToBpm then
            s.sound:setPitch((data.bpm/(c.originalBpm or 120)))
          end
          if s.loop then
            s.loopEnd = (((i.x+i.length)/64)*(60000/data.bpm))/1000
            s.loopEndBeat = (i.x+i.length)/64
          end
          if s.time < math.max(editor.playheadInGame,0) then
            s.played = true
          end
          table.insert(data.beatmap.sounds,s)
        end
      end
      if i.hits then
        for _,c in pairs(i.hits) do
          local s = {
            time = (((i.x+c.x)/64)*(60000/data.bpm))/1000,
            beat = (i.x+c.x)/64,
            input = c.input,
            played = false,
            sound = c.sound,
            name = c.name,
            silent = c.silent
          }
          if c.pitchToBpm then
            s.sound:setPitch((data.bpm/(c.originalBpm or 120)))
          end
          if s.time < math.max(editor.playheadInGame,0) then
            s.played = true
            s.played2 = true
          end
          table.insert(data.beatmap.inputs,s)
        end  
      end
      
      if i.switch then
        local s = {
          time = (((i.x)/64)*(60000/data.bpm))/1000,
          beat = (i.x)/64,
          minigame = i.minigame,
          played = false,
        }
        table.insert(data.beatmap.switches,s)
      end 
    end 
    
    --load game
    loadGameInputs()
    
    data.beat = 0
    data.beatCount = 0
    
    bpm = data.bpm
    updateTempoChanges()
end

