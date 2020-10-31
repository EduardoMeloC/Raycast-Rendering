Grid_Scene = Scene:extend()
wall_thickness = 1
ray_count = math.floor(Window.width/wall_thickness)

-- function prototype
local render_3D

function Grid_Scene:new()
    --set mouse invisible
    love.mouse.setRelativeMode(true)

    --instantiate objects
    self.miniMap = Family(this)
    self.miniMap.scale = 0.2
    grid = self.miniMap:addGameObject("Graph", Window.width/2, Window.height/2,
                            { mapData = MapData(40, 40)})
    player = self.miniMap:addGameObject("Player", Window.width/2, Window.height/2)

    --bind inputs
    input:bind('w', 'forward')
    input:bind('a', 'left')
    input:bind('s', 'backward')
    input:bind('d', 'right')
end

function Grid_Scene:update(dt)
    self.miniMap:update(dt)
end

function Grid_Scene:draw()
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle("fill", 0, Window.height/2, Window.width, Window.height)
    render_3D()
    self.miniMap:draw()
end

function love.mousemoved(x, y, dx, dy)
    player:mousemoved(x, y, dx, dy)
end

render_3D = function()
    local distanceFromProjectionPlane = (Window.width/2) / math.tan(math.rad(player.FOV/2))
    for i, ray in ipairs(player.rays) do
        local wall_distance = ray.distance * math.cos(math.rad(ray.angle - player.rotation))
        local stripHeight = distanceFromProjectionPlane * grid.rect_height / wall_distance

        local intensity = (wall_distance > 110) and 110 / wall_distance or 1
        local color = (ray.verticalHit and 0.9 or 180/255) * intensity
        love.graphics.setColor(color, color, color, 1)

        love.graphics.rectangle("fill", wall_thickness * i, Window.height/2 - stripHeight/2, wall_thickness, stripHeight)
    end
end
