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
