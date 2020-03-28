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
            self.grid[i][j] = 0--(math.random(1, 10) == 1) and 1 or 0
        end
    end
    for i=0, columns-1 do
        self.grid[i][0] = 1
        self.grid[0][i] = 1
        self.grid[i][columns-1] = 1
        self.grid[columns-1][i] = 1
    end
end
