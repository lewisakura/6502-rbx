--[[
OPCODE     MNEMONIC   OPERANDS   FLAGS      CYCLES     LENGTH

0x00       BRK                   B          7          1
0x01       ORA        (ind,X)    SZ         6          2
0x05       ORA        zpg        SZ         3          2
0x06       ASL        zpg        SZC        5          2
0x08       PHP                              3          1
0x09       ORA        #          SZ         2          2
0x0a       ASL        A          SZC        2          1
0x0d       ORA        abs        SZ         4          3
0x0e       ASL        abs        SZC        6          3

0x10       BPL        rel                   2/1*       2
0x11       ORA        (ind),Y    SZ         5*         2
0x15       ORA        zpg,X      SZ         4          2
0x16       ASL        zpg,X      SZC        6          2
0x18       CLC                   C          2          1
0x19       ORA        abs,Y      SZ         4*         3
0x1d       ORA        abs,X      SZ         4*         3
0x1e       ASL        abs,X      SZC        7          3

0x20       JSR        abs                   6          3
0x21       AND        (ind,X)    SZ         6          2
0x24       BIT        zpg        NVZ        3          2
0x25       AND        zpg        SZ         3          2
0x26       ROL        zpg        SZC        5          2
0x28       PLP                              4          1
0x29       AND        #          SZ         2          2
0x2a       ROL        A          SZC        2          1
0x2c       BIT        abs        NVZ        4          3
0x2d       AND        abs        SZ         4          3
0x2e       ROL        abs        SZC        6          3

0x30       BMI        rel                   2/1*       2
0x31       AND        (ind),Y    SZ         5*         2
0x35       AND        zpg,X      SZ         4          2
0x36       ROL        zpg,X      SZC        6          2
0x38       SEC                   C          2          1
0x39       AND        abs,Y      SZ         4*         3
0x3d       AND        abs,X      SZ         4*         3
0x3e       ROL        abs,X      SZC        7          3

0x40       RTI                   SZCDVIB    6          1
0x41       EOR        (ind,X)    SZ         6          2
0x45       EOR        zpg        SZ         3          2
0x46       LSR        zpg        SZC        5          2
0x48       PHA                              3          1
0x49       EOR        #          SZ         2          2
0x4a       LSR        A          SZC        2          1
0x4c       JMP        abs                   3          3
0x4d       EOR        abs        SZ         4          3
0x4e       LSR        abs        SZC        6          3

0x50       BVC        rel                   2/1*       2
0x51       EOR        (ind),Y    SZ         5*         2
0x55       EOR        zpg,X      SZ         4          2
0x56       LSR        zpg,X      SZC        6          2
0x58       CLI                   I          2          1
0x59       EOR        abs,Y      SZ         4*         3
0x5d       EOR        abs,X      SZ         4*         3
0x5e       LSR        abs,X      SZC        7          3

0x60       RTS                              6          1
0x61       ADC        (ind,X)    SVZC       6          2
0x65       ADC        zpg        SVZC       3          2
0x66       ROR        zpg        SZC        5          2
0x68       PLA                              4          1
0x69       ADC        #          SVZC       2          2
0x6a       ROR        A          SZC        2          1
0x6c       JMP        (ind)                 5          3
0x6d       ADC        abs        SVZC       4          3
0x6e       ROR        abs        SZC        6          3

0x70       BVS        rel                   2/1*       2
0x71       ADC        (ind),Y    SVZC       5*         2
0x75       ADC        zpg,X      SVZC       4          2
0x76       ROR        zpg,X      SZC        6          2
0x78       SEI                   I          2          1
0x79       ADC        abs,Y      SVZC       4*         3
0x7d       ADC        abs,X      SVZC       4*         3
0x7e       ROR        abs,X      SZC        7          3

0x81       STA        (ind,X)               6          2
0x84       STY        zpg                   3          2
0x85       STA        zpg                   3          2
0x86       STX        zpg                   3          2
0x88       DEY                   SZ         2          1
0x8a       TXA                   SZ         2          1
0x8c       STY        abs                   4          3
0x8d       STA        abs                   4          3
0x8e       STX        abs                   4          3

0x90       BCC        rel                   2/1*       2
0x91       STA        (ind),Y               6          2
0x94       STY        zpg,X                 4          2
0x95       STA        zpg,X                 4          2
0x96       STX        zpg,Y                 4          2
0x98       TYA                   SZ         2          1
0x99       STA        abs,Y                 5          3
0x9a       TXS                              2          1
0x9d       STA        abs,X                 5          3

0xa0       LDY        #          SZ         2          2
0xa1       LDA        (ind,X)    SZ         6          2
0xa2       LDX        #          SZ         2          2
0xa4       LDY        zpg        SZ         3          2
0xa5       LDA        zpg        SZ         3          2
0xa6       LDX        zpg        SZ         3          2
0xa8       TAY                   SZ         2          1
0xa9       LDA        #          SZ         2          2
0xaa       TAX                   SZ         2          1
0xac       LDY        abs        SZ         4          3
0xad       LDA        abs        SZ         4          3
0xae       LDX        abs        SZ         4          3

0xb0       BCS        rel                   2/1*       2
0xb1       LDA        (ind),Y    SZ         5*         2
0xb4       LDY        zpg,X      SZ         4          2
0xb5       LDA        zpg,X      SZ         4          2
0xb6       LDX        zpg,Y      SZ         4          2
0xb8       CLV                   V          2          1
0xb9       LDA        abs,Y      SZ         4*         3
0xba       TSX                              2          1
0xbc       LDY        abs,X      SZ         4*         3
0xbd       LDA        abs,X      SZ         4*         3
0xbe       LDX        abs,Y      SZ         4*         3

0xc0       CPY        #          SZC        2          2
0xc1       CMP        (ind,X)    SZC        6          2
0xc4       CPY        zpg        SZC        3          2
0xc5       CMP        zpg        SZC        3          2
0xc6       DEC        zpg        SZ         5          2
0xc8       INY                              2          1
0xc9       CMP        #          SZC        2          2
0xca       DEX                   SZ         2          1
0xcc       CPY        abs        SZC        4          3
0xcd       CMP        abs        SZC        4          3
0xce       DEC        abs        SZ         6          3

0xd0       BNE        rel                   2/1*       2
0xd1       CMP        (ind),Y    SZC        5*         2
0xd5       CMP        zpg,X      SZC        4          2
0xd6       DEC        zpg,X      SZ         6          2
0xd8       CLD                   D          2          1
0xd9       CMP        abs,Y      SZC        4*         3
0xdd       CMP        abs,X      SZC        4*         3
0xde       DEC        abs,X      SZ         7          3

0xe0       CPX        #          SZC        2          2
0xe1       SBC        (ind,X)    SVZC       6          2
0xe4       CPX        zpg        SZC        3          2
0xe5       SBC        zpg        SVZC       3          2
0xe6       INC        zpg        SZ         5          2
0xe8       INX                   SZ         2          1
0xe9       SBC        #          SVZC       2          2
0xea       NOP                              2          1
0xec       CPX        abs        SZC        4          3
0xed       SBC        abs        SVZC       4          3
0xee       INC        abs        SZ         6          3

0xf0       BEQ        rel                   2/1*       2
0xf1       SBC        (ind),Y    SVZC       5*         2
0xf5       SBC        zpg,X      SVZC       4          2
0xf6       INC        zpg,X      SZ         6          2
0xf8       SED                   D          2          1
0xf9       SBC        abs,Y      SVZC       4*         3
0xfd       SBC        abs,X      SVZC       4*         3
0xfe       INC        abs,X      SZ         7          3
]]

return {
    [0x00] = {mnemonic = "BRK"; operands = nil;       flags = "B";       cycles = 7; bytes = 1},
    [0x01] = {mnemonic = "ORA"; operands = "(ind,X)"; flags = "SZ";      cycles = 6; bytes = 2},
    [0x02] = {mnemonic = "ORA"; operands = "zpg";     flags = "SZ";      cycles = 3; bytes = 2},
    [0x03] = {mnemonic = "ASL"; operands = "zpg";     flags = "SZC";     cycles = 5; bytes = 2},
    [0x04] = {mnemonic = "PHP"; operands = nil;       flags = nil;       cycles = 3; bytes = 1},
    [0x05] = {mnemonic = "ORA"; operands = "#";       flags = "SZ";      cycles = 2; bytes = 2},
    [0x06] = {mnemonic = "ASL"; operands = "zpg";     flags = "SZC";     cycles = 5; bytes = 2},
    [0x08] = {mnemonic = "PHP"; operands = nil;       flags = nil;       cycles = 3; bytes = 1},
    [0x09] = {mnemonic = "ORA"; operands = "#";       flags = "SZ";      cycles = 2; bytes = 2},
    [0x0a] = {mnemonic = "ASL"; operands = "A";       flags = "SZC";     cycles = 2; bytes = 1},
    [0x0d] = {mnemonic = "ORA"; operands = "abs";     flags = "SZ";      cycles = 4; bytes = 3},
    [0x0e] = {mnemonic = "ASL"; operands = "abs";     flags = "SZC";     cycles = 6; bytes = 3},

    [0x10] = {mnemonic = "BPL"; operands = "rel";     flags = nil;       cycles = 2; bytes = 2},
    [0x11] = {mnemonic = "ORA"; operands = "(ind),Y"; flags = "SZ";      cycles = 5; bytes = 2},
    [0x15] = {mnemonic = "ORA"; operands = "zpg,X";   flags = "SZ";      cycles = 4; bytes = 2},
    [0x16] = {mnemonic = "ASL"; operands = "zpg,X";   flags = "SZC";     cycles = 6; bytes = 2},
    [0x18] = {mnemonic = "CLC"; operands = nil;       flags = "C";       cycles = 2; bytes = 1},
    [0x19] = {mnemonic = "ORA"; operands = "abs,Y";   flags = "SZ";      cycles = 4; bytes = 3},
    [0x1d] = {mnemonic = "ORA"; operands = "abs,X";   flags = "SZ";      cycles = 4; bytes = 3},
    [0x1e] = {mnemonic = "ASL"; operands = "abs,X";   flags = "SZC";     cycles = 7; bytes = 3},

    [0x20] = {mnemonic = "JSR"; operands = "abs";     flags = nil;       cycles = 6; bytes = 3},
    [0x21] = {mnemonic = "AND"; operands = "(ind,X)"; flags = "SZ";      cycles = 6; bytes = 2},
    [0x24] = {mnemonic = "BIT"; operands = "zpg";     flags = "NVZ";     cycles = 3; bytes = 2},
    [0x25] = {mnemonic = "AND"; operands = "zpg";     flags = "SZ";      cycles = 3; bytes = 2},
    [0x26] = {mnemonic = "ROL"; operands = "zpg";     flags = "SZC";     cycles = 5; bytes = 2},
    [0x28] = {mnemonic = "PLP"; operands = nil;       flags = nil;       cycles = 4; bytes = 1},
    [0x29] = {mnemonic = "AND"; operands = "#";       flags = "SZ";      cycles = 2; bytes = 2},
    [0x2a] = {mnemonic = "ROL"; operands = "A";       flags = "SZC";     cycles = 2; bytes = 1},
    [0x2c] = {mnemonic = "BIT"; operands = "abs";     flags = "NVZ";     cycles = 4; bytes = 3},
    [0x2d] = {mnemonic = "AND"; operands = "abs";     flags = "SZ";      cycles = 4; bytes = 3},
    [0x2e] = {mnemonic = "ROL"; operands = "abs";     flags = "SZC";     cycles = 6; bytes = 3},

    [0x30] = {mnemonic = "BMI"; operands = "rel";     flags = nil;       cycles = 2; bytes = 2},
    [0x31] = {mnemonic = "AND"; operands = "(ind),Y"; flags = "SZ";      cycles = 5; bytes = 2},
    [0x35] = {mnemonic = "AND"; operands = "zpg,X";   flags = "SZ";      cycles = 4; bytes = 2},
    [0x36] = {mnemonic = "ROL"; operands = "zpg,X";   flags = "SZC";     cycles = 6; bytes = 2},
    [0x38] = {mnemonic = "SEC"; operands = nil;       flags = "C";       cycles = 2; bytes = 1},
    [0x39] = {mnemonic = "AND"; operands = "abs,Y";   flags = "SZ";      cycles = 4; bytes = 3},
    [0x3d] = {mnemonic = "AND"; operands = "abs,X";   flags = "SZ";      cycles = 4; bytes = 3},
    [0x3e] = {mnemonic = "ROL"; operands = "abs,X";   flags = "SZC";     cycles = 7; bytes = 3},

    [0x40] = {mnemonic = "RTI"; operands = nil;       flags = "SZCDVIB"; cycles = 6; bytes = 1},
    [0x41] = {mnemonic = "EOR"; operands = "(ind,X)"; flags = "SZ";      cycles = 6; bytes = 2},
    [0x45] = {mnemonic = "EOR"; operands = "zpg";     flags = "SZ";      cycles = 3; bytes = 2},
    [0x46] = {mnemonic = "LSR"; operands = "zpg";     flags = "SZC";     cycles = 5; bytes = 2},
    [0x48] = {mnemonic = "PHA"; operands = nil;       flags = nil;       cycles = 3; bytes = 1},
    [0x49] = {mnemonic = "EOR"; operands = "#";       flags = "SZ";      cycles = 2; bytes = 2},
    [0x4a] = {mnemonic = "LSR"; operands = "A";       flags = "SZC";     cycles = 2; bytes = 1},
    [0x4c] = {mnemonic = "JMP"; operands = "abs";     flags = nil;       cycles = 3; bytes = 3},
    [0x4d] = {mnemonic = "EOR"; operands = "abs";     flags = "SZ";      cycles = 4; bytes = 3},
    [0x4e] = {mnemonic = "LSR"; operands = "abs";     flags = "SZC";     cycles = 6; bytes = 3},

    [0x50] = {mnemonic = "BVC"; operands = "rel";     flags = nil;       cycles = 2; bytes = 2},
    [0x51] = {mnemonic = "EOR"; operands = "(ind),Y"; flags = "SZ";      cycles = 5; bytes = 2},
    [0x55] = {mnemonic = "EOR"; operands = "zpg,X";   flags = "SZ";      cycles = 4; bytes = 2},
    [0x56] = {mnemonic = "LSR"; operands = "zpg,X";   flags = "SZC";     cycles = 6; bytes = 2},
    [0x58] = {mnemonic = "CLI"; operands = nil;       flags = "I";       cycles = 2; bytes = 1},
    [0x59] = {mnemonic = "EOR"; operands = "abs,Y";   flags = "SZ";      cycles = 4; bytes = 3},
    [0x5d] = {mnemonic = "EOR"; operands = "abs,X";   flags = "SZ";      cycles = 4; bytes = 3},
    [0x5e] = {mnemonic = "LSR"; operands = "abs,X";   flags = "SZC";     cycles = 7; bytes = 3},

    [0x60] = {mnemonic = "RTS"; operands = nil;       flags = nil;       cycles = 6; bytes = 1},
    [0x61] = {mnemonic = "ADC"; operands = "(ind,X)"; flags = "SZC";     cycles = 6; bytes = 2},
    [0x65] = {mnemonic = "ADC"; operands = "zpg";     flags = "SZC";     cycles = 3; bytes = 2},
    [0x66] = {mnemonic = "ROR"; operands = "zpg";     flags = "SZC";     cycles = 5; bytes = 2},
    [0x68] = {mnemonic = "PLA"; operands = nil;       flags = nil;       cycles = 4; bytes = 1},
    [0x69] = {mnemonic = "ADC"; operands = "#";       flags = "SVZC";    cycles = 2; bytes = 2},
    [0x6a] = {mnemonic = "ROR"; operands = "A";       flags = "SZC";     cycles = 2; bytes = 1},
    [0x6c] = {mnemonic = "JMP"; operands = "ind";     flags = nil;       cycles = 5; bytes = 3},
    [0x6d] = {mnemonic = "ADC"; operands = "abs";     flags = "SVZC";    cycles = 4; bytes = 3},
    [0x6e] = {mnemonic = "ROR"; operands = "abs";     flags = "SZC";     cycles = 6; bytes = 3},

    [0x70] = {mnemonic = "BVS"; operands = "rel";     flags = nil;       cycles = 2; bytes = 2},
    [0x71] = {mnemonic = "ADC"; operands = "(ind),Y"; flags = "SVZC";    cycles = 5; bytes = 2},
    [0x75] = {mnemonic = "ADC"; operands = "zpg,X";   flags = "SVZC";    cycles = 4; bytes = 2},
    [0x76] = {mnemonic = "ROR"; operands = "zpg,X";   flags = "SZC";     cycles = 6; bytes = 2},
    [0x78] = {mnemonic = "SEI"; operands = nil;       flags = "I";       cycles = 2; bytes = 1},
    [0x79] = {mnemonic = "ADC"; operands = "abs,Y";   flags = "SVZC";    cycles = 4; bytes = 3},
    [0x7d] = {mnemonic = "ADC"; operands = "abs,X";   flags = "SVZC";    cycles = 4; bytes = 3},
    [0x7e] = {mnemonic = "ROR"; operands = "abs,X";   flags = "SZC";     cycles = 7; bytes = 3},

    [0x81] = {mnemonic = "STA"; operands = "(ind,X)"; flags = nil;       cycles = 6; bytes = 2},
    [0x84] = {mnemonic = "STY"; operands = "zpg";     flags = nil;       cycles = 3; bytes = 2},
    [0x85] = {mnemonic = "STA"; operands = "zpg";     flags = nil;       cycles = 3; bytes = 2},
    [0x86] = {mnemonic = "STX"; operands = "zpg";     flags = nil;       cycles = 3; bytes = 2},
    [0x88] = {mnemonic = "DEY"; operands = nil;       flags = "SZ";      cycles = 2; bytes = 1},
    [0x8a] = {mnemonic = "TXA"; operands = nil;       flags = "SZ";      cycles = 2; bytes = 1},
    [0x8c] = {mnemonic = "STY"; operands = "abs";     flags = nil;       cycles = 4; bytes = 3},
    [0x8d] = {mnemonic = "STA"; operands = "abs";     flags = nil;       cycles = 4; bytes = 3},
    [0x8e] = {mnemonic = "STX"; operands = "abs";     flags = nil;       cycles = 4; bytes = 3},

    [0x90] = {mnemonic = "BCC"; operands = "rel";     flags = nil;       cycles = 2; bytes = 2},
    [0x91] = {mnemonic = "STA"; operands = "(ind),Y"; flags = nil;       cycles = 6; bytes = 2},
    [0x94] = {mnemonic = "STY"; operands = "zpg,X";   flags = nil;       cycles = 4; bytes = 2},
    [0x95] = {mnemonic = "STA"; operands = "zpg,X";   flags = nil;       cycles = 4; bytes = 2},
    [0x96] = {mnemonic = "STX"; operands = "zpg,Y";   flags = nil;       cycles = 4; bytes = 2},
    [0x98] = {mnemonic = "TYA"; operands = nil;       flags = "SZ";      cycles = 2; bytes = 1},
    [0x99] = {mnemonic = "STA"; operands = "abs,Y";   flags = nil;       cycles = 5; bytes = 3},
    [0x9a] = {mnemonic = "TXS"; operands = nil;       flags = nil;       cycles = 2; bytes = 1},
    [0x9d] = {mnemonic = "STA"; operands = "abs,X";   flags = nil;       cycles = 5; bytes = 3},

    [0xa0] = {mnemonic = "LDY"; operands = "#";       flags = "SZ";      cycles = 2; bytes = 2},
    [0xa1] = {mnemonic = "LDA"; operands = "(ind,X)"; flags = "SZ";      cycles = 6; bytes = 2},
    [0xa2] = {mnemonic = "LDX"; operands = "#";       flags = "SZ";      cycles = 2; bytes = 2},
    [0xa4] = {mnemonic = "LDY"; operands = "zpg";     flags = "SZ";      cycles = 3; bytes = 2},
    [0xa5] = {mnemonic = "LDA"; operands = "zpg";     flags = "SZ";      cycles = 3; bytes = 2},
    [0xa6] = {mnemonic = "LDX"; operands = "zpg";     flags = "SZ";      cycles = 3; bytes = 2},
    [0xa8] = {mnemonic = "TAY"; operands = nil;       flags = "SZ";      cycles = 2; bytes = 1},
    [0xa9] = {mnemonic = "LDA"; operands = "#";       flags = "SZ";      cycles = 2; bytes = 2},
    [0xaa] = {mnemonic = "TAX"; operands = nil;       flags = "SZ";      cycles = 2; bytes = 1},
    [0xac] = {mnemonic = "LDY"; operands = "abs";     flags = "SZ";      cycles = 4; bytes = 3},
    [0xad] = {mnemonic = "LDA"; operands = "abs";     flags = "SZ";      cycles = 4; bytes = 3},
    [0xae] = {mnemonic = "LDX"; operands = "abs";     flags = "SZ";      cycles = 4; bytes = 3},

    [0xb0] = {mnemonic = "BCS"; operands = "rel";     flags = nil;       cycles = 2; bytes = 2},
    [0xb1] = {mnemonic = "LDA"; operands = "(ind),Y"; flags = "SZ";      cycles = 5; bytes = 2},
    [0xb4] = {mnemonic = "LDY"; operands = "zpg,X";   flags = "SZ";      cycles = 4; bytes = 2},
    [0xb5] = {mnemonic = "LDA"; operands = "zpg,X";   flags = "SZ";      cycles = 4; bytes = 2},
    [0xb6] = {mnemonic = "LDX"; operands = "zpg,Y";   flags = "SZ";      cycles = 4; bytes = 2},
    [0xb8] = {mnemonic = "CLV"; operands = nil;       flags = "V";       cycles = 2; bytes = 1},
    [0xb9] = {mnemonic = "LDA"; operands = "abs,Y";   flags = "SZ";      cycles = 4; bytes = 3},
    [0xba] = {mnemonic = "TSX"; operands = nil;       flags = nil;       cycles = 2; bytes = 1},
    [0xbc] = {mnemonic = "LDY"; operands = "abs,X";   flags = "SZ";      cycles = 4; bytes = 3},
    [0xbd] = {mnemonic = "LDA"; operands = "abs,X";   flags = "SZ";      cycles = 4; bytes = 3},
    [0xbe] = {mnemonic = "LDX"; operands = "abs,Y";   flags = "SZ";      cycles = 4; bytes = 3},

    [0xc0] = {mnemonic = "CPY"; operands = "#";       flags = "SZC";     cycles = 2; bytes = 2},
    [0xc1] = {mnemonic = "CMP"; operands = "(ind,X)"; flags = "SZC";     cycles = 6; bytes = 2},
    [0xc4] = {mnemonic = "CPY"; operands = "zpg";     flags = "SZC";     cycles = 3; bytes = 2},
    [0xc5] = {mnemonic = "CMP"; operands = "zpg";     flags = "SZC";     cycles = 3; bytes = 2},
    [0xc6] = {mnemonic = "DEC"; operands = "zpg";     flags = "SZC";     cycles = 5; bytes = 2},
    [0xc8] = {mnemonic = "INY"; operands = nil;       flags = nil;       cycles = 2; bytes = 1},
    [0xc9] = {mnemonic = "CMP"; operands = "#";       flags = "SZC";     cycles = 2; bytes = 2},
    [0xca] = {mnemonic = "DEX"; operands = nil;       flags = "SZ";      cycles = 2; bytes = 1},
    [0xcc] = {mnemonic = "CPY"; operands = "abs";     flags = "SZC";     cycles = 4; bytes = 3},
    [0xcd] = {mnemonic = "CMP"; operands = "abs";     flags = "SZC";     cycles = 4; bytes = 3},
    [0xce] = {mnemonic = "DEC"; operands = "abs";     flags = "SZC";     cycles = 6; bytes = 3},

    [0xd0] = {mnemonic = "BNE"; operands = "rel";     flags = nil;       cycles = 2; bytes = 2},
    [0xd1] = {mnemonic = "CMP"; operands = "(ind),Y"; flags = "SZC";     cycles = 5; bytes = 2},
    [0xd5] = {mnemonic = "CMP"; operands = "zpg,X";   flags = "SZC";     cycles = 4; bytes = 2},
    [0xd6] = {mnemonic = "DEC"; operands = "zpg,X";   flags = "SZC";     cycles = 6; bytes = 2},
    [0xd8] = {mnemonic = "CLD"; operands = nil;       flags = "D";       cycles = 2; bytes = 1},
    [0xd9] = {mnemonic = "CMP"; operands = "abs,Y";   flags = "SZC";     cycles = 4; bytes = 3},
    [0xdd] = {mnemonic = "CMP"; operands = "abs,X";   flags = "SZC";     cycles = 4; bytes = 3},
    [0xde] = {mnemonic = "DEC"; operands = "abs,X";   flags = "SZ";      cycles = 7; bytes = 3},

    [0xe0] = {mnemonic = "CPX"; operands = "#";       flags = "SZC";     cycles = 2; bytes = 2},
    [0xe1] = {mnemonic = "SBC"; operands = "(ind,X)"; flags = "SVZC";    cycles = 6; bytes = 2},
    [0xe4] = {mnemonic = "CPX"; operands = "zpg";     flags = "SZC";     cycles = 3; bytes = 2},
    [0xe5] = {mnemonic = "SBC"; operands = "zpg";     flags = "SVZC";    cycles = 3; bytes = 2},
    [0xe6] = {mnemonic = "INC"; operands = "zpg";     flags = "SZ";      cycles = 5; bytes = 2},
    [0xe8] = {mnemonic = "INX"; operands = nil;       flags = "SZ";      cycles = 2; bytes = 1},
    [0xe9] = {mnemonic = "SBC"; operands = "#";       flags = "SVZC";    cycles = 2; bytes = 2},
    [0xea] = {mnemonic = "NOP"; operands = nil;       flags = nil;       cycles = 2; bytes = 1},
    [0xec] = {mnemonic = "CPX"; operands = "abs";     flags = "SZC";     cycles = 4; bytes = 3},
    [0xed] = {mnemonic = "SBC"; operands = "abs";     flags = "SVZC";    cycles = 4; bytes = 3},
    [0xee] = {mnemonic = "INC"; operands = "abs";     flags = "SZC";     cycles = 6; bytes = 3},

    [0xf0] = {mnemonic = "BEQ"; operands = "rel";     flags = nil;       cycles = 2; bytes = 2},
    [0xf1] = {mnemonic = "SBC"; operands = "(ind),Y"; flags = "SVZC";    cycles = 5; bytes = 2},
    [0xf5] = {mnemonic = "SBC"; operands = "zpg,X";   flags = "SVZC";    cycles = 4; bytes = 2},
    [0xf6] = {mnemonic = "INC"; operands = "zpg,X";   flags = "SZ";      cycles = 6; bytes = 2},
    [0xf8] = {mnemonic = "SED"; operands = nil;       flags = "D";       cycles = 2; bytes = 1},
    [0xf9] = {mnemonic = "SBC"; operands = "abs,Y";   flags = "SVZC";    cycles = 4; bytes = 3},
    [0xfd] = {mnemonic = "SBC"; operands = "abs,X";   flags = "SVZC";    cycles = 4; bytes = 3},
    [0xfe] = {mnemonic = "INC"; operands = "abs,X";   flags = "SZ";      cycles = 7; bytes = 3}
}