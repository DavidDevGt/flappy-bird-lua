local gameState = "menu"

-- Aquí modificar el menú principal y opciones
local menu = {
    title = "Menú Principal",
    buttons = {
        { text = "Jugar", action = "startGame" },
        { text = "Salir", action = "exit" }
    },
    selected = 1
}

-- CONFIG Variables
local birdX, birdY, birdWidth, birdHeight
local playingAreaWidth = 300
local playingAreaHeight = 388
local pipeSpaceHeight, pipeWidth
local pipe1X, pipe1SpaceY, pipe2X, pipe2SpaceY
local birdYSpeed
local score, upcomingPipe

-- Font
local font

local function newPipeSpaceY()
    local pipeSpaceYMin = 54
    return love.math.random(
        pipeSpaceYMin,
        playingAreaHeight - pipeSpaceHeight - pipeSpaceYMin
    )
end

local function reset()
    birdY = 200
    birdYSpeed = 0

    pipe1X = playingAreaWidth
    pipe1SpaceY = newPipeSpaceY()

    pipe2X = playingAreaWidth + ((playingAreaWidth + pipeWidth) / 2)
    pipe2SpaceY = newPipeSpaceY()

    score = 0
    upcomingPipe = 1
end

function love.load()
    love.window.setMode(playingAreaWidth, playingAreaHeight, { resizable = false })
    love.window.setTitle("Juego con Menú Principal - LÖVE2D")

    font = love.graphics.newFont(24)
    love.graphics.setFont(font)

    -- Dimensiones del juego
    birdX = 62
    birdWidth = 30
    birdHeight = 25

    pipeSpaceHeight = 100
    pipeWidth = 54

    reset()
end

function love.update(dt)
    if gameState == "game" then
        birdYSpeed = birdYSpeed + (516 * dt)
        birdY = birdY + (birdYSpeed * dt)

        local function movePipe(pipeX, pipeSpaceY)
            pipeX = pipeX - (60 * dt)
            if (pipeX + pipeWidth) < 0 then
                pipeX = playingAreaWidth
                pipeSpaceY = newPipeSpaceY()
            end
            return pipeX, pipeSpaceY
        end

        pipe1X, pipe1SpaceY = movePipe(pipe1X, pipe1SpaceY)
        pipe2X, pipe2SpaceY = movePipe(pipe2X, pipe2SpaceY)

        local function isBirdCollidingWithPipe(pipeX, pipeSpaceY)
            return
                birdX < (pipeX + pipeWidth) and
                (birdX + birdWidth) > pipeX and
                (birdY < pipeSpaceY or
                (birdY + birdHeight) > (pipeSpaceY + pipeSpaceHeight))
        end

        if isBirdCollidingWithPipe(pipe1X, pipe1SpaceY)
            or isBirdCollidingWithPipe(pipe2X, pipe2SpaceY)
            or birdY > playingAreaHeight then
            reset()
            gameState = "menu"
        end

        local function updateScoreAndClosestPipe(thisPipe, pipeX, otherPipe)
            if upcomingPipe == thisPipe and (birdX > (pipeX + pipeWidth)) then
                score = score + 1
                upcomingPipe = otherPipe
            end
        end

        updateScoreAndClosestPipe(1, pipe1X, 2)
        updateScoreAndClosestPipe(2, pipe2X, 1)
    end
end
function love.keypressed(key)
    if gameState == "menu" then
        if key == "down" then
            menu.selected = menu.selected + 1
            if menu.selected > #menu.buttons then
                menu.selected = 1
            end
        elseif key == "up" then
            menu.selected = menu.selected - 1
            if menu.selected < 1 then
                menu.selected = #menu.buttons
            end
        elseif key == "return" or key == "enter" then
            local action = menu.buttons[menu.selected].action
            if action == "startGame" then
                reset()
                gameState = "game"
            elseif action == "exit" then
                love.event.quit()
            end
        end
    elseif gameState == "game" then
        if key == "space" and birdY > 0 then
            birdYSpeed = -165
        end
    end
end


function love.draw()
    if gameState == "menu" then
        -- Background
        love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
        love.graphics.setColor(1, 1, 1)

        -- Title
        local titleX = playingAreaWidth / 2 - font:getWidth(menu.title) / 2
        local titleY = playingAreaHeight / 6
        love.graphics.print(menu.title, titleX, titleY)

        -- Buttons
        local buttonSpacing = 50
        local startY = playingAreaHeight / 2
        for i, button in ipairs(menu.buttons) do
            local buttonText = button.text
            local textWidth = font:getWidth(buttonText)
            local x = playingAreaWidth / 2 - textWidth / 2
            local y = startY + (i - 1) * buttonSpacing

            if i == menu.selected then
                love.graphics.setColor(0.4, 0.8, 0.4) -- Verde claro para el seleccionado
            else
                love.graphics.setColor(1, 1, 1)
            end
            love.graphics.print(buttonText, x, y)
        end
    elseif gameState == "game" then
        -- Background
        love.graphics.setColor(0.14, 0.36, 0.46)
        love.graphics.rectangle('fill', 0, 0, playingAreaWidth, playingAreaHeight)

        -- Bird
        love.graphics.setColor(0.87, 0.84, 0.27)
        love.graphics.rectangle('fill', birdX, birdY, birdWidth, birdHeight)

        --- Pipes
        local function drawPipe(pipeX, pipeSpaceY)
            love.graphics.setColor(0.37, 0.82, 0.28)
            love.graphics.rectangle('fill', pipeX, 0, pipeWidth, pipeSpaceY)
            love.graphics.rectangle(
                'fill',
                pipeX,
                pipeSpaceY + pipeSpaceHeight,
                pipeWidth,
                playingAreaHeight - pipeSpaceY - pipeSpaceHeight
            )
        end

        drawPipe(pipe1X, pipe1SpaceY)
        drawPipe(pipe2X, pipe2SpaceY)

        -- Puntaje
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Score: " .. score, 15, 15)
    end
end
