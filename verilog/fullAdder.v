module fullAdder(
   output out,
   output addCarryout,
   input a,
   input b,
   input addCarryIn
);

    wire AxorB, fullAnd, AandB;

    `XOR2(AxorB, a, b);
    `AND2(AandB, a, b);
    `AND2(fullAnd, addCarryIn, AxorB);

    `XOR2(out, AxorB, addCarryIn);
    `XOR2(addCarryout, AandB, fullAnd);

endmodule
