Polygon = Object:extend()

--[[
    Polygon can be created as
    Polygon({100, 200, 200, 200, 150, 150})
    or as
    Polygon({Vertex(100, 200), Vertex(200, 200), Vertex(150, 150)})
]]

-- function prototype
local calculateCentroid

function Polygon:new(vertices, color)
    if(type(vertices[1]) == "table") then
            self.vertices = vertices
            self.raw_vertices = {}
        for i=0, #arg-1 do
            self.raw_vertices[i*2 + 1] = vertices[i + 1].x
            self.raw_vertices[i*2 + 2] = vertices[i + 1].y
        end
    else
        self.raw_vertices = vertices
        self.vertices = {}
        for i=1, #vertices, 2 do
            self.vertices[math.floor(i/2)+1] = Vertex(vertices[i], vertices[i+1])
        end
    end

    self.centroid = calculateCentroid(self.vertices)
    self.color = color or {1, 1, 1}
    self.creation_time = love.timer.getTime()
end

function Polygon:draw()
    love.graphics.setColor(self.color)
    love.graphics.polygon("fill", self.raw_vertices)
end

function Polygon:setPos(x, y)
    local offsetX = x - self.centroid.x
    local offsetY = y - self.centroid.y
    for i, v in ipairs(self.raw_vertices) do
        if(i%2 == 1) then self.raw_vertices[i] = v + offsetX
        else self.raw_vertices[i] = v + offsetY end
    end
    self.centroid.x = x
    self.centroid.y = y
end

calculateCentroid = function(vertices)
    --https://stackoverflow.com/questions/2792443/finding-the-centroid-of-a-polygon
    local x0, y0, x1, y1, a, signedArea, centroidX, centroidY = 0, 0, 0, 0, 0, 0, 0, 0
    for i=1, #vertices-1 do
        x0 = vertices[i].x
        y0 = vertices[i].y
        x1 = vertices[i+1].x
        y1 = vertices[i+1].y
        a = x0*y1 - x1*y0
        signedArea = signedArea + a
        centroidX = centroidX + (x0 + x1) * a
        centroidY = centroidY + (y0 + y1) * a
    end
    x0 = vertices[#vertices].x
    y0 = vertices[#vertices].y
    x1 = vertices[1].x
    y1 = vertices[1].y
    a = x0*y1 - x1*y0
    signedArea = signedArea + a
    centroidX = centroidX + (x0 + x1) * a
    centroidY = centroidY + (y0 + y1) * a

    signedArea = signedArea/2
    centroidX = centroidX / (6 * signedArea)
    centroidY = centroidY / (6 * signedArea)

    return Vertex(centroidX, centroidY)
end
