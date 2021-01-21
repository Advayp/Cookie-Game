-- Initial Screen Dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Virtual Screen Dimensions
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Imports push and class
push = require 'push'
Class = require 'class'

-- Imports Code that I have written
require 'Player'
require 'Collidable'
require 'Heart'

function love.load()

    -- Initial Score and Lives
    score = 0
    lives = 3

    -- Initial Game State
    gameState = 'start'
    
    -- Seeds the Random Number generation
    math.randomseed(os.time())

    -- Title of Window
    love.window.setTitle('Cookie Catcher')

    -- Defualt Font
    defaultFont = love.graphics.newFont('fonts/font.TTF', 16)

    -- Large Font
    largeFont = love.graphics.newFont('fonts/font.TTF', 32)

    -- Player
    player = Player(VIRTUAL_WIDTH / 2 - 30, VIRTUAL_HEIGHT - 30)

    -- Image of the Cookie and Cheese
    cookieIMG = love.graphics.newImage('images/cookie.png')
    cheeseIMG = love.graphics.newImage('images/cheese.png')

    winningIMG = love.graphics.newImage('images/win.png')

    -- Cheese and Cookies Tables. Used to store information about 
    -- each cookie and each piece of cheese
    cheese = {}
    cookies = {}

    -- Hearts table
    hearts = {}

    normalHeart = love.graphics.newImage('images/normal-heart.png')

    -- Populates Hearts Table
    x = 82
    for i = 0, 2 do
        hearts[i] = Heart(x)
        x = x + 18
    end

    -- Populates cookies table
    for i = 0, 3 do
        cookies[i] = Collidable(cookieIMG, 50)
    end

    -- Populates cheese table
    for i = 0, 3 do
        cheese[i] = Collidable(cheeseIMG, 70)
    end

    -- Sounds table to store sounds
    sounds = {
        ['pickup'] = love.audio.newSource('sounds/pickup.wav', 'static'),
        ['lifeLost'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav', 'static')
    }

    -- Default Filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Sets up the screen
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    -- Allows user to restart
    if key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        end
        if gameState == 'done' then
            gameState = 'play'

            -- Resets values
            lives = 3
            score = 0

            for i = 0, 2 do
                -- Sets the state to the normal state of the heart (red)
                hearts[i].state = 'norm'
            end

            for i = 0, 3 do
                -- Resets the x and y of the cookies
                cookies[i]:reset()
            end

            for i = 0, 3 do
                -- Resets the x and y of the cheese
                cheese[i]:reset()
            end

        end

        if gameState == 'win' then
            gameState = 'play'

            -- Resets values
            lives = 3
            score = 0

            for i = 0, 2 do
                -- Sets the state to the normal state of the heart (red)
                hearts[i].state = 'norm'
            end

            for i = 0, 3 do
                -- Resets the x and y of the cookies
                cookies[i]:reset()
            end

            for i = 0, 3 do
                -- Resets the x and y of the cheese
                cheese[i]:reset()
            end

        end
    end
    
    -- Pausing
    if key == 'p' then
        if gameState == 'play' then
            -- Plays the pause sound
            sounds['pause']:play()
            gameState = 'pause'

            -- Sets the dx or dy for each object to 0 which looks like the game has paused.
            for i = 0, 3 do
                cookies[i].dy = 0
            end

            for i = 0, 3 do
                cheese[i].dy = 0
            end

            player.dx = 0
        elseif gameState == 'pause' then
            -- Unpauses the game
            sounds['pause']:play()
            gameState = 'play'
            for i = 0, 3 do
                if score >= 15 then
                    cookies[i].dy = 70
                else
                    cookies[i].dy = 50
                end
            end

            for i = 0, 3 do
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

    if score >= 25 and lives > 0 then
        gameState = 'win'
    end

    if lives == 0 then
        gameState = 'done'
    end

    if score >= 15 then
        for i = 0, 3 do
            cheese[i].dy = 110
        end

        for i = 0, 3 do
            cookies[i].dy = 90
        end
    else
        for i = 0, 3 do
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

        for i = 0, 3 do
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

    if gameState == 'start' then
        love.graphics.clear(237 / 255, 175 / 255, 95 / 255, 1)

        love.graphics.setFont(defaultFont)

        love.graphics.setColor(0, 0, 0, 1)

        love.graphics.print("Welcome to Cookie Catcher!", VIRTUAL_WIDTH / 2 - 109, 30)

        love.graphics.print("Press Enter to Start!", VIRTUAL_WIDTH / 2 - 89, VIRTUAL_HEIGHT / 2 - 16)
    end

    if gameState == 'pause' then
        love.graphics.print("Paused", VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)
    end

    if gameState == 'play' or gameState == 'pause' then

        love.graphics.clear(0, 130 / 255, 170 / 255, 1)

        if gameState == 'pause' then
            love.graphics.setFont(largeFont)
            love.graphics.print('Paused', 155, 0)
            love.graphics.setFont(defaultFont)
        end
    
        for i = 0, 3 do
            cookies[i]:draw()
        end
        
        player:draw()
            

        love.graphics.setColor(0, 1, 170 / 255, 1)
        love.graphics.print("Score: " .. tostring(score))

        for i = 0, 3 do
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
        love.graphics.setFont(defaultFont)

        love.graphics.print("Final Score: " .. tostring(score), VIRTUAL_WIDTH / 2 - 55)

        love.graphics.print('Press Enter to Restart!', VIRTUAL_WIDTH / 2 - 84, VIRTUAL_HEIGHT - 30)

        love.graphics.setColor(1, 1, 1, 1)

    elseif gameState == 'win' then
        love.graphics.clear(140 / 255, 25 / 255, 1, 1)
        love.graphics.draw(winningIMG, VIRTUAL_WIDTH / 2 - 64, VIRTUAL_HEIGHT / 2 - 64)
        love.graphics.setFont(defaultFont)
        love.graphics.print('Press Enter to Restart!', VIRTUAL_WIDTH / 2 - 84, VIRTUAL_HEIGHT - 30)
    end 
    push:apply('end')
end