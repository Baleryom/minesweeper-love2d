local utils = {}

function utils.manhattan_distance(x1, y1, x2, y2)
    return math.abs(x2 - x1) + math.abs(y2 - y1)
end

function utils.drawCenteredText(rectX, rectY, rectWidth, rectHeight, text)
    local font = love.graphics.getFont()
    local textWidth = font:getWidth(text)
    local textHeight = font:getHeight()
    love.graphics.print(text, rectX, rectY, 0, 1, 1, textWidth/2, textHeight/2)
end

function utils.checkAdjacency(grid, clickI, clickJ, tileX, tileY)
    local rows = #grid
    local cols = #grid[1]
    local neighbors = {}
    local directions = {
        {-1, 0},  -- Up
        {1, 0},   -- Down
        {0, -1},  -- Left
        {0, 1},   -- Right
        {-1, -1}, -- Top-left
        {-1, 1},  -- Top-right
        {1, -1},  -- Bottom-left
        {1, 1}    -- Bottom-right
    }

    for _, dir in ipairs(directions) do
        local ni, nj = clickI + dir[1], clickJ + dir[2]
        if ni >= 1 and ni <= rows and nj >= 1 and nj <= cols then
            --table.insert(neighbors, grid[ni][nj])
            if ni == tileX and nj == tileY then 
                return true
            end
        end
    end

    return false
end

return utils