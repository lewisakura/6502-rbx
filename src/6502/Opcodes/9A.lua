-- TXS Transfer X Register to Stack Pointer, 1 Bytes, 2 Cycles

local mem = require(script.Parent.Parent.Memory)
local statusRegisters = require(script.Parent.Parent.Registers)
local internal = require(script.Parent.Parent.Internal)

return function()
    mem.stackPointer = mem.registers.x

    internal:Cycle()
end