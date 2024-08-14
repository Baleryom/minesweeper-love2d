local class = require('libs.middleclass')
local Tile = require('objects.tile')
local utils = require('objects.utils')

local Game = class('Game')

function Game:initialize()
    self.currentBombs = 0
    self.maxBombs = 10
    self.mouseClicked = false
    self.firstClick = true
    self.gameOver = false
    self.grid = {}
    self.gridClicks = {}
    self.gridBombs = {}
    self.bombOffsetSpawing = 30
    love.mouse.setVisible(false)
    self.img = love.graphics.newImage("assets/cursor.png")
    self.font = love.graphics.newFont("assets/Roboto-Black.ttf", 15)
    self.size = 32
    self.width = math.ceil(love.graphics.getWidth() / self.size)
    self.height = math.ceil(love.graphics.getHeight() / self.size)
    self:initializeGrid()
end

function Game:initializeGrid()
    for col = 0, self.width do
        self.grid[col] = {}
        for row = 0, self.height do
            self.grid[col][row] = Tile:new(col, row, (self.width * self.size) / 10)
        end
    end
end

function Game:distanceBetweenNeighboursAndBombs(x, y)
    for _, bomb in ipairs(self.gridBombs) do
        for col = x - 1 - self.bombOffsetSpawing, x + 1 + self.bombOffsetSpawing do
            for row = y - 1 - self.bombOffsetSpawing, y + 1 + self.bombOffsetSpawing do
                if (col ~= x or row ~= y) and col >= 0 and col <= self.width and row >= 0 and row < self.height then
                    if self.currentBombs <= self.maxBombs then
                        local tile = self.grid[col][row]
                        if not tile:isBomb() then
                            local distance = utils.manhattan_distance(bomb.x, bomb.y, col, row)
                            if distance < tile.distance then
                                tile.distance = distance
                            end
                        else
                            tile.distance = 1
                        end
                    end
                end
            end
        end
    end
end

function Game:checkAdjacency(x,y)
    for _, click in ipairs(self.gridClicks) do
        if utils.checkAdjacency(self.grid, click.x, click.y, x, y) then 
            return true
        end
    end
    return false
end

function Game:tileClicked(x, y)
    local tile = self.grid[x][y]
    if not self.firstClick then 
        if tile:isClicked() then
            print("Previously clicked")
            return
        end
        if tile:isBomb() then
            print("Clicked on the bomb")
            self.gameOver = true
        end
        
        if not self:checkAdjacency(x, y) then
            print("Click on neighbouring tiles")
            return
        end
    end
    print("Tile Clicked " .. x .. " " .. y)
    self.firstClick = false
    table.insert(self.gridClicks, self.grid[x][y])

    for col = x - 1, x + 1 do
        for row = y - 1, y + 1 do
            if (col ~= x or row ~= y) and col >= 0 and col <= self.width and row >= 0 and row < self.height then
                print(col,row)
                if self.currentBombs <= self.maxBombs then
                    local neighborTile = self.grid[col][row]
                    if love.math.random(1, 100) > 80 and not neighborTile:isBomb() and not neighborTile:isClicked() and not neighborTile:isNeighbor() then
                        neighborTile:setBomb()
                        table.insert(self.gridBombs, neighborTile)
                        self.currentBombs = self.currentBombs + 1
                    end
                end
                self.grid[col][row]:setNeighbor()
            end
        end
    end
    self:distanceBetweenNeighboursAndBombs(x,y)
    tile:setClicked()
end

function Game:update(dt)
    self.mx, self.my = love.mouse.getPosition()
    if self.mouseClicked then
        local gridX = math.floor(self.mx / self.size)
        local gridY = math.floor(self.my / self.size)
        if gridX >= 0 and gridX <= self.width and gridY >= 0 and gridY <= self.height then
            self:tileClicked(gridX, gridY)
        end
        self.mouseClicked = false
    end
end

function Game:draw()
    for x = 0, self.width do
        for y = 0, self.height do
            self.grid[x][y]:draw(x, y, self.size, self.mx, self.my)
        end
    end
    love.graphics.draw(self.img, self.mx, self.my)
end

function Game:mousepressed(x, y, button)
    if self.gameOver then
        return
    end
    if button == 1 then 
        self.mouseClicked = true
    end
end

return Game