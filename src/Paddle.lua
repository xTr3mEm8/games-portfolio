--[[
    Paddle Class
    Represents a paddle that can move left and right. Used in the main
    program to deflect the ball toward the bricks; if the ball passes
    the paddle, the player loses one heart. The Paddle can have a skin,
    which the player gets to choose upon starting the game.
]]

Paddle = Class{}

-- Initializes the paddle
function Paddle:init(skin)
    -- Set initial position and dimensions
    self.x = VIRTUAL_WIDTH / 2 - 32
    self.y = VIRTUAL_HEIGHT - 32
    self.width = 64
    self.height = 16

    -- Set initial velocity to 0
    self.dx = 0

    -- Set paddle skin and size
    self.skin = skin
    self.size = 2
end

-- Updates paddle movement
function Paddle:update(dt)
    -- Handle keyboard input for left and right movement
    if love.keyboard.isDown('left') then
        self.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        self.dx = PADDLE_SPEED
    else
        self.dx = 0
    end

    -- Update paddle position within screen bounds
    self.x = math.max(0, math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt))
end

-- Renders the paddle
function Paddle:render()
    love.graphics.draw(gTextures['main'], gFrames['paddles'][self.size + 4 * (self.skin - 1)], self.x, self.y)
end

-- Shrinks the paddle
function Paddle:shrink()
    if self.size > 1 then
        self.size = self.size - 1
        self.width = self.width - 32
        self.x = self.x + 16
    end
end

-- Grows the paddle
function Paddle:grow()
    if self.size < 4 then
        self.size = self.size + 1
        self.width = self.width + 32
        self.x = self.x - 16
    end
end
