local Blocks = require "classes.blocks"
local Snake = Blocks:extend()


function Snake:new(grid)
    self.super.new(self)

    self.alive = true
    self.win   = nil
    self.bite  = nil
    self.grow  = nil
    self.miss  = nil

    self.direction = "right"
    self.side      = "top"
    self.corner    = "TOP_LEFT"

    self.parts = {
        { x = 3, y = 1 },
        { x = 2, y = 1 },
        { x = 1, y = 1 },
    }
    self.max  = (grid.max - 1) * 4
    self.min  = 2 -- Trust me.
    self.head = nil
    self.tail = nil
    self.next = nil

    self.colors = {
        ALIVE = { 0.60, 1.00, 0.32, 1 }, -- Light Green
        HEAD  = { 0.60, 1.00, 0.32, 0.5 }, -- Dark Green
        DEAD  = { 1.00, 0.30, 0.30, 1 }, -- Red, Apple
    }

    self.mode = "fill"
end

function Snake:reset(grid)
    self.alive = true
    self.win   = nil
    self.bite  = nil

    self.direction = "right"
    self.side      = "top"
    self.corner    = "TOP_LEFT"

    if grid.max <= 5 then
        self.parts = { -- Moved back 1 left
            { x = 2, y = 1 },
            { x = 1, y = 1 },
            { x = 0, y = 1 },
        }
    elseif grid.max <= 7 then
        self.parts = { -- Moved back 1 left
            { x = 3, y = 1 },
            { x = 2, y = 1 },
            { x = 1, y = 1 },
            { x = 0, y = 1 },
        }
    elseif grid.max <= 9 then
        self.parts = { -- Moved back 1 left
            { x = 4, y = 1 },
            { x = 3, y = 1 },
            { x = 2, y = 1 },
            { x = 1, y = 1 },
            { x = 0, y = 1 },
        }
    end
    self.max  = (grid.max - 1) * 4
    self.min  = 2 -- Trust me.
    self.head = nil
    self.tail = nil
    self.next = nil
end


-- function Snake:keypressed(key)

function Snake:changeDirection()
    local dir = self.direction

    if dir == "right" then
        dir = "left"
    elseif dir == "left" then
        dir = "right"
    end

    self.direction = dir
end


-- function Snake:update()

function Snake:setPosition(grid)
    -- Assign
    self.head = self.parts[1]
    self.next = { x = self.head.x, y = self.head.y }

    local dir  = self.direction
    local side = self.side
    local corner = nil
    local x, y = self.next.x, self.next.y

    -- Side
    -- Try and y not 1, max?
    if     y == 1        then side = "top"
    elseif x == grid.max then side = "right"
    elseif y == grid.max then side = "bottom"
    elseif x == 1        then side = "left"
    end

    self.side = side

    -- Corner
    for name, grid_corner in pairs(grid.corners) do
        if  grid_corner.x == self.next.x
        and grid_corner.y == self.next.y
        then
            corner = name

            break
        end
    end

    self.corner = corner

    -- Movement
    -- Try removing half of corner cases?
    if side == "top" then
        if corner == nil then
            if     dir == "right" then x = x + 1
            elseif dir == "left"  then x = x - 1
            end
        elseif corner == "TOP_LEFT" then
            if     dir == "right" then x = x + 1
            elseif dir == "left"  then y = y + 1
            end
        elseif corner == "TOP_RIGHT" then
            if     dir == "right" then y = y + 1
            elseif dir == "left"  then x = x - 1
            end
        end
    elseif side == "right" then
        if corner == nil then
            if     dir == "right" then y = y + 1
            elseif dir == "left"  then y = y - 1
            end
        elseif corner == "TOP_RIGHT" then
            if     dir == "right" then y = y + 1
            elseif dir == "left"  then x = x - 1
            end
        elseif corner == "BOTTOM_RIGHT" then
            if     dir == "right" then x = x - 1
            elseif dir == "left"  then y = y - 1
            end
        end
    elseif side == "bottom" then
        if corner == nil then
            if     dir == "right" then x = x - 1
            elseif dir == "left"  then x = x + 1
            end
        elseif corner == "BOTTOM_RIGHT" then
            if     dir == "right" then x = x - 1
            elseif dir == "left"  then y = y - 1
            end
        elseif corner == "BOTTOM_LEFT" then
            if     dir == "right" then y = y - 1
            elseif dir == "left"  then x = x + 1
            end
        end
    elseif side == "left" then
        if corner == nil then
            if     dir == "right" then y = y - 1
            elseif dir == "left"  then y = y + 1
            end
        elseif corner == "BOTTOM_LEFT" then
            if     dir == "right" then y = y - 1
            elseif dir == "left"  then x = x + 1
            end
        elseif corner == "TOP_LEFT" then
            if     dir == "right" then x = x + 1
            elseif dir == "left"  then y = y + 1
            end
        end
    end

    self.direction = dir
    self.next.x, self.next.y = x, y
end

function Snake:addHead()
    table.insert(self.parts, 1, self.next)
end

function Snake:removeTail()
    table.remove(self.parts, #self.parts)
end


function Snake:draw()
    for part_number, part in ipairs(self.parts) do
        -- self.color = {1,1,1,0.5}
        -- Snake.super.draw(self, part.x,part.y)

        if self.alive then
            self.color = self.colors.ALIVE
            self.color[4] = ((self.max - (part_number - 1)) / self.max) + 0.2
            -- print(self.color[4])
        else
            self.color = self.colors.DEAD
        end

        Snake.super.draw(self, part.x,part.y)
    end
end


return Snake