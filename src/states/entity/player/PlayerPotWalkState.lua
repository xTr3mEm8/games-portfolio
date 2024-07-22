PlayerPotWalkState = Class{__includes = EntityWalkState}


function PlayerPotWalkState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon


end

function PlayerPotWalkState:enter(params)
    self.lifted_object = self.entity.lifted_object
end


function PlayerPotWalkState:update(dt)
    --We'll have to do some shameless copy pasting here to retain wall collision and object collision and such.
    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
    elseif love.keyboard.isDown('e') then
        self.entity:changeState('pot-throw')
    else
        self.entity:changeState('pot-idle')
    end

    self.entity:changeAnimation('pot-walk-'..self.entity.direction)

    EntityWalkState.update(self, dt)

    self.lifted_object.x = self.entity.x
    self.lifted_object.y = self.entity.y


    --Don't mind me, just c&p'ing!

    -- if we bumped something when checking collision, check any object collisions
    if self.bumped then
        if self.entity.direction == 'left' then
            
            -- temporarily adjust position into the wall, since bumping pushes outward
            self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift player to center of door to avoid phasing through wall
                    self.entity.y = doorway.y + 4
                    Event.dispatch('shift-left')
                end
            end

            -- readjust
            self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt
        elseif self.entity.direction == 'right' then
            
            -- temporarily adjust position
            self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift player to center of door to avoid phasing through wall
                    self.entity.y = doorway.y + 4
                    Event.dispatch('shift-right')
                end
            end

            -- readjust
            self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt
        elseif self.entity.direction == 'up' then
            
            -- temporarily adjust position
            self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift player to center of door to avoid phasing through wall
                    self.entity.x = doorway.x + 8
                    Event.dispatch('shift-up')
                end
            end

            -- readjust
            self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
        else
            
            -- temporarily adjust position
            self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift player to center of door to avoid phasing through wall
                    self.entity.x = doorway.x + 8
                    Event.dispatch('shift-down')
                end
            end

            -- readjust
            self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
        end
    end



end

function PlayerPotWalkState:render()
    self.object_renderX = self.entity.x 
    self.object_renderY = self.entity.y - self.lifted_object.width / 2

    --Draw player.
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
    --Draw lifted object.
    love.graphics.draw(gTextures[self.lifted_object.texture], gFrames[self.lifted_object.texture][self.lifted_object.frame],
                        self.object_renderX, self.object_renderY)


end