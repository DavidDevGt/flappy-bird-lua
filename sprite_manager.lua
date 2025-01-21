local spriteManager = {}

local sprites = {}

function spriteManager.load()
    sprites = {
        bird = love.graphics.newImage("assets/bird.png", { mipmaps = true }),
        -- pipe = love.graphics.newImage("assets/pipe.png", { mipmaps = true }),
        background = love.graphics.newImage("assets/background.png"),
    }
end

function spriteManager.get(spriteName)
    if sprites[spriteName] then
        return sprites[spriteName]
    else
        error("Sprite '" .. spriteName .. "' no encontrado en el spriteManager.")
    end
end

return spriteManager
