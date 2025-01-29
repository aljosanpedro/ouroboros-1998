local Object = require "libraries.classic"
local Timer = Object:extend()


function Timer:new()
    self.MOVE = 0.125
    self.DIE  = 2.00

    self.time = 0
end


-- function Timer:keypressed(key)

function Timer:shorten()
    self.MOVE = self.MOVE * 0.95
end


-- function Timer:update(dt)

function Timer:run(dt)
    self.time = self.time + dt
end

function Timer:isDone(max_time)
    return self.time >= max_time
end

function Timer:reset()
    self.time = 0
end


return Timer