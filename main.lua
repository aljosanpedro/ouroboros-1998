-- Declarations
-- Objects (Global)
local grid, snake, apple
local timer


function love.load()
    -- Initializations
    -- Classes (Local)
    local Grid  = require "classes.blocks.grid"
    local Snake = require "classes.blocks.snake"
    -- local Apple = require "classes.blocks.apple"

    local Timer = require "classes.timer"

    -- Objects (Global)
    grid  = Grid()
    snake = Snake()
    -- apple = Apple()

    timer = Timer()


    -- Commands
    local BG_COLOR = { 0.28, 0.28, 0.28 }
    love.graphics.setBackgroundColor(BG_COLOR)
end


function love.keypressed(key)
    if key == "space" then
        local dir = snake.direction

        if dir == "right" then
            dir = "left"
        elseif dir == "left" then
            dir = "right"
        end

        snake.direction = dir
    end
end


function love.update(dt)
    -- Timer
    timer:run(dt)

    if  snake.alive
    and timer:isDone(timer.MOVE)
    then
        timer:reset()

        -- Snake
        -- Set Values
        -- snake:setDirection()
        snake:setPosition(grid)

        -- Update Body
        snake:addHead()

            -- Apple-related

        snake:removeTail()

        -- Still Alive
        return
    end

    if  not snake.alive
    and timer:isDone(timer.DIE)
    then
        love.load()
    end
end


function love.draw()
    snake:draw()
    -- apple:draw()

    grid:draw()
end