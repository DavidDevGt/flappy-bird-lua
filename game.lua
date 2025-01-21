local game = {}
local config = require("config")
local spriteManager = require("sprite_manager")

local birdX, birdY, birdWidth, birdHeight
local pipe1X, pipe1SpaceY, pipe2X, pipe2SpaceY
local birdYSpeed
local score, upcomingPipe
local backgroundSprite, birdSprite

local birdHitboxWidth = 10
local birdHitboxHeight = 10

-- Offsets para centrar el hitbox dentro del sprite
local birdHitboxOffsetX = 3
local birdHitboxOffsetY = 3

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
    backgroundSprite = spriteManager.get("background")
    birdSprite = spriteManager.get("bird")

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

    -- Detectar colisiones del bird con las pipes usando el hitbox ajustado
    local function isBirdCollidingWithPipe(pipeX, pipeSpaceY)
        local birdHitboxX = birdX + birdHitboxOffsetX
        local birdHitboxY = birdY + birdHitboxOffsetY

        return
            birdHitboxX < (pipeX + config.pipe.width) and
            (birdHitboxX + birdHitboxWidth) > pipeX and
            (birdHitboxY < pipeSpaceY or
            (birdHitboxY + birdHitboxHeight) > (pipeSpaceY + config.pipe.spaceHeight))
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
    -- Dibujar el fondo
    love.graphics.draw(backgroundSprite, 0, 0)

    -- Dibujar el bird
    love.graphics.draw(birdSprite, birdX, birdY)

    -- Dibujar el hitbox del bird para depuración
    -- love.graphics.setColor(1, 0, 0, 0.5) -- Rojo con transparencia
    -- love.graphics.rectangle(
    --     "fill",
    --     birdX + birdHitboxOffsetX,
    --     birdY + birdHitboxOffsetY,
    --     birdHitboxWidth,
    --     birdHitboxHeight
    -- )
    -- love.graphics.setColor(1, 1, 1)

    -- Dibujar las pipes
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

    -- Dibujar el puntaje
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. score, 15, 15)
end

return game
