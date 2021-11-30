local registers = require(script.Parent.Registers)

local event = script.Parent.Events.Cycle

local internal = {
    cycleCount = 0,
    interrupt = false,
    previousInterrupt = false
}

function internal:Cycle()
    self.cycleCount += 1

    event:Fire()

    self.previousInterrupt = self.interrupt
    self.interrupt = registers.triggerNmi or (registers.triggerIRQ and not registers.disableInterruptFlag)
end

function internal:ResetCycle()
    self.cycleCount = 0
end

return internal