local require

do
  local requireCache = {}

  require = function(file)
	-- local absolute = shell.resolve(file)
    local absolute = file

	if requireCache[absolute] ~= nil then
	  --# Lucky day, this file has already been loaded once!
	  --# Return its cached result.
	  return requireCache[absolute]
	end

	--# Create a custom environment so that loaded
	--# source files also have access to require.
	local env = {
	  require = require
	}

	setmetatable(env, { __index = _G, __newindex = _G })

	--# Load the source file with loadfile, which
	--# also allows us to pass our custom environment.
    print("[Required]"..absolute)
	local chunk, err = loadfile("./"..absolute..".lua","bt", env)

	--# If chunk is nil, then there was a syntax error
	--# or the file does not exist.
	if chunk == nil then
	  return error(err)
	end

	--# Execute the file, cache and return its return value.
	local result = chunk()
	requireCache[absolute] = result
	return result
  end
end

turtle = {}
function turtle:getFuelLevel()
    return 10
end

gps = {}

local Directions = require("Directions")
local TurtleTurn = require("TurtleTurn")
local Stack = require("Stack")

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
