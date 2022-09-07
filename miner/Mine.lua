initialFacing=Directions.NORTH
thisTurleTurn = TurtleTurn:new(nil,0,initialFacing)

prospectorPile = Stack:Create()

local Fuel = require("Fuel")

local Enderchest = require("EnderChest")
local Prospector = require("Prospector")


while true do

    Fuel:FuelRoutine()
    Enderchest:fullInentoryRoutine()

    -- basic dig > move
    if(prospectorPile:getn() == 0)then

        turtle:dig()
        turtle:forward()
        prospectorPile:push(Prospector:new(nil,initialFacing))

    end

    local prospec = prospectorPile._et[prospectorPile:getn()]

    prospec.seachRoutine()

end