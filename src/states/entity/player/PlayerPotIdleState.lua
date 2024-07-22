PlayerPotIdleState = Class{__includes = EntityIdleState}



function PlayerPotIdleState:init(player)
    self.player = player
end

function PlayerPotIdleState:enter(params)
    self.lifted_object = self.player.lifted_object

    self.player:changeAnimation('pot-idle-'..self.player.direction)
end

function PlayerPotIdleState:update(dt)
    
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.player:changeState('pot-walk')
    elseif love.keyboard.isDown('e') then
        self.player:changeState('pot-throw')
    end



end

function PlayerPotIdleState:render()
    self.object_renderX = self.player.x 
    self.object_renderY = self.player.y - self.lifted_object.width / 2

    --Draw player.
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
    --Draw lifted object.
    love.graphics.draw(gTextures[self.lifted_object.texture], gFrames[self.lifted_object.texture][self.lifted_object.frame],
                        self.object_renderX, self.object_renderY)

end