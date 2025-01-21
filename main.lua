local config = require("config")
local menu = require("menu")
local game = require("game")

local font
local gameState = "menu"

function love.load()
    love.window.setMode(config.playingAreaWidth, config.playingAreaHeight, { resizable = false })
    love.window.setTitle("FlappyBird - LÖVE2D")

    font = love.graphics.newFont(24)
    love.graphics.setFont(font)

    game.load()
end

function love.update(dt)
    if gameState == "menu" then
        menu.update(dt)
    elseif gameState == "game" then
        gameState = game.update(dt)
    end
end


function love.keypressed(key)
    if gameState == "menu" then
        if key == "return" or key == "enter" then
            gameState = menu.handleAction()
        else
            menu.updateSelection(key)
        end
    elseif gameState == "game" then
        game.keypressed(key)
    end
end

function love.draw()
    if gameState == "menu" then
        menu.draw(font, config.playingAreaWidth, config.playingAreaHeight)
    elseif gameState == "game" then
        game.draw()
    end
end
