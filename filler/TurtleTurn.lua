local GetIndex = require("GetIndex")
local Directions = require("Directions")

local TurtleTurn = {
    turns = 0,
    faces = {
        [0] = Directions.NORTH,
        [1] = Directions.EAST,
        [2] = Directions.SOUTH,
        [3] = Directions.WEST
    }
}


function TurtleTurn:new(o, turns, facing)
    o = o or {}
    local c = setmetatable(o, self)
    self.__index = self
    self.turns = turns or 0

    local initialFaceIndex = GetIndex(facing, TurtleTurn.faces) - 1

    -- if turtle is already facing north
    if (initialFaceIndex == 0) then
        self.faces = TurtleTurn.faces
    else
        ---set facing face as index 0
        for k, v in pairs(TurtleTurn.faces) do

            if(k >3)then
                break
            end

            if (k < initialFaceIndex) then
                self.faces[(k + initialFaceIndex)] = v
            else
                self.faces[(k - initialFaceIndex)] = v
            end

        end
    end

    return c
end

function TurtleTurn:getFacing()
    return self.faces[self.turns % 4]
end

function TurtleTurn:turnRight()
    self.turns = self.turns + 1
    turtle.turnRight()
end

function TurtleTurn:turnLeft()
    self.turns = self.turns - 1
    turtle.turnLeft()
end

function TurtleTurn:face(direction)

    local turnDelta = self.faces[direction]

    if (turnDelta == nil) then
        print("direction not faceble")
    end

    if (turnDelta == self:getFacing()) then
        return false
    end

    while turnDelta ~= self:getFacing() do

        if (turnDelta < self:getFacing()) then
            self:turnLeft()
        elseif (turnDelta > self:getFacing()) then
            self:turnRight()
        else
            print("something went wrong")
            return false
        end
    end

    return true

end

return TurtleTurn