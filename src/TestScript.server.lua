local funcs = game.ServerScriptService["6502"].Functions
local events = game.ServerScriptService["6502"].Events

local physicalRegisters = workspace.FlagView
local instructionView = workspace.InstructionBoard.UI
local registerView = workspace.Registers.UI

local opcodeData = require(script.Parent["6502"].OpcodeMap)

funcs.LoadProgramByName:Invoke("6502_functional_test")

events.Cycle.Event:Connect(function()
    local registers = funcs.GetStatusRegisters:Invoke()
    local memState = funcs.GetMemory:Invoke()

    local on = Color3.new(0, 1, 0)
    local off = Color3.new(1, 0, 0)

    physicalRegisters.Carry.Color = registers.carryFlag and on or off
    physicalRegisters.Zero.Color = registers.zeroFlag and on or off
    physicalRegisters.DisableInterrupt.Color = registers.disableInterruptFlag and on or off
    physicalRegisters.Decimal.Color = registers.decimalFlag and on or off
    physicalRegisters.Overflow.Color = registers.overflowFlag and on or off
    physicalRegisters.Negative.Color = registers.negativeFlag and on or off

    physicalRegisters.TriggerNmi.Color = registers.triggerNmi and on or off
    physicalRegisters.TriggerIRQ.Color = registers.triggerIRQ and on or off

    registerView.X.Text = string.format("%02X", memState.registers.x)
    registerView.Y.Text = string.format("%02X", memState.registers.y)
    registerView.A.Text = string.format("%02X", memState.accumulator)
    registerView.PC.Text = string.format("%02X", memState.programCounter)
    registerView.SP.Text = string.format("%02X", memState.stackPointer)
end)

while task.wait() do
    local memState = funcs.GetMemory:Invoke()
    local currentInstruction = memState:_Read(memState.programCounter)

    local opcodeInfo = opcodeData[currentInstruction]

    instructionView.OP.Text = string.format("0x%02X", currentInstruction)
    instructionView.MN.Text = opcodeInfo.mnemonic
    instructionView.OPR.Text = opcodeInfo.operands or ""
    instructionView.FL.Text = opcodeInfo.flags or ""
    instructionView.CY.Text = opcodeInfo.cycles
    instructionView.LEN.Text = opcodeInfo.bytes

    funcs.Step:Invoke()
end