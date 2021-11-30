-- LDA Load Accumulator with Memory, Indexed Indirect, 2 Bytes, 6 Cycles

local mem = require(script.Parent.Parent.Memory)
local statusRegisters = require(script.Parent.Parent.Registers)
local internal = require(script.Parent.Parent.Internal)

local opVar = require(script.Parent.Parent.Util.OperatorVariations)
local addressingMode = require(script.Parent.Parent.Util.GetAddressByAddressingMode).addressingMode

return function()
    opVar.LoadAccumulatorWithMemory(addressingMode.IndirectX)
end