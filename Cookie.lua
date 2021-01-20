Cookie = Class{}

function Cookie:init()
    self.x = math.random(20, VIRTUAL_WIDTH - 30)
    self.y = math.random(5, 30)
    
    self.image = love.graphics.newImage('images/cookie.png')

    self.dy = 50
end

function Cookie:collides(player)
    if self.x + self.image:getWidth() / 2 > player.x - 14 and self.x + self.image:getWidth() / 2 < player.x + player.img:getWidth() + 14 and self.y < player.y + player.img:getHeight() / 2 and self.y > player.y then
        return true
    end

    return false
end

function Cookie:update(dt)

    self.y = self.y + self.dy * dt

    if self.y > VIRTUAL_HEIGHT then
        self.y = math.random(5, 30)
        self.x = math.random(20, VIRTUAL_WIDTH - 30)
    end
end



function Cookie:draw()
    love.graphics.draw(self.image, math.floor(self.x), math.floor(self.y))
end
