-- STA Store Accumulator In Memory, Absolute Y, 3 Bytes, 5 Cycles

local mem = require(script.Parent.Parent.Memory)
local statusRegisters = require(script.Parent.Parent.Registers)
local internal = require(script.Parent.Parent.Internal)

local opVar = require(script.Parent.Parent.Util.OperatorVariations)
local addressingMode = require(script.Parent.Parent.Util.GetAddressByAddressingMode).addressingMode

return function()
    opVar.StoreAccumulatorInMemory(addressingMode.AbsoluteY)
    internal:Cycle()
end