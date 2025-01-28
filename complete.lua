-- Declarations
-- Objects (Global)
local grid, snake, apple
local timer


function love.load()
    -- Initializations
    -- Classes (Local)
    local Grid  = require "classes.blocks.grid"
    local Snake = require "classes.blocks.snake"
    local Apple = require "classes.blocks.apple"

    local Timer = require "classes.timer"

    -- Objects (Global)
    grid  = Grid()
    snake = Snake()
    apple = Apple(grid, snake)

    timer = Timer()

    -- Constants
    local BG_COLOR = { 0.28, 0.28, 0.28 } -- Dark Gray

    -- Commands
    love.graphics.setBackgroundColor(BG_COLOR)
end


function love.keypressed(key)
    snake:addDirection(key)
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
        snake:setDirection()
        snake:setPosition(grid)

        -- Check Alive
        if snake:isHit() then
            return
        end

        -- Update Body
        snake:addHead()

        if snake:isEating(apple) then
            apple:spawn(grid, snake)
        else
            snake:removeTail()
        end

        -- Still Alive
        return
    end

    if  not snake.alive
    and timer:isDone(timer.DIE)
    then
        love.load() -- Reset
    end
end


function love.draw()
    -- apple:draw
    snake:draw()
    -- Technically, wrong order...
        -- but good for debugging apple position
        -- and makes snake look like it's "eating"
    apple:draw()

    grid:draw()
end