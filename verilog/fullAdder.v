module fullAdder(
   output out,
   output addCarryout,
   input a,
   input b,
   input addCarryIn
);

    wire AxorB, fullAnd, AandB;

    `XOR(AxorB, a, b);
    `AND(AandB, a, b);
    `AND(fullAnd, addCarryIn, AxorB);

    `XOR(out, AxorB, addCarryIn);
    `XOR(addCarryout, AandB, fullAnd);

endmodule
