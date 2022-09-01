local Directions = require("Directions")
local DirectionStack = require("DirectionStack")
local Singer = require("Singer")
local SelectBuffer = require("SelectBuffer")

local ProspectorStatus = {
    IDLE = 1,
    FACING_START = 2,
    FACING_END = 3,
    BREAKING_START = 4,
    BREAKING_END = 5,
    FORWARD_START = 6,
    FORWARD_END = 7,
    BACK_START = 8,
    BACK_END = 9
}

Prospector = {
    oreSlots = {
        [1] = FixedSlot.ORE1_SLOT,
        [2] = FixedSlot.ORE2_SLOT,
        [3] = FixedSlot.ORE3_SLOT,
        [4] = FixedSlot.ORE4_SLOT,
        [5] = FixedSlot.ORE5_SLOT,
        [6] = FixedSlot.ORE6_SLOT,
        [7] = FixedSlot.ORE7_SLOT,
        [8] = FixedSlot.ORE8_SLOT
    },
    direction = Directions.NORTH,
    directions=nil,
    commingFrom = nil,
    home = nil,
    status = ProspectorStatus.IDLE
}

function Prospector:new(o, commingFrom)

    o = o or {}

    setmetatable(o, self)

    self.commingFrom = commingFrom
    self.home = vector.new(gps.locate(5))

    if (commingFrom == Directions.UP or commingFrom == Directions.DOWN) then
        self.directions = DirectionStack.VerticalDirectionStack:new(nil, commingFrom)
    else
        self.directions = DirectionStack.HorizontalDirectionStack:new(nil, commingFrom)
    end

    return o
end

function Prospector:CheckBlock()
    SelectBuffer:save()
    local want = false

    for k, v in pairs(self.oreSlots) do

        turtle.select(k)

        if (turtle.compare()) then

            Singer:singFoundSelectedAt()

            want = true

            break
        end
    end

    SelectBuffer:load()

    return want
end

function Prospector:faceDirection(direction)

    self.direction = self.directions:pop()

    if (self.direction == Directions.UP or self.direction == Directions.DOWN) then
        return true
    end

    return thisTurleTurn:face(self.direction)

end

function Prospector:seachRoutine()

    Singer.sing("[Prospector] Routine from " .. self.status)

    if(
        self.status == ProspectorStatus.FACING_START or
        self.status == ProspectorStatus.FORWARD_START or
        self.status == ProspectorStatus.BREAKING_START or
        self.status == ProspectorStatus.BACK_START 
    )then
        return error("prospetor fail to exist")
    end

    if (self.status == ProspectorStatus.IDLE) then

        -- finished my job, peace
        if (self.directions:getn() == 0) then
            prospectorPile:pop()
        end

        self.status = ProspectorStatus.FACING_START

        local facingResult = self:faceDirection()

        if (facingResult == false) then
            return error("prospetor fail to face direction")
        end

        self.status = ProspectorStatus.FACING_END
        return true
    end

    if (self.status == ProspectorStatus.FACING_END) then
        if (self:CheckBlock() == false) then
            self.status = ProspectorStatus.IDLE
            return
        end
        self.status = ProspectorStatus.BREAKING_START
        -- TODO:add gravel fallback breack redundance

        if (self.direction == Directions.DOWN) then
            turtle.digDown()
        elseif (self.direction == Directions.UP) then
            turtle.digUp()
        else
            while turtle.detect() do
                turtle.dig()
                sleep(2)
            end
        end

        self.status = ProspectorStatus.BREAKING_END

        return
    end

    if (self.status == ProspectorStatus.BREAKING_END) then
        self.status = ProspectorStatus.FORWARD_START

        if (self.direction == Directions.DOWN) then
            turtle.down()
        elseif (self.direction == Directions.UP) then
            turtle.up()
        else
            turtle.forward()
        end

        prospectorPile:push(Prospector:new(nil, self.direction))

        self.status = ProspectorStatus.FORWARD_END

        return
    end

    if (self.status == ProspectorStatus.FORWARD_END) then
        self.status = ProspectorStatus.BACK_START
        if (self.commingFrom == Directions.DOWN) then
            turtle.up()
        elseif (self.commingFrom == Directions.UP) then
            turtle.down()
        else
            turtle.back()
        end
        self.status = ProspectorStatus.BACK_END
        self.status = ProspectorStatus.IDLE
        return
    end

end

-- return Prospector
