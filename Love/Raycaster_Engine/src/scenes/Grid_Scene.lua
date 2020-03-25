Grid_Scene = Scene:extend()

function Grid_Scene:new()
    --set mouse invisible
    love.mouse.setRelativeMode(true)

    --instantiate objects
    self.family = Family(this)
    grid = self.family:addGameObject("Graph", Window.width/2, Window.height/2,
                            { mapData = MapData(40, 40)})
    player = self.family:addGameObject("Player", Window.width/2, Window.height/2)

    --bind inputs
    input:bind('w', 'forward')
    input:bind('a', 'left')
    input:bind('s', 'backward')
    input:bind('d', 'right')
end

function Grid_Scene:update(dt)
    self.family:update(dt)
end

function Grid_Scene:draw()
    self.family:draw()
end

function love.mousemoved(x, y, dx, dy)
    player:mousemoved(x, y, dx, dy)
end
