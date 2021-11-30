local memory = require(script.Parent.Memory)
local statusRegisters = require(script.Parent.Registers)
local internal = require(script.Parent.Internal)

export type Memory = typeof(memory)
export type StatusRegisters = typeof(statusRegisters)
export type Internal = typeof(internal)

return nil