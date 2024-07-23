--[[
    GD50
    Pokemon
    Assignment

    This state contains a Menu of the levelUp increases for the player pokemon stats   
]]

LevelUpMenuState = Class{__includes = BaseState}

function LevelUpMenuState:init(levelUpValues, playerPokemon, onClose)

    self.HPIncrease = levelUpValues[1]
    self.attackIncrease = levelUpValues[2]
    self.defenseIncrease = levelUpValues[3]
    self.speedIncrease = levelUpValues[4]
    
    -- Values after the increase, which are actually current values
    self.newHP = playerPokemon.HP
    self.newAttack = playerPokemon.attack
    self.newDefense = playerPokemon.defense
    self.newSpeed = playerPokemon.speed

    -- Working backwards to get the original pre-levelUp values
    self.startHP = self.newHP - self.HPIncrease
    self.startAttack = self.newAttack - self.attackIncrease
    self.startDefense = self.newDefense -self.defenseIncrease
    self.startSpeed = self.newSpeed - self.speedIncrease

    self.onClose = onClose or function() end

    self.levelUpMenus = {}

    -- First menu fills the bottom left corner of the screen and displays the HP and Speed changes
    self.levelUpMenus[1] = Menu {
        x = 0,
        y = VIRTUAL_HEIGHT - 64,
        width = VIRTUAL_WIDTH / 2,
        height = 64,
        items = {
            {
                text = 'HP: ' .. self.startHP .. ' + ' .. self.HPIncrease .. ' = ' .. self.newHP,
                -- The first item needs to include the onSelect function and this one includes our onClose function
                onSelect = function()
                    gStateStack:pop()
                    self.onClose()
                end
            },
            {
                text = 'Speed: ' .. self.startSpeed .. ' + ' .. self.speedIncrease .. ' = ' .. self.newSpeed
            }
        },
        -- Selectable flag for Selection class
        selectable = false
    }

    -- Second menu fills the bottom right corner and displays Attack and Defense changes
    self.levelUpMenus[2] = Menu {
        x = VIRTUAL_WIDTH / 2,
        y = VIRTUAL_HEIGHT - 64,
        width = VIRTUAL_WIDTH / 2,
        height = 64,
        items = {
            {
                text = 'Attack: ' .. self.startAttack .. ' + ' .. self.attackIncrease .. ' = ' .. self.newAttack,
                -- Here we include an empty onSelect function as both menus will be called when we press 'enter'
                onSelect = function() end
            },
            {
                text = 'Defense: ' .. self.startDefense .. ' + ' .. self.defenseIncrease .. ' = ' .. self.newDefense
            }
        },
        selectable = false
    }
end

-- We have to update and render both menus
function LevelUpMenuState:update(dt)
    for i, menu in pairs(self.levelUpMenus) do
        menu:update(dt)
    end
end

function LevelUpMenuState:render()
    for i, menu in pairs(self.levelUpMenus) do
        menu:render()
    end
end