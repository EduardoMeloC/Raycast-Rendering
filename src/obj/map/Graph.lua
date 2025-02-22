Graph = GameObject:extend()

function Graph:new(family, x, y, opts)
    Graph.super.new(self, family, x, y, opts)
    local mapData = opts.mapData

    self.mapData = mapData
    self.rows = mapData.rows
    self.columns = mapData.columns
    self.rect_width = Window.width/self.columns
    self.rect_height = Window.height/self.rows

    self.wallNodes = {}
    self.nodes = {}
    for i=0, mapData.columns-1 do
        self.nodes[i] = {}
        for j=0, mapData.rows-1 do
            local type = mapData.grid[i][j]
            local newNode = Node(i, j, type)
            self.nodes[i][j] = newNode
            if(type == NodeType.Blocked) then
                table.insert(self.wallNodes, newNode)
            end
        end
    end
end

function Graph:draw()
    local scale = self.family.scale
    for i=0, self.columns-1 do
        for j=0, self.rows-1 do
            self.nodes[i][j]:draw(self.rect_width * scale, self.rect_height * scale)
        end
    end
end

function Graph:update(dt)
    --[[
        if(love.mouse.isDown(1)) then
            local i = math.floor(love.mouse.getY()/self.rect_height)
            local j = math.floor(love.mouse.getX()/self.rect_width)
            self.mapData.grid[i][j] = NodeType.Blocked
            self.nodes[i][j].nodeType =  NodeType.Blocked
        elseif(love.mouse.isDown(2)) then
            local i = math.floor(love.mouse.getY()/self.rect_height)
            local j = math.floor(love.mouse.getX()/self.rect_width)
            self.mapData.grid[i][j] = NodeType.Open
            self.nodes[i][j].nodeType =  NodeType.Open
        end
    ]]
end

function Graph:getNodeAt(posX, posY)
    -- this function returns the node by the given position (not index)
    return self.nodes[math.floor(posY/self.rect_height)][math.floor(posX/self.rect_width)]
end

function Graph:hasWallAt(posX, posY)
    if (posX < 0 or posX > Window.width or posY < 0 or posY > Window.width) then return true end
    return self:getNodeAt(posX, posY).nodeType == NodeType.Blocked
end
