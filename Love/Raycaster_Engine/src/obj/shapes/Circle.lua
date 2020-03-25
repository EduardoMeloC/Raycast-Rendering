Circle = GameObject:extend()

function Circle:new(family, x, y, opts)
    Circle.super.new(self, family, x, y, opts)

    self.radius = opts.radius or 3
end

function Circle:update(dt)
end

function Circle:draw()
    love.graphics.circle("fill", self.x, self.y, self.radius)
end
