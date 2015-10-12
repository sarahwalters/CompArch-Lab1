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

endmodule
