--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

local goldMedal = love.graphics.newImage('Gold medal.jpg')
local silverMedal = love.graphics.newImage('Silver medal.jpg')
local bronzeMedal = love.graphics.newImage('Bronze medal.jpg')
ScoreState = Class{__includes = BaseState}

local GOLD_MEDAL_THRESHOLD = 3
local SILVER_MEDAL_THRESHOLD = 2
local BRONZE_MEDAL_THRESHOLD = 1

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
    if self.score >= GOLD_MEDAL_THRESHOLD then
        self.medal = goldMedal
    elseif self.score >= SILVER_MEDAL_THRESHOLD then
        self.medal = silverMedal
    elseif self.score >= BRONZE_MEDAL_THRESHOLD then
        self.medal = bronzeMedal
    else
        self.medal = nil  -- No medal earned
    end
end

function ScoreState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    -- Display the medal if earned
    if self.medal then
        local medalX = VIRTUAL_WIDTH / 2 - self.medal:getWidth() / 2
        local medalY = 100

        -- Resize the medal images
        local medalWidth = 50
        local medalHeight = 50

        love.graphics.draw(self.medal, medalX, medalY, 0, medalWidth / self.medal:getWidth(), medalHeight / self.medal:getHeight())
    end

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end


function ScoreState:enter(params)
    self.score = params.score
    self.medal = nil
end