local Blocks = require "classes.blocks"
local Grid = Blocks:extend()


function Grid:new()
    Grid.super.new(self)

    self.COLS = 5
    self.ROWS = 7

    self.corners = {
        TOP_LEFT     = { x = 1,         y = 1         },
        TOP_RIGHT    = { x = self.COLS, y = 1         },
        BOTTOM_LEFT  = { x = 1,         y = self.ROWS },
        BOTTOM_RIGHT = { x = self.COLS, y = self.ROWS },
    }

    self.color = { 0.50, 0.50, 0.50 } -- Light Gray
    self.MODE = "line"
end


-- function Grid:update()


function Grid:draw()
    -- Corners
    for grid_x = 1, self.COLS, 1 do
        for grid_y = 1, self.ROWS, 1 do
            -- Corners
            if  (grid_x == 1 or grid_x == self.COLS)
            or  (grid_y == 1 or grid_y == self.ROWS)
            then
                Grid.super.draw(self, grid_x, grid_y)
            end
        end
    end

    -- Inner Square
    local square_W = (self.COLS - 2) * self.SIZE
    local square_H = (self.ROWS - 2) * self.SIZE

    love.graphics.rectangle(self.MODE, self.SIZE,self.SIZE, square_W,square_H)
end


return Grid