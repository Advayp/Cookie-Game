Collidable = Class{}

function Collidable:init(image, dy)
    self.x = math.random(20, VIRTUAL_WIDTH - 30)
    self.y = math.random(5, 30)
    
    self.image = image

    self.dy = dy
end

function Collidable:collides(player)
    if self.x + self.image:getWidth() / 2 > player.x - 14 and self.x + self.image:getWidth() / 2 < player.x + player.img:getWidth() + 14 and 
        self.y < player.y + player.img:getHeight() / 2 and self.y > player.y then

        return true
    end

    return false
end

function Collidable:update(dt, scoreValue)

    self.y = self.y + self.dy * dt

    if self.y > VIRTUAL_HEIGHT then
        self.y = math.random(5, 30)
        self.x = math.random(20, VIRTUAL_WIDTH - 30)
        score = math.max(0, score + scoreValue)
    end
end

function Collidable:reset()
    self.x = math.random(20, VIRTUAL_WIDTH - 30)
    self.y = math.random(5, 30)
end


function Collidable:draw()
    love.graphics.draw(self.image, math.floor(self.x), math.floor(self.y))
end
