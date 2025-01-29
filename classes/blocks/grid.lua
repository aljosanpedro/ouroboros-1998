local Blocks = require "classes.blocks"
local Grid = Blocks:extend()


function Grid:new()
    Grid.super.new(self)

    self.max = 5

    self.corners = {
        TOP_LEFT     = { x = 1,         y = 1        },
        TOP_RIGHT    = { x = self.max,  y = 1        },
        BOTTOM_LEFT  = { x = 1,         y = self.max },
        BOTTOM_RIGHT = { x = self.max,  y = self.max },
    }

    self.colors = {
        LINE = { 0.50, 0.50, 0.50 }, -- Light Gray
        FILL = { 0.60, 1.00, 0.32 }, -- Light Green
    }
    self.color = self.colors.LINE

    self.mode = "line"
end


-- function Grid:update()


function Grid:draw(snake)
    for grid_x = 1, self.max, 1 do
        for grid_y = 1, self.max, 1 do
            -- Corners
            if  (grid_x == 1 or grid_x == self.max)
            or  (grid_y == 1 or grid_y == self.max)
            then
                -- Fill
                if not snake.alive then
                    self.mode = "fill"
                    self.color = self.colors.FILL

                    Grid.super.draw(self, grid_x, grid_y)
                end

                -- Line
                self.mode = "line"
                self.color = self.colors.LINE
                Grid.super.draw(self, grid_x, grid_y)
            end
        end
    end

    -- Inner Square
    local square_W = (self.max - 2) * self.LENGTH
    local square_H = (self.max - 2) * self.LENGTH

    love.graphics.rectangle(self.mode, self.LENGTH,self.LENGTH, square_W,square_H)
end


return Grid