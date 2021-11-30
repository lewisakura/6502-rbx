-- RTI Return From Interrupt, Implied, 1 Byte, 6 Cycles

local mem = require(script.Parent.Parent.Memory)
local statusRegisters = require(script.Parent.Parent.Registers)
local internal = require(script.Parent.Parent.Internal)

return function()
    mem:ModifyProgramCounter(mem.programCounter + 1)
    mem:Read(mem.programCounter)
    internal:Cycle()

    statusRegisters:PullFlags(mem:PeekStack())
    mem:ModifyStackPointer(mem.stackPointer + 1)
    internal:Cycle()

    local lowBit = mem:PeekStack()
    mem:ModifyStackPointer(mem.stackPointer + 1)
    internal:Cycle()

    local highBit = bit32.lshift(mem:PeekStack(), 8)
    internal:Cycle()

    mem.programCounter = bit32.bor(highBit, lowBit)
end