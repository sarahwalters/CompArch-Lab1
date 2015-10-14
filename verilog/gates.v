// define gates with delays
`define AND2 and #30 // 2 inputs and an inverter
`define AND3 and #40 // 3 inputs and an inverter
`define AND4 and #50 // 4 inputs and an inverter
`define NOT1 not #10
`define OR2 or #30 // 2 inputs and an inverter
`define OR8 or #90 // 8 inputs and an inverter
`define XOR2 xor #110 // 10 nand gates (see below) and an inverter
`define XNOR2 xnor #100 // can build a 2-input xnor with 5 nand gates -> 10 inputs
`define BUF1 buf #20 // 2 inverters
`define NOR2 nor #20 // 2 inputs
`define NOR32 nor #320 // 32 inputs
