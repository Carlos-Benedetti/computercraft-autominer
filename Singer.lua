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
