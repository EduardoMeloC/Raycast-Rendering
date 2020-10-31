Circle = Object:extend()

function Circle:new(x, y, radius, color)
    self.x, self.y = x, y

    self.radius = radius or 3
    self.color = color or {1, 1, 1}
end

function Circle:update(dt)
end

function Circle:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, self.radius)
end
