-- TAX Transfer Accumulator to X Register, Implied, 1 Bytes, 2 Cycles

local mem = require(script.Parent.Parent.Memory)
local statusRegisters = require(script.Parent.Parent.Registers)
local internal = require(script.Parent.Parent.Internal)

return function()
    internal:Cycle()

    mem.registers.x = mem.accumulator

    statusRegisters.negativeFlag = mem.registers.x > 127
    statusRegisters.zeroFlag = mem.registers.x == 0
end