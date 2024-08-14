local class = require('libs.middleclass')
local colors = require('libs.colors')
local utils = require('objects.utils')

local Tile = class('Tile')

function Tile:initialize(x, y, initialDistance)
    self.x = x
    self.y = y
    self.clicked = false
    self.neighbor = false
    self.bomb = false
    self.distance = initialDistance
end

function Tile:isClicked() return self.clicked end
function Tile:isNeighbor() return self.neighbor end
function Tile:isBomb() return self.bomb end

function Tile:setClicked() self.clicked = true end
function Tile:setNeighbor() self.neighbor = true end
function Tile:setBomb() self.bomb = true end

function Tile:draw(x, y, size, mx, my)
    love.graphics.setColor(love.math.colorFromBytes(colors.almost_black[1], colors.almost_black[2], colors.almost_black[3]))
    love.graphics.print(mx .. ' ' .. my, 20, 20)
    love.graphics.setColor(love.math.colorFromBytes(colors.grey_teal[1], colors.grey_teal[2], colors.grey_teal[3]))
    love.graphics.rectangle("line", x*size, y*size, size, size)
    love.graphics.setColor(love.math.colorFromBytes(colors.greyish_pink[1], colors.greyish_pink[2], colors.greyish_pink[3]))
    love.graphics.rectangle("fill", x*size, y*size, size, size)
    
    if self.clicked then
        love.graphics.setColor(love.math.colorFromBytes(colors.red_brown[1], colors.red_brown[2], colors.red_brown[3]))
        love.graphics.rectangle("fill", x*size, y*size, size, size)
        if self.bomb then
            love.graphics.setColor(love.math.colorFromBytes(colors.almost_black[1], colors.almost_black[2], colors.almost_black[3]))
            love.graphics.rectangle("fill", x*size, y*size, size, size)
            love.graphics.setColor(love.math.colorFromBytes(colors.off_white[1], colors.off_white[2], colors.off_white[3]))
            utils.drawCenteredText(x*size + size / 2, y*size + size/2, size, size, "Boom")
        end
    elseif self.neighbor then
        love.graphics.setColor(love.math.colorFromBytes(colors.green_apple[1], colors.green_apple[2], colors.green_apple[3]))
        love.graphics.rectangle("fill", x*size, y*size, size, size)
        love.graphics.setColor(love.math.colorFromBytes(colors.almost_black[1], colors.almost_black[2], colors.almost_black[3]))
        utils.drawCenteredText(x*size + size / 2, y*size + size/2, size, size, self.distance)
    end
    
    if x == math.floor(mx / size) and y == math.floor(my / size) then
        love.graphics.setColor(love.math.colorFromBytes(colors.red_brown[1], colors.red_brown[2], colors.red_brown[3]))
        love.graphics.rectangle("fill", x*size, y*size, size, size)
    end
end

return Tile