--[[
    GD50
    Super Mario Bros. Remake

    -- GameLevel Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameLevel = Class{}

-- Initialize the GameLevel with entities, objects, and a tilemap
function GameLevel:init(entities, objects, tilemap)
    self.entities = entities
    self.objects = objects
    self.tileMap = tilemap
end

-- Remove all nil references from the objects and entities tables
function GameLevel:clear()
    -- Clear objects
    for i = #self.objects, 1, -1 do
        if not self.objects[i] then
            table.remove(self.objects, i)
        end
    end

    -- Clear entities
    for i = #self.entities, 1, -1 do
        if not self.entities[i] then
            table.remove(self.entities, i)
        end
    end
end

-- Update the tilemap, objects, and entities
function GameLevel:update(dt)
    self.tileMap:update(dt)

    for _, object in pairs(self.objects) do
        object:update(dt)
    end

    for _, entity in pairs(self.entities) do
        entity:update(dt)
    end
end

-- Render the tilemap, objects, and entities
function GameLevel:render()
    self.tileMap:render()

    for _, object in pairs(self.objects) do
        object:render()
    end

    for _, entity in pairs(self.entities) do
        entity:render()
    end
end
