local Object = require "libraries.classic"
local Timer = Object:extend()


function Timer:new()
    self.MOVE = 0.15
    self.DIE  = 2.00

    self.time = 0
end

function Timer:reset()
    self.time = 0
end


function Timer:run(dt)
    self.time = self.time + dt
end

function Timer:isDone(max_time)
    return self.time >= max_time
end


return Timer