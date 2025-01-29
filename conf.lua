local TITLE = "Snake"

local Grid = require "classes.blocks.grid"
local grid = Grid()


function love.conf(t)
    t.window = {
        title = TITLE,

        width  = grid.max * grid.LENGTH,
        height = grid.max * grid.LENGTH
    }
end