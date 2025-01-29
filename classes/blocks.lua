local Object = require "libraries.classic"
local Blocks = Object:extend()


function Blocks:new()
    self.LENGTH = 50
end


-- function Blocks:update(dt)


function Blocks:draw(block_x, block_y)
    -- Color
    love.graphics.setColor(self.color)

    -- Rectangle
    block_x = (block_x - 1) * self.LENGTH
    block_y = (block_y - 1) * self.LENGTH

    love.graphics.rectangle(
        self.mode,
        block_x, block_y,
        self.LENGTH, self.LENGTH
    )
end


return Blocks