--[[
Ray = Object:extend()

function Ray:new(x, y, ray_angle, ray_distance)
    self.x, self.y = x, y
    self.ray_angle = normalize_angle(ray_angle)
    self.hitX = 0
    self.hitY = 0
    self.distance = 0

    self.isFacingDown = ray_angle > 0 and ray_angle < math.pi
    self.isFacingUp = ~self.isFacingDown
    self.isFacingRight = ray_angle < 0.5 * math.pi or ray_angle > 1.5 * math.pi
    self.isFacingLeft = ~self.isFacingRight
end

function Ray:cast(columnId)
    local xintercept, yintercept
    local xstep, ystep
    local th = math.rad(self.ray_angle)
    -------------------------------------------
    -- HORIZONTAL RAY-GRID INTERSECTION CODE --
    -------------------------------------------
    local foundHorzWallHit = false

    -- first intercept
    yintercept = math.floor(self.y / grid.rect_height) * grid.rect_height
    if self.isFacingDown then yintercept = yintercept + grid.rect_height end
    xintercept = self.x + (yintercept - self.y) / math.tan(th)

    -- calculater increment xstep and ystep
    ystep = grid.rect_height
    ystep = ystep * (self.isFacingUp) and -1 or 1

    xstep = ystep / math.tan(th)
    xstep = xstep * (self.isFacingLeft and xstep > 0) and -1 or 1
    xstep = xstep * (self.isFacingRight and xstep < 0) and -1 or 1

    local nextHorzTouchX = xintercept
    local nextHorzTouchY = yintercept

    if(self.isFacingUp) then nextHorzTouchY = nextHorzTouchY - 1 end

    while(nextHorzTouchX >= 0 and nextHorzTouchX <= Window.width and nextHorzTouchY > 0 and nextHorzTouchY < Window.height) do
        if(grid:hasWallAt(nextHorzTouchX, nextHorzTouchY)) then
            foundHorzWallHit = true
            self.hitX, self.hitY = nextHorzTouchX, nextHorzTouchY
            break
        else
            nextHorzTouchX = nextHorzTouchX + xstep
            nextHorzTouchY = nextHorzTouchY + ystep
        end
    end
]]
