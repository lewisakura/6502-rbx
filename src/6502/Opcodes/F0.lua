-- BEQ Branch if Zero is Set, Relative, 2 Bytes, 2+ Cycles

local mem = require(script.Parent.Parent.Memory)
local statusRegisters = require(script.Parent.Parent.Registers)
local internal = require(script.Parent.Parent.Internal)

local opVar = require(script.Parent.Parent.Util.OperatorVariations)

return function()
    opVar.BranchOperation(statusRegisters.zeroFlag)
end