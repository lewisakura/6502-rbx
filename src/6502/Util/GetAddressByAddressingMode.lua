local mem = require(script.Parent.Parent.Memory)
local statusRegisters = require(script.Parent.Parent.Registers)
local internal = require(script.Parent.Parent.Internal)

local addressingMode = {
    Absolute = 0,
    AbsoluteX = 1,
    AbsoluteY = 2,
    Immediate = 3,
    IndirectX = 4,
    IndirectY = 5,
    Relative = 6,
    ZeroPage = 7,
    ZeroPageX = 8,
    ZeroPageY = 9,
    Accumulator = 10 -- not handled by this function, handled in ASL and LSR
}

function getAddressByAddressingMode(mode: number)
    if mode == addressingMode.Absolute then
        local a = mem:Read(mem.programCounter)
        mem:ModifyProgramCounter(mem.programCounter + 1)
        local b = mem:Read(mem.programCounter)
        mem:ModifyProgramCounter(mem.programCounter + 1)
        return bit32.bor(a, bit32.lshift(b, 8))
    elseif mode == addressingMode.AbsoluteX then
        local address = mem:Read(mem.programCounter)
        mem:ModifyProgramCounter(mem.programCounter + 1)
        local highByte = mem:Read(mem.programCounter)
        mem:ModifyProgramCounter(mem.programCounter + 1)

        if (address + mem.registers.x) > 0xFF then
            if mem.currentOpcode == 0x1E or
                mem.currentOpcode == 0xDE or
                mem.currentOpcode == 0xFE or
                mem.currentOpcode == 0x5E or
                mem.currentOpcode == 0x3E or
                mem.currentOpcode == 0x7E or
                mem.currentOpcode == 0x9D
            then
                return bit32.band(bit32.bor(bit32.lshift(highByte, 8), address) + mem.registers.x, 0xFFFF)
            else
                mem:Read(bit32.band((bit32.bor(bit32.lshift(highByte, 8), address) + mem.registers.x) - 0xFF, 0xFFFF))
            end
        end

        return bit32.band(bit32.bor(bit32.lshift(highByte, 8), address) + mem.registers.x, 0xFFFF)
    elseif mode == addressingMode.AbsoluteY then
        local address = mem:Read(mem.programCounter)
        mem:ModifyProgramCounter(mem.programCounter + 1)
        local highByte = mem:Read(mem.programCounter)
        mem:ModifyProgramCounter(mem.programCounter + 1)

        if (address + mem.registers.y) > 0xFF and mem.currentOpcode ~= 0x99 then
            mem:Read(bit32.band((bit32.bor(bit32.lshift(highByte, 8), address) + mem.registers.y) - 0xFF, 0xFFFF))
        end

        return bit32.band(bit32.bor(bit32.lshift(highByte, 8), address) + mem.registers.y, 0xFFFF)
    elseif mode == addressingMode.Immediate then
        local pc = mem.programCounter
        mem:ModifyProgramCounter(mem.programCounter + 1)
        return pc
    elseif mode == addressingMode.IndirectX then
        local address = mem:Read(mem.programCounter)
        mem:ModifyProgramCounter(mem.programCounter + 1)

        mem:Read(address)

        address += mem.registers.x

        local finalAddress = mem:Read(
            bit32.bor(
                bit32.band(address, 0xFF),
                bit32.lshift(mem:Read(bit32.band(address + 1, 0xFF)), 8)
            )
        )

        return finalAddress
    elseif mode == addressingMode.IndirectY then
        local address = mem:Read(mem.programCounter)
        mem:ModifyProgramCounter(mem.programCounter + 1)

        local finalAddress = mem:Read(address) + bit32.lshift(mem:Read(bit32.band(address + 1, 0xFF)), 8)

        if bit32.band(finalAddress, 0xFF) + mem.registers.y > 0xFF and mem.currentOpcode ~= 0x91 then
            mem:Read(bit32.band(finalAddress + mem.registers.y - 0xFF, 0xFFFF))
        end

        return bit32.band(finalAddress + mem.registers.y, 0xFFFF)
    elseif mode == addressingMode.Relative then
        return mem.programCounter
    elseif mode == addressingMode.ZeroPage then
        local address = mem:Read(mem.programCounter)
        mem:ModifyProgramCounter(mem.programCounter + 1)
        return address
    elseif mode == addressingMode.ZeroPageX then
        local address = mem:Read(mem.programCounter)
        mem:ModifyProgramCounter(mem.programCounter + 1)

        mem:Read(address)

        address += mem.registers.x
        address = bit32.band(address, 0xFF)

        if address > 0xFF then
            address -= 0x100
        end

        return address
    elseif mode == addressingMode.ZeroPageY then
        local address = mem:Read(mem.programCounter)
        mem:ModifyProgramCounter(mem.programCounter + 1)

        mem:Read(address)

        address += mem.registers.y
        address = bit32.band(address, 0xFF)

        return address
    else
        error("No addressing mode found for " .. mode)
    end
end

return {
    addressingMode = addressingMode,
    getAddressByAddressingMode = getAddressByAddressingMode,
}