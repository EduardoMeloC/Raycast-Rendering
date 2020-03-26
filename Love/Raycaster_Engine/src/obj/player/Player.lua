Player = GameObject:extend()
local ray_range = 300
local wall_thickness = 10
local ray_count = Window.width/wall_thickness

-- function prototype
local raycast
local castAllRays

function Player:new(family, x, y, opts)
    Player.super.new(self, family, x, y, opts)

    self.size = 3 -- size is actually a radius
    self.speed = 1
    self.rotation = 0

    self.FOV = 60
    self.mouse_sensitivity = 0.1

    self.rays = {}
end

function Player:mousemoved(x, y, dx, dy)
    self.rotation = self.rotation - dx * self.mouse_sensitivity
end

function Player:update(dt)
    -- player movement
    local axisX = input:down('left') and -1 or input:down('right') and 1 or 0
    local axisY = input:down('backward') and -1 or input:down('forward') and 1 or 0
    local th = math.rad(self.rotation) -- th stands for theta angle
    local nextX = self.x + math.cos(th) * (axisY) * self.speed + math.cos(th - math.pi/2) * (axisX) * self.speed
    local nextY = self.y - math.sin(th) * (axisY) * self.speed - math.sin(th - math.pi/2) * (axisX) * self.speed

    -- collision detection
    local collidedX = false
    local collidedY = false
    local currentNode = grid:getNodeAt(self.x, self.y)
    for i=currentNode.i-1, currentNode.i+1 do -- collision is tested on surrounding nodes
        for j=currentNode.j-1, currentNode.j+1 do
            local node = grid.nodes[i][j]
            if (node.nodeType == NodeType.Blocked) then
                print(node.i .. " " .. node.j)
                if(self:checkCollision(node, nextX, self.y)) then
                    collidedX = true
                end
                if(self:checkCollision(node, self.x, nextY)) then
                    collidedY = true
                end
            end
        end
    end
    if not collidedX then self.x = nextX end
    if not collidedY then self.y = nextY end

    --cast rays
    self.rays = castAllRays()
    print(self.rays)

end

function Player:draw(dt)
    -- draws player shape
    love.graphics.setColor(Color.red)
    love.graphics.circle("fill", self.x, self.y, self.size-2)
    love.graphics.rectangle("line", self.x - self.size, self.y - self.size, self.size*2, self.size*2)

    --draws player rays
    love.graphics.setColor(1, 0, 0, 0.1)
    for _, ray in ipairs(self.rays) do
        love.graphics.line(ray.x1, ray.y1, ray.x2, ray.y2)
    end
end

function Player:checkCollision(other, posX, posY)
    -- this is a circle/rect collision detection, where:
    -- player is a circle
    -- other is a rect
    local posX = posX or self.x
    local posY = posY or self.y

    local testX = posX
    local testY = posY

    local otherX = other.j * grid.rect_width
    local otherY = other.i * grid.rect_height
    local otherW = grid.rect_width
    local otherH = grid.rect_height

    if(posX < otherX) then testX = otherX                           -- left
    elseif(posX > otherX + otherW) then testX = otherX + otherW end -- right
    if(posY < otherY) then testY = otherY                           -- top
    elseif(posY > otherY + otherW) then testY = otherY + otherH end -- bottom

    local distX = posX - testX
    local distY = posY - testY
    local distance = math.sqrt((distX * distX) + (distY * distY))

    if (distance <= self.size) then return true end
    return false
end

castAllRays = function()
    local rays = {}
    local ray_angle = player.rotation - (player.FOV/2)
    local ray_step = player.FOV / ray_count

    for i=0, ray_count do
        ray = raycast(player.x, player.y, ray_angle, ray_range)
        rays[i] = ray
        ray_angle = ray_angle + ray_step
    end
    return rays
end

raycast = function(x, y, ray_angle, ray_distance)
    -- ray will be a line filled with x1, y1, x2, y2
    local ray = { x1 = x, y1 = y }
    local th = math.rad(ray_angle)
    ray.x2 = x + math.cos(th) * ray_distance
    ray.y2 = y - math.sin(th) * ray_distance
    return ray
end
