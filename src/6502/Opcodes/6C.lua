-- JMP Jump to New Location, Indirect, 3 Bytes, 5 Cycles

local mem = require(script.Parent.Parent.Memory)
local statusRegisters = require(script.Parent.Parent.Registers)
local internal = require(script.Parent.Parent.Internal)

local gabam = require(script.Parent.Parent.Util.GetAddressByAddressingMode)
local getAddressByAddressingMode = gabam.getAddressByAddressingMode
local addressingMode = gabam.addressingMode

return function()
    mem.programCounter = getAddressByAddressingMode(addressingMode.Absolute)

    if bit32.band(mem.programCounter, 0xFF) == 0xFF then
        local address = mem:Read(mem.programCounter)

        address += 256 * mem:Read(mem.programCounter - 255)
        mem.programCounter = address
    else
        mem.programCounter = getAddressByAddressingMode(addressingMode.Absolute)
    end
end