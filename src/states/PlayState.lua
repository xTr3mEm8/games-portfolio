--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

-- Initialize the PlayState with parameters passed between states
function PlayState:enter(params)
    -- Initialize game elements
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.level = params.level
    
    -- Track whether the player has found the key brick
    self.hasKey = true
    for _, brick in pairs(self.bricks) do
        if brick.key then
            self.hasKey = false
            break
        end
    end
    
    -- Initialize ball and power-up arrays
    self.balls = {params.ball}
    self.powers = {}

    -- Initialize gameplay variables
    self.recoverPoints = 5000
    self.hitsLastDrop = 0

    -- Give the ball random starting velocity
    self.balls[1].dx = math.random(-200, 200)
    self.balls[1].dy = math.random(-50, -60)
end

-- Update function, called each frame
function PlayState:update(dt)
    -- Check for pause input
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- Update paddle position
    self.paddle:update(dt)
    
    -- Update ball positions
    for _, ball in pairs(self.balls) do
        ball:update(dt)
    end
    
    -- Update power-up positions
    for _, power in pairs(self.powers) do
        power:update(dt)
    end
    
    -- Check for collisions between power-ups and the paddle
    for i=#self.powers, 1, -1 do
        if self.powers[i]:collides(self.paddle) then
            -- Handle power-up effects
            -- Add balls power-up
            if self.powers[i].skin == 9 then
                -- Add two new balls above the paddle
                ball1 = self.powers[i]:addBall(self.paddle.x + (self.paddle.width / 2) - 2, self.paddle.y - 8)
                ball2 = self.powers[i]:addBall(self.paddle.x + (self.paddle.width / 2) - 6, self.paddle.y - 8)
                table.insert(self.balls, ball1)
                table.insert(self.balls, ball2)
            -- Heal power-up
            elseif self.powers[i].skin == 3 then
                -- Increase player health (up to a maximum of 3)
                self.health = self.powers[i]:heal(self.health)
            -- Grow paddle power-up
            elseif self.powers[i].skin == 5 then
                -- Increase paddle size (up to a maximum of 4)
                self.paddle.size, self.paddle.width = self.powers[i]:paddleUp(self.paddle.size, 4, self.paddle.width)           
            -- Found key power-up
            elseif self.powers[i].skin == 10 and not self.hasKey then
                -- Set key brick as found
                for _, brick in pairs(self.bricks) do
                    if brick.key then
                        brick.found = true
                    end
                    self.hasKey = true
                end
            end
            -- Remove collected power-up
            table.remove(self.powers, i)
        end
    end

    -- Check for collisions between balls and the paddle
    for _, ball in pairs(self.balls) do
        if ball:collides(self.paddle) then
            -- Adjust ball position and velocity for paddle collision
            ball.y = self.paddle.y - 8
            ball.dy = -ball.dy
            -- Tweak bounce angle based on where ball hits paddle
            if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ball.x))
            elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
            end
            -- Play paddle hit sound effect
            gSounds['paddle-hit']:play()
        end
    end

    -- Check for collisions between balls and bricks
    for k, brick in pairs(self.bricks) do
        for _, ball in pairs(self.balls) do
            if brick.inPlay and ball:collides(brick) then
                -- Handle power-up drop chance
                self.hitsLastDrop = self.hitsLastDrop + 1
                if math.random(0, 100) <= self.hitsLastDrop + 10 then
                    -- Determine if the player has enough health and paddle size to receive certain power-ups
                    local hp = self.health >= 3
                    local pd = self.paddle.size >= 4
                    -- Insert a new power-up at the brick's position
                    table.insert(self.powers, PowerUp(PowerUp:random(self.hasKey, hp, pd), brick.x, brick.y))
                    self.hitsLastDrop = 0
                end
                -- Add score for hitting brick
                if not brick.key or brick.found then 
                    self.score = self.score + (brick.tier * 200 + brick.color * 25)
                end
                -- Trigger brick hit function to remove brick from play
                brick:hit()
                -- Increase player health if score reaches a certain threshold
                if self.score > self.recoverPoints then
                    self.health = math.min(3, self.health + 1)
                    -- Increase paddle size if not already at maximum
                    if self.paddle.size < 4 then
                        self.paddle.size = self.paddle.size + 1
                        self.paddle.width = self.paddle.width + 32
                    end
                    -- Increase recovery points threshold
                    self.recoverPoints = self.recoverPoints + math.min(100000, self.recoverPoints * 2)
                    -- Play recovery sound effect
                    gSounds['recover']:play()
                end
                -- Transition to victory screen if no bricks remain
                if self:checkVictory() then
                    gSounds['victory']:play()
                    gStateMachine:change('victory', {
                        level = self.level,
                        paddle = self.paddle,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        ball = ball,
                        recoverPoints = self.recoverPoints
                    })
                end
                -- Resolve ball-brick collision
                -- Check if ball collides with brick on its sides or top/bottom
                if ball.x + 2 < brick.x and ball.dx > 0 then
                    ball.dx = -ball.dx
                    ball.x = brick.x - 8
                elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                    ball.dx = -ball.dx
                    ball.x = brick.x + 32
                elseif ball.y < brick.y then
                    ball.dy = -ball.dy
                    ball.y = brick.y - 8
                else
                    ball.dy = -ball.dy
                    ball.y = brick.y + 16
                end
                -- Scale ball speed to speed up the game
                if math.abs(ball.dy) < 150 then
                    ball.dy = ball.dy * 1.02
                end
                -- Break loop to handle only one brick collision per ball
                break
            end
        end
    end

    -- Remove power-ups that have fallen below the screen
    for i=#self.powers, 1, -1 do
        if self.powers[i].y >= VIRTUAL_HEIGHT then
            table.remove(self.powers, i)
        end
    end
    
    -- Remove balls that have fallen below the screen
    for i=#self.balls, 1, -1 do
        if self.balls[i].y >= VIRTUAL_HEIGHT then
            table.remove(self.balls, i)
        end
    end
    
    -- Handle case when all balls are lost
    if  #self.balls == 0 then
        -- Decrease paddle size and player health
        if self.paddle.size > 2 then
            self.paddle.size = self.paddle.size - 1
            self.paddle.width = self.paddle.width - 32
        end
        self.health = self.health - 1
        gSounds['hurt']:play()
        -- Transition to game over screen if health reaches 0, otherwise to serve state
        if self.health == 0 then
            gStateMachine:change('game-over', {
                score = self.score,
                highScores = self.highScores
            })
        else
            gStateMachine:change('serve', {
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health,
                score = self.score,
                highScores = self.highScores,
                level = self.level,
                recoverPoints = self.recoverPoints
            })
        end
    end

    -- Update particle systems for bricks
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    -- Check for escape key press to quit game
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

-- Render function to draw game elements
function PlayState:render()
    -- Render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- Render particle systems for bricks
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    -- Render paddle
    self.paddle:render()
    
    -- Render balls
    for _, ball in pairs(self.balls) do
        ball:render()
    end
    
    -- Render power-ups
    for _, power in pairs(self.powers) do
        power:render()
    end

    -- Render score and health
    renderScore(self.score)
    renderHealth(self.health)

    -- Render pause text if game is paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

-- Check for victory condition (no bricks remaining)
function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end
    return true
end