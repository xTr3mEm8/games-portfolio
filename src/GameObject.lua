--[[
    GD50
    -- Super Mario Bros. Remake --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

-- Initialize the GameObject with the given definition
function GameObject:init(def)
    self.x = def.x
    self.y = def.y
    self.texture = def.texture
    self.width = def.width
    self.height = def.height
    self.frame = def.frame
    self.solid = def.solid
    self.collidable = def.collidable
    self.consumable = def.consumable
    self.onCollide = def.onCollide
    self.onConsume = def.onConsume
    self.remove = def.remove or false
    self.hit = def.hit
    self.animation = def.animation
end

-- Check if this object collides with another target
function GameObject:collides(target)
    return not (target.x > self.x + self.width or 
                self.x > target.x + target.width or
                target.y > self.y + self.height or 
                self.y > target.y + target.height)
end

-- Update the object, including its animation if it has one
function GameObject:update(dt)
    if self.animation then
        self.animation:update(dt)
    end
end

-- Render the object, using its current animation frame if it has one
function GameObject:render()
    if self.animation then
        love.graphics.draw(gTextures[self.texture], 
                           gFrames[self.texture][self.animation:getCurrentFrame()], 
                           self.x, self.y)
    else
        love.graphics.draw(gTextures[self.texture], 
                           gFrames[self.texture][self.frame], 
                           self.x, self.y)
    end
end
