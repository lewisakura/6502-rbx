-- CLC Clear Carry Flag, Implied, 1 Byte, 2 Cycles

local mem = require(script.Parent.Parent.Memory)
local statusRegisters = require(script.Parent.Parent.Registers)
local internal = require(script.Parent.Parent.Internal)

return function()
    statusRegisters.carryFlag = false
    internal:Cycle()
end