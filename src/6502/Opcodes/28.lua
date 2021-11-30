-- PLP Pull Flags from Stack, Implied, 1 Byte, 4 Cycles

local mem = require(script.Parent.Parent.Memory)
local statusRegisters = require(script.Parent.Parent.Registers)
local internal = require(script.Parent.Parent.Internal)

return function()
    mem:Read(mem.programCounter + 1)
    mem:ModifyStackPointer(mem.stackPointer + 1)
    internal:Cycle()

    statusRegisters:PullFlags(mem:PeekStack())

    internal:Cycle()
end