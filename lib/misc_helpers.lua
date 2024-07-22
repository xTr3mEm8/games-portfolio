--[[
    Gamble
    This function returns true with a certain probability (1-100), false otherwise.
    Assumes that math.random has been seeded already, doesn't seed it itself.
]]
function Gamble(probability)
    local rand = math.random(1,100)
    if(rand <= probability) then
        return true
    
    else
        return false
    end

end

--[[
    Vector Distance
    Assumes that vectors are tables with x,y fields.
]]

function Distance(vector1, vector2)
    local x_diff = vector1.x - vector2.x
    local y_diff = vector1.y - vector2.y

    local dist = math.sqrt(x_diff^2 + y_diff^2)
    return dist

end