local menu = {}

local config = require("config")

menu.selected = 1
menu.title = config.menu.title
menu.buttons = config.menu.buttons
menu.animationTimer = 0

function menu.update(dt)
    menu.animationTimer = menu.animationTimer + dt
end

function menu.updateSelection(key)
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
    end
end

function menu.handleAction()
    local action = menu.buttons[menu.selected].action
    if action == "startGame" then
        return "game"
    elseif action == "exit" then
        love.event.quit()
    end
    return "menu"
end

function menu.draw(font, playingAreaWidth, playingAreaHeight)
    love.graphics.setBackgroundColor(0.1, 0.1, 0.2)
    love.graphics.setColor(0.2, 0.2, 0.4 + 0.1 * math.sin(menu.animationTimer * 2)) -- Animation color
    love.graphics.rectangle("fill", 0, 0, playingAreaWidth, playingAreaHeight)

    love.graphics.setColor(1, 1, 1)
    local titleX = playingAreaWidth / 2 - font:getWidth(menu.title) / 2
    local titleY = playingAreaHeight / 12
    love.graphics.print(menu.title, titleX, titleY)

    local buttonSpacing = 50
    local startY = playingAreaHeight / 2.35

    for i, button in ipairs(menu.buttons) do
        local buttonText = button.text
        local textWidth = font:getWidth(buttonText)
        local x = playingAreaWidth / 2 - textWidth / 2
        local y = startY + (i - 1) * buttonSpacing

        if i == menu.selected then
            local alpha = 0.5 + 0.5 * math.sin(menu.animationTimer * 5)
            love.graphics.setColor(0.4 + alpha * 0.6, 0.8, 0.4 + alpha * 0.6)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.print(buttonText, x, y)
    end

    love.graphics.setColor(0.8, 0.8, 0.8)
    local hintText = "Presiona Enter"
    local hintX = playingAreaWidth / 2 - font:getWidth(hintText) / 2
    local hintY = playingAreaHeight - 60
    love.graphics.print(hintText, hintX, hintY)
end

return menu
