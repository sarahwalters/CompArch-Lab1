module ALU (
    output[31:0]    result,
    output          carryout,
    output          zero,
    output          overflow,
    input[31:0]     operandA,
    input[31:0]     operandB,
    input[2:0]      command
);

    wire initialSltKin, initialSltAnsIn;
    `XNOR(initialSltKin, operandA[31], operandB[31]);
    `AND(initialSltAnsIn, operandA[31], initialSltKin);

    wire[30:0] addCarryouts; // 31 bit is ALU carryout
    wire[31:0] sltKouts;
    wire[31:0] sltAnsOuts;

    // flip bits of operandB for subtraction
    wire shouldFlip;
    wire[2:0] flipCommand;

    // only flip operandB if command is 3'b001 (subtraction)
    `NOT(flipCommand[2], command[2]);
    `NOT(flipCommand[1], command[1]);
    `BUF(flipCommand[0], command[0]);
    `AND(shouldFlip, 
            flipCommand[2], 
            flipCommand[1], 
            flipCommand[0]);

    // flip the bits (might explode)
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin:FLIP
            `XOR(operandB[i], shouldFlip, operandB[i]);
        end
    endgenerate

    bitSlice msb(result[31], 
                carryout,
                sltKouts[31],
                sltAnsOuts[31],
                operandA[31],
                operandB[31],
                command,
                addCarryouts[31 - 1],
                initialSltKin,
                initialSltAnsIn,
                1'b1
                );

    generate
        for (i = 1; i < 31; i = i + 1) begin:SLICE
            bitSlice b(result[i], 
                        addCarryouts[i], 
                        sltKouts[i],
                        sltAnsOuts[i],
                        operandA[i],
                        operandB[i],
                        command,
                        addCarryouts[i - 1],
                        sltKouts[i + 1],
                        sltAnsOuts[i + 1],
                        1'b0
                        );
        end
    endgenerate

    bitSlice lsb(result[0], 
                addCarryouts[0], 
                sltKouts[0],
                sltAnsOuts[0],
                operandA[0],
                operandB[0],
                command,
                command[0],
                sltKouts[0 + 1],
                sltAnsOuts[0 + 1],
                1'b0
                );
endmodule
