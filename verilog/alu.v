module ALU (
    output[31:0]    result,
    output          carryout,
    output          zero,
    output          overflow,
    input[31:0]     operandA,
    input[31:0]     operandB,
    input[2:0]      command
);

    wire[31:0] signedB;

    wire initialSltKin, initialSltAnsIn, bPositive;
    `NOT1(bPositive, operandB[31]);
    `XNOR2(initialSltKin, operandA[31], operandB[31]);
    `AND2(initialSltAnsIn, operandA[31], bPositive);

    wire[30:0] addCarryouts; // 31 bit is ALU carryout
    wire[31:0] sltKouts;
    wire[31:0] sltAnsOuts;

    // flip bits of operandB for subtraction
    wire shouldFlip;
    wire[2:0] flipCommand;

    // only flip operandB if command is 3'b001 (subtraction)
    `NOT1(flipCommand[2], command[2]);
    `NOT1(flipCommand[1], command[1]);
    `BUF1(flipCommand[0], command[0]);
    `AND3(shouldFlip,
            flipCommand[2],
            flipCommand[1],
            flipCommand[0]);

    // only set flags if we're adding/subtracting (command=00x)
    wire setFlags;
    `NOR2(setFlags, command[2], command[1]);

    // flip the bits
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin:FLIP
            `XOR2(signedB[i], shouldFlip, operandB[i]);
        end
    endgenerate

    // this wire is 1 if there is a carryout on the addition.
    wire isCarryout;

    bitSlice msb(result[31],
                isCarryout,
                sltKouts[31],
                sltAnsOuts[31],
                operandA[31],
                signedB[31],
                command,
                addCarryouts[31 - 1],
                initialSltKin,
                initialSltAnsIn,
                1'b1
            );

    `AND2(carryout, isCarryout, setFlags);

    generate
        for (i = 1; i < 31; i = i + 1) begin:SLICE
            bitSlice b(result[i],
                        addCarryouts[i],
                        sltKouts[i],
                        sltAnsOuts[i],
                        operandA[i],
                        signedB[i],
                        command,
                        addCarryouts[i - 1],
                        sltKouts[i + 1],
                        sltAnsOuts[i + 1],
                        1'b0
                        );
        end
    endgenerate

    wire lsbResult;
    bitSlice lsb(lsbResult,
                addCarryouts[0],
                sltKouts[0],
                sltAnsOuts[0],
                operandA[0],
                signedB[0],
                command,
                command[0],
                sltKouts[0 + 1],
                sltAnsOuts[0 + 1],
                1'b0
                );

    wire doingSLT, notDoingSLT, sltCaseAns, notSltCaseAns;
    wire[2:0] isSLTCommand;

    `NOT1(isSLTCommand[2], command[2]);
    `BUF1(isSLTCommand[1], command[1]);
    `BUF1(isSLTCommand[0], command[0]);

    `AND3(doingSLT, isSLTCommand[0], isSLTCommand[1], isSLTCommand[2]);
    `NOT1(notDoingSLT, doingSLT);

    `AND2(sltCaseAns, doingSLT, sltAnsOuts[0]);
    `AND2(notSltCaseAns, notDoingSLT, lsbResult);

    `OR2(result[0], sltCaseAns, notSltCaseAns);

    // Addition flags if not set are 0. We're unsure if setting them to 0 or to
    // 1'bx is better practice.

    // overflow circuit from lab0
    wire AxnB, BxS;
    `XNOR2(AxnB, operandA[31], signedB[31]); //Overflow: A == B and S !== B
    `XOR2(BxS, signedB[31], result[31]);
    `AND3(overflow, AxnB, BxS, setFlags);

    wire isZero;
    `NOR32(isZero, result[0], result[1], result[2], result[3], result[4],
         result[5], result[6], result[7], result[8], result[9], result[10],
         result[11], result[12], result[13], result[14], result[15], result[16],
         result[17], result[18], result[19], result[20], result[21], result[22],
         result[23], result[24], result[25], result[26], result[27], result[28],
         result[29], result[30], result[31]);

    `AND2(zero, isZero, setFlags);

endmodule
