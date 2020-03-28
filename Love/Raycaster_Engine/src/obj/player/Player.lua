
Player = GameObject:extend()
local ray_range = 300
local wall_thickness = 1
local ray_count = math.floor(Window.width/wall_thickness)

-- function prototype
local raycast

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
    self.rotation = (self.rotation - dx * self.mouse_sensitivity) % 360
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
    self:castAllRays()
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

    love.graphics.setColor(Color.white)
    --love.graphics.line(self.x, self.y, self.x + math.cos(math.rad(self.rotation)) * 1000, self.y - math.sin(math.rad(self.rotation)) * 1000)
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

function Player:castAllRays()
    local rays = self.rays
    local ray_angle = self.rotation - (self.FOV/2)

    local ray_step = self.FOV / ray_count

    for i=1, ray_count do
        ray = raycast(self.x, self.y, ray_angle)
        rays[i] = ray
        ray_angle = ray_angle + ray_step
    end
end

raycast = function(x, y, ray_angle)
    -- ray will be a line filled with x1, y1, x2, y2 where x2 and y2 is the hitpoint
    local ray = { x1 = x, y1 = y, x2 = 0, y2 = 0, distance = 0, verticalHit = false}
    local ray_angle = ray_angle % 360

    local isFacingUp = ray_angle > 0 and ray_angle < 180
    local isFacingDown = not isFacingUp
    local isFacingRight = ray_angle < 90 or ray_angle > 270
    local isFacingLeft = not isFacingRight

    local xintercept, yintercept
    local xstep, ystep
    local th = math.rad(ray_angle)

    --[[
    print("isFacingUp:\t" .. (isFacingUp and "true" or "false"))
    print("isFacingDown:\t" .. (isFacingDown and "true" or "false"))
    print("isFacingRight:\t" .. (isFacingRight and "true" or "false"))
    print("isFacingLeft:\t" .. (isFacingLeft and "true" or "false"))
    print("\n")
    ]]

    -------------------------------------------
    -- HORIZONTAL RAY-GRID INTERSECTION CODE --
    -------------------------------------------
    local foundHorzWallHit = false
    local horzHitX, horzHitY

    -- first intercept
    yintercept = math.floor(y / grid.rect_height) * grid.rect_height
    if isFacingDown then yintercept = yintercept + grid.rect_height end
    xintercept = x + ((y - yintercept) / math.tan(th))

    -- calculate increment xstep and ystep
    ystep = grid.rect_height
    ystep = ystep * (isFacingUp and -1 or 1)

    xstep = grid.rect_width / math.tan(th)
    xstep = xstep * ((isFacingLeft and xstep > 0) and -1 or 1)
    xstep = xstep * ((isFacingRight and xstep < 0) and -1 or 1)

    local nextHorzTouchX = xintercept
    local nextHorzTouchY = yintercept

    if(isFacingUp) then nextHorzTouchY = nextHorzTouchY - 0.000001 end

    while(nextHorzTouchX >= 0 and nextHorzTouchX <= Window.width and nextHorzTouchY >= 0 and nextHorzTouchY <= Window.height) do
        if(grid:hasWallAt(nextHorzTouchX, nextHorzTouchY)) then
            foundHorzWallHit = true
            break
        else
            nextHorzTouchX = nextHorzTouchX + xstep
            nextHorzTouchY = nextHorzTouchY + ystep
        end
    end
    horzHitX, horzHitY = nextHorzTouchX, nextHorzTouchY

    -------------------------------------------
    -- VERTICAL RAY-GRID INTERSECTION CODE --
    -------------------------------------------
    local foundVertWallHit = false
    local vertHitX, vertHitY

    -- first intercept
    xintercept = math.floor(x / grid.rect_width) * grid.rect_width
    if isFacingRight then xintercept = xintercept + grid.rect_width end
    yintercept = y + ((x - xintercept) * math.tan(th))

    -- calculate increment xstep and ystep
    xstep = grid.rect_width
    xstep = xstep * (isFacingLeft and -1 or 1)

    ystep = grid.rect_height * math.tan(th)
    ystep = ystep * ((isFacingUp and ystep > 0) and -1 or 1)
    ystep = ystep * ((isFacingDown and ystep < 0) and -1 or 1)

    local nextVertTouchX = xintercept
    local nextVertTouchY = yintercept

    if(isFacingLeft) then nextVertTouchX = nextVertTouchX - 0.000001 end

    while(nextVertTouchX >= 0 and nextVertTouchX <= Window.width and nextVertTouchY >= 0 and nextVertTouchY <= Window.height) do
        if(grid:hasWallAt(nextVertTouchX, nextVertTouchY)) then
            foundVertWallHit = true
            break
        else
            nextVertTouchX = nextVertTouchX + xstep
            nextVertTouchY = nextVertTouchY + ystep
        end
    end
    vertHitX, vertHitY = nextVertTouchX, nextVertTouchY

    -- calculate horizontal and vertical distances and choose smallest
    local horzDistance, vertDistance

    if(foundHorzWallHit) then
        horzDistance = distanceFrom(x, y, horzHitX, horzHitY)
    else horzDistance = 99999999 end--math.huge = infinity
    if(foundVertWallHit) then
        vertDistance = distanceFrom(x, y, vertHitX, vertHitY)
    else vertDistance = 99999999 end

    if(horzDistance < vertDistance) then
        ray.x2, ray.y2 = horzHitX, horzHitY
        ray.distance = horzDistance
    else
        ray.x2, ray.y2 = vertHitX, vertHitY
        ray.distance = vertDistance
        ray.verticalHit = true
    end
        --ray.x2, ray.y2 = horzHitX, horzHitY
        --ray.x2, ray.y2 = vertHitX, vertHitY


    return ray
end
