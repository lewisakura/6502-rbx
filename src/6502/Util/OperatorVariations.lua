local operatorVariations = {}

local mem = require(script.Parent.Parent.Memory)
local statusRegisters = require(script.Parent.Parent.Registers)
local internal = require(script.Parent.Parent.Internal)

local gabam = require(script.Parent.GetAddressByAddressingMode)
local getAddressByAddressingMode = gabam.getAddressByAddressingMode
local AddressingMode = gabam.addressingMode

function operatorVariations.AddWithCarryOperation(addressingMode: number)
    local memoryValue = mem:Read(getAddressByAddressingMode(addressingMode))
    local newValue = memoryValue + mem.accumulator + (statusRegisters.carryFlag and 1 or 0)

    statusRegisters.overflowFlag =
        bit32.band(bit32.bxor(mem.accumulator, newValue), 0x80) ~= 0 and bit32.band(bit32.bxor(mem.accumulator, memoryValue), 0x80) == 0

    if statusRegisters.decimalFlag then
        newValue = tonumber(string.format("%X", memoryValue))
            + tonumber(string.format("%X", mem.accumulator))
            + (statusRegisters.carryFlag and 1 or 0)

        if newValue > 99 then
            statusRegisters.carryFlag = true
            newValue -= 100
        else
            statusRegisters.carryFlag = false
        end

        newValue = tonumber("0x" .. newValue)
    else
        if newValue > 255 then
            statusRegisters.carryFlag = true
            newValue -= 256
        else
            statusRegisters.carryFlag = false
        end
    end

    statusRegisters.zeroFlag = newValue == 0
    statusRegisters.negativeFlag = newValue > 127

    mem.accumulator = newValue
end

function operatorVariations.SubtractWithBorrowOperation(addressingMode: number)
    local memoryValue = mem:Read(getAddressByAddressingMode(addressingMode))
    local newValue = if statusRegisters.decimalFlag then
            tonumber(string.format("%X", mem.accumulator)) - tonumber(string.format("%X", memoryValue)) - (statusRegisters.carryFlag and 1 or 0)
        else
            mem.accumulator - memoryValue - (statusRegisters.carryFlag and 1 or 0)

    statusRegisters.carryFlag = newValue >= 0

    if statusRegisters.decimalFlag then
        if newValue < 0 then
            newValue += 100
        end

        newValue = tonumber("0x" .. newValue)
    else
        statusRegisters.overflowFlag =
            bit32.band(bit32.bxor(mem.accumulator, newValue), 0x80) ~= 0 and bit32.band(bit32.bxor(mem.accumulator, memoryValue), 0x80) ~= 0

        if newValue < 0 then
            newValue += 256
        end
    end

    statusRegisters.negativeFlag = newValue > 127
    statusRegisters.zeroFlag = newValue == 0

    mem.accumulator = newValue
end

function operatorVariations.BreakOperation(isBrk: boolean, vector: number)
    mem:ModifyProgramCounter(mem.programCounter + 1)
    mem:Read(mem.programCounter)

    mem:PokeStack(bit32.band(bit32.rshift(mem.programCounter, 8), 0xFF))
    mem:ModifyStackPointer(mem.stackPointer - 1)
    internal:Cycle()

    mem:PokeStack(bit32.band(mem.programCounter, 0xFF))
    mem:ModifyStackPointer(mem.stackPointer - 1)
    internal:Cycle()

    if isBrk then
        mem:PokeStack(bit32.bor(statusRegisters:ToByte(true), 0x10))
    else
        mem:PokeStack(statusRegisters:ToByte(false))
    end

    mem:ModifyStackPointer(mem.stackPointer - 1)
    internal:Cycle()

    statusRegisters.disableInterruptFlag = true

    mem.programCounter = bit32.bor(bit32.lshift(mem:Read(vector + 1), 8), mem:Read(vector))

    internal.previousInterrupt = false
end

function operatorVariations.BranchOperation(performBranch: boolean)
    local value = mem:Read(getAddressByAddressingMode(AddressingMode.Relative))

    if not performBranch then
        mem:ModifyProgramCounter(mem.programCounter + 1)
        return
    end

    local movement = if value > 127 then value - 255 else value
    local newProgramCounter = mem.programCounter + movement

    if movement >= 0 then
        newProgramCounter += 1
    end

    if bit32.band(bit32.bxor(mem.programCounter + 1, newProgramCounter), 0xFF00) ~= 0 then
        internal:Cycle()
    end

    mem.programCounter = newProgramCounter
    mem:Read(mem.programCounter)
end

function operatorVariations.AndOperation(addressingMode: number)
    mem.accumulator = bit32.band(mem:Read(getAddressByAddressingMode(addressingMode)), mem.accumulator)

    statusRegisters.zeroFlag = mem.accumulator == 0
    statusRegisters.negativeFlag = mem.accumulator > 127
end

function operatorVariations.BitOperation(addressingMode: number)
    local memoryValue = mem:Read(getAddressByAddressingMode(addressingMode))
    local valueToCompare = bit32.band(memoryValue, mem.accumulator)

    statusRegisters.overflowFlag = bit32.band(memoryValue, 0x40) ~= 0

    statusRegisters.negativeFlag = memoryValue > 127
    statusRegisters.zeroFlag = valueToCompare == 0
end

function operatorVariations.EorOperation(addressingMode: number)
    mem.accumulator = bit32.bxor(mem.accumulator, mem:Read(getAddressByAddressingMode(addressingMode)))

    statusRegisters.negativeFlag = mem.accumulator > 127
    statusRegisters.zeroFlag = mem.accumulator == 0
end

function operatorVariations.OrOperation(addressingMode: number)
    mem.accumulator = bit32.bor(mem.accumulator, mem:Read(getAddressByAddressingMode(addressingMode)))

    statusRegisters.negativeFlag = mem.accumulator > 127
    statusRegisters.zeroFlag = mem.accumulator == 0
end

function operatorVariations.CompareOperation(addressingMode: number, comparisionValue: number)
    local memoryValue = mem:Read(getAddressByAddressingMode(addressingMode))
    local comparedValue = comparisionValue - memoryValue

    if comparedValue < 0 then
        comparedValue += 0x10000
    end

    statusRegisters.zeroFlag = comparedValue == 0
    statusRegisters.carryFlag = memoryValue <= comparisionValue
    statusRegisters.negativeFlag = comparedValue > 127
end

function operatorVariations.ChangeMemoryByOne(addressingMode: number, decrement: boolean)
    local memoryLocation = getAddressByAddressingMode(addressingMode)
    local memory = mem:Read(memoryLocation)

    mem:Write(memoryLocation, memory)

    if decrement then
        memory -= 1
    else
        memory += 1
    end

    statusRegisters.zeroFlag = memory == 0
    statusRegisters.negativeFlag = memory > 127

    mem:Write(memoryLocation, memory)
end

function operatorVariations.ChangeRegisterByOne(xRegister: boolean, decrement: boolean)
    local value = xRegister and mem.registers.x or mem.registers.y

    if decrement then
        value -= 1
    else
        value += 1
    end

    if value < 0x00 then
        value += 0x100
    elseif value > 0xFF then
        value -= 0x100
    end

    statusRegisters.zeroFlag = value == 0
    statusRegisters.negativeFlag = value > 127

    internal:Cycle()

    if xRegister then
        mem.registers.x = value
    else
        mem.registers.y = value
    end
end

function operatorVariations.LoadAccumulatorWithMemory(addressingMode: number)
    mem.accumulator = mem:Read(getAddressByAddressingMode(addressingMode))
    statusRegisters.zeroFlag = mem.accumulator == 0
    statusRegisters.negativeFlag = mem.accumulator > 127
end

function operatorVariations.LoadRegisterWithMemory(xRegister: boolean, addressingMode: number)
    if xRegister then
        mem.registers.x = mem:Read(getAddressByAddressingMode(addressingMode))
    else
        mem.registers.y = mem:Read(getAddressByAddressingMode(addressingMode))
    end
    statusRegisters.zeroFlag = if xRegister then mem.registers.x == 0 else mem.registers.y == 0
    statusRegisters.negativeFlag = if xRegister then mem.registers.x > 127 else mem.registers.y > 127
end

function operatorVariations.AslOperation(addressingMode: number)
    local value: number
    local memoryAddress = 0

    if addressingMode == AddressingMode.Accumulator then
        mem:Read(mem.programCounter + 1)
        value = mem.accumulator
    else
        memoryAddress = getAddressByAddressingMode(addressingMode)
        value = mem:Read(memoryAddress)
    end

    if addressingMode ~= AddressingMode.Accumulator then
        mem:Write(memoryAddress, value)
    end

    statusRegisters.carryFlag = bit32.band(value, 0x80) ~= 0

    value = bit32.band(bit32.lshift(value, 1), 0xFE)

    statusRegisters.negativeFlag = value > 127
    statusRegisters.zeroFlag = value == 0

    if addressingMode == AddressingMode.Accumulator then
        mem.accumulator = value
    else
        mem:Write(memoryAddress, value)
    end
end

function operatorVariations.LsrOperation(addressingMode: number)
    local value: number
    local memoryAddress = 0

    if addressingMode == AddressingMode.Accumulator then
        mem:Read(mem.programCounter + 1)
        value = mem.accumulator
    else
        memoryAddress = getAddressByAddressingMode(addressingMode)
        value = mem:Read(memoryAddress)
    end

    if addressingMode ~= AddressingMode.Accumulator then
        mem:Write(memoryAddress, value)
    end

    statusRegisters.negativeFlag = false

    statusRegisters.carryFlag = bit32.band(value, 0x01) ~= 0

    value = bit32.rshift(value, 1)

    statusRegisters.zeroFlag = value == 0

    if addressingMode == AddressingMode.Accumulator then
        mem.accumulator = value
    else
        mem:Write(memoryAddress, value)
    end
end

function operatorVariations.RolOperation(addressingMode: number)
    local value: number
    local memoryAddress = 0

    if addressingMode == AddressingMode.Accumulator then
        mem:Read(mem.programCounter + 1)
        value = mem.accumulator
    else
        memoryAddress = getAddressByAddressingMode(addressingMode)
        value = mem:Read(memoryAddress)
    end

    if addressingMode ~= AddressingMode.Accumulator then
        mem:Write(memoryAddress, value)
    end

    local newCarry = bit32.band(0x80, value) ~= 0

    value = bit32.band(bit32.lshift(value, 1), 0xFE)

    if statusRegisters.carryFlag then
        value = bit32.bor(value, 0x01)
    end

    statusRegisters.carryFlag = newCarry

    statusRegisters.zeroFlag = value == 0
    statusRegisters.negativeFlag = value > 127

    if addressingMode == AddressingMode.Accumulator then
        mem.accumulator = value
    else
        mem:Write(memoryAddress, value)
    end
end

function operatorVariations.RorOperation(addressingMode: number)
    local value: number
    local memoryAddress = 0

    if addressingMode == AddressingMode.Accumulator then
        mem:Read(mem.programCounter + 1)
        value = mem.accumulator
    else
        memoryAddress = getAddressByAddressingMode(addressingMode)
        value = mem:Read(memoryAddress)
    end

    if addressingMode ~= AddressingMode.Accumulator then
        mem:Write(memoryAddress, value)
    end

    local newCarry = bit32.band(0x01, value) ~= 0

    value = bit32.rshift(value, 1)

    if statusRegisters.carryFlag then
        value = bit32.bor(value, 0x80)
    end

    statusRegisters.carryFlag = newCarry

    statusRegisters.zeroFlag = value == 0
    statusRegisters.negativeFlag = value > 127

    if addressingMode == AddressingMode.Accumulator then
        mem.accumulator = value
    else
        mem:Write(memoryAddress, value)
    end
end

function operatorVariations.StoreAccumulatorInMemory(addressingMode: number)
    mem:Write(getAddressByAddressingMode(addressingMode), mem.accumulator)
end

function operatorVariations.StoreRegisterInMemory(xRegister: boolean, addressingMode: number)
    mem:Write(getAddressByAddressingMode(addressingMode), if xRegister then mem.registers.x else mem.registers.y)
end

return operatorVariations