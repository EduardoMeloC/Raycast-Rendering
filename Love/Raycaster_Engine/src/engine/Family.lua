--[[
    a Family is a set of GameObjects
    this set is contained by a scene and is responsible for calling each
    game object's update/draw callbacks
]]

Family = Object:extend()

function Family:new(scene)
    self.scene = scene
    self.game_objects = {}
end

function Family:update(dt)
    for i = #self.game_objects, 1, -1 do
        local game_object = self.game_objects[i]
        game_object:update(dt)
        if game_object.dead then table.remove(self.game_objects, i) end
    end
end

function Family:draw()
    for _, game_object in ipairs(self.game_objects) do game_object:draw() end
end

function Family:addGameObject(game_object_type, x, y, opts)
    local opts = opts or {}
    local game_object = _G[game_object_type](self, x or 0, y or 0, opts)
    table.insert(self.game_objects, game_object)
    return game_object
end
