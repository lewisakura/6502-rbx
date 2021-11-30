-- SEI Set Interrupt, Implied, 1 Bytes, 2 Cycles

local mem = require(script.Parent.Parent.Memory)
local statusRegisters = require(script.Parent.Parent.Registers)
local internal = require(script.Parent.Parent.Internal)

return function()
    statusRegisters.disableInterruptFlag = true
    internal:Cycle()
end