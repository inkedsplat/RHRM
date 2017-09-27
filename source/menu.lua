function loadMenu()
  love.graphics.setDefaultFilter("nearest","nearest")
  menu = {
    loadPhase = 0,
    remixIntro = {
      [1] = love.audio.newSource("/resources/sfx/game/remixIntroTengoku.ogg"),
      [3] = love.audio.newSource("/resources/sfx/game/remixIntroFever.ogg"),
    },
    introImg = {
      [1] = {
        border = love.graphics.newImage("/resources/gfx/game/remixBorderTengoku.png"),
        remix = love.graphics.newImage("/resources/gfx/game/remixTengoku.png"),
        overlay = love.graphics.newImage("/resources/gfx/game/remixOverlayTengoku.png"),
      },
      [3] = {
        remix = love.graphics.newImage("/resources/gfx/game/remix.png"),
      },
    },
    remixIntroSize = 0.1,
    
    img = {
      logo = love.graphics.newImage("/resources/gfx/menu/logo.png"),
      buttonSheet = love.graphics.newImage("/resources/gfx/menu/buttons.png"),
      baristaSheet = love.graphics.newImage("/resources/gfx/menu/barista.png")
    },
    buttons = {},
    stars = {},
    music = love.audio.newSource("/resources/music/space dance (GBA).ogg"),
    bpm = 120,
    beat = 0,
    beatCount = 0,
    beatAnim = false,
    bounce = 0,
    bounceOld = 0,
    snd = {
      buttonOn = love.audio.newSource("/resources/sfx/menu/buttonOn.ogg"),
      buttonOff = love.audio.newSource("/resources/sfx/menu/buttonOff.ogg"),
      buttonPress = love.audio.newSource("/resources/sfx/menu/buttonPress.ogg")
    }
  }
  menu.quad = {
    buttonOn = love.graphics.newQuad(0,0,256,32,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
    buttonOff = love.graphics.newQuad(0,32,256,32,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
    baristaBox = love.graphics.newQuad(160,96,48,32,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
    
    play = love.graphics.newQuad(0,64,96,32,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
    create = love.graphics.newQuad(96,64,144,32,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
    library = love.graphics.newQuad(0,96,160,32,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
    
    rhrmR = love.graphics.newQuad(0,128,48,48,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
    rhrmH = love.graphics.newQuad(48,128,48,48,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
    rhrmM = love.graphics.newQuad(48*2,128,48,48,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
    
    star = {
      [0] = love.graphics.newQuad(240,64,16,16,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
      [1] = love.graphics.newQuad(240,64+16,16,16,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
      [2] = love.graphics.newQuad(208,96,24,20,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
      [3] = love.graphics.newQuad(208+24,96,24,20,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
      [4] = love.graphics.newQuad(208,116,5,5,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
      [5] = love.graphics.newQuad(208+5,116,5,5,menu.img.buttonSheet:getWidth(),menu.img.buttonSheet:getHeight()),
    },
  }
  
  for i = 1,50 do
    local t = {
      quad = menu.quad.star[love.math.random(0,5)],
      y = love.math.random(0,view.height),
      x = love.math.random(0,view.width),
      r = 0,--love.math.random(-0.1,0.1),
      depth = love.math.random(1,3),
      bounce = 0,
      oldBounce = 0,
    }
    if t.quad == menu.quad.star[0] or menu.quad.star[1] then
      t.w = 16
      t.h = 16
    elseif t.quad == menu.quad.star[2] or menu.quad.star[3] then
      t.w = 24
      t.h = 20
    else
      t.w = 5
      t.h = 5
    end
    table.insert(menu.stars,t)
  end
  
  local x = view.width/2-256
  local y = 128+64+32
  local dist = 96
  
  local t = {
    x = x,
    y = y,
    on = false,
    text = menu.quad.play,
    tw = 96,
    bounce = 0,
    bounceOld = 0,
    barista = newAnimationGroup(menu.img.baristaSheet),
    n = 1,
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
    bounceOld = 0,
    barista = newAnimationGroup(menu.img.baristaSheet),
    n = 2,
  }
  t.barista:addAnimation("anim",0,32,32,32,6,100)
  table.insert(menu.buttons,t)
  local t = {
    x = x,
    y = y+dist*2,
    on = false,
    text = menu.quad.library,
    tw = 160,
    bounce = 0,
    bounceOld = 0,
    n = 3,
  }
  table.insert(menu.buttons,t)
end

function updateMenu(dt)
  
  local dist = 1
  local time = (60000/menu.bpm)
  local spd = dist/time
  
  menu.beat = menu.beat+spd*(dt*1000)
  menu.beatAnim = false
  menu.bounce = menu.bounce/1.1
  if menu.beat >= menu.beatCount then
    menu.beatCount = menu.beatCount+1
    menu.beatAnim = true
    menu.bounce = 10
  end
  menu.bounceOld = (menu.bounce+menu.bounceOld)/2
  
  --menu.music:play()
  
  for _,i in pairs(menu.stars) do
    
    if i.bounce > 0 then
      i.bounce = i.bounce/1.1
    end
    if menu.beatAnim then
      i.bounce = 1
    end
    
    i.y = i.y-i.depth
    if i.y < -32 then
      i.y = view.height+32
    end
    if i.x < -32 then
      i.x = view.width+32
    end
  end
  
  if screen == "menu" then
    local mx,my = love.mouse.getPosition()
    if menu.loadPhase == 0 then
      for _,i in pairs(menu.buttons) do
        
        i.bounce = i.bounce-1*sign(i.bounce)
        if i.barista then
          i.barista:update(dt)
        end
        
        if mx > i.x and mx < i.x+512 and my > i.y and my < i.y+64 then
          if not i.on then
            menu.snd.buttonOn:stop()
            menu.snd.buttonOn:play()
            i.on = true
            i.bounce = -10
          else
            if love.mouse.isDown(1) then
              if i.n == 1 then
                deleteTempFiles()
                love.window.setTitle("RHRM - "..version)
                menu.loadPhase = 1
                randomized = false
              elseif i.n == 2 then
                screen = "editor"
              elseif i.n == 3 then
                loadLibrary()
                screen = "library"
              end
              menu.music:stop()
              menu.beatCount = 0
              menu.beat = 0
              
              menu.snd.buttonPress:play()
            end
          end
        else
          if i.on then
            --menu.snd.buttonOff:stop()
            --menu.snd.buttonOff:play()
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
    if menu.loadPhase == 1 then
      --[[if love.keyboard.isDown("return") then
        gradient = newVertGradient(view.width, view.height, hex2rgb("ffe600",true), hex2rgb("6b297b",true))
        menu.loadPhase = 3
        randomized = true
        intro = true
        local introFile = love.filesystem.newFile("/resources/remixBits/intro.rhrm")
        if introFile:open('r') then
          data = json.decode(introFile:read())
          data.music = love.audio.newSource("/resources/sfx/randomizedRemix/endlessRemixIntro.ogg")
          createBeatmap()
          bpm = data.bpm
          data.beat = 0
          data.beatCount = 0
          loadGameInputs(0)
          love.math.setRandomSeed(os.time())
          loadRemixBit = love.thread.newThread("threads/loadRemixBit.lua")
          loadRemixBitChannel = love.thread.getChannel("loadRemixBitChannel")
          
          loadRemixBit:start("/resources/remixBits/intro.rhrm")
        end
      end]]
    elseif menu.loadPhase == 2 then
      if not tempData then
        local remixFile = love.filesystem.newFile("/temp/beatmap.rhrm")
        if remixFile:open('r') then
          tempData = json.decode(remixFile:read())
        else
          print("AN ERROR OCCURED WHILE LOADING")
        end
      else
        if love.keyboard.isDown("return") then
          menu.remixIntro[tempData.options.introStyle or 1]:stop()
          menu.remixIntro[tempData.options.introStyle or 1]:play()
          menu.loadPhase = 3
          
          if (tempData.options.introStyle or 1) == 1 then
            gradient = newVertGradient(view.width, view.height, hex2rgb(tempData.options.color1 or "00d8a8",true), hex2rgb(tempData.options.color2 or "00e820",true))
          end
        end
      end
    end
    if menu.loadPhase >= 3 and menu.loadPhase < 4 then
      menu.loadPhase = menu.loadPhase+0.003
      if menu.loadPhase < 3.5 and menu.remixIntroSize < 2 then
        menu.remixIntroSize = menu.remixIntroSize*2
      end
      --print(menu.loadPhase)
    end
    if menu.loadPhase >= 4 then
      loadGameInputs()
      screen = "game"
    end
  end
end

function drawMenu()
  setColorHex("5096ff")
  love.graphics.rectangle("fill",0,0,view.width,view.height)
  
  setColorHex("ffffff")
  for _,i in pairs(menu.stars) do
    
    i.oldBounce = (i.bounce+i.oldBounce)/2
    love.graphics.draw(menu.img.buttonSheet,i.quad,i.x,i.y,i.r,2+i.oldBounce,2+i.oldBounce,i.w/2,i.h/2)
  end
  
  if screen == "menu" then
    if menu.loadPhase == 0 then
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
      
      local yoff = 16
      local xoff = -48+8
      local rad = 64+10+menu.bounceOld/4
      
      setColorHex("4946bd")
      love.graphics.circle("fill",view.width/2+128+xoff,64+32+yoff+menu.bounceOld,rad)
      love.graphics.circle("fill",view.width/2+64+xoff,64-12+yoff-menu.bounceOld,rad)
      love.graphics.circle("fill",view.width/2+xoff,64+28+yoff+menu.bounceOld,rad)
      love.graphics.circle("fill",view.width/2-64+xoff,64+yoff-menu.bounceOld,rad)
      
      rad = 64-menu.bounceOld/4
      setColorHex("000000")
      love.graphics.circle("fill",view.width/2+128+xoff,64+32+yoff+menu.bounceOld,rad)
      love.graphics.circle("fill",view.width/2+64+xoff,64-12+yoff-menu.bounceOld,rad)
      love.graphics.circle("fill",view.width/2+xoff,64+28+yoff+menu.bounceOld,rad)
      love.graphics.circle("fill",view.width/2-64+xoff,64+yoff-menu.bounceOld,rad)
      
      setColorHex("ffffff")
      love.graphics.draw(menu.img.buttonSheet,menu.quad.rhrmM,view.width/2+128+xoff,64+32+yoff+menu.bounceOld,0,2,2,48/2,48/2)
      love.graphics.draw(menu.img.buttonSheet,menu.quad.rhrmR,view.width/2+64+xoff,64-12+yoff-menu.bounceOld,0,2,2,48/2,48/2)
      love.graphics.draw(menu.img.buttonSheet,menu.quad.rhrmH,view.width/2+xoff,64+28+yoff+menu.bounceOld,0,2,2,48/2,48/2)
      love.graphics.draw(menu.img.buttonSheet,menu.quad.rhrmR,view.width/2-64+xoff,64+yoff-menu.bounceOld,0,2,2,48/2,48/2)
      
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
      setColorHex("000000",200)
      love.graphics.rectangle("fill",16,16,view.width-32,view.height-32)
      love.graphics.setFont(fontBig)
      setColorHex("ffffff",255)
      
      printNew("esc to cancel",16+8,view.height-48)
      
      if menu.loadPhase == 1 then
        love.graphics.printf({{255,255,255},"drop a ",hex2rgb("5aabff",true),".brhrm",{255,255,255}," file onto the window to play it"},0,view.height/2-16,view.width,"center",0,1,1)
      elseif menu.loadPhase == 2 then
        love.graphics.printf("remix info",0,16,view.width,"center")
        love.graphics.setFont(font)
        if tempData then
          local files = love.filesystem.getDirectoryItems("/temp")
          --PRINT REMIX INFO
          love.graphics.print("name: "..(tempData.options.name or "???"),32,128)
          love.graphics.print({{255,255,255},"author: ",{255,248,98},(tempData.author or tempData.autor or "???")},32,128+32)
          love.graphics.print("bpm: "..(tempData.bpm or "???"),32,128+32*2)
          
          local sec = tempData.length
          local min 
          if sec then
            min = 0
            sec = math.floor(sec*0.00001)
            while sec > 60 do
              sec = sec-60
              min = min+1
            end
            if tostring(sec):len() == 1 then
              sec = "0"..tostring(sec)
            end
          end
          love.graphics.print("length: "..(min or "???")..":"..(sec or "???").." minutes",32,128+32*3)
          
          local customTextures = "No"
          for _,i in pairs(files) do
            if string.lower(string.sub(i,i:len()-3)) == ".gfx" then
              customTextures = "Yes"
              break
            end
          end
          love.graphics.print("custom textures?: "..(customTextures or "???"),32,128+32*4)
          
          if tempData.version ~= version then
            setColorHex("ffa649")
          end
          love.graphics.print("version: "..(tempData.version or "???"),32,128+32*5)
          setColorHex("ffffff")
        else
          love.graphics.printf("LOADING REMIX INFO",0,view.height/2,view.width,"center")
        end
        love.graphics.setFont(fontBig)
        
        printNew("press enter to play",view.width-256-128+32,view.height-48)
      elseif menu.loadPhase >= 3 and menu.loadPhase < 4 then
        setColorHex("000000",255)
        love.graphics.rectangle("fill",0,0,view.width,view.height)
        setColorHex("ffffff",255)
        if randomized or (tempData.options.introStyle or 1) == 1 then
          love.graphics.draw(gradient,0,0,0,view.width,1)
          love.graphics.draw(menu.introImg[1].border,view.width/2,view.height/2,0,3,3,menu.introImg[1].border:getWidth()/2,menu.introImg[1].border:getHeight()/2)
          love.graphics.draw(menu.introImg[1].remix,view.width/2,view.height/2,0,3,3,menu.introImg[1].remix:getWidth()/2,menu.introImg[1].remix:getHeight()/2)
          setColorHex("ffffff",50)
          love.graphics.draw(menu.introImg[1].overlay,0,0,0,3,3)
        elseif tempData.options.introStyle == 3 then
          love.graphics.draw(menu.introImg[3].remix,view.width/2,view.height/2,0,menu.remixIntroSize,menu.remixIntroSize,menu.remixIntroImg:getWidth()/2,menu.remixIntroImg:getHeight()/2)
        end
        
        if menu.loadPhase > 3.5 then
          setColorHex("000000",(menu.loadPhase-3.5)*255*3)
          love.graphics.rectangle("fill",0,0,view.width,view.height)
        end
      end
      
      love.graphics.setFont(font)
    end
  end
end

function filedroppedMenu(file)
  local filename = file:getFilename()
  if string.lower(string.sub(filename,filename:len()-5)) == ".brhrm" then
    if file:open("r") then
      local d = file:read()
      if not love.filesystem.exists("temp") then
        love.filesystem.createDirectory("temp")
      else
        for _,i in pairs(love.filesystem.getDirectoryItems("temp")) do
          love.filesystem.remove("temp/"..i)
        end
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
            
            --load game
            loadGameInputs()
            
            data.beat = 0
            data.beatCount = 0
            
            bpm = data.bpm
            
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
    menu.loadPhase = 2
  end
end

function createBeatmap()
  if not data.musicStart then
    data.musicStart = 0
  end
  data.beat = 0
    --generate beatmap
    data.beatmap = {
      sounds = {},
      inputs = {},
      switches = {},
    }
    for _,i in pairs(data.blocks) do
      
      if i.cues then
        for _,j in pairs(i.cues) do
          if not j.sound then 
            j.sound = cue[j.cueId]()
          end
        end
      end
      if i.hits then
        for _,j in pairs(i.hits) do
          if not j.sound then 
            j.sound = cue[j.cueId]()
          end
        end
      end
      
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
end

