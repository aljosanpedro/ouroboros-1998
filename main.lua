-- Declarations
-- Objects (Global)
local grid, snake, apple
local timer

local window, setWindow

local resetRequested, resetGame

local inner_mode, outer_mode = "line", "fill"


function love.load()
    -- Initializations
    -- Classes (Local)
    local Grid  = require "classes.blocks.grid"
    local Snake = require "classes.blocks.snake"
    local Apple = require "classes.blocks.apple"

    local Timer = require "classes.timer"

    -- Objects (Global)
    grid  = Grid()
    snake = Snake(grid)
    apple = Apple(grid, snake)

    timer = Timer()

    -- Constants
    BG_COLOR = { 0.28, 0.28, 0.28 }

    -- Variables
    resetRequested = nil

    -- Commands
    setWindow()
    love.graphics.setBackgroundColor(BG_COLOR)
end

setWindow = function ()
    window = grid.max * grid.length
    love.window.setMode(window, window)
end

resetGame = function ()
    if snake.win then
        snake:raiseLength()
        apple:raiseLength()

        grid:raiseLength()
        grid:raiseMax()
        grid:reset()

        setWindow()
    end

    snake:reset(grid)
    apple:reset(grid, snake)

    timer:reset()
end


function love.keypressed(key)
    if     key == "space" then
        snake.bite = true
    elseif key == 'c' then
        snake:changeDirection()
    elseif key == 'r' then
        resetRequested = true
    elseif key == 'q' then
        love.load()
    elseif key == "escape" then
        love.event.quit()
    elseif key == 'n' then
        snake.alive = false
        snake.win = true
        resetGame()
    end
end


function love.update(dt)
    timer:run(dt)

    if not snake.alive then
        if timer:isDone(timer.DIE) then
            if snake.win then
                resetGame()
            else
                love.load()
            end
        end

        return
    end

    if not timer:isDone(timer.MOVE) then
        return
    end

    if resetRequested then
        resetGame()
        resetRequested = false
    end

    timer:restart()

    snake:setPosition(grid)

    snake:addHead()

    -- snake.grow = false
    if snake.bite then
        if apple:isInHead(snake) then
            if #snake.parts == snake.max then
                snake.alive = false
                snake.win = true

                return
            end

            snake:addHead()
            snake.grow = true

            apple:spawn(grid, snake)

            timer:shorten()
        else
            if #snake.parts == snake.min then
                snake.alive = false
                snake.win = false

                return
            end

            snake:changeDirection()
            snake.grow = false

            snake:removeTail()
            timer:lengthen()

            if #snake.parts > (snake.max / 2) then
                snake:removeTail()
                timer:lengthen()
            end
        end

        snake.bite = false
    end

    snake:removeTail()
end


function love.draw()
    snake:draw()
    apple:draw(snake)

    grid:draw(snake, apple)
end