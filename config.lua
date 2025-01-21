local config = {}

config.playingAreaHeight = 388
config.playingAreaWidth = 300

config.bird = {
    x = 62,
    width = 30,
    height = 25,
    initialY = 200,
    speed = 165
}

config.pipe = {
    spaceHeight = 100,
    width = 54
}

config.menu = {
    title = "Menú Principal",
    buttons = {
        { text = "Jugar", action = "startGame" },
        { text = "Salir", action = "exit" }
    }
}

return config