HorizontalDirectionStack = Stack:Create()
VerticalDirectionStack = Stack:Create()

local HorizontalDirectionOrder = {
    [Directions.NORTH] = 1,
    [Directions.EAST] = 2,
    [Directions.SOUTH] = 3,
    [Directions.WEST] = 4
}

local function getHorizontalDirectionSequence(horizontalDirection)

    local newDir = {}
    local posSubtr = 0

    for k, v in pairs(HorizontalDirectionOrder) do

        if (v == horizontalDirection) then
            posSubtr = 1
            goto continue
        end

        newDir[k] = v - posSubtr

        ::continue::
    end

    return newDir

end

function HorizontalDirectionStack:new(o, commingFrom)
    o = o or Stack:Create()
    setmetatable(o, self);

    local NewDir = getHorizontalDirectionSequence()

    for k, v in pairs(NewDir) do
        self.stack:push(Directions[k])
    end

    self.stack:push(Directions.UP)
    self.stack:push(Directions.DOWN)

    return o
end

function VerticalDirectionStack:new(o, commingFrom)
    o = o or Stack:Create()
    setmetatable(o, self);

    self.stack:push(Directions.EAST)
    self.stack:push(Directions.NORTH)
    self.stack:push(Directions.SOUTH)
    self.stack:push(Directions.WEST)

    if (commingFrom ~= Directions.UP) then
        self.stack:push(Directions.UP)
    end
    if (commingFrom ~= Directions.DOWN) then
        self.stack:push(Directions.DOWN)
    end

    return o
end

DirectionStack = {
    HorizontalDirectionStack = HorizontalDirectionStack,
    VerticalDirectionStack = VerticalDirectionStack
}

-- return DirectionStack