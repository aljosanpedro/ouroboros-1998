local Blocks = require "classes.blocks"
local Snake = Blocks:extend()


function Snake:new()
    self.super.new(self)

    self.alive = true

    self.directions = { "right" }
    self.direction = nil

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


-- Snake:keypressed(key)

function Snake:addDirection(key)
    self.direction = self.directions[1]
    local dir = self.direction

    local horizontal = (dir == "left" or dir == "right")
    local vertical   = (dir == "up"   or dir == "down" )

    if (key == "left"  and not horizontal)
    or (key == "right" and not horizontal)
    or (key == "up"    and not vertical  )
    or (key == "down"  and not vertical  )
    then
        table.insert(self.directions, key)
    end
end


-- function Snake:update()

function Snake:setDirection()
    if #self.directions > 1 then
        table.remove(self.directions, 1)
    end

    self.direction = self.directions[1]
end

function Snake:setPosition(grid)
    -- Assign
    self.head = self.parts[1]
    self.next = { x = self.head.x, y = self.head.y }

    local dir = self.direction
    local x, y = self.next.x, self.next.y

    -- Movement
    if     dir == "left"  then x = x - 1
    elseif dir == "right" then x = x + 1
    elseif dir == "up"    then y = y - 1
    elseif dir == "down"  then y = y + 1
    end

    -- Wrapping
    if     x < 1         then x = grid.COLS
    elseif x > grid.COLS then x = 1
    elseif y < 1         then y = grid.ROWS
    elseif y > grid.ROWS then y = 1
    end

    -- Update
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

function Snake:isEating(apple)
    return ((self.head.x == apple.x) and (self.head.y == apple.y))
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