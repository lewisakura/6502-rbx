# 6502-rbx
A functional (I think) 6502 CPU emulator, ported from [6502Net](https://github.com/aaronmell/6502Net). No I/O just yet.

## Try it?
Why? [Here you go I guess...](https://www.roblox.com/games/8144510365/6502-CPU)

## Prep
Download the place from the above game, then run `rojo serve`. You can now develop on the emulator.

## Assembling code
Write your code in 6502 Assembly, then use [as65](http://www.kingswood-consulting.co.uk/assemblers/) to assemble your code.
Afterwards, run `node ./a65ToLua.js ./output.bin ./output.lua` to convert it into a program you can load into 6502-rbx.
Put this Lua file into the `src/6502/Programs`. Configure your `memoryOffset` and `programCounterStart` to whatever your
program requires.

## Running code
If you want to run code with all the fancy bells and whistles that the example provides, edit `src/TestScript.server.lua`
and adjust the 10th line to whatever your program name is.