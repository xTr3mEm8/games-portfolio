PlayerPotThrowState = Class{__includes = BaseState}


function PlayerPotThrowState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

end


function PlayerPotThrowState:enter(params)
    self:throw()

    self.player:changeState('idle')
    
end


function PlayerPotThrowState:update(dt)
    
end

function PlayerPotThrowState:render()
    --local anim
    --love.graphics.draw(gTextures['character-pot-lift'])
end


function PlayerPotThrowState:throw()
    
    --Sanity check for the presence of the object we're to throw.
    if self.player.lifted_object then
        local projectile = Projectile({x=self.player.x, 
                                       y = self.player.y, 
                                       dir = self.player.direction, 
                                       object = self.player.lifted_object})

        --Insert into current room's projectile list.
        table.insert(self.dungeon.currentRoom.projectiles, projectile)

        --Get rid of player's lifted object.
        self.player.lifted_object = nil
    end
    
end