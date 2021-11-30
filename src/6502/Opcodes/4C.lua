-- JMP Jump to New Location, Absolute, 3 Bytes, 3 Cycles

local mem = require(script.Parent.Parent.Memory)
local statusRegisters = require(script.Parent.Parent.Registers)
local internal = require(script.Parent.Parent.Internal)

local gabam = require(script.Parent.Parent.Util.GetAddressByAddressingMode)
local getAddressByAddressingMode = gabam.getAddressByAddressingMode
local addressingMode = gabam.addressingMode

return function()
    mem.programCounter = getAddressByAddressingMode(addressingMode.Absolute)
end