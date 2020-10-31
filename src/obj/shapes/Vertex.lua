Vertex = Object:extend()

function Vertex:new(x, y)
    self.x = x
    self.y = y
end

function Vertex:draw(radius)
    local radius = radius or 3
    love.graphics.circle("fill", self.x, self.y, radius)
end
