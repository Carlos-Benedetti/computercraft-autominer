require "strict"
local FixedSlot = require("FixedSlot")
local Singer = require("Singer")
local SelectBuffer = require("SelectBuffer")

local EnderChest = {
    itemSlot = 1,
    placed = false
}

---@param o any optional
function EnderChest:new(o, slot --[[int]] , placed --[[boolean]] )
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.itemSlot = slot or 1
    self.placed = placed or false
    return o

end

function EnderChest.positionUp()
    Singer.singer()
    if (turtle.detectUp()) then
        turtle.digUp()
    end

    turtle.up()

end

function EnderChest.goBackDown()

    if (turtle.detectDown()) then
        turtle.digDown()
    end

    turtle.down()
end

function EnderChest:place()
    SelectBuffer:save()

    self:positionUp()

    turtle.select(self.itemSlot)

    local placed = turtle.placeDown()

    SelectBuffer:load()

    if (placed) then
        self.placed = placed
    end

end

function EnderChest:retrive()

    SelectBuffer:save()

    turtle.select(self.itemSlot)

    local placed = turtle.digDown()

    SelectBuffer:load()

    self:goBackDown()

end

function EnderChest:isFull()
    for i = FixedSlot.ORE1_SLOT, 16 do
        if turtle:getItemSpace(i) == 0 then
            return true
        end
    end
    return false

end

function EnderChest:fullInentoryRoutine()

    if (self:isFull()) then

        self:place()

        SelectBuffer.save()

        for i = FixedSlot.ORE1_SLOT, FixedSlot.ORE8_SLOT do
            turtle.select(i)
            local max = turtle.getItemCount()
            turtle.dropDown(max - 1)
        end

        for i = (FixedSlot.ORE8_SLOT + 1), 16 do
            turtle.select(i)
            turtle.dropDown()
        end

        SelectBuffer:load()

        self:retrive()

        return true

    end
end

return EnderChest