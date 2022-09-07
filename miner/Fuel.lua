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