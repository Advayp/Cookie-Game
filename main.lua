WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

push = require 'push'
Class = require 'class'

require 'Player'
require 'Collidable'
require 'Heart'

function love.load()

    score = 0
    lives = 3

    gameState = 'play'

    math.randomseed(os.time())

    love.window.setTitle('Cookie Catcher')

    defaultFont = love.graphics.newFont('fonts/font.TTF', 16)

    player = Player(VIRTUAL_WIDTH / 2 - 30, VIRTUAL_HEIGHT - 30)

    cookieIMG = love.graphics.newImage('images/cookie.png')
    cheeseIMG = love.graphics.newImage('images/cheese.png')

    cheese = {}
    cookies = {}

    hearts = {}

    x = 82
    for i = 0, 2 do
        hearts[i] = Heart(x)
        x = x + 18
    end

    for i = 0, 3 do
        cookies[i] = Collidable(cookieIMG, 50)
    end

    for i = 0, 1 do
        cheese[i] = Collidable(cheeseIMG, 70)
    end

    sounds = {
        ['pickup'] = love.audio.newSource('sounds/pickup.wav', 'static'),
        ['lifeLost'] = love.audio.newSource('sounds/hurt.wav', 'static'),
    }

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

    if key == 'enter' or key == 'return' then
        if gameState == 'done' then
            gameState = 'play'
            lives = 3
            score = 0

            for i = 0, 2 do
                hearts[i].state = 'norm'
            end

            for i = 0, 3 do
                cookies[i]:reset()
            end

            for i = 0, 1 do
                cheese[i]:reset()
            end

        end
    end
    
    if key == 'p' then
        if gameState == 'play' then
            gameState = 'pause'
            for i = 0, 3 do
                cookies[i].dy = 0
            end

            for i = 0, 1 do
                cheese[i].dy = 0
            end

            player.dx = 0
        elseif gameState == 'pause' then
            gameState = 'play'
            for i = 0, 3 do
                if score >= 15 then
                    cookies[i].dy = 70
                else
                    cookies[i].dy = 50
                end
            end

            for i = 0, 1 do
                if score >= 15 then
                    cheese[i].dy = 90
                else
                    cheese[i].dy = 70
                end
            end

            player.dx = 200
        end
    end

end

function love.update(dt)
    
    if lives == 0 then
        gameState = 'done'
    end

    if score >= 15 then
        for i = 0, 1 do
            cheese[i].dy = 110
        end

        for i = 0, 3 do
            cookies[i].dy = 90
        end
    else
        for i = 0, 1 do
            cheese[i].dy = 70
        end

        for i = 0, 3 do
            cookies[i].dy = 50
        end
    end

    if gameState == 'play' then
        for i = 0, 3 do
            if cookies[i]:collides(player) then
                cookies[i]:reset()
                score = score + 1
                sounds['pickup']:play()
            end


            cookies[i]:update(dt, -1)
        end

        for i = 0, 1 do
            if cheese[i]:collides(player) then
                cheese[i]:reset()
                lives = lives - 1
                hearts[lives].state = 'gray'
                sounds['lifeLost']:play()
            end

            cheese[i]:update(dt, 0)
        end
        player:update(dt)
    end
end

function love.draw()
    push:apply('start')

    love.graphics.setFont(defaultFont)

    if gameState == 'play' or gameState == 'pause' then

        love.graphics.clear(0, 130 / 255, 170 / 255, 1)

    
        for i = 0, 3 do
            cookies[i]:draw()
        end
    
        player:draw()

        love.graphics.setColor(0, 1, 170 / 255, 1)
        love.graphics.print("Score: " .. tostring(score))

        for i = 0, 1 do
            cheese[i]:draw()
        end

        love.graphics.setColor(1, 1, 1, 1)
        for i = 0, 2 do
            hearts[i]:draw()
        end

        love.graphics.setColor(232 / 255, 105 / 255, 21 / 255, 1)
        love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT - 10, VIRTUAL_WIDTH, 10)
        love.graphics.setColor(1, 1, 1, 1)

    elseif gameState == 'done' then
        love.graphics.clear(0, 0, 0, 1)
        game_over = love.graphics.newImage('images/game-over.png')
        love.graphics.draw(game_over, VIRTUAL_WIDTH / 2 - 128, VIRTUAL_HEIGHT / 2 - 128)
        love.graphics.setColor(0, 1, 170 / 255, 1)
        love.graphics.print("Final Score: " .. tostring(score), VIRTUAL_WIDTH / 2 - 55)
        love.graphics.setColor(1, 1, 1, 1)
    end 
    push:apply('end')
end