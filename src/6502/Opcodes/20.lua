-- JSR Jump to SubRoutine, Absolute, 3 Bytes, 6 Cycles

local mem = require(script.Parent.Parent.Memory)
local statusRegisters = require(script.Parent.Parent.Registers)
local internal = require(script.Parent.Parent.Internal)

local gabam = require(script.Parent.Parent.Util.GetAddressByAddressingMode)
local getAddressByAddressingMode = gabam.getAddressByAddressingMode
local addressingMode = gabam.addressingMode

return function()
    internal:Cycle()

    mem:PokeStack(bit32.band(bit32.rshift(mem.programCounter + 1, 8), 0xFF))
    mem:ModifyStackPointer(mem.stackPointer - 1)
    internal:Cycle()

    mem:PokeStack(bit32.band(mem.programCounter + 1, 0xFF))
    mem:ModifyStackPointer(mem.stackPointer - 1)
    internal:Cycle()

    mem.programCounter = getAddressByAddressingMode(addressingMode.Absolute)
end