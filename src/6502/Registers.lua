local registers = {
    carryFlag = false,
    zeroFlag = false,
    disableInterruptFlag = false,
    decimalFlag = false,
    overflowFlag = false,
    negativeFlag = false,
    triggerNmi = false,
    triggerIRQ = false
}

function registers:ToByte(setBreak: boolean): number
    return
        (if self.carryFlag then 0x01 else 0) +
        (if self.zeroFlag then 0x02 else 0) +
        (if self.disableInterruptFlag then 0x04 else 0) +
        (if self.decimalFlag then 8 else 0) +
        (if setBreak then 0x10 else 0) +
        0x20 +
        (if self.overflowFlag then 0x40 else 0) +
        (if self.negativeFlag then 0x80 else 0)
end

function registers:PullFlags(flags: number)
    self.carryFlag = bit32.band(flags, 0x01) ~= 0
    self.zeroFlag = bit32.band(flags, 0x02) ~= 0
    self.disableInterruptFlag = bit32.band(flags, 0x04) ~= 0
    self.decimalFlag = bit32.band(flags, 0x08) ~= 0
    self.overflowFlag = bit32.band(flags, 0x40) ~= 0
    self.negativeFlag = bit32.band(flags, 0x80) ~= 0
end

return registers