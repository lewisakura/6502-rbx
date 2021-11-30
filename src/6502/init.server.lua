-- 6502 Processor Emulator

local mem = require(script.Memory)
local statusRegisters = require(script.Registers)
local internal = require(script.Internal)
local opVar = require(script.Util.OperatorVariations)

function clearMemory()
    for i = 0, 0xFFFF do
        mem:_Write(i, 0)
    end
end

-- initialize memory
mem:ModifyStackPointer(0x100)
clearMemory()

function reset()
    internal.cycleCount = 0

    mem:ModifyStackPointer(0x1FD)
    mem:ModifyProgramCounter(0xFFFC)

    mem:ModifyProgramCounter(bit32.bor(mem:_Read(mem.programCounter), bit32.lshift(mem:_Read(mem.programCounter + 1), 8)))

    mem.currentOpcode = mem:_Read(mem.programCounter)

    statusRegisters.disableInterruptFlag = true
    statusRegisters.triggerNmi = false
    statusRegisters.triggerIRQ = false
end

function step()
    mem.currentOpcode = mem:Read(mem.programCounter)
    mem:ModifyProgramCounter(mem.programCounter + 1)

    local opcode = require(script.Opcodes[string.format("%02X", mem.currentOpcode)])
    if opcode then
        opcode()
    else
        error("Unimplemented opcode: " .. mem.currentOpcode)
    end

    if internal.previousInterrupt then
        if statusRegisters.triggerNmi then
            processNmi()
            statusRegisters.triggerNmi = false
        elseif statusRegisters.triggerIRQ then
            processIRQ()
            statusRegisters.triggerIRQ = false
        end
    end
end

function processNmi()
    mem:ModifyProgramCounter(mem.programCounter - 1)
    opVar.BreakOperation(false, 0xFFFA)
    mem.currentOpcode = mem:Read(mem.programCounter)
end

function processIRQ()
    if statusRegisters.disableInterruptFlag then return end

    mem:ModifyProgramCounter(mem.programCounter - 1)
    opVar.BreakOperation(false, 0xFFFE)
    mem.currentOpcode = mem:Read(mem.programCounter)
end

function loadProgram(offset: number, program: {number})
    if offset > 0x10000 then
        error("Offset is greater than 0x10000")
    end

    if #program > 0x10000 + offset then
        error("Program is too large (> 0x10000 + " .. offset .. ")")
    end

    for i = 1, #program do
        mem:_Write(offset + i - 1, program[i])
    end

    reset()
end

function loadProgramWithInitialProgramCounter(offset: number, program: {number}, initialProgramCounter: number)
    loadProgram(offset, program)

    local pc1 = bit32.band(initialProgramCounter, 0xFF)
    local pc2 = bit32.band(bit32.rshift(initialProgramCounter, 8), 0xFF)

    mem:Write(0xFFFC, pc1)
    mem:Write(0xFFFD, pc2)

    reset()
end

function loadProgramByName(name: string)
    local program = require(script.Programs[name])
    loadProgramWithInitialProgramCounter(program.memoryOffset, program.programData, program.programCounterStart)
end

-- bind to the bindablefunctions
script.Functions.GetInternal.OnInvoke = function()
    return internal
end

script.Functions.GetMemory.OnInvoke = function()
    return mem
end

script.Functions.GetStatusRegisters.OnInvoke = function()
    return statusRegisters
end

script.Functions.LoadProgram.OnInvoke = loadProgram
script.Functions.LoadProgramWithInitialProgramCounter.OnInvoke = loadProgramWithInitialProgramCounter
script.Functions.LoadProgramByName.OnInvoke = loadProgramByName
script.Functions.Step.OnInvoke = step