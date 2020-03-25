Grid_Scene = Scene:extend()

function Grid_Scene:new()
    self.family = Family(this)
    self.family:addGameObject("Graph", Window.width/2, Window.height/2,
                            { mapData = MapData(40, 40)})
end

function Grid_Scene:update(dt)
    self.family:update(dt)
end

function Grid_Scene:draw()
    self.family:draw()
end
