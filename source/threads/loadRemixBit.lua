require("love.filesystem")
path = ...
channel = love.thread.getChannel("loadRemixBitChannel")
channel:push(path)
local nextData = {}
local file = love.filesystem.newFile(path)
if file:open('r') then
  nextData = json.decode(file:read())
  channel:push(nextData)
end