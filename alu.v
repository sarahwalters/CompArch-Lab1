// define gates with delays
`define AND and #50
`define NOT not #50
`define OR or #50
`define XOR xor #50
`define XNOR xnor #50
`define BUF buf #50


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

module bitSlice (
    output out,
    output addCarryout,
    output sltKout,
    output sltAnsOut,
    input a,
    input b,
    input[2:0] s,
    input addCarryIn,
    input sltKin,
    input sltAnsIn,
    input first
);

    wire[7:0] results;


    fullAdder adder(results[0], addCarryout, a, b, addCarryIn);
    `BUF(results[1], results[0]);
    `XOR(results[2], a, b);
    sltSlice slt(results[3], sltKout, sltAnsOut, sltKin, sltAnsIn, a, b, first);
    `AND(results[4], a, b);
    `NOT(results[5], results[4]);
    `NOT(results[6], results[7]);
    `OR(results[7], a, b);

    multiplexer mux(out, s, results);

endmodule

module multiplexer(
    output out,
    input[2:0] address,
    input[7:0] in
);

    wire[2:0] naddress;
    wire[7:0] outputs;

    `NOT(naddress[0], address[0]);
    `NOT(naddress[1], address[1]);
    `NOT(naddress[2], address[2]);


    `AND(outputs[0], naddress[2], naddress[1], naddress[0], in[0]);
    `AND(outputs[1], naddress[2], naddress[1], address[0], in[1]);
    `AND(outputs[2], naddress[2], address[1], naddress[0], in[2]);
    `AND(outputs[3], naddress[2], address[1], address[0], in[3]);
    `AND(outputs[4], address[2], naddress[1], naddress[0], in[4]);
    `AND(outputs[5], address[2], naddress[1], address[0], in[5]);
    `AND(outputs[6], address[2], address[1], naddress[0], in[6]);
    `AND(outputs[7], address[2], address[1], address[0], in[7]);

    `OR(out, outputs[7], outputs[6], outputs[5], outputs[4], outputs[3], outputs[2], outputs[1], outputs[0]);

endmodule

module fullAdder(
   output out,
   output addCarryout,
   input a,
   input b,
   input addCarryIn
);

    wire AxorB, fullAnd, AandB;

    `XOR(AxorB, a, b);  // first level gates
    `AND(AandB, a, b);
    `AND(fullAnd, addCarryIn, AxorB);

    `XOR(out, AxorB, addCarryIn);  // final gates
    `XOR(addCarryout, AandB, fullAnd);

endmodule

module sltSlice(
    output out,
    output keepLookingOut,
    output ansOut,
    input keepLookingIn,
    input ansIn,
    input a,
    input b,
    input first
);

    // keepLookingIn=1 if every previous bit pair has been equal.

    // Keep looking if A and B are equal and we haven't already stopped looking
    wire AxnorB, logicalKOut;
    `XNOR(AxnorB, a, b);
    `AND(logicalKOut, AxnorB, keepLookingIn);

    // Hand keepLookingIn straight through to keepLookingOut if first block
    wire notFirst, notFirstCase, firstCase;
    `NOT(notFirst, first);
    `AND(notFirstCase, notFirst, logicalKOut);
    `AND(firstCase, first, keepLookingIn);
    `OR(keepLookingOut, notFirstCase, firstCase);

    // ansOut=1 if A=0 and B=1 and we haven't already stopped looking, or if
    // we already determined ans=1.
    wire notA;
    wire notAandBandKin;
    `NOT(notA, a);
    `AND(notAandBandKin, notA, b, keepLookingIn);
    `OR(ansOut, notAandBandKin, ansIn);

    `BUF(out, 1'b0);

endmodule

module testBitSlice;


    reg a, b;
    reg[2:0] s;
    reg addCarryIn, sltKin, sltAnsIn, first;
    wire out;
    wire addCarryout, sltKout, sltAnsOut;


    bitSlice slice (out, addCarryout, sltKout, sltAnsOut, a, b, s, addCarryIn,
                    sltKin, sltAnsIn, first);

    initial begin
        $dumpfile("slice.vcd"); //dump info to create wave propagation later
        $dumpvars(0, testBitSlice);

        $display("ADD");
        $display("A B Cin Selector | out Cout | Expected");
        s=3'b000;
        a=0; b=0; addCarryIn=0; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, addCarryIn, s, out, addCarryout, 1'b0, 1'b0);
        a=1; b=1; addCarryIn=0; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, addCarryIn, s, out, addCarryout, 1'b0, 1'b1);
        a=1; b=1; addCarryIn=1; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, addCarryIn, s, out, addCarryout, 1'b1, 1'b1);

        $display("");
        $display("XOR");
        $display("A B Cin Selector | out Cout | Expected");
        s=3'b010;
        a=0; b=0; addCarryIn=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, addCarryIn, s, out, addCarryout, 1'b0, 1'bx);
        a=0; b=1; addCarryIn=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, addCarryIn, s, out, addCarryout, 1'b1, 1'bx);
        a=1; b=1; addCarryIn=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, addCarryIn, s, out, addCarryout, 1'b0, 1'bx);

        $display("");
        $display("AND");
        $display("A B Cin Selector | out Cout | Expected");
        s=3'b100;
        a=0; b=1; addCarryIn=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, addCarryIn, s, out, addCarryout, 1'b0, 1'bx);
        a=1; b=1; addCarryIn=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, addCarryIn, s, out, addCarryout, 1'b1, 1'bx);
        a=0; b=0; addCarryIn=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, addCarryIn, s, out, addCarryout, 1'b0, 1'bx);

        $display("");
        $display("NAND");
        $display("A B Cin Selector | out Cout | Expected");
        s=3'b101;
        a=0; b=1; addCarryIn=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, addCarryIn, s, out, addCarryout, 1'b1, 1'bx);
        a=1; b=1; addCarryIn=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, addCarryIn, s, out, addCarryout, 1'b0, 1'bx);
        a=0; b=0; addCarryIn=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, addCarryIn, s, out, addCarryout, 1'b1, 1'bx);

        $display("");
        $display("NOR");
        $display("A B Cin Selector | out Cout | Expected");
        s=3'b110;
        a=0; b=0; addCarryIn=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, addCarryIn, s, out, addCarryout, 1'b1, 1'bx);
        a=0; b=1; addCarryIn=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, addCarryIn, s, out, addCarryout, 1'b0, 1'bx);
        a=1; b=1; addCarryIn=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, addCarryIn, s, out, addCarryout, 1'b0, 1'bx);

        $display("");
        $display("OR");
        $display("A B Selector | out | Expected");
        s=3'b111;
        a=0; b=0; addCarryIn=1'bx; #1000
        $display("%b %b  %b     | %b   | %b ",
                 a, b, s, out, 1'b0);
        a=0; b=1; addCarryIn=1'bx; #1000
        $display("%b %b  %b     | %b   | %b ",
                 a, b, s, out, 1'b1);
        a=1; b=1; addCarryIn=1'bx; #1000
        $display("%b %b  %b     | %b   | %b ",
                 a, b, s, out, 1'b1);

        $display("");
        $display("SLT");
        $display("A B Kin AnsIn Selector | KOut AnsOut out | Expected");
        s=3'b011;
        first=0;
        a=0; b=1; sltKin=1; sltAnsIn=0; #1000
        $display("%b %b %b   %b     %b      | %b    %b      %b   | %b %b %b",
                 a, b, sltKin, sltAnsIn, s, sltKout, sltAnsOut, out, 1'b0, 1'b1, 1'b0);
        a=1; b=0; sltKin=1; sltAnsIn=0; #1000
        $display("%b %b %b   %b     %b      | %b    %b      %b   | %b %b %b",
                 a, b, sltKin, sltAnsIn, s, sltKout, sltAnsOut, out, 1'b0, 1'b0, 1'b0);
        a=1; b=1; sltKin=1; sltAnsIn=0; #1000
        $display("%b %b %b   %b     %b      | %b    %b      %b   | %b %b %b",
                 a, b, sltKin, sltAnsIn, s, sltKout, sltAnsOut, out, 1'b1, 1'b0, 1'b0);
        a=1'bx; b=1'bx; sltKin=0; sltAnsIn=1; #1000
        $display("%b %b %b   %b     %b      | %b    %b      %b   | %b %b %b",
                 a, b, sltKin, sltAnsIn, s, sltKout, sltAnsOut, out, 1'b0, 1'b1, 1'b0);
        a=1'bx; b=1'bx; sltKin=0; sltAnsIn=0; #1000
        $display("%b %b %b   %b     %b      | %b    %b      %b   | %b %b %b",
                 a, b, sltKin, sltAnsIn, s, sltKout, sltAnsOut, out, 1'b0, 1'b0, 1'b0);
        first=1;
        a=1'bx; b=1'bx; sltKin=0; sltAnsIn=1; #1000
        $display("%b %b %b   %b     %b      | %b    %b      %b   | %b %b %b",
                 a, b, sltKin, sltAnsIn, s, sltKout, sltAnsOut, out, 1'b0, 1'b1, 1'b0);
        a=1'bx; b=1'bx; sltKin=0; sltAnsIn=0; #1000
        $display("%b %b %b   %b     %b      | %b    %b      %b   | %b %b %b",
                 a, b, sltKin, sltAnsIn, s, sltKout, sltAnsOut, out, 1'b0, 1'b0, 1'b0);
    end
endmodule
