--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}

    local tileID = TILE_ID_GROUND

    local keycolor = math.random(#KEY_LOCKS)
    local flagColor = math.random(#FLAG_POSTS)
    local gHeight = 7
    local pHeight = 5
    local hasKey = false
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    for x = 1, height do
        table.insert(tiles, {})
    end

    for x = 1, width do
        local tileID = TILE_ID_EMPTY

        for y = 1, 6 do
            table.insert(tiles[y], Tile(x, y, tileID, nil, tileset, topperset))
        end

        if x <= 3 then
            tileID = TILE_ID_GROUND
            for y = 7, height do
                table.insert(tiles[y], Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end
            goto continue
        end

        if math.random(7) == 1 then
            for y = 7, height do
                table.insert(tiles[y], Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND
            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y], Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            if math.random(8) == 1 then
                blockHeight = 2

                if math.random(8) == 1 then
                    table.insert(objects, GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (4 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    })
                end

                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil

            elseif math.random(8) == 1 then
                table.insert(objects, GameObject {
                    texture = 'bushes',
                    x = (x - 1) * TILE_SIZE,
                    y = (6 - 1) * TILE_SIZE,
                    width = 16,
                    height = 16,
                    frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                    collidable = false
                })
            end

            if math.random(10) == 1 then
                table.insert(objects, GameObject {
                    texture = 'jump-blocks',
                    x = (x - 1) * TILE_SIZE,
                    y = (blockHeight - 1) * TILE_SIZE,
                    width = 16,
                    height = 16,
                    frame = math.random(#JUMP_BLOCKS),
                    collidable = true,
                    hit = false,
                    solid = true,

                    onCollide = function(obj)
                        if not obj.hit then
                            if math.random(5) == 1 then
                                local gem = GameObject {
                                    texture = 'gems',
                                    x = (x - 1) * TILE_SIZE,
                                    y = (blockHeight - 1) * TILE_SIZE - 4,
                                    width = 16,
                                    height = 16,
                                    frame = math.random(#GEMS),
                                    collidable = true,
                                    consumable = true,
                                    solid = false,

                                    onConsume = function(player, object)
                                        gSounds['pickup']:play()
                                        player.score = player.score + 100
                                    end
                                }

                                Timer.tween(0.1, {
                                    [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                })
                                gSounds['powerup-reveal']:play()

                                table.insert(objects, gem)
                            end

                            obj.hit = true
                        end

                        gSounds['empty-block']:play()
                    end
                })
            end
        end
        ::continue::
    end

    local kFlag = true
    while kFlag do
        local keyx = math.random(width)

        if tiles[height][keyx].id == TILE_ID_GROUND then
            local keyHeight
            if tiles[gHeight][keyx].id == TILE_ID_GROUND then
                keyHeight = gHeight - 3
            elseif tiles[pHeight][keyx].id == TILE_ID_GROUND then
                keyHeight = pHeight - 3
            end

            local key = getKeyOrLock(KEY_ID, keyHeight, keyx, keycolor)
            key.onConsume = function(player, object)
                gSounds['pickup']:play()
                hasKey = true
            end
            table.insert(objects, GameObject(key))
            kFlag = false
        end
    end

    local lFlag = true
    while lFlag do
        local lockX = math.random(width)

        if tiles[height][lockX].id == TILE_ID_GROUND then
            local lockHeight
            if tiles[gHeight][lockX].id == TILE_ID_GROUND and tiles[gHeight - 1][lockX].id == TILE_ID_EMPTY then
                lockHeight = gHeight - 3
            elseif tiles[pHeight][lockX].id == TILE_ID_GROUND then
                lockHeight = pHeight - 3
            end

            local lock = getKeyOrLock(LOCK_ID, lockHeight, lockX, keycolor)
            lock.onCollide = function(player, object)
                if hasKey then
                    gSounds['pickup']:play()
                    object.remove = true
                    hasKey = false

                    local flagObjects = getFlag(tiles, objects, width, height, flagColor)
                    for _, obj in pairs(flagObjects) do
                        table.insert(objects, obj)
                    end
                else
                    gSounds['empty-block']:play()
                end
            end
            table.insert(objects, GameObject(lock))
            lFlag = false

            for k, obj in pairs(objects) do
                if obj.texture == 'jump-blocks' and obj.x == (lockX - 1) * TILE_SIZE then
                    table.remove(objects, k)
                    break
                end
            end
        end
    end

    local map = TileMap(width, height)
    map.tiles = tiles

    return GameLevel(entities, objects, map)
end

function getKeyOrLock(KoL, blockHeight, x, color)
    local keyY = KoL == KEY_ID and blockHeight + 2 or blockHeight

    return {
        texture = 'keys',
        x = (x - 1) * TILE_SIZE,
        y = (keyY - 1) * TILE_SIZE,
        width = 16,
        height = 16,
        collidable = true,
        consumable = KoL == KEY_ID,
        solid = KoL == LOCK_ID,
        frame = KEY_LOCKS[color] + KoL
    }
end

function getFlag(tiles, objects, width, height, flagColor)
    local flag = {}
    local flagY = 6
    local flagX = -1

    for x = width - 1, 1, -1 do
        if tiles[flagY][x].id == TILE_ID_EMPTY and tiles[flagY + 1][x].id == TILE_ID_GROUND then
            flagX = x
            break
        end
    end

    for k, obj in pairs(objects) do
        if obj.x == (flagX - 1) * TILE_SIZE then
            table.remove(objects, k)
        end
    end

    for poleType = 2, 0, -1 do
        table.insert(flag, createFlagPost(width, flagColor, flagX, flagY, poleType))

        if poleType == 1 then
            flagY = flagY - 1
            table.insert(flag, createFlagPost(width, flagColor, flagX, flagY, poleType))

            flagY = flagY - 1
            table.insert(flag, createFlagPost(width, flagColor, flagX, flagY, poleType))
        end
        flagY = flagY - 1
    end

    table.insert(flag, createFlag(width, flagX, flagY + 2))

    return flag
end

function createFlag(width, flagX, flagY)
    local baseFrame = FLAGS[math.random(#FLAGS)]

    return GameObject {
        texture = 'flags',
        x = (flagX - 1) * TILE_SIZE + 8,
        y = (flagY - 1) * TILE_SIZE - 8,
        width = 16,
        height = 16,
        animation = Animation {
            frames = {baseFrame, baseFrame + 1},
            interval = 0.2
        }
    }
end

function createFlagPost(width, flagColor, flagX, flagY, poleType)
    return GameObject {
        texture = 'flags',
        x = (flagX - 1) * TILE_SIZE,
        y = (flagY - 1) * TILE_SIZE,
        width = 6,
        height = 16,
        frame = flagColor + poleType * FLAG_OFFSET,
        collidable = true,
        consumable = true,
        solid = false,

        onConsume = function(player, object)
            gSounds['pickup']:play()

            player.score = player.score + 500

            gStateMachine:change('play', {
                score = player.score,
                levelWidth = width + 10,
                levelComplete = true
            })
        end
    }
end
