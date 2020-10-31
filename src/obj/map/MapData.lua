--[[
    MapData contains a grid, an matrix filled with 0's and 1's
    This data is used by Graph.lua and each cell is turned into a node
]]

MapData = Object:extend()

function MapData:new(rows, columns)
    self.rows = rows
    self.columns = columns
    self.grid = {}
    for i=0, columns-1 do
        self.grid[i] = {}
        for j=0, rows-1 do
            self.grid[i][j] = 0
        end
    end
    for i=0, columns-1 do
        self.grid[i][0] = 1
        self.grid[0][i] = 1
        self.grid[i][columns-1] = 1
        self.grid[rows-1][i] = 1
    end

    -- generate horizontal stripes
    for n=1, 15 do
        local i = math.random(2, columns-1)
        for j=1, rows-1 do
            self.grid[i][j] = ((math.random(1, 10) == 1) and 0 or 1)
        end
    end
    for n=1, 6 do
        local i = math.random(2, columns-1)
        for j=1, rows-1 do
            self.grid[i][j] = ((math.random(1, 10) == 1) and 1 or 0)
        end
    end
    --generate vertical stripes
    for n=1, 15 do
        local j = math.random(2, rows-1)
        for i=1, columns-1 do
            self.grid[i][j] = ((math.random(1, 10) == 1) and 0 or 1)
        end
    end
    for n=1, 6 do
        local j = math.random(2, rows-1)
        for i=1, columns-1 do
            self.grid[i][j] = ((math.random(1, 10) == 1) and 1 or 0)
        end
    end
    self.grid[math.floor(rows/2)][math.floor(columns/2)] = 0
    self.grid[math.floor(rows/2)+1][math.floor(columns/2)+1] = 0
    self.grid[math.floor(rows/2)-1][math.floor(columns/2)-1] = 0
    self.grid[math.floor(rows/2)-1][math.floor(columns/2)] = 0
    self.grid[math.floor(rows/2)+1][math.floor(columns/2)+1] = 0

    for i=0, columns-1 do
        self.grid[i][0] = 1
        self.grid[0][i] = 1
        self.grid[i][columns-1] = 1
        self.grid[rows-1][i] = 1
    end
end
