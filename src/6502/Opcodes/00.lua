-- BRK Simulate IRQ, Implied, 1 Byte, 7 Cycles

local mem = require(script.Parent.Parent.Memory)
local statusRegisters = require(script.Parent.Parent.Registers)
local internal = require(script.Parent.Parent.Internal)

local opVar = require(script.Parent.Parent.Util.OperatorVariations)

return function()
    opVar.BreakOperation(true, 0xFFFE)
end