--[[
    GD50
    Angry Birds

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Level = Class{}

function Level:init()
    -- Create a new world with no x gravity and 30 units of y gravity
    self.world = love.physics.newWorld(0, 300)
    self.destroyedBodies = {}

    function beginContact(a, b, coll)
        local types = {}
        types[a:getUserData()] = true
        types[b:getUserData()] = true

        if types['Obstacle'] and types['Player'] then
            self.playerCollided = true
            local playerFixture = a:getUserData() == 'Player' and a or b
            local obstacleFixture = a:getUserData() == 'Obstacle' and a or b
            local velX, velY = playerFixture:getBody():getLinearVelocity()
            local sumVel = math.abs(velX) + math.abs(velY)
            if sumVel > 20 then
                table.insert(self.destroyedBodies, obstacleFixture:getBody())
            end
        end

        if types['Obstacle'] and types['Alien'] then
            local obstacleFixture = a:getUserData() == 'Obstacle' and a or b
            local alienFixture = a:getUserData() == 'Alien' and a or b
            local velX, velY = obstacleFixture:getBody():getLinearVelocity()
            local sumVel = math.abs(velX) + math.abs(velY)
            if sumVel > 20 then
                table.insert(self.destroyedBodies, alienFixture:getBody())
            end
        end

        if types['Player'] and types['Alien'] then
            self.playerCollided = true
            local playerFixture = a:getUserData() == 'Player' and a or b
            local alienFixture = a:getUserData() == 'Alien' and a or b
            local velX, velY = playerFixture:getBody():getLinearVelocity()
            local sumVel = math.abs(velX) + math.abs(velY)
            if sumVel > 20 then
                table.insert(self.destroyedBodies, alienFixture:getBody())
            end
        end

        if types['Player'] and types['Ground'] then
            gSounds['bounce']:stop()
            gSounds['bounce']:play()
        end
    end

    function endContact(a, b, coll) end
    function preSolve(a, b, coll) end
    function postSolve(a, b, coll, normalImpulse, tangentImpulse) end

    self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)
    self.launchMarker = AlienLaunchMarker(self.world)
    self.playerCollided = false
    self.playerSplit = false
    self.extraPlayers = {}
    self.aliens = {}
    self.obstacles = {}
    self.edgeShape = love.physics.newEdgeShape(0, 0, VIRTUAL_WIDTH * 3, 0)

    table.insert(self.aliens, Alien(self.world, 'square', VIRTUAL_WIDTH - 80, VIRTUAL_HEIGHT - TILE_SIZE - ALIEN_SIZE / 2, 'Alien'))
    table.insert(self.obstacles, Obstacle(self.world, 'vertical', VIRTUAL_WIDTH - 120, VIRTUAL_HEIGHT - 35 - 110 / 2))
    table.insert(self.obstacles, Obstacle(self.world, 'vertical', VIRTUAL_WIDTH - 35, VIRTUAL_HEIGHT - 35 - 110 / 2))
    table.insert(self.obstacles, Obstacle(self.world, 'horizontal', VIRTUAL_WIDTH - 80, VIRTUAL_HEIGHT - 35 - 110 - 35 / 2))

    self.groundBody = love.physics.newBody(self.world, -VIRTUAL_WIDTH, VIRTUAL_HEIGHT - 35, 'static')
    self.groundFixture = love.physics.newFixture(self.groundBody, self.edgeShape)
    self.groundFixture:setFriction(0.5)
    self.groundFixture:setUserData('Ground')
    self.background = Background()
end

function Level:update(dt)
    self.launchMarker:update(dt)
    self.world:update(dt)

    for k, body in pairs(self.destroyedBodies) do
        if not body:isDestroyed() then 
            body:destroy()
        end
    end

    self.destroyedBodies = {}

    for i = #self.obstacles, 1, -1 do
        if self.obstacles[i].body:isDestroyed() then
            table.remove(self.obstacles, i)
            local soundNum = math.random(5)
            gSounds['break' .. tostring(soundNum)]:stop()
            gSounds['break' .. tostring(soundNum)]:play()
        end
    end

    for i = #self.aliens, 1, -1 do
        if self.aliens[i].body:isDestroyed() then
            table.remove(self.aliens, i)
            gSounds['kill']:stop()
            gSounds['kill']:play()
        end
    end

    if self.launchMarker.launched then
        local extraPlayersStopped = false
        local xPos, yPos = self.launchMarker.alien.body:getPosition()
        local xVel, yVel = self.launchMarker.alien.body:getLinearVelocity()

        if love.keyboard.wasPressed("space") and not self.playerCollided and not self.playerSplit then
            for i = 1, 2 do
                local newAlien = Alien(self.world, 'round', xPos, yPos, 'Player')
                newAlien.body:setLinearVelocity(xVel * math.random(85, 115) / 100, i == 1 and yVel * math.random(105, 115) / 100 or yVel * math.random(85, 95) / 100)
                newAlien.fixture:setRestitution(0.4)
                newAlien.body:setAngularDamping(1)
                table.insert(self.extraPlayers, newAlien)
            end
            self.playerSplit = true
        end

        if self.playerSplit then
            local stoppedPlayers = {}
            for k, alien in pairs(self.extraPlayers) do
                local xV, yV = alien.body:getLinearVelocity()
                local xP, yP = alien.body:getPosition()
                if (math.abs(xV) + math.abs(yV)) < 2 or xP > VIRTUAL_WIDTH * 2 then
                    table.insert(stoppedPlayers, alien)
                end
                if #stoppedPlayers == #self.extraPlayers then
                    extraPlayersStopped = true
                end
            end
        end

        if xPos < 0 or xPos > VIRTUAL_WIDTH * 2 or ((math.abs(xVel) + math.abs(yVel) < 2) and #self.extraPlayers == 0 or extraPlayersStopped) then
            self.playerCollided = false
            self.playerSplit = false
            self.extraPlayers = {}

            self.launchMarker.alien.body:destroy()
            self.launchMarker = AlienLaunchMarker(self.world)

            if #self.aliens == 0 then
                gStateMachine:change('start')
            end
        end
    end
end

function Level:render()
    for x = -VIRTUAL_WIDTH, VIRTUAL_WIDTH * 2, 35 do
        love.graphics.draw(gTextures['tiles'], gFrames['tiles'][12], x, VIRTUAL_HEIGHT - 35)
    end

    self.launchMarker:render()

    for k, alien in pairs(self.extraPlayers) do
        alien:render()
    end

    for k, alien in pairs(self.aliens) do
        alien:render()
    end

    for k, obstacle in pairs(self.obstacles) do
        obstacle:render()
    end

    if not self.launchMarker.launched then
        love.graphics.setFont(gFonts['medium'])
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf('Click and drag circular alien to shoot!', 0, 64, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1, 1)
    end

    if #self.aliens == 0 then
        love.graphics.setFont(gFonts['huge'])
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf('VICTORY', 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1, 1)
    end
end
