local Blocks = require "classes.blocks"
local Snake = Blocks:extend()


function Snake:new()
    self.super.new(self)

    self.alive = true

    self.corner = "TOP_LEFT"
    self.direction = "right"

    self.parts = {
        { x = 3, y = 1 },
        { x = 2, y = 1 },
        { x = 1, y = 1 },
    }
    self.head = nil
    self.next = nil

    self.colors = {
        ALIVE = { 0.60, 1.00, 0.32 }, -- Green
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

    -- Corner
    local corner = self.corner

    for name, grid_corner in pairs(grid.corners) do
        if  grid_corner.x == self.head.x
        and grid_corner.y == self.head.y
        then
            corner = name

            break
        end
    end

    self.corner = corner

    -- Movement
    local dir  = self.direction
    local x, y = self.next.x, self.next.y

    if     corner == "TOP_LEFT"         then
        if dir == "right" then x = x + 1 end
        if dir == "left"  then y = y + 1 end
    elseif corner == "TOP_RIGHT"        then
        if dir == "right" then y = y + 1 end
        if dir == "left"  then x = x - 1 end
    elseif corner == "BOTTOM_RIGHT"     then
        if dir == "right" then x = x - 1 end
        if dir == "left"  then y = y - 1 end
    elseif corner == "BOTTOM_LEFT"      then
        if dir == "right" then y = y - 1 end
        if dir == "left"  then x = x + 1 end
    end

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
    if self.alive then
        self.color = self.colors.ALIVE
    else
        self.color = self.colors.DEAD
    end

    for _, part in ipairs(self.parts) do
        Snake.super.draw(self, part.x,part.y)
    end
end


return Snake