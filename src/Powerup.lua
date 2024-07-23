PowerUp = Class{}

function PowerUp:init(skin, x, y)
    -- Initialize PowerUp with default properties
    self.width = 16
    self.height = 16
    self.x = x
    self.y = y
    self.dy = 25
    self.skin = skin
end

function PowerUp:random(key, hp, pd)
    -- Possible power-up options
    local powerups = {9, 5, 3, 10}
    local max = 4
    
    -- Adjust max value and remove corresponding power-up options
    if key then
        table.remove(powerups, 4) -- Remove key power-up
        max = max - 1
    end
    
    if hp then
        table.remove(powerups, 3) -- Remove health power-up
        max = max - 1
    end
    
    if pd then
        table.remove(powerups, 2) -- Remove paddle power-up
        max = max - 1
    end
    
    -- Randomly select a power-up from remaining options
    local rand = math.random(1, max)
    return powerups[rand]
end

function PowerUp:addBall(x, y)
    -- Create a new ball with a random skin
    local ball = Ball(math.random(7))
    ball.x = x
    ball.y = y
    ball.dy = math.random(50, 200) -- Randomize ball's initial vertical velocity
    return ball
end

function PowerUp:heal(health)
    -- Play recovery sound and increase health by 1 (limited to a maximum of 3)
    gSounds['recover']:play()
    return math.min(3, health + 1)
end

function PowerUp:paddleUp(size, max_size, width)
    -- Increase paddle size and width if not already at maximum size
    if size < max_size then
        size = size + 1
        width = width + 32
    end
    return size, width
end

function PowerUp:collides(target)
    -- Check if PowerUp collides with target
    return not (self.x > target.x + target.width or target.x > self.x + self.width or
                self.y > target.y + target.height or target.y > self.y + self.height)
end

function PowerUp:update(dt)
    -- Update PowerUp position based on vertical velocity
    self.y = self.y + self.dy * dt
end

function PowerUp:render()
    -- Render PowerUp
    love.graphics.draw(gTextures['main'], gFrames['powers'][self.skin], self.x, self.y)
end
