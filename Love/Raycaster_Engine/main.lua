require 'src.engine.GameLoop'
Object = require 'src.lib.classic'
Input = require 'src.lib.Input'
Timer = require 'src.lib.enhanced_timer.EnhancedTimer'
M = require 'src.lib.moses'

function love.load()

    -- Initialize Input lib
    input = Input()

    -- Initialize hump lib timer
    timer = Timer()

    -- Require other files
    local object_files = {}
    recursiveEnumerate('src', object_files)
    requireFiles(object_files)

    -- Initialize Window
    love.window.setMode(Window.width, Window.height, Window.flags)

    -- set current scene
    setScene("Grid_Scene")
end

function love.update(dt)
    -- libs update
    timer:update(dt)

    -- scene update
    if current_scene then current_scene:update(dt) end
end

function love.draw()
    -- draw scene
    if current_scene then current_scene:draw() end
    love.graphics.setColor(Color.white)
    love.graphics.print(love.timer.getFPS(), Window.width - 30, 10)
end

function setScene(scene_type, ...)
    current_scene = _G[scene_type](...)
end

----------------- Files Utilities -----------------------
function recursiveEnumerate(folder, file_list)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder .. '/' .. item
        if love.filesystem.getInfo(file, "file") then
            table.insert(file_list, file)
        elseif love.filesystem.getInfo(file, "directory") then
            recursiveEnumerate(file, file_list)
        end
    end
end

function requireFiles(files)
    for _, file in ipairs(files) do
        local file = file:sub(1, -5)
        require(file)
    end
end
