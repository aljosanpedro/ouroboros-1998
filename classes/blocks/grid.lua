local Blocks = require "classes.blocks"
local Grid = Blocks:extend()


function Grid:new()
    Grid.super.new(self)

    self.max = 4
    self.INCREASE = 1
    self.HIGHEST = 9

    self.corners = {
        TOP_LEFT     = { x = 1,         y = 1        },
        TOP_RIGHT    = { x = self.max,  y = 1        },
        BOTTOM_LEFT  = { x = 1,         y = self.max },
        BOTTOM_RIGHT = { x = self.max,  y = self.max },
    }

    self.colors = {
        LINE = { 0.50, 0.50, 0.50 }, -- Light Gray
        fill = {
            WIN = { 0.60, 1.00, 0.32, 1}, -- Light Green, Snake
            LOSE = { 1.00, 0.30, 0.30, 1} -- Red, Apple
        }
    }
    self.color = self.colors.LINE
    self.color_square = nil

    self.mode = "line"
end

function Grid:raiseMax()
    self.max = self.max + self.INCREASE
end

function Grid:reset()
    self.corners = {
        TOP_LEFT     = { x = 1,         y = 1        },
        TOP_RIGHT    = { x = self.max,  y = 1        },
        BOTTOM_LEFT  = { x = 1,         y = self.max },
        BOTTOM_RIGHT = { x = self.max,  y = self.max },
    }
end


-- function Grid:update()


function Grid:draw(snake, apple, timer)
    -- Inner Square
    if snake.alive then
        self.color_square = self.colors.LINE

        snake.head = snake.parts[1]
        if apple:isInHead(snake) then
            self.color_square = {1,1,1,0.5}
        end
    else
        if snake.win then
            self.color_square = self.colors.fill.WIN
        else
            self.color_square = self.colors.fill.LOSE
        end
    end

    love.graphics.setColor(self.color_square)
    love.graphics.rectangle(
        "fill",
        self.length,
        self.length,
        (self.max - 2) * self.length,
        (self.max - 2) * self.length
    )

    love.graphics.setColor(self.colors.LINE)
    love.graphics.rectangle(
        "line",
        self.length,
        self.length,
        (self.max - 2) * self.length,
        (self.max - 2) * self.length
    )

    for grid_x = 1, self.max, 1 do
        for grid_y = 1, self.max, 1 do
            -- Corners
            if  (grid_x == 1 or grid_x == self.max)
            or  (grid_y == 1 or grid_y == self.max)
            then
                -- Fill
                if not snake.alive then
                    self.mode = "fill"

                    if snake.win then
                        self.color = self.colors.fill.WIN
                    else
                        self.color = self.colors.fill.LOSE
                    end

                    Grid.super.draw(self, grid_x, grid_y)
                end

                -- Line
                self.mode = "line"
                self.color = self.colors.LINE
                Grid.super.draw(self, grid_x, grid_y)
            end
        end
    end
end


return Grid