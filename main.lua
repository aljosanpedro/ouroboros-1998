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


    -- Commands
    local BG_COLOR = { 0.28, 0.28, 0.28 }
    love.graphics.setBackgroundColor(BG_COLOR)
end


function love.keypressed(key)
    if  key == "space"
    and snake.alive then
        snake.bite = true
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

        if snake:isHit(grid) then
            snake:addHead()
            snake.alive = false
            return
        end

        -- Update Body
        snake:addHead()

        if apple:isInHead(snake)
        and snake.bite
        then
            snake:setDirection()
            if snake.alive then
                apple:spawn(grid, snake)
            end
            timer:shorten()
        else
            snake:removeTail()
        end

        -- Still Alive
        snake.bite = false
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
    apple:draw()

    grid:draw(snake)
end