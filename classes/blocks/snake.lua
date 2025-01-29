local Blocks = require "classes.blocks"
local Snake = Blocks:extend()


function Snake:new()
    self.super.new(self)

    self.alive = true

    self.direction = "right"
    self.corner = "TOP_LEFT"
    self.edge = "top"

    self.parts = {
        { x = 3, y = 1 },
        { x = 2, y = 1 },
        { x = 1, y = 1 },
    }
    self.head = nil
    self.next = nil

    self.colors = {
        ALIVE = { 0.00, 0.50, 0.32 }, -- Dark Green
        HEAD  = { 0.60, 1.00, 0.32 }, -- Green
        DEAD  = { 0.50, 0.50, 0.50 }, -- Light Gray
    }

    self.MODE = "fill"
end


-- function Snake:keypressed(key)

-- function Snake:setDirection(key, snake,apple, timer)
--     if not key == "space" then
--         return
--     end

--     for _, snake_part in ipairs(snake.parts) do
--         if  apple:isInside(snake)
--         and not timer:isDone(timer.MOVE) then
--             --
--         end
--     end
-- end


-- function Snake:update()

function Snake:setPosition(grid)
    -- Assign
    self.head = self.parts[1]
    self.next = { x = self.head.x, y = self.head.y }

    local dir  = self.direction
    local edge = self.edge
    local corner = nil
    local x, y = self.next.x, self.next.y

    -- Edge
    -- Try and y not 1, max
    if     y == 1         then edge = "top"
    elseif x == grid.COLS then edge = "right"
    elseif y == grid.ROWS then edge = "bottom"
    elseif x == 1         then edge = "left"
    end

    self.edge = edge

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
    if edge == "top" then
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
    elseif edge == "right" then
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
    elseif edge == "bottom" then
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
    elseif edge == "left" then
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

function Snake:isHit()
    for part_number, part in ipairs(self.parts) do
        -- Not tail, removed on tick
        if  part_number ~= #self.parts
        -- Next vs. Current
        and self.next.x == part.x
        and self.next.y == part.y
        then
            self.alive = false
            return true
        end
    end

    return false
end

function Snake:addHead()
    table.insert(self.parts, 1, self.next)
end

function Snake:removeTail()
    table.remove(self.parts, #self.parts)
end


function Snake:draw()
    for part_number, part in ipairs(self.parts) do
        if self.alive then
            self.color = self.colors.ALIVE

            if part_number == 1 then
                self.color = self.colors.HEAD
            end
        else
            self.color = self.colors.DEAD
        end

        Snake.super.draw(self, part.x,part.y)
    end
end


return Snake