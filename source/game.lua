function loadGameInputs(seekTime)
  input = {}
  margin = 0.2
  bearlyMargin = 0.3
  hit = 0
  beat = 0
  beatCount = 0
  minigameTime = 0
  missCount = 0
  
  if data.endless then
    speedUp = 1
    originalBpm = bpm
    originalLives = data.lives
    endlessAssets = {
      heart = love.graphics.newImage("/resources/gfx/game/life.png"),
      alive = love.graphics.newQuad(0,0,32,32,96,32),
      dead = love.graphics.newQuad(32,0,32,32,96,32),
      worried = love.graphics.newQuad(64,0,32,32,96,32),
    }
  end
  
  misses = 0
  if not data.beatmap.editor then
    perfect = true
    perfectFail = 0
  else
    perfect = false
    perfectFail = 0
  end
  
  
  minigame = 1
  for _,i in pairs(data.beatmap.switches) do
    if i.time <= 0 then
      minigame = i.minigame
    end
  end
  
  transition = 0
  endRemix = false
  endRemixTimer = 0
  
  loadMinigames()
  loadMinigame[minigame]()
  currentSounds = {}
  currentHits = {}
  
  rating = false
  ratingNote = "perfect"
  ratingTimer = 0
  ratingPhase = 0
  gameSnd = {
    potHit = love.audio.newSource("/resources/sfx/karate man (GBA)/potHit.ogg"),
    header = love.audio.newSource("/resources/sfx/game/header.ogg"),
    text = love.audio.newSource("/resources/sfx/game/text.ogg"),
    music = {
      ["perfect"] = love.audio.newSource("/resources/sfx/game/perfect.ogg"),
      ["superb"] = love.audio.newSource("/resources/sfx/game/superb.ogg"),
      ["ok"] = love.audio.newSource("/resources/sfx/game/ok.ogg"),
      ["tryAgain"] = love.audio.newSource("/resources/sfx/game/tryAgain.ogg"),
    },
    bearlyHit = love.audio.newSource("/resources/sfx/game/bearlyHit.ogg"),
  }
  gameSnd.potHit:setVolume(3)
  
  gameImg = {
    rating = love.graphics.newImage("/resources/gfx/game/rating.png")
  }
  gameQuad = {
    rating = {
      ["perfect"] = love.graphics.newQuad(0,96*3,272,96,gameImg.rating:getWidth(),gameImg.rating:getHeight()),
      ["superb"] = love.graphics.newQuad(0,96*2,272,96,gameImg.rating:getWidth(),gameImg.rating:getHeight()),
      ["ok"] = love.graphics.newQuad(0,96,272,96,gameImg.rating:getWidth(),gameImg.rating:getHeight()),
      ["tryAgain"] = love.graphics.newQuad(0,0,272,96,gameImg.rating:getWidth(),gameImg.rating:getHeight())
    }
  }
  
  imgPerfect = love.graphics.newImage("/resources/gfx/perfect.png")
  sndPerfectFail = love.audio.newSource("/resources/sfx/karate man (GBA)/potBreak.ogg")
  
  if data.musicStart <= data.beat then
    data.music:play()
    data.music:seek(seekTime)
  end
  
  auto = false
end

function love.keypressed(key,scancode,isRepeat)
  if screen == "game" then
    if key == "l" then
      input["pressA"] = true
      input["holdA"] = true
      input["pressANY"] = true
      input["holdANY"] = true
      
      if input["holdB"] then
        input["holdAB"] = true
        input["pressAB"] = true
      end
    end
    if key == "k" then
      input["pressB"] = true
      input["holdB"] = true
      input["pressANY"] = true
      input["holdANY"] = true
      
      if input["holdA"] then
        input["holdAB"] = true
        input["pressAB"] = true
      end
    end
    
    if key == "w" or key == "a" or key == "s" or key == "d" then
      input["pressDPAD"] = true
      input["holdDPAD"] = true
      input["pressANY"] = true
      input["holdANY"] = true
    end
    
    if key == "d" then
      input["pressRIGHT"] = true
      input["holdRIGHT"] = true
    end
    
    if key == "a" then
      input["pressLEFT"] = true
      input["holdLEFT"] = true
    end
    
    if key == "r" then
      view.flipH = 1
      view.flipV = 1
      gameSnd.music[ratingNote]:stop()
      for _,i in pairs(data.beatmap) do
        if type(i) == "table" then
          for _,j in pairs(i) do
              j.played = false
              j.played2 = nil
          end
        end
      end
      data.music:stop()
      data.music:play()
      data.music:setVolume(0.25)
      loadGameInputs(0)
    end
    
    if data.beatmap.editor then
      if key == "escape" then
        view.flipH = 1
        view.flipV = 1
        screen = "editor"
        gameSnd.music[ratingNote]:stop()
        data.music:setPitch(1)
        if data.music then
          data.music:stop()
        end
      end
    else
      if key == "escape" then
        view.flipH = 1
        view.flipV = 1
        screen = "menu"
        data.music:setPitch(1)
        menu.loadPhase = 0
        gameSnd.music[ratingNote]:stop()
        if data.music then
          data.music:stop()
        end
      end
    end
  elseif screen == "editor" then
    if love.keyboard.isDown("b") then
      local spd = 1
      if love.keyboard.isDown("lctrl") or love.keyboard.isDown("lctrl") then
        spd = 10
      end
      if key == "up" then
        data.bpm = data.bpm+spd
      end
      if key == "down" then
        data.bpm = data.bpm-spd
      end
    else
      if key == "up" then
        editor.gridwidth = editor.gridwidth*2
      end
      if key == "down" then
        editor.gridwidth = editor.gridwidth/2
      end
    end
    
    if key == "m" then
      editor.metronome = not editor.metronome
    end
    
    if key == "escape" then
      screen = "menu"
    end
    
    if love.keyboard.isDown("lctrl") or love.keyboard.isDown("lctrl") then
      if key == "s" then
        if data.dir then
          entry = data.dir
          saveRemix()
        end
      end
    end
  elseif screen == "save" then
    if key == "backspace" then
      entry = string.sub(entry,1,entry:len()-1)
    end
    if key == "return" then
      if loadRemixBool then
        loadRemix()
      else
        saveRemix()
      end
      
      screen = "editor"
    end
    if key == "escape" then
      screen = "editor"
    end
  elseif screen == "remixOptions" then
    keypressedRemixOptions(key)
  elseif screen == "menu" then
    if key == "escape" then
      if menu.loadPhase > 0 then
        menu.loadPhase = 0
        tempData = nil
        initializeData()
      else
        love.event.quit()
      end
    end
  elseif screen == "init" then
    keypressedInit(key)
  end
end

function love.keyreleased(key)
  if screen == "game" then
    if key == "l" then
      input["releaseA"] = true
      input["holdA"] = false
      if input["holdAB"] then
        input["releaseAB"] = true
      end
      input["holdAB"] = false
      input["releaseANY"] = true
      input["holdANY"] = false
    end
    if key == "k" then
      input["releaseB"] = true
      input["holdB"] = false
      if input["holdAB"] then
        input["releaseAB"] = true
      end
      input["holdAB"] = false
      input["releaseANY"] = true
      input["holdANY"] = false
    end
    
    if key == "w" or key == "a" or key == "s" or key == "d" then
      input["releaseDPAD"] = true
      input["holdDPAD"] = false
      input["releaseANY"] = true
      input["holdANY"] = false
    end
    
    if key == "d" then
      input["releaseRIGHT"] = true
      input["holdRIGHT"] = false
    end
    
    if key == "a" then
      input["releaseLEFT"] = true
      input["holdLEFT"] = false
    end
  end
end

function updateGameInputs(dt)
  --[[local nxtData = loadRemixBitChannel:pop()
  if nxtData then
    nextData = nxtData
  end]]
  
  minigameTime = minigameTime+dt
  if not rating then
    
    --[[for _,i in pairs(data.tempoChanges) do
      if data.beat >= i.x/64 then
        bpm = i.bpm
      end
    end]]
    
    data.time = data.time+dt
    local dist = 1
    local time = (60000/bpm)
    local spd = dist/time
    
    data.beat = data.beat+spd*(dt*1000)
    
    --play music
    if data.beat >= data.musicStart then
      data.music:play()
    end
    --beat
    if data.beat >= data.beatCount then
      data.beatCount = data.beatCount+1
      --if data.music:isPlaying() then
        beat = 10
      --end
    end
    --handle switches
    for _,s in pairs(data.beatmap.switches) do
      if data.beat >= s.beat and not s.played then
        s.played = true
        --print("SWITCHING TO "..minigames[s.minigame].name)
        minigameTime = 0
        minigame = s.minigame
        loadMinigame[minigame](s.beat)
        transition = data.options.minigameFadeTime or 7
      end
    end 
    --handle sounds
    for _,s in pairs(data.beatmap.sounds) do
      if not s.silent then
        if s.loop then
          if data.beat >= s.beat and not s.played then
            s.sound:stop()
            s.sound:play()
            table.insert(currentSounds,{name = s.name,time = s.beat})
            s.played = true
          end
          if not s.played2 and s.played then
            s.sound:play()
            if data.beat >= s.loopEndBeat then
              s.played2 = true
              s.sound:stop()
              table.insert(currentSounds,{name = s.name.."LoopEnd",time = s.beat})
            end
          end
        else
          if data.beat >= s.beat and not s.played then
            s.sound:stop()
            s.sound:play()
            s.played = true
            table.insert(currentSounds,{name = s.name,time = s.beat})
            --print(s.beat,data.beat)
            ----print(s.name)
          end
        end
      else
        if data.beat >= s.beat and not s.played then
          s.played = true
        end
      end
    end 
    --handle gameplay
    for _,s in pairs(data.beatmap.inputs) do
      if s.input:find("hold") then
        if data.beat >= s.beat and not s.played then
          if input[s.input] then
            if not s.silent then
              s.sound:stop()
              s.sound:play()
            end
            hit = 10
            --print("HIT")
          else
            misses = misses + 1
            --print(misses.." misses")
            s.played = true
          end
          s.played = true
        end
      else
        if data.beat > s.beat-margin and data.beat < s.beat+margin then
          if (input[s.input] or (auto and data.beat >= s.beat)) and not s.played then
            if not s.silent then
              s.sound:stop()
              s.sound:play()
            end
            s.played = true
            hit = 10
            --print("HIT WITH A MARGIN OF "..data.music:tell()-s.time)
            
            local h = {
              name = s.name,
              time = s.beat,
              bearly = false
            }
            table.insert(currentHits,h)
            
            --AUTO
            if auto then
              input[s.input] = true
            end
          end
        elseif data.beat > s.beat-bearlyMargin and data.beat < s.beat+bearlyMargin then
          if input[s.input] and not s.played then
            misses = misses + 1
            --print("bearly hit  "..misses.." misses")
            s.played = true
            
            local h = {
              name = s.name,
              time = s.beat,
              bearly = true
            }
            table.insert(currentHits,h)
          end
        elseif data.beat > s.beat+bearlyMargin then
          if not s.played then
            misses = misses + 1
            --print(misses.." misses")
            s.played = true
          end
        end
        if data.beat >= s.beat and not s.played2 then
          s.played2 = true
          table.insert(currentSounds,{name = s.name,time = s.beat})
        end
      end
    end 
    
    if misses > missCount then
      missCount = missCount+1
      if data.endless then
        data.lives = data.lives-1
      end
    end
    
    if updateMinigame[minigame] then
      updateMinigame[minigame](dt)
    end
    
    if beat > 0 then
      beat = beat-1
    end
    if hit > 0 then
      hit = hit-1
    end
    if perfectFail > 0 then
      perfectFail = perfectFail-1
    end
    if transition > 0 then
      transition = transition-1
    end

    if endRemix then
      if data.endless then
        data.beat = math.ceil(data.musicStart)
        data.beatCount = data.beat
        local seekPos = (((math.ceil(data.musicStart)-data.musicStart))*(60000/bpm))/1000
        data.music:seek(seekPos)
        print(data.beat,data.music:tell())
        
        for _,i in pairs(data.beatmap.sounds) do 
          if i.beat >= math.ceil(data.musicStart) then
            i.played = nil
          end
        end
        for _,i in pairs(data.beatmap.inputs) do 
          if i.beat >= math.ceil(data.musicStart) then
            i.played = nil
            i.played2 = nil
          end
        end
        for _,i in pairs(data.beatmap.switches) do 
          if i.beat >= math.ceil(data.musicStart) then
            i.played = nil
          end
        end
        
        speedUp = speedUp+0.1
        bpm = originalBpm*speedUp
        data.music:setPitch(speedUp)
        
        endRemix = false
      elseif randomized then
        if intro then
          data.music:stop()
          data.music = love.audio.newSource("/resources/sfx/randomizedRemix/endlessRemixLoop.ogg")
          data.music:seek(0)
          intro = false
        end
        loadRemixBit:start("/resources/remixBits/intro.rhrm")
        data = nextData
      else
        endRemixTimer = endRemixTimer+1
        data.music:setVolume((0.25-(endRemixTimer/(data.options.endFadeOutTime or 100))*0.25))
        if endRemixTimer >= (data.options.endFadeOutTime or 100) then
          view.flipH = 1
          view.flipV = 1
          if data.beatmap.editor then
            screen = "editor"
            data.music:setVolume(0.25)
            data.music:stop()
            --print(misses.." misses")
            if misses == 0 then
              --print("YOU GOT A PERFECT")
            end
          else
            data.music:stop()
            rating = true
            if misses >= 1 then
              ratingNote = "superb"
            end
            if misses >= (data.options.okRating or 3) then
              ratingNote = "ok"
            end
            if misses >= (data.options.tryAgainRating or 10) then
              ratingNote = "tryAgain"
            end
          end
        end 
      end
    end
    
    --END THE REMIX
    for _,i in pairs(currentSounds) do
      if i.name == "end remix" then
        endRemixTimer = 0
        endRemix = true
      end
    end
    
    --PERFECT INDICATOR
    if perfect and misses > 0 then
      perfect = false
      sndPerfectFail:stop()
      sndPerfectFail:play()
      perfectFail = 20
    end
    
    for _,i in pairs(currentSounds) do
      if i.name == "vflip" then
        view.flipV = view.flipV*-1
      end
      if i.name == "hflip" then
        view.flipH = view.flipH*-1
      end
      if i.name == "rflip" then
        view.flipV = 1
        view.flipH = 1
      end
      if i.name == "screenshake" then
        view.shake = view.shake+16
      end
      if i.name == "screenshake1" then
        view.shake = view.shake+32
      end
      if i.name == "screenshake2" then
        view.shake = view.shake+64
      end
    end
    
    currentSounds = {}
    currentHits = {}
    
    for k,i in pairs(input) do
      if k:find("hold") == nil then
        input[k] = false
      end
    end
  else
    ratingTimer = ratingTimer + dt*100
    if ratingPhase == 0 then
      if ratingTimer > 100 then
        gameSnd.header:stop()
        gameSnd.header:play()
        ratingPhase = 1
      end
    elseif ratingPhase == 1 then
      if ratingTimer > 250 then
        gameSnd.text:stop()
        gameSnd.text:play()
        ratingPhase = 2
      end
    elseif ratingPhase == 2 then  
      if ratingTimer > 400 then
        gameSnd.music[ratingNote]:stop()
        gameSnd.music[ratingNote]:play()
        ratingPhase = 4
      end
    elseif ratingPhase == 4 then 
      if 500^1.2-ratingTimer^1.2 <= 1 then
        gameSnd.potHit:stop()
        gameSnd.potHit:play()
        ratingPhase = 5
      end
    end
  end
end

function drawGameInputs()
  if not rating then
    --printNew(data.music:tell())
    
    if drawMinigame[minigame] then
      drawMinigame[minigame]()
    end
    
    if data.endless then
      for i = 1, originalLives do
        y = 0
        if (data.beatCount%4) == i%4 then
          y = beat
        end
        if i > data.lives then
          love.graphics.draw(endlessAssets.heart,endlessAssets.dead,32-64+64*i,32+beat/5,0,2+beat/40,2-beat/40,16,16)
        elseif data.lives == 1 then
          love.graphics.draw(endlessAssets.heart,endlessAssets.worried,32-64+64*i,32+y,0,2-y/40,2+y/40,16,16)
        else
          love.graphics.draw(endlessAssets.heart,endlessAssets.alive,32-64+64*i,32+y,0,2-y/40,2+y/40,16,16)
        end
      end
    else
      if perfect or perfectFail > 0 then
        local y = 0--beat/2
        if hit > 0 then
          y = -hit
        end
        setColorHex("ffffff")
        love.graphics.draw(imgPerfect,8+math.sin(perfectFail)*perfectFail,8+y)
      end
    end
  
    if transition > 0 then
      setColorHex("000000")
      love.graphics.rectangle("fill",0,0,view.width,view.height)
    end
    
    love.graphics.setColor(0,0,0,(endRemixTimer/(data.options.endFadeOutTime or 100))*255)
    love.graphics.rectangle("fill",0,0,view.width,view.height)
  else
    setColorHex("000000")
    love.graphics.rectangle("fill",0,0,view.width,view.height)
    setColorHex("ffffff")
    --printNew(ratingTimer)
    
    love.graphics.setFont(fontBig)
    if ratingPhase >= 1 then
      printNew(data.options.header,64,64)
    end
    if ratingPhase >= 2 then
      local r = ratingNote
      if r == "perfect" then
        r = "superb"
      end
      printNew(data.options.rating[r],128,256)
    end
    if ratingPhase >= 4 then
      love.graphics.draw(gameImg.rating,gameQuad.rating[ratingNote],view.width-272-32,view.height-96-32,0,math.max(1,500^1.2-ratingTimer^1.2),math.max(1,500^1.2-ratingTimer^1.2),272/2,96/2)
    end
    love.graphics.setFont(font)
  end
end