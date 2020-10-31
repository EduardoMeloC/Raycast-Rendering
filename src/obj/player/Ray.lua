function raycast(x, y, ray_angle)
    -- ray will be a line filled with x1, y1, x2, y2 where x2 and y2 is the hitpoint
    local ray = { x1 = x, y1 = y, x2 = 0, y2 = 0, distance = 0, angle = ray_angle, verticalHit = false}
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

    while(nextHorzTouchX >= 0 and nextHorzTouchX <= Window.width and nextHorzTouchY >= 0 and nextHorzTouchY <= Window.height) do
        if(grid:hasWallAt(nextHorzTouchX, nextHorzTouchY - ((isFacingUp) and 1 or 0))) then
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

    while(nextVertTouchX >= 0 and nextVertTouchX <= Window.width and nextVertTouchY >= 0 and nextVertTouchY <= Window.height) do
        if(grid:hasWallAt(nextVertTouchX - ((isFacingLeft) and 1 or 0), nextVertTouchY)) then
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
    else horzDistance = math.huge end -- math.huge = infinity
    if(foundVertWallHit) then
        vertDistance = distanceFrom(x, y, vertHitX, vertHitY)
    else vertDistance = math.huge end

    if(horzDistance < vertDistance) then
        ray.x2, ray.y2 = horzHitX, horzHitY
        ray.distance = horzDistance
    else
        ray.x2, ray.y2 = vertHitX, vertHitY
        ray.distance = vertDistance
        ray.verticalHit = true
    end

    return ray
end
