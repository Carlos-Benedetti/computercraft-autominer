local Directions = require("Directions")
local TurtleTurn = require("TurtleTurn")

local initialFacing = Directions.NORTH
local turleTurn = TurtleTurn:new(nil, 0, initialFacing)

local Fuel = require("Fuel")
local Enderchest = require("EnderChest")

local xMax = tonumber(arg[1]) or 3
local yMax = tonumber(arg[2]) or 3
local x = 0
local y = 0

turtle = {

}

function turtle.turnLeft()
    print('left')
end

function turtle.dig()
    -- print('dig')
end

function turtle.forward()
    -- print('forward')
end

while true do
    
    -- Fuel:FuelRoutine()
    -- Enderchest:fullInentoryRoutine()
    if (y > yMax) then
        break
    end
    if (x > xMax) then
        turleTurn:turnLeft()
        turtle.dig()
        turtle.forward()
        x = 1
        print("{X:" .. tostring(x) .. " Y:" .. tostring(y) .. "}")
        y = y + 1
        turleTurn:turnLeft()
    else

        turtle.dig()
        turtle.forward()
        x = x + 1
        print("{X:" .. tostring(x) .. " Y:" .. tostring(y) .. "}")
    end



end
