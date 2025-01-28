local TITLE = "Snake"

local Grid = require "classes.blocks.grid"
local grid = Grid()


function love.conf(t)
    t.window = {
        title = TITLE,

        width  = grid.COLS * grid.SIZE,
        height = grid.ROWS * grid.SIZE
    }
end