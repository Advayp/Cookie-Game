Player = Class{}

function Player:init(x, y)
    self.x = x
    self.y = y
    self.img = love.graphics.newImage('images/bowl.png')

    self.dx = 200
end

function Player:update(dt)
    if love.keyboard.isDown('left') then
        self.x = math.max(0, self.x +  -self.dx * dt)
    elseif love.keyboard.isDown('right') then
        self.x = math.min(VIRTUAL_WIDTH - self.img:getWidth(), self.x + self.dx * dt)
    end
end

function Player:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, 1.5, 1.5)
    love.graphics.setColor(1, 1, 1, 1)
end