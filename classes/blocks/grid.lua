local Blocks = require "classes.blocks"
local Grid = Blocks:extend()


function Grid:new()
    Grid.super.new(self)

    self.empty = {}
    self.COLS = 20
    self.ROWS = 15

    self.color = { 0.50, 0.50, 0.50 } -- Light Gray
    self.MODE = "line"
end


-- function Grid:update()


function Grid:draw()
    for grid_x = 1, self.COLS, 1 do
        for grid_y = 1, self.ROWS, 1 do
            Grid.super.draw(self, grid_x,grid_y)
        end
    end
end


return Grid