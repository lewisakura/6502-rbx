-- TAY Transfer Accumulator to Y Register, Implied, 1 Bytes, 2 Cycles

local mem = require(script.Parent.Parent.Memory)
local statusRegisters = require(script.Parent.Parent.Registers)
local internal = require(script.Parent.Parent.Internal)

return function()
    internal:Cycle()

    mem.registers.y = mem.accumulator

    statusRegisters.negativeFlag = mem.registers.y > 127
    statusRegisters.zeroFlag = mem.registers.y == 0
end