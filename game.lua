local game = {}
local config = require("config")

local birdX, birdY, birdWidth, birdHeight
local pipe1X, pipe1SpaceY, pipe2X, pipe2SpaceY
local birdYSpeed
local score, upcomingPipe

local function newPipeSpaceY()
    local pipeSpaceYMin = 54
    return love.math.random(
        pipeSpaceYMin,
        config.playingAreaHeight - config.pipe.spaceHeight - pipeSpaceYMin
    )
end

function game.reset()
    birdY = config.bird.initialY
    birdYSpeed = 0

    pipe1X = config.playingAreaWidth
    pipe1SpaceY = newPipeSpaceY()

    pipe2X = config.playingAreaWidth + ((config.playingAreaWidth + config.pipe.width) / 2)
    pipe2SpaceY = newPipeSpaceY()

    score = 0
    upcomingPipe = 1
end

function game.load()
    birdX = config.bird.x
    birdWidth = config.bird.width
    birdHeight = config.bird.height
    game.reset()
end

function game.update(dt)
    birdYSpeed = birdYSpeed + (516 * dt)
    birdY = birdY + (birdYSpeed * dt)

    local function movePipe(pipeX, pipeSpaceY)
        pipeX = pipeX - (60 * dt)
        if (pipeX + config.pipe.width) < 0 then
            pipeX = config.playingAreaWidth
            pipeSpaceY = newPipeSpaceY()
        end
        return pipeX, pipeSpaceY
    end

    pipe1X, pipe1SpaceY = movePipe(pipe1X, pipe1SpaceY)
    pipe2X, pipe2SpaceY = movePipe(pipe2X, pipe2SpaceY)

    local function isBirdCollidingWithPipe(pipeX, pipeSpaceY)
        return
            birdX < (pipeX + config.pipe.width) and
            (birdX + birdWidth) > pipeX and
            (birdY < pipeSpaceY or
            (birdY + birdHeight) > (pipeSpaceY + config.pipe.spaceHeight))
    end

    if isBirdCollidingWithPipe(pipe1X, pipe1SpaceY)
        or isBirdCollidingWithPipe(pipe2X, pipe2SpaceY)
        or birdY > config.playingAreaHeight then
        game.reset()
        return "menu"
    end

    local function updateScoreAndClosestPipe(thisPipe, pipeX, otherPipe)
        if upcomingPipe == thisPipe and (birdX > (pipeX + config.pipe.width)) then
            score = score + 1
            upcomingPipe = otherPipe
        end
    end

    updateScoreAndClosestPipe(1, pipe1X, 2)
    updateScoreAndClosestPipe(2, pipe2X, 1)

    return "game"
end

function game.keypressed(key)
    if key == "space" and birdY > 0 then
        birdYSpeed = -config.bird.speed
    end
end

function game.draw()
    -- Background
    love.graphics.setColor(0.14, 0.36, 0.46)
    love.graphics.rectangle('fill', 0, 0, config.playingAreaWidth, config.playingAreaHeight)

    -- Bird
    love.graphics.setColor(0.87, 0.84, 0.27)
    love.graphics.rectangle('fill', birdX, birdY, birdWidth, birdHeight)

    --- Pipes
    local function drawPipe(pipeX, pipeSpaceY)
        love.graphics.setColor(0.37, 0.82, 0.28)
        love.graphics.rectangle('fill', pipeX, 0, config.pipe.width, pipeSpaceY)
        love.graphics.rectangle(
            'fill',
            pipeX,
            pipeSpaceY + config.pipe.spaceHeight,
            config.pipe.width,
            config.playingAreaHeight - pipeSpaceY - config.pipe.spaceHeight
        )
    end

    drawPipe(pipe1X, pipe1SpaceY)
    drawPipe(pipe2X, pipe2SpaceY)

    -- Score
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. score, 15, 15)
end

return game
