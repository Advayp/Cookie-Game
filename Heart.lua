Heart = Class{}

function Heart:init(x)
    self.x = x
    self.norm = love.graphics.newImage('images/normal-heart.png')
    self.loss = love.graphics.newImage('images/gray-heart.png')
    self.state = 'norm'
end

function Heart:draw()
    if self.state == 'norm' then
        love.graphics.draw(self.norm, self.x, 0)
    else
        love.graphics.draw(self.loss, self.x, 0)
    end
end