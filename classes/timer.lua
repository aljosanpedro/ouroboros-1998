local Object = require "libraries.classic"
local Timer = Object:extend()


function Timer:new()
    self.MOVE = 0.125
    self.DIE  = 2.000
    self.SHAKE = 0.25

    self.CHANGE = 0.05

    self.time = 0
    self.time_shake = 0
end

function Timer:reset()
    self.MOVE = 0.125
    self.DIE  = 2.000

    self.CHANGE = 0.05

    self.time = 0
end


-- function Timer:keypressed(key)

function Timer:shorten()
    self.MOVE = self.MOVE * (1 - self.CHANGE)
end

function Timer:lengthen()
    self.MOVE = self.MOVE * (1 + self.CHANGE)
end


-- function Timer:update(dt)

function Timer:run(dt)
    self.time = self.time + dt
end

function Timer:isDone(max_time)
    return self.time >= max_time
end

function Timer:restart()
    self.time = 0
end


return Timer