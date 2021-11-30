-- ASL Shift Left 1 Bit Memory or Accumulator, Absolute X, 2 Bytes, 7 Cycles

local mem = require(script.Parent.Parent.Memory)
local statusRegisters = require(script.Parent.Parent.Registers)
local internal = require(script.Parent.Parent.Internal)

local opVar = require(script.Parent.Parent.Util.OperatorVariations)
local addressingMode = require(script.Parent.Parent.Util.GetAddressByAddressingMode).addressingMode

return function()
    opVar.AslOperation(addressingMode.AbsoluteX)
    internal:Cycle()
end