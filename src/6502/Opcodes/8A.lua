-- TXA Transfer X Register to Accumulator, Implied, 1 Bytes, 2 Cycles

local mem = require(script.Parent.Parent.Memory)
local statusRegisters = require(script.Parent.Parent.Registers)
local internal = require(script.Parent.Parent.Internal)

return function()
    internal:Cycle()

    mem.accumulator = mem.registers.x

    statusRegisters.negativeFlag = mem.accumulator > 127
    statusRegisters.zeroFlag = mem.accumulator == 0
end