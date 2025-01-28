local Object = require "libraries.classic"
local Blocks = Object:extend()


function Blocks:new()
    self.SIZE = 15
end


-- function Blocks:update(dt)


function Blocks:draw(block_x, block_y)
    -- Color
    love.graphics.setColor(self.color)

    -- Rectangle
    block_x = (block_x - 1) * self.SIZE
    block_y = (block_y - 1) * self.SIZE

    love.graphics.rectangle(
        self.MODE,
        block_x, block_y,
        self.SIZE, self.SIZE
    )
end


return Blocks