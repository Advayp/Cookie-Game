WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

push = require 'push'
Class = require 'class'

require 'Player'
require 'Cookie'
require 'Cheese'

function love.load()

    score = 0
    lives = 3

    gameState = 'play'

    math.randomseed(os.time())

    love.window.setTitle('Cookie Catcher')

    defaultFont = love.graphics.newFont('fonts/font.TTF', 16)

    player = Player(VIRTUAL_WIDTH / 2 - 30, VIRTUAL_HEIGHT - 30)
    cheese = {}
    cookies = {}

    for i = 0, 3 do
        cookies[i] = Cookie()
    end

    for i = 0, 1 do
        cheese[i] = Cheese()
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
    
    if lives == 0 then
        gameState = 'done'
    end

    if gameState == 'play' then
        for i = 0, 3 do
            if cookies[i]:collides(player) then
                cookies[i].x = math.random(20, VIRTUAL_WIDTH - 30)
                cookies[i].y = math.random(5, 30)
                score = score + 1
            end


            cookies[i]:update(dt)
        end

        for i = 0, 1 do
            if cheese[i]:collides(player) then
                cheese[i].x = math.random(20, VIRTUAL_WIDTH - 30)
                cheese[i].y = math.random(5, 30)
                lives = lives - 1
            end

            cheese[i]:update(dt)
        end
        player:update(dt)
    end
end

function love.draw()
    push:apply('start')

    love.graphics.setFont(defaultFont)

    if gameState == 'play' then

        love.graphics.clear(0, 130 / 255, 170 / 255, 1)

    
        for i = 0, 3 do
            cookies[i]:draw()
        end
    


        love.graphics.setColor(232 / 255, 105 / 255, 21 / 255, 1)
        love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT - 10, VIRTUAL_WIDTH, 10)
        love.graphics.setColor(1, 1, 1, 1)

        love.graphics.print("Score: " .. tostring(score) .. ". Lives: " .. tostring(lives))

        for i = 0, 1 do
            cheese[i]:draw()
        end
    
        player:draw()
    elseif gameState == 'done' then
        love.graphics.clear(0, 0, 0, 1)
        love.graphics.print("Game Over", VIRTUAL_WIDTH / 2 - 16, VIRTUAL_HEIGHT / 2 - 16)
    end 
    push:apply('end')
end