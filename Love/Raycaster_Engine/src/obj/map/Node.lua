Node = Object:extend()

-- pretend this to be an enum :p
NodeType =
{
    Open = 0,
    Blocked = 1
}

function Node:new(i, j, nodeType)
    self.i = i or -1
    self.j = j or -1
    self.nodeType = nodeType or NodeType.Open

    self.neihgbours = {}
    self.prev = nil
end

function Node:reset()
    self.prev = nil
end

function Node:draw(rect_width, rect_height)
    if(self.nodeType == NodeType.Blocked) then
        --love.graphics.setColor(Color.black)
        --love.graphics.rectangle("fill", self.j * rect_width, self.i * rect_height, rect_width, rect_height)
        love.graphics.setColor(Color.gray)
        love.graphics.rectangle("fill", self.j * rect_width, self.i * rect_height, rect_width, rect_height)
    end
end
