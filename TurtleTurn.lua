function getIndex(item, tabel)
    local index = {}
    for k, v in pairs(tabel) do
        index[v] = k
    end
    return index[item]
end

TurtleTurn = {
    turns = 0,
    faces = {
        [0] = Directions.NORTH,
        [1] = Directions.EAST,
        [2] = Directions.SOUTH,
        [3] = Directions.WEST
    }
}

---@param turns integer
---@param facing string
function TurtleTurn:new(o, turns, facing)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.turns = turns or 0
    
    local initialFaceIndex = getIndex(facing, TurtleTurn.faces) - 1

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
                self.faces[(k + initialFaceIndex)] = k
            else
                self.faces[(k - initialFaceIndex)] = k
            end

            

        end
    end
    
    return o
end

function TurtleTurn:getFacing()
    return self.faces[self.turns % 4]
end

function TurtleTurn:turnRight(o, facing)
    self.turns = self.turns + 1
    turtle.turnRight()
end

function TurtleTurn:turnLeft(o, facing)
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