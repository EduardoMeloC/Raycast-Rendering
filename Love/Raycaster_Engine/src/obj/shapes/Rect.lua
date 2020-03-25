-- Exercise 6 --
Rect = Object:extend()

function Rect:new(x, y, w, h, color)
    self.x = x;
    self.y = y;
    self.w = w;
    self.h = h
    self.color = color or {1, 1, 1}
    self.creation_time = love.timer.getTime()
end

function Rect:update(dt)

end

function Rect:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x - self.w/2, self.y - self.h/2, self.w, self.h)
end
