local TITLE = "Ouroboros_1998"

local Grid = require "classes.blocks.grid"
local grid = Grid()


function love.conf(t)
    t.window = {
        title = TITLE,

        width  = grid.max * grid.length,
        height = grid.max * grid.length
    }
    t.version = "11.5"
end