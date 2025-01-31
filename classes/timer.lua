local Object = require "libraries.classic"
local Timer = Object:extend()


function Timer:reset()
    self.max = {
        MOVE  = 0.125,
        DIE   = 2,
        SHAKE = 0.25,
    }
    self.CHANGE = 0.05

    self.time = {
        move  = 0,
        die   = 0,
        shake = 0,
    }
end

function Timer:new()
    self:reset()
end


-- function Timer:keypressed(key)

function Timer:shorten()
    self.max.MOVE = self.max.MOVE * (1 - self.CHANGE)
end

function Timer:lengthen()
    self.max.MOVE = self.max.MOVE * (1 + self.CHANGE)
end


-- function Timer:update(dt)

function Timer:run(type, dt)
    self.time[type] = self.time[type] + dt
end

function Timer:isDone(type)
    return self.time[type] >= self.max[string.upper(type)]
end

function Timer:restart(type)
    self.time[type] = 0
end


return Timer