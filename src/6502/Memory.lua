local internal = require(script.Parent.Internal)

local memory = {
    memory = {} :: {[number]: number},
    registers = {
        x = 0,
        y = 0
    },
    currentOpcode = 0,
    accumulator = 0,
    programCounter = 0,
    stackPointer = 0,
}

function memory:ModifyProgramCounter(value)
    self.programCounter = value
    self.programCounter = bit32.band(self.programCounter, 0xFFFF)
end

function memory:ModifyStackPointer(value)
    self.stackPointer = value
    if value > 0xFF then
        self.stackPointer = value - 0x100
    elseif value < 0x00 then
        self.stackPointer = value + 0x100
    end
end

-- get around 0 index limitations of lua
function memory:_Read(address: number)
    return self.memory[address + 1]
end

function memory:_Write(address: number, data: number)
    self.memory[address + 1] = data
end

function memory:Read(address: number): number
    local data = self:_Read(address)
    internal:Cycle()
    return data
end

function memory:Write(address: number, data: number)
    internal:Cycle()
    self:_Write(address, data)
end

function memory:PeekStack()
    return self:_Read(self.stackPointer + 0x100)
end

function memory:PokeStack(value: number)
    self:_Write(self.stackPointer + 0x100, value)
end

return memory