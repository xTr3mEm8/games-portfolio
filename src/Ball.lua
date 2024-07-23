--[[
    Ball Class
    Represents a ball which will bounce back and forth between the sides
    of the world space, the player's paddle, and the bricks laid out above
    the paddle. The ball can have a skin, which is chosen at random, just
    for visual variety.
]]

Ball = Class{}

function Ball:init(skin)
    -- Simple positional and dimensional variables
    self.width = 8
    self.height = 8

    -- Variables for velocity on both the X and Y axis
    self.dy = 0
    self.dx = 0

    -- Ball color/skin
    self.skin = skin
end

-- Checks if the ball collides with a target (paddle or brick)
function Ball:collides(target)
    -- Check if the bounding boxes overlap
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    return true
end

-- Places the ball in the middle of the screen with no movement
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = 0
    self.dy = 0
end

-- Updates the ball's position and velocity
function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    -- Allow ball to bounce off walls
    if self.x <= 0 then
        self.x = 0
        self.dx = -self.dx
        gSounds['wall-hit']:play()
    end

    if self.x >= VIRTUAL_WIDTH - 8 then
        self.x = VIRTUAL_WIDTH - 8
        self.dx = -self.dx
        gSounds['wall-hit']:play()
    end

    if self.y <= 0 then
        self.y = 0
        self.dy = -self.dy
        gSounds['wall-hit']:play()
    end
end

-- Renders the ball
function Ball:render()
    love.graphics.draw(gTextures['main'], gFrames['balls'][self.skin], self.x, self.y)
end
