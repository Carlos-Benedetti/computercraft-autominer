
require "strict"
local Singer=require("Singer")
local SelectBuffer=require("SelectBuffer")
local FixedSlot= require("FixedSlot")
local EnderChest = require("EnderChest")

local Fuel = {fThreshold=10,fSlot=FixedSlot.FUEL_SLOT,enderChest=nil}

function Fuel:new(o,enderChest)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    self.enderChest = enderChest or EnderChest:new()
end

function Fuel:FuelRoutine ()
    local fLevel = turtle.getFuelLevel()

    if(fLevel <= self.fThreshold) then

        Singer:sing("Refueling")

        self.enderChest:place()

        turtle.getItemDetail()

        SelectBuffer:save()

        turtle.select(self.fSlot)
        turtle.suckDown(10)
        turtle.refuel(turtle.getItemCount())
        SelectBuffer:load()

        self.enderChest:retrive()

    end
end

return Fuel