WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

push = require 'push'
Class = require 'class'

require 'Player'
require 'Cookie'

function love.load()

    math.randomseed(os.time())

    love.window.setTitle('Cookie Catcher')

    defaultFont = love.graphics.newFont('fonts/font.TTF', 32)

    player = Player(VIRTUAL_WIDTH / 2 - 30, VIRTUAL_HEIGHT - 30)
    cookies = {}

    for i = 0, 3 do
        cookies[i] = Cookie()
    end

    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    
    for i = 0, 3 do
        if cookies[i]:collides(player) then
            cookies[i].x = math.random(20, VIRTUAL_WIDTH - 30)
            cookies[i].y = 30
        end

        cookies[i]:update(dt)
    end


    player:update(dt)
end

function love.draw()
    push:apply('start')

    love.graphics.setFont(defaultFont)

    love.graphics.clear(0, 130 / 255, 170 / 255, 1)

    
    for i = 0, 3 do
        cookies[i]:draw()
    end
    


    love.graphics.setColor(232 / 255, 105 / 255, 21 / 255, 1)
    love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT - 10, VIRTUAL_WIDTH, 10)
    love.graphics.setColor(1, 1, 1, 1)

    player:draw()

    push:apply('end')
end