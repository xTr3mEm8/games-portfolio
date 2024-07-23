--[[
    GD50
    Match-3 Remake

    -- Board Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Board represents the grid of Tiles where the player seeks matching sets of three
    tiles horizontally or vertically.
]]

Board = Class{}

function Board:init(x, y, level)
    self.x = x
    self.y = y
    self.level = level
    self.matches = {}

    self:initializeTiles()
end

function Board:initializeTiles()
    self.tiles = {}

    self.baseColors = {}

    local numTypes = MIN_NUM_TILES_TYPES + self.level

    local onlyColor = numTypes <= 18 -- Only distinct colors when level is 18 or lower

    for i = 1, numTypes do
        local newColor = {
            color = math.random(18),
            variety = math.min(math.random(1, self.level), 6)
        }
        while self:contains(newColor, onlyColor) do
            newColor = {
                color = math.random(18),
                variety = math.min(math.random(1, self.level), 6)
            }
        end
        table.insert(self.baseColors, newColor);
    end

    for tileY = 1, 8 do
        
        -- Initialize a new row
        table.insert(self.tiles, {})

        for tileX = 1, 8 do
            local baseColor = self.baseColors[math.random(#self.baseColors)]
            -- Create a new tile at position X, Y with a random color and variety
            table.insert(self.tiles[tileY], Tile(tileX, tileY, baseColor.color, baseColor.variety))
        end
    end

    local m = self:calculateMatches()
    if m then
        -- Reinitialize if matches were found to ensure a matchless board at the start
        self:initializeTiles()
    elseif m == false then
        self:possibleMoves()
    end
end

function Board:contains(baseColor, onlyColor)
    for i=1, #self.baseColors do
       if (self.baseColors.color == baseColor.color and onlyColor) or (self.baseColors.color == baseColor.color and self.baseColors.variety == baseColor.variety) then 
          return true
       end
    end
    return false
end

function Board:possibleMoves()
    local tiles = {} -- Track movable tiles for highlighting
    for y = 1, 8 do
        for x = 1, 8 do
            -- Attempt horizontal swap
            if x < 8 then
                local newX = x + 1;
                self:swapTiles(self.tiles[y][x], self.tiles[y][newX])
                if self:calculateMatches() then
                    table.insert(tiles, self.tiles[y][newX])
                end
                self:swapTiles(self.tiles[y][x], self.tiles[y][newX])
            end
            -- Attempt vertical swap
            if y < 8 then
                local newY = y + 1;
                self:swapTiles(self.tiles[y][x], self.tiles[newY][x])
                if self:calculateMatches() then
                    table.insert(tiles, self.tiles[newY][x])
                end
                self:swapTiles(self.tiles[y][x], self.tiles[newY][x])
            end
        end
    end
    print("Possible Moves:" .. #tiles);
    if(#tiles > 0) then
        print("X:" .. (tiles[1].x/32+1) .. " Y:" .. (tiles[1].y/32+1))
    end
    return #tiles > 0 and tiles or false
end

function Board:shuffleH()
    local tweens = {}
    local swapped = {}
    -- Shuffle by row
    for y = 1, 8 do
        local x = math.random(4)
        local j = math.random(5, 8)

        self:swapTiles(self.tiles[y][x], self.tiles[y][j])
        
        tweens[self.tiles[y][x]] = {x = self.tiles[y][j].x, y = self.tiles[y][j].y}
        tweens[self.tiles[y][j]] = {x = self.tiles[y][x].x, y = self.tiles[y][x].y}
    end
    return tweens
end

function Board:shuffleV()
    local tweens = {}
    local swapped = {}
    -- Shuffle by column
    for x = 1, 8 do
        local y = math.random(4)
        local j = math.random(5, 8)

        self:swapTiles(self.tiles[y][x], self.tiles[j][x])
        
        tweens[self.tiles[y][x]] = {x = self.tiles[j][x].x, y = self.tiles[j][x].y}
        tweens[self.tiles[j][x]] = {x = self.tiles[y][x].x, y = self.tiles[y][x].y}
    end
    return tweens
end

function Board:calculateMatches()
    local matches = {}

    local matchNum = 1

    -- Horizontal matches
    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color

        matchNum = 1
        
        for x = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color

                if matchNum >= 3 then
                    local match = {}
                    local lineExplosion = false
                    for x2 = x - 1, x - matchNum, -1 do
                        table.insert(match, self.tiles[y][x2])

                        if self.tiles[y][x2].explosive then
                            lineExplosion = true
                        end
                    end

                    if lineExplosion then
                        match = {}
                        for x2 = 8, 1, -1 do
                            table.insert(match, self.tiles[y][x2])
                        end
                    end

                    table.insert(matches, match)
                end

                matchNum = 1

                if x >= 7 then
                    break
                end
            end
        end

        if matchNum >= 3 then
            local match = {}
            local lineExplosion = false

            for x = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])

                if self.tiles[y][x].explosive then
                    lineExplosion = true
                end
            end

            if lineExplosion then
                match = {}
                for x = 8, 1, -1 do
                    table.insert(match, self.tiles[y][x])
                end
            end

            table.insert(matches, match)
        end
    end

    -- Vertical matches
    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color

        matchNum = 1

        for y = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color

                if matchNum >= 3 then
                    local match = {}
                    local columnExplosion = false
                    for y2 = y - 1, y - matchNum, -1 do
                        table.insert(match, self.tiles[y2][x])
                        if self.tiles[y2][x].explosive then
                            columnExplosion = true
                        end
                    end

                    if columnExplosion then
                        match = {}
                        for y2 = 8, 1, -1 do
                            table.insert(match, self.tiles[y2][x])
                        end
                    end
                    table.insert(matches, match)
                end

                matchNum = 1

                if y >= 7 then
                    break
                end
            end
        end

        if matchNum >= 3 then
            local match = {}
            local columnExplosion = false

            for y = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
                if self.tiles[y][x].explosive then
                    columnExplosion = true
                end
            end

            if columnExplosion then
                match = {}
                for y = 8, 1, -1 do
                    table.insert(match, self.tiles[y][x])
                end
            end
            table.insert(matches, match)
        end
    end

    self.matches = matches

    return #self.matches > 0 and self.matches or false
end

function Board:swapTiles(tile1, tile2)
    local tempX = tile1.gridX
    local tempY = tile1.gridY

    tile1.gridX = tile2.gridX
    tile1.gridY = tile2.gridY
    tile2.gridX = tempX
    tile2.gridY = tempY

    self.tiles[tile1.gridY][tile1.gridX] = tile1
    self.tiles[tile2.gridY][tile2.gridX] = tile2
end

function Board:removeMatches()
    for k, match in pairs(self.matches) do
        local toExclude = 0
        if #match == 5 or #match == 4 then
            toExclude = 3
        end
        for k, tile in pairs(match) do
            if k == toExclude then
                tile:startShine()
            else
                if tile.explosive then
                    tile:stopShine()
                end
                self.tiles[tile.gridY][tile.gridX] = nil
            end
        end
    end

    self.matches = nil
end

function Board:getFallingTiles()
    local tweens = {}

    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8
        while y >= 1 do
            local tile = self.tiles[y][x]
            
            if space then
                if tile then
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY
                    self.tiles[y][x] = nil

                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    space = false
                    y = spaceY
                    spaceY = 0
                end
            elseif tile == nil then
                space = true
                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            if not tile then

                local baseColor = self.baseColors[math.random(#self.baseColors)]
                
                local tile = Tile(x, y, baseColor.color, baseColor.variety)
                if math.random(RANDOM_SHINE_TILE) == RANDOM_SHINE_TILE then
                    tile:startShine()
                end
                tile.y = -32
                self.tiles[y][x] = tile

                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end

    return tweens
end

function Board:getTileFromCoordinate(cx, cy)

    local foundX = 0
    local foundY = 0

    cx = cx - self.x
    cy = cy - self.y

    if cx > 0 and cx <= TILE_SIZE * 8 and cy > 0 and cy <= TILE_SIZE * 8 then
        foundX = math.ceil( cx/TILE_SIZE )
        foundY = math.ceil( cy/TILE_SIZE )
    end

    return foundX, foundY
    
end

function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end
