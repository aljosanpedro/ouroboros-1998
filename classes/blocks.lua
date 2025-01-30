local Object = require "libraries.classic"
local Blocks = Object:extend()


function Blocks:new()
    self.length = 60
    self.CHANGE = 0
end

function Blocks:raiseLength()
    self.length = self.length + self.CHANGE
end

-- function Blocks:update(dt)


function Blocks:draw(block_x, block_y)
    -- Color
    love.graphics.setColor(self.color)

    -- Rectangle
    block_x = (block_x - 1) * self.length
    block_y = (block_y - 1) * self.length

    love.graphics.rectangle(
        self.mode,
        block_x, block_y,
        self.length, self.length
    )
end


return Blocks