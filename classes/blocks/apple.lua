local Blocks = require "classes.blocks"
local Apple = Blocks:extend()


function Apple:new(grid, snake)
    Apple.super.new(self)

    self.color = { 1.00, 0.30, 0.30, 1}
    self.mode = "fill"
    self.alpha = 1

    self.angle = 0

    self.x = nil
    self.y = nil

    self.sounds = {
        HEAD = love.audio.newSource("sfx/apple_on_head.wav", "static"),
        BEAT = love.audio.newSource("sfx/apple_beat.wav", "static"),
    }

    self:spawn(grid, snake)
end

function Apple:reset(grid, snake)
    self.x = nil
    self.y = nil

    self:spawn(grid, snake)
end


-- function Apple:update(dt)

function Apple:isInHead(snake)
    local inside = false

    if  self.x == snake.head.x
    and self.y == snake.head.y
    then
        inside = true
    end

    return inside
end

function Apple:changeAlpha(grid, snake, dt)
    if self.alpha > 0 then
        local percent = ((grid.max - (#snake.parts - 1)) / grid.max)
        self.alpha = self.alpha - (dt * (1.25 - percent))
    else
        self.alpha = 1
        self.sounds.BEAT:play()
    end
end

function Apple:spawn(grid, snake)
    while true do
        -- Choose Side
        local side = love.math.random(1,4)

        -- Set Ranges
        local x_min, x_max
        local y_min, y_max

        if     side == 1 then -- Top
            x_min, x_max = 1, grid.max
            y_min, y_max = 1, 1
        elseif side == 2 then -- Right
            x_min, x_max = grid.max, grid.max
            y_min, y_max = 1, grid.max
        elseif side == 3 then -- Bottom
            x_min, x_max = 1, grid.max
            y_min, y_max = grid.max, grid.max
        elseif side == 4 then -- Left
            x_min, x_max = 1, 1
            y_min, y_max = 1, grid.max
        end

        -- Propose Position
        local new_x = love.math.random(x_min, x_max)
        local new_y = love.math.random(y_min, y_max)

        -- Track Empty
        local empty = true

        -- Avoid Current Apple
        if  new_x == self.x
        and new_y == self.y
        then
            empty = false
        end

        -- Avoid Snake
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
    self.color[4] = self.alpha
    Apple.super.draw(self, self.x,self.y)
end


return Apple