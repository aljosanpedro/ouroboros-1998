-- Declarations
-- Objects (Global)
local grid, snake, apple
local timer

local BG_COLOR, SHAKE_STRENGTH

local window, setWindow
local resetRequested, resetGame


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
    SHAKE_STRENGTH = 4

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

        if grid.max > grid.HIGHEST then
            love.event.quit()
        end

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
    timer:run("move", dt)
    timer.time.shake = timer.time.shake - dt

    if not snake.alive then
        timer:run("die", dt)
        grid:changeAlpha(dt)

        if timer:isDone("die") then
            if snake.win then
                resetGame()
            else
                love.load()
            end
        end

        return
    end

    apple:changeAlpha(grid, snake, dt)
    if apple:isInHead(snake) then
        apple.sounds.HEAD:play()
    end

    if resetRequested then
        resetGame()
        resetRequested = false
    end

    if not timer:isDone("move") then
        return
    end

    timer:restart("move")

    snake:setPosition(grid)
    snake:addHead()
    -- snake.grow = false

    if snake.bite then
        if apple:isInHead(snake) then
            snake.sounds.EAT_1:play()
            snake.sounds.EAT_2:play()

            if #snake.parts == snake.max then
                snake.alive = false
                snake.win = true
                snake.sounds.NEXT_LEVEL:play()

                return
            end

            snake:addHead()
            snake.grow = true

            apple:spawn(grid, snake)

            timer:shorten()
        else
            snake.sounds.MISS:play()
            timer.time.shake = timer.max.SHAKE

            if #snake.parts == snake.min then
                snake.alive = false
                snake.win = false
                snake.sounds.DIE:play()
                snake.sounds.GAME_OVER:play()

                return
            end

            snake:changeDirection()
            snake:removeTail()
            snake.grow = false

            timer:lengthen()

            -- if #snake.parts > (snake.max / 2) then
            --     snake:removeTail()
            --     timer:lengthen()
            -- end
        end

        snake.bite = false
        -- snake.grow = false
    end

    snake:removeTail()
end


function love.draw()
    -- Bite
    if  snake.bite
    and apple:isInHead(snake)
    and #snake.parts < snake.max then
        love.graphics.setColor(1, 1, 1, 0.15)
    else
        love.graphics.setColor(1, 1, 1, 0)
    end

    love.graphics.rectangle("fill", 0,0, grid.length*grid.max,grid.length*grid.max)

    -- Game
    love.graphics.push()
        -- Miss
        if timer.time.shake > 0 then
            love.graphics.translate(
                love.math.random(-SHAKE_STRENGTH, SHAKE_STRENGTH),
                love.math.random(-SHAKE_STRENGTH, SHAKE_STRENGTH)
            )
        end

        if snake.alive then
            snake:draw()
            apple:draw()
        end

        grid:draw(snake, apple)
    love.graphics.pop()
end