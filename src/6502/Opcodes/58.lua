-- CLI Clear Interrupt Flag, Implied, 1 Byte, 2 Cycles

local mem = require(script.Parent.Parent.Memory)
local statusRegisters = require(script.Parent.Parent.Registers)
local internal = require(script.Parent.Parent.Internal)

return function()
    statusRegisters.disableInterruptFlag = false
    internal:Cycle()
end