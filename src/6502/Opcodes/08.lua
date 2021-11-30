-- PHP Push Flags onto Stack, Implied, 1 Byte, 3 Cycles

local mem = require(script.Parent.Parent.Memory)
local statusRegisters = require(script.Parent.Parent.Registers)
local internal = require(script.Parent.Parent.Internal)

return function()
    mem:Read(mem.programCounter + 1)

    mem:PokeStack(statusRegisters:ToByte(true))
    mem:ModifyStackPointer(mem.stackPointer - 1)
    internal:Cycle()
end