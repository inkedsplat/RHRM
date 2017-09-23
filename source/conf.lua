function love.conf(t)
  t.window.width = 1920/2
  t.window.height = 1080/2
  --if love.filesystem.isFused then
    t.console = true
  --end
  t.window.fullscreen = false
  t.window.title = "RHRE - ???"
  --t.window.icon = "resources/icon.png"   
end