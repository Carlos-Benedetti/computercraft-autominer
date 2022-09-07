-- Directions.lua
Directions = {
    NORTH = "FORWARD",
    SOUTH = "BACK",
    DOWN = "DOWN",
    UP = "UP",
    WEST = "LEFT",
    EAST = "RIGHT"
}
-- return Directions

-- DirectionStack.lua
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

-- EnderChest.lua
EnderChest = {
    itemSlot = 1,
    placed = false
}

function EnderChest:new(o, slot --[[int]] , placed --[[boolean]] )
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.itemSlot = slot or 1
    self.placed = placed or false
    return o

end

function EnderChest:positionUp()

    if (turtle.detectUp()) then
        turtle.digUp()
    end

    turtle.up()

end

function EnderChest:goBackDown()

    if (turtle.detectDown()) then
        turtle.digDown()
    end

    turtle.down()
end

function EnderChest:place()
    print(teste)
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

-- return EnderChest

-- FixedSlot.lua
FixedSlot = {
    ENDERCHEST_SLOT = 1,
    FUEL_SLOT = 2,
    ORE1_SLOT = 3,
    ORE2_SLOT = 4,
    ORE3_SLOT = 5,
    ORE4_SLOT = 6,
    ORE5_SLOT = 7,
    ORE6_SLOT = 8,
    ORE7_SLOT = 9,
    ORE8_SLOT = 10
}
-- return FixedSlot

-- Fuel.lua
local thisEnderchest = EnderChest:new()

Fuel = {fThreshold=10,fSlot=FixedSlot.FUEL_SLOT}

function Fuel:FuelRoutine ()
    teste = "oi :)"
    local fLevel = turtle.getFuelLevel()

    if(fLevel <= self.fThreshold) then

        Singer:sing("Refueling")

        thisEnderchest:place()

        turtle.getItemDetail()

        SelectBuffer:save()

        turtle.select(self.fSlot)
        turtle.suckDown(10)
        turtle.refuel(turtle.getItemCount())
        SelectBuffer:load()

        thisEnderchest:retrive()

    end
end

-- return Fuel

-- Mine.lua
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

-- Prospector.lua
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

-- SelectBuffer.lua
SelectBuffer = {
    slot = nil --[[int]]
}

function SelectBuffer:save()
    self.slot = turtle.getSelectedSlot()
end

function SelectBuffer:load()
    turtle.select(self.slot)
end

-- return SelectBuffer

-- Singer.lua
Singer = {}
function Singer:sing(message)
    print(message)
end

function Singer:singFoundSelectedAt()
    local item = turtle.getItemDetail()

    if (item == nil) then
        return nil
    end

    local itemName = nil

    for k, v in pairs(self.oreSlots) do
        itemName = k
        break
    end

    local x, y, z = gps.locate(2)

    self.sing("Found [" .. itemName .. "] at (" .. x .. ", " .. y .. ", " .. z .. ")")

end

-- return Singer

-- Stack.lua
-- Stack Table
-- Uses a table as stack, use <table>:push(value) and <table>:pop()
-- Lua 5.1 compatible

-- GLOBAL
Stack = {}

-- Create a Table with stack functions
function Stack:Create()

  -- stack table
  local t = {}
  -- entry table
  t._et = {}

  -- push a value on to the stack
  function t:push(...)
    if ... then
      local targs = {...}
      -- add values
      for _,v in ipairs(targs) do
        table.insert(self._et, v)
      end
    end
  end

  -- pop a value from the stack
  function t:pop(num)

    -- get num values from stack
    local num = num or 1

    -- return table
    local entries = {}

    -- get values into entries
    for i = 1, num do
      -- get last entry
      if #self._et ~= 0 then
        table.insert(entries, self._et[#self._et])
        -- remove last value
        table.remove(self._et)
      else
        break
      end
    end
    -- return unpacked entries
    return unpack(entries)
  end

  -- get entries
  function t:getn()
    return #self._et
  end

  -- list values
  function t:list()
    for i,v in pairs(self._et) do
      print(i, v)
    end
  end
  return t
end

-- return Stack

-- TurtleTurn.lua
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

-- return TurtleTurn

