

PlayerLiftingPotState = Class{__includes = BaseState}


function PlayerLiftingPotState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    local direction = self.player.direction
    local hitBoxX, hitBoxY, hitBoxWidth, hitBoxHeight
    
    if direction == 'left' then
        hitBoxWidth = 8
        hitBoxHeight= 16
        hitBoxX = self.player.x - hitBoxWidth
        hitBoxY = self.player.y
    elseif direction == 'right' then
        hitBoxWidth = 8
        hitBoxHeight = 16
        hitBoxX = self.player.x + self.player.width
        hitBoxY = self.player.y

    elseif direction == 'up' then
        hitBoxWidth = 16
        hitBoxHeight = 8
        hitBoxX = self.player.x
        hitBoxY = self.player.y - hitBoxHeight
    elseif direction == 'down' then
        hitBoxWidth = 16
        hitBoxHeight = 8
        hitBoxX = self.player.x
        hitBoxY = self.player.y + self.player.height
    end

    self.liftingHitbox = Hitbox(hitBoxX, hitBoxY, hitBoxWidth, hitBoxHeight)

    self.player:changeAnimation('lift-'..self.player.direction)
end

function PlayerLiftingPotState:enter(params)
    local k_to_remove
    --Check for a pot in our hitbox.
    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if object.pickupable and self.liftingHitbox:collides(object) then
            
            object.solid = false
            k_to_remove = k
            Timer.tween(0.1, {[object] = {x = self.player.x, y = self.player.y - object.width/2}})
            :finish(function ()
                --print("Picking up object: "..tostring(object))
                gSounds['object-pickup']:play()
                self.player.lifted_object = object
                --We don't consider the lifted object to be part of the same room anymore, so we remove it.
                table.remove(self.dungeon.currentRoom.objects, k_to_remove)
                self.player:changeState('pot-idle')


            end)
            break
        end
    end
end


function PlayerLiftingPotState:update(dt)

    
    --If animation is done, we go back to idle.
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
    end

    
end


function PlayerLiftingPotState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

    
        
end