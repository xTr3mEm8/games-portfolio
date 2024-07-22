--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PROJECTILE_SPEED = 200

Projectile = Class{}

--Direction is either 'up', 'down', 'left', 'right'
--Object is a game object.
function Projectile:init(def)
    self.origin_x, self.x = def.x, def.x
    self.origin_y, self.y = def.y, def.y

    self.height = def.object.height
    self.width = def.object.width

    self.max_travel_tiles = 4
    self.expired = false

    if def.dir == 'up' then
        self.dx = 0
        self.dy = -PROJECTILE_SPEED
    elseif def.dir == 'down' then
        self.dx = 0
        self.dy = PROJECTILE_SPEED
    elseif def.dir == 'right' then
        self.dx = PROJECTILE_SPEED
        self.dy = 0
    elseif def.dir == 'left' then
        self.dx = -PROJECTILE_SPEED
        self.dy = 0
    end

    self.texture = def.object.texture
    self.frame = def.object.frame

    self.damage = 2

end

function Projectile:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    -- if we've gone more than two tiles without hitting anything, the projectile expires.
    local originVec = {x = self.origin_x, y = self.origin_y}
    local currVec = {x = self.x, y = self.y}

    local tile_distance = math.floor(Distance(originVec, currVec) / TILE_SIZE)

    --Check for distance travelled.
    if tile_distance >= self.max_travel_tiles and not self.expired then
        self:destroy()
    end

    --Wall collision
    local leftEdge = MAP_RENDER_OFFSET_X + TILE_SIZE
    local rightEdge = VIRTUAL_WIDTH - TILE_SIZE * 2
    local topEdge = MAP_RENDER_OFFSET_Y + TILE_SIZE - self.height / 2
    local bottomEdge = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) 
    + MAP_RENDER_OFFSET_Y - TILE_SIZE * 2    
    if (not self.expired and (self.x <= leftEdge or
        self.x + self.width >= rightEdge or
        self.y <= topEdge or
        self.y >= bottomEdge)) then
            self:destroy()
        end


end

function Projectile:destroy()
    if gSounds['pot-break']:isPlaying() then
        gSounds['pot-break']:stop()
    end

    self.expired = true
    gSounds['pot-break']:play()
end

function Projectile:render()

    love.graphics.draw( gTextures[self.texture], gFrames[self.texture][self.frame], self.x, self.y)

end