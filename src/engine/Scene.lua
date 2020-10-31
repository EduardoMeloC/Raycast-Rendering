--[[
    https://github.com/adnzzzzZ/blog/issues/17

    A Scene contains GameObjects and Families
    it is responsible for calling each of these object's updates

    Essentialy, a Scene is just an object
    I'll be defining a global Scene just for the sake of avoiding confusion
    This way, you can create a Scene by MyScene = Scene:extend()
    and actual objects are created by MyObject = Object:extend()
]]

Scene = Object:extend()


--[[
    This instantiates a scene whenever you want to go to one
    which means data will not be saved and previous scenes will be garbage
    collected.
]]
function gotoScene(scene_type, ...)
    current_scene = _G[scene_type](...)
end

--[[
    main.lua should look something like this:

    function love.load()
        current_scene = nil
    end

    function love.update(dt)
        if current_scene then current_scene:update(dt) end
    end

    function love.draw()
        if current_scene then current_scene:draw() end
    end
]]

--[[
    However, if you're looking for data persistency when changing scenes,
    you should have your code like this:

    function love.load()
        scenes = {}
        current_scene = nil
    end

    function love.update(dt)
        if current_scene then current_scene:update(dt) end
    end

    function love.draw()
        if current_scene then current_scene:draw() end
    end

    function addScene(scene_type, scene_name, ...)
        local scene = _G[scene_type](scene_name, ...)
        scenes[scene_name] = scene
        return scene
    end

    function gotoScene(scene_type, scene_name, ...)
        if current_scene and scenes[scene_name] then
            if current_scene.deactivate then current_scene:deactivate() end
            current_scene = scenes[scene_name]
            if current_scene.activate then current_scene:activate() end
        else current_scene = addScene(scene_type, scene_name, ...) end
    end
]]
