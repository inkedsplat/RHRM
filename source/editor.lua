function loadEditor()
  debugDots = {}
  editor = {
    scheme = {
      bg = "a9a9a9",
      gridBg = "dadada",
      grid = "010101",
      block = "b3d1f0",
      blockLight = "cbe5ff",
      blockOutline = "010317",
      blockOutlineLight = "5187ce",
      playhead = "3ddd77",
      playheadInGame = "768aec",
      stop = "e53f3f",
      playtest = "ffffff",
      tempoChanges=  "c0a0ff"
    },
    snd = {
      metronome = love.audio.newSource("/resources/sfx/metronome.ogg"),
    },
    block = {
      name = "potu hittu",
      length = 128,
      cues = {{name = "potu thru",x = 0,sound = love.audio.newSource("/resources/sfx/karate man (GBA)/potThrow.ogg")}},
      hits = {{name = "panchu",x = 64,sound = love.audio.newSource("/resources/sfx/karate man (GBA)/potHit.ogg"),input = "pressA"}}
    },
    buttonSpace = 48,
    gridspace = 256,
    gridwidth = 64,
    gridheight = 64,
    viewX = 192,
    playhead = 0,
    playheadInGame = 0,
    playheadStart = 0,
    beatStart = 0,
    beatStartInGame = 0,
    playing = false,
    beats = 0,
    metronome = false,
    selectedMinigame = 0,
    switch = 1,
    playTime = 0,
    minigameScroll = 0,
    patternScroll = 0,
    playHeadMove = 0,
    placeTempoChange = false,
    
    mouseOnGrid = {0,0},
    
    buttons = {}
  }
  local function f()
    editor.playing = true
    
    data.music:play()
    data.music:seek(math.max(editor.playheadStart,0))
    editor.playTime = math.max(editor.playheadStart,0)
    editor.beats = editor.beatStart
    editor.playhead = editor.beatStart*64
    
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
    end
  end
  createButton(0,0,f,love.graphics.newImage("/resources/gfx/editor/buttons/play.png"),editor.scheme.playhead,true)
  
  local function f()
    editor.playing = false
    editor.beats = 0
    editor.playhead = 0
    data.music:stop()
    for _,i in pairs(data.tempoChanges) do
      i.played = nil
    end
    for _,i in pairs(data.blocks) do
      if i.cues then
        for _,c in pairs(i.cues) do
          if i.x+c.x < editor.beatStart*64 then
            c.played = true
          else
            c.played = false
          end
          c.sound:stop()
        end
      end
      if i.hits then
        for _,c in pairs(i.hits) do
          if i.x+c.x < editor.beatStart*64 then
            c.played = true
          else
            c.played = false
          end
          c.sound:stop()
        end
      end
    end
  end
  createButton(48,0,f,love.graphics.newImage("/resources/gfx/editor/buttons/stop.png"),editor.scheme.stop,true)
  
  local function f()
    screen = "game"
    data.music:stop()
    
    --generate beatmap
    data.beatmap = {
      sounds = {},
      inputs = {},
      switches = {},
      editor = true,
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
          minigame = i.minigame,
          played = false,
        }
        table.insert(data.beatmap.switches,s)
      end 
    end 
    
    --load game
    loadGameInputs()
    
    data.music:play()
    data.music:seek(math.max(editor.playheadInGame,0))
    print(editor.playheadInGame)
  end
  createButton(48*2,0,f,love.graphics.newImage("/resources/gfx/editor/buttons/playtest.png"),editor.scheme.playtest,true)
  
  local function f()
    --SAVE THE DATA FILE
    screen = "save"
    entry = ""
    files = love.filesystem.getDirectoryItems("/remixes/")
  end
  createButton(48*6,0,f,love.graphics.newImage("/resources/gfx/editor/buttons/save.png"),editor.scheme.block,true)
  
  local function f()
    screen = "remixOptions"
    loadRemixOptions()
  end
  
  createButton(48*7,0,f,love.graphics.newImage("/resources/gfx/editor/buttons/options.png"),editor.scheme.block,true)
  
  local function f()
    editor.metronome = not editor.metronome
  end
  local b = createButton(view.width-48,0,f,love.graphics.newImage("/resources/gfx/editor/buttons/metronome.png"),editor.scheme.block,true)
  b.w = 24
  b.h = 24
  
  local function f()
    editor.gridwidth = editor.gridwidth*2
  end
  local b = createButton(view.width-24,0,f,love.graphics.newImage("/resources/gfx/editor/buttons/gridUp.png"),editor.scheme.block,true)
  b.w = 24
  b.h = 24
  
  local function f()
    editor.gridwidth = editor.gridwidth/2
  end
  local b = createButton(view.width-24,24,f,love.graphics.newImage("/resources/gfx/editor/buttons/gridDown.png"),editor.scheme.block,true)
  b.w = 24
  b.h = 24
  
  local function f()
    editor.viewX = 192
  end
  local b = createButton(view.width-48,24,f,love.graphics.newImage("/resources/gfx/editor/buttons/backToStart.png"),editor.scheme.block,true)
  b.w = 24
  b.h = 24
  
  local function f(i)
    editor.playHeadMove = 1-editor.playHeadMove
    if editor.playHeadMove == 0 then
      i.color = editor.scheme.playhead
    elseif editor.playHeadMove == 1 then
      i.color = editor.scheme.playheadInGame
    end
  end
  local b = createButton(view.width-48*2,0,f,love.graphics.newImage("/resources/gfx/editor/buttons/lineSelect.png"),editor.scheme.playhead,true)
  b.w = 48
  b.h = 48
  
  
  local function f(i)
    editor.minigameScroll = editor.minigameScroll - 40
    if editor.minigameScroll < 0 then
      editor.minigameScroll = 0
    end
  end
  local b = createButton(6,editor.gridspace+editor.buttonSpace+8,f,love.graphics.newImage("/resources/gfx/editor/buttons/up.png"),editor.scheme.playtest)
  b.w = 16
  b.h = 16
  
  local function f(i)
    editor.minigameScroll = editor.minigameScroll + 40
  end
  local b = createButton(6,editor.gridspace+editor.buttonSpace+8+24,f,love.graphics.newImage("/resources/gfx/editor/buttons/down.png"),editor.scheme.playtest)
  b.w = 16
  b.h = 16
  
  local function f(i)
    editor.placeTempoChange = not editor.placeTempoChange
  end
  local b = createButton(view.width-48*3,0,f,love.graphics.newImage("/resources/gfx/editor/buttons/tempoChange.png"),editor.scheme.playtest,true)
end

function love.wheelmoved(x,y)
  local mx,my = love.mouse.getPosition()
  
  if my > editor.buttonSpace+editor.gridspace then
    if mx < view.width/2 then
      editor.minigameScroll = editor.minigameScroll-y*40
      if editor.minigameScroll < 0 then
        editor.minigameScroll = 0
      end
    else
      editor.patternScroll = editor.patternScroll-y*24
      if editor.patternScroll < 0 then
        editor.patternScroll = 0
      end
    end
  end
  
  for k,i in pairs(data.blocks) do
    if i.pitchShift then
      if my > i.y+editor.buttonSpace and my < i.y+editor.buttonSpace+editor.gridheight and mx > i.x+editor.viewX and mx < i.x+i.length+editor.viewX then
        i.pitch = i.pitch+(y/12)
      end
    end
  end
end

function updateEditor(dt)
    --RESIZE PATTERNS
  local mx, my = love.mouse.getPosition()
  
  curs = love.mouse.getSystemCursor("arrow")
  love.mouse.setCursor(curs)
  
  for k,i in pairs(data.blocks) do
    if i.resizable then
      if my > i.y+editor.buttonSpace and my < i.y+editor.buttonSpace+editor.gridheight and mx > i.x+i.length-4+editor.viewX and mx < i.x+i.length+4+editor.viewX then
        curs = love.mouse.getSystemCursor("sizewe")
        love.mouse.setCursor(curs)
        if mouse.button.pressed[1] then
          editor.blocked = true
          i.resizeGrab = true
          i.originalLength = i.length
        end
      end
      
      if i.resizeGrab then
        i.length = math.floor((mx-editor.viewX)/editor.gridwidth)*editor.gridwidth-(i.x)
        
        curs = love.mouse.getSystemCursor("sizewe")
        love.mouse.setCursor(curs)
        
        if mouse.button.released[1] then
          editor.blocked = false
          i.resizeGrab = nil
          if i.length <= 0 then
            i.length = i.originalLength
          end
          i.originalLength = nil
        end
      end
    end
  end
  
  --buttons
  for _,i in pairs(editor.buttons) do
    if mx > i.x and mx < i.x+i.w and my > i.y and my < i.y+i.h then
      i.hover = true
      if mouse.button.pressed[1] then
        if i.func then
          i.func(i)
        end
      end
    else
      i.hover = nil
    end
  end
  --select patterns
  local mx,my = love.mouse.getPosition()
  for k,i in pairs(minigames) do
    --if k == 1 then
    --  print(k.." "..i.name.." "..8+editor.buttonSpace+editor.gridspace+40*(k).." "..my.." "..(8+editor.buttonSpace+editor.gridspace+40*(k)+32))
    --end
    --print(my,editor.gridspace+editor.buttonSpace)
    if my > editor.gridspace+editor.buttonSpace and mx > 24 and mx < view.width/2 and my > 8+editor.buttonSpace+editor.gridspace+40*(k)-editor.minigameScroll and my < 8+editor.buttonSpace+editor.gridspace+40*(k)+32-editor.minigameScroll then
      if mouse.button.pressed[1] then
        editor.selectedMinigame = k
        if k > 0 then
          editor.switch = k
        end
        print(editor.switch)
      end
    end
    if k == editor.selectedMinigame then
      for n,b in pairs(i.blocks) do
        if mx > view.width/2 and mx < view.width and my > 8+editor.buttonSpace+editor.gridspace+24*(n-1)-editor.patternScroll and my < 8+editor.buttonSpace+editor.gridspace+24*(n-1)+16-editor.patternScroll then
          if mouse.button.pressed[1] then
            editor.block.name = b.name
            editor.block.length = b.length
            editor.block.cues = b.cues
            editor.block.hits = b.hits
            editor.block.resizable = b.resizable
            editor.block.pitchShift = b.pitchShift
            editor.switch = false
          end
        end
      end
    end
  end
  --TEMPO CHANGES
  if editor.playing then
    for _,i in pairs(data.tempoChanges) do
      if not i.played then
        if editor.playhead >= i.x then
          print("SWITCH")
          print((60000/data.bpm)*editor.beats/1000,data.music:tell())
          data.bpm = i.bpm
          local b = editor.beats
          editor.beats = i.x/64
          print("BEATS:",editor.beats,b)
          print((60000/data.bpm)*editor.beats/1000,data.music:tell())
          i.played = true
          
          print("SWITCH END")
        end
      end
    end
  end
  --EDITOR ON GRID
  --simple grid movement
  local spd
  if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
    spd = 10
  else
    spd = 4
  end
  if love.keyboard.isDown("right") then
    editor.viewX = editor.viewX-spd
  end
  if love.keyboard.isDown("left") then
    editor.viewX = editor.viewX+spd
  end
  --get mouse location on grid
  if my < editor.buttonSpace or my > editor.buttonSpace+editor.gridspace then
    editor.mouseOnGrid[1],editor.mouseOnGrid[2] = -1,-1
  else
    editor.mouseOnGrid[1] = math.floor((mx-editor.viewX)/editor.gridwidth)
    editor.mouseOnGrid[2] = math.floor((my-editor.buttonSpace)/editor.gridheight) --Y
  end
  --playhead
  if editor.playing then
    editor.playTime = editor.playTime+(dt/(data.bpm/60))
    
    editor.viewX = -editor.playhead+view.width/2
    
    --print((((60000/data.bpm)*editor.beats)/1000).." "..data.music:tell())
    
    if (60000/data.bpm)*editor.beats/1000 < data.music:tell() then--data.music:tell() then
      --print("beat "..editor.beats)
      if editor.metronome then
        editor.snd.metronome:stop()
        editor.snd.metronome:play()
      end
      editor.beats = editor.beats + 1
      print(editor.beats)
      editor.playhead = 64*(editor.beats-1)
      
      createDebugDot(editor.playhead,64)
    end
    editor.playhead = editor.playhead+((data.bpm/60000)*64)*(20)*dt*50
    
    --editor.playhead = data.music:tell()*data.bpm
  end
  --moving pieces around
  local onBlock = false
  if data.blocks and not editor.blocked then
    for k,i in pairs(data.blocks) do
      if mx > i.x+editor.viewX and mx < i.x+i.length+editor.viewX and my > i.y+editor.buttonSpace and my < i.y+editor.gridheight+editor.buttonSpace then
        onBlock = true
        i.hover = true
        if mouse.button.pressed[1] then
          if love.keyboard.isDown("lalt") and not i.copied then
            --print("alt")
            local b = deepcopy(i)
            b.copied = true
            b.selected = true
            table.insert(data.blocks,b)
            
            i.copied = true
          else
            i.selected = true
          end
        end
        if mouse.button.pressed[2] then
          table.remove(data.blocks,k)
        end
      else
        i.hover = false
      end
      if mouse.button.released[1] then
        i.selected = false
        i.copied = false
      end
      
      if i.selected then
        if editor.mouseOnGrid[1] >= 0 then
          i.x = editor.mouseOnGrid[1]*editor.gridwidth
        end
        if editor.mouseOnGrid[2] >= 0 then
          i.y = editor.mouseOnGrid[2]*editor.gridheight
        end
      end
    end
  end
  
  if my > editor.buttonSpace and my < editor.buttonSpace+editor.gridspace then
    if not onBlock then
      if mouse.button.pressed[1] and not editor.blocked then
        if editor.placeTempoChange then
          local s = {
            bpm = data.bpm,
            x = editor.mouseOnGrid[1]*editor.gridwidth
          }
          table.insert(data.tempoChanges,s)
          editor.placeTempoChange = false
        else
          if editor.switch then
            local s = {
              switch = true,
              x = editor.mouseOnGrid[1]*editor.gridwidth,
              y = editor.mouseOnGrid[2]*editor.gridheight,
              length = 64,
              name = "switch to "..minigames[editor.switch].name,
              minigame = editor.switch
            }
            table.insert(data.blocks,s)
          else
            local b = createBlock(editor.block.name,editor.mouseOnGrid[1]*editor.gridwidth,editor.mouseOnGrid[2]*editor.gridheight,editor.block.length,deepcopy(editor.block.cues),deepcopy(editor.block.hits),editor.block.resizable,editor.block.pitchShift)
            if b.cues then
              for _,i in pairs(b.cues) do
                i.sound = nil
                i.sound = cue[i.cueId]()
              end
            end
            if b.hits then
              for _,i in pairs(b.hits) do
                i.sound = nil
                i.sound = cue[i.cueId]()
              end
            end
          end
        end
      end
    end
    
    if mouse.button.pressed[3] then
      local mx = editor.mouseOnGrid[1]*(editor.gridwidth/64)
      if editor.playHeadMove == 0 then
        --audio playhead
        editor.playheadStart = (((mx))*(60000/data.bpm))/1000
        editor.beatStart = mx
      elseif editor.playHeadMove == 1 then
        --in game playhead
        editor.playheadInGame = (((mx))*(60000/data.bpm))/1000
        editor.beatStartInGame = mx
      end
    end
  end
end

function drawEditor()
  --define some vars
  local pal = editor.scheme
  local w,h = view.width, view.height 
  --DRAW BG
  setColorHex(pal.bg)
  love.graphics.rectangle("fill",0,0,w,h)
  --DRAW GRIDSPACE
  setColorHex(pal.gridBg)
  love.graphics.rectangle("fill",0,editor.buttonSpace,w,editor.gridspace)
  --DRAW GRID
  setColorHex(pal.grid)
  love.graphics.setLineWidth(1)
  for xx = 0, w/editor.gridwidth do
    love.graphics.line(xx*editor.gridwidth+(editor.viewX%editor.gridwidth),editor.buttonSpace,xx*editor.gridwidth+(editor.viewX%editor.gridwidth),editor.buttonSpace+editor.gridspace)
  end
  for yy = editor.buttonSpace/editor.gridheight, editor.gridspace/editor.gridheight+1 do
    love.graphics.line(0,yy*editor.gridheight,w,yy*editor.gridheight)
  end
  --DRAW BLOCKS
  if data.blocks then
    for k,i in pairs(data.blocks) do
      if editor.viewX > -i.x-i.length and editor.viewX < -i.x+view.width then
        if i.hover or i.selected then
          setColorHex(pal.blockLight)
        else
          setColorHex(pal.block)
        end
        if not i.hideConnection then
          love.graphics.rectangle("fill",i.x+editor.viewX,i.y+editor.buttonSpace,i.length,editor.gridheight)
        end
        setColorHex(pal.blockOutline)
        love.graphics.rectangle("line",i.x+editor.viewX,i.y+editor.buttonSpace,i.length,editor.gridheight)
        printNew(i.name,i.x+editor.viewX+4,i.y+editor.buttonSpace+4)
        
        if i.pitchShift then
          printNew(string.sub(i.pitch,1,5),i.x+editor.viewX+4,i.y+editor.buttonSpace+52)
        end
        
        if i.hits then
          for _,h in pairs(i.hits) do
            if i.hideConnection then
              
              if i.hover or i.selected then
                setColorHex(pal.blockLight)
              else
                setColorHex(pal.block)
              end
              love.graphics.rectangle("fill",i.x+i.h+editor.viewX,i.y+editor.buttonSpace,i.length,editor.gridheight)
            end
        
            setColorHex(pal.blockOutlineLight)
            love.graphics.line(i.x+editor.viewX+h.x,i.y+editor.buttonSpace,i.x+editor.viewX+h.x,i.y+editor.gridheight+editor.buttonSpace)
            setColorHex(pal.blockOutline)
            printNew(h.name,i.x+editor.viewX+4+h.x,i.y+editor.buttonSpace+32+4)
            
            --print("hit "..math.floor(editor.playhead).." "..i.x+h.x.." "..tostring(h.played).." "..k)
            if editor.playhead > i.x+h.x and editor.playing then
              if not h.played then
                if h.sound then
                  h.sound:stop()
                  h.sound:play()
                end
                h.played = true
              end 
            end
          end
        end
        if i.cues then
          for _,c in pairs(i.cues) do
            if i.hideConnection then
              if i.hover or i.selected then
                setColorHex(pal.blockLight)
              else
                setColorHex(pal.block)
              end
              love.graphics.rectangle("fill",i.x+i.c+editor.viewX,i.y+editor.buttonSpace,i.length,editor.gridheight)
            end
            
            setColorHex(pal.blockOutlineLight)
            love.graphics.line(i.x+editor.viewX+c.x,i.y+editor.buttonSpace,i.x+editor.viewX+c.x,i.y+editor.gridheight+editor.buttonSpace)
            setColorHex(pal.blockOutline)
            printNew(c.name,i.x+editor.viewX+4+c.x,i.y+editor.buttonSpace+16+4)
            
            if c.loop then
              if editor.playhead > i.x+c.x and editor.playing then
                if editor.playhead < i.x+i.length then
                  c.sound:play()
                elseif not c.played then
                  c.sound:stop()
                  c.played = true
                end
              end
            else
              if editor.playhead > i.x+c.x and editor.playing then
                if not c.played then
                  if c.sound then
                    c.sound:stop()
                    c.sound:play()
                  end
                  c.played = true
                end 
              end
            end
          end
        end
      end
    end
  end
  --TEMPO CHANGES
  for _,i in pairs(data.tempoChanges) do
    if editor.viewX > -i.x and editor.viewX < -i.x+view.width then      
      love.graphics.setLineWidth(5)
      setColorHex(pal.grid)
      love.graphics.line(i.x+editor.viewX,editor.buttonSpace,i.x+editor.viewX,editor.buttonSpace+editor.gridspace)
      love.graphics.setLineWidth(3)
      setColorHex(pal.tempoChanges)
      love.graphics.line(i.x+editor.viewX,editor.buttonSpace,i.x+editor.viewX,editor.buttonSpace+editor.gridspace)
      
      setColorHex(pal.grid)
      printNew(i.bpm,i.x+8+editor.viewX+1,editor.buttonSpace+8)
      printNew(i.bpm,i.x+8+editor.viewX-1,editor.buttonSpace+8)
      printNew(i.bpm,i.x+8+editor.viewX,editor.buttonSpace+8+1)
      printNew(i.bpm,i.x+8+editor.viewX,editor.buttonSpace+8-1)
      setColorHex(pal.tempoChanges)
      printNew(i.bpm,i.x+8+editor.viewX,editor.buttonSpace+8)
    end
  end
  --DRAW PLAYHEAD AND OTHER INDICATORS
  setColorHex(pal.grid,100)
  love.graphics.rectangle("fill",0,editor.buttonSpace,editor.viewX,editor.gridspace)
  setColorHex(pal.grid)
  love.graphics.setLineWidth(3)
  love.graphics.line(editor.viewX,editor.buttonSpace,editor.viewX,editor.buttonSpace+editor.gridspace)
  
  local x = math.max(editor.playheadInGame,editor.beatStartInGame*64)
  setColorHex(pal.grid)
  love.graphics.setLineWidth(5)
  love.graphics.line(x+editor.viewX,editor.buttonSpace,x+editor.viewX,editor.buttonSpace+editor.gridspace)
  setColorHex(pal.playheadInGame)
  love.graphics.setLineWidth(3)
  love.graphics.line(x+editor.viewX,editor.buttonSpace,x+editor.viewX,editor.buttonSpace+editor.gridspace)
  
  local x = math.max(editor.playhead,editor.beatStart*64)
  setColorHex(pal.grid)
  love.graphics.setLineWidth(5)
  love.graphics.line(x+editor.viewX,editor.buttonSpace,x+editor.viewX,editor.buttonSpace+editor.gridspace)
  love.graphics.setLineWidth(3)
  setColorHex(pal.playhead)
  love.graphics.line(x+editor.viewX,editor.buttonSpace,x+editor.viewX,editor.buttonSpace+editor.gridspace)
  --PATTERN SELECT or however you would call that thing idk
  local mx,my = love.mouse.getPosition()
  for k,i in pairs(minigames) do
    if mx > 24 and mx < view.width/2 and my > 8+editor.buttonSpace+editor.gridspace+40*(k)-editor.minigameScroll and my < 8+editor.buttonSpace+editor.gridspace+40*(k)+32-editor.minigameScroll then
      setColorHex(pal.block)
    else
      if editor.selectedMinigame == k then
        setColorHex(pal.blockOutlineLight)
      else
        setColorHex(pal.grid)
      end
    end
    if 8+editor.buttonSpace+editor.gridspace+40*(k)-editor.minigameScroll > editor.gridspace+40 then
      printNew(i.name,16+32+24,20+editor.buttonSpace+editor.gridspace+40*(k)-editor.minigameScroll)
      love.graphics.rectangle("line",8+24,8+editor.buttonSpace+editor.gridspace+40*(k)-editor.minigameScroll,32,32)
      setColorHex("ffffff")
      love.graphics.draw((i.img or imgUnknownMinigame),8+24,8+editor.buttonSpace+editor.gridspace+40*(k)-editor.minigameScroll)
    end
    if editor.selectedMinigame == k then
      for n,b in pairs(i.blocks) do
        if mx > view.width/2 and mx < view.width and my > 8+editor.buttonSpace+editor.gridspace+24*(n-1)-editor.patternScroll and my < 8+editor.buttonSpace+editor.gridspace+24*(n-1)+16-editor.patternScroll then
          setColorHex(pal.block)
        else
          setColorHex(pal.grid)
        end
        
        if 8+editor.buttonSpace+editor.gridspace+24*(n)-editor.patternScroll > editor.gridspace+64 then
          printNew(b.name,view.width/2+8,8+editor.buttonSpace+editor.gridspace+24*(n-1)-editor.patternScroll)
        end
      end
    end
    
  end
  --DRAW BUTTONS
  love.graphics.setLineWidth(2)
  for _,i in pairs(editor.buttons) do
    if i.hover then
      setColorHex(pal.gridBg)
    else
      setColorHex(pal.bg)
    end
    love.graphics.rectangle("fill",i.x,i.y,i.w,i.h)
    setColorHex(pal.grid)
    if i.outline then
      love.graphics.rectangle("line",i.x,i.y,i.w,i.h)
    end
    if i.img then
      if i.color then setColorHex(i.color) end
      love.graphics.draw(i.img,i.x,i.y)
    end
  end
  setColorHex("000000")
  if data.music then
    printNew("BPM : "..tostring(data.bpm),48*3+8,8)
    printNew("TIME : "..string.sub(tostring(data.music:tell()),1,5),48*3+8,8+22)
  end
  --DRAW DEBUG DOTS
  --[[for _,i in pairs(debugDots) do
    if math.floor(math.floor(i.x)/editor.gridwidth) == math.floor(i.x)/editor.gridwidth then
      setColorHex("00ff00")
    else  
      setColorHex("ff0000")
    end
    love.graphics.circle("line",i.x+editor.viewX,i.y,0.5)
  end]]
end

--[[
CUES: (table of tables)
  name,
  x,
  sound
  
HITS: (table of tables)
  name,
  x,
  sound,
  input
]]
function createBlock(name,x,y,length,cues,hits,resizable,pitchShift)
  local b = {
    name = name,
    x = x,
    y = y,
    length = length,
    cues = cues,
    hits = hits,
    resizable = resizable,
    pitchShift = pitchShift
  }
  if b.pitchShift then
    b.pitch = 1
  end
  table.insert(data.blocks,b)
  return b
end

function createButton(x,y,func,img,color,outline)
  local b = {
    x = x,
    y = y,
    w = 48,
    h = 48,
    func = func,
    img = img,
    color = color,
    outline = outline,
  }
  table.insert(editor.buttons,b)
  return b
end

function createDebugDot(x,y)
  local d = {
    x = x,
    y = y
  }
  table.insert(debugDots,d)
end