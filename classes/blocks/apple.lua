local Blocks = require "classes.blocks"
local Apple = Blocks:extend()


function Apple:new(grid, snake)
    Apple.super.new(self)

    self.color = { 1.00, 0.30, 0.30 } -- Red
    self.MODE = "fill"

    self.x = nil
    self.y = nil

    self:spawn(grid, snake)
end


-- function Apple:update(dt)

function Apple:spawn(grid, snake)
    while true do
        -- Propose Position
        local new_x = love.math.random(1, grid.COLS)
        local new_y = love.math.random(1, grid.ROWS)

        -- Track Empty
        local empty = true

        -- Current Apple
        if  new_x == self.x
        and new_y == self.y
        then
            empty = false
        end

        -- Snake
        for _, snake_part in ipairs(snake.parts) do
            if  new_x == snake_part.x
            and new_y == snake_part.y
            then
                empty = false

                break
            end
        end

        -- Set Position
        if empty then
            self.x, self.y = new_x, new_y

            break
        end
    end
end


function Apple:draw()
    Apple.super.draw(self, self.x,self.y)
end


return Apple