// define gates with delays
`define AND and #50
`define NOT not #50
`define OR or #50
`define XOR xor #50
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
endmodule

module bitSlice (
    output out,
    output carryout,
    input a,
    input b,
    input[2:0] s,
    input carryin
);

    wire[7:0] results;


    fullAdder adder(results[0], carryout, a, b, carryin);
    `BUF(results[1], results[0]);
    `XOR(results[2], a, b);
    `AND(results[3], results[2], b);
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
   output carryout,
   input a,
   input b,
   input carryin
);

    wire AxorB, fullAnd, AandB;

    `XOR(AxorB, a, b);  // first level gates
    `AND(AandB, a, b);
    `AND(fullAnd, carryin, AxorB);

    `XOR(out, AxorB, carryin);  // final gates
    `XOR(carryout, AandB, fullAnd);

endmodule


module testBitSlice;
    reg a, b;
    reg[2:0] s;
    reg carryin;
    wire out;
    wire carryout;

    bitSlice slice (out, carryout, a, b, s, carryin);

    initial begin
        $dumpfile("slice.vcd"); //dump info to create wave propagation later
        $dumpvars(0, testBitSlice);

        $display("ADD");
        $display("A B Cin Selector | out Cout | Expected");
        s=3'b000;
        a=0; b=0; carryin=0; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, carryin, s, out, carryout, 1'b0, 1'b0);
        a=1; b=1; carryin=0; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, carryin, s, out, carryout, 1'b0, 1'b1);
        a=1; b=1; carryin=1; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, carryin, s, out, carryout, 1'b1, 1'b1);

        $display("");
        $display("XOR");
        $display("A B Cin Selector | out Cout | Expected");
        s=3'b010;
        a=0; b=0; carryin=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, carryin, s, out, carryout, 1'b0, 1'bx);
        a=0; b=1; carryin=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, carryin, s, out, carryout, 1'b1, 1'bx);
        a=1; b=1; carryin=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, carryin, s, out, carryout, 1'b0, 1'bx);

        $display("");
        $display("SLT");
        $display("A B Cin Selector | out Cout | Expected");
        s=3'b011;
        a=0; b=1; carryin=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, carryin, s, out, carryout, 1'b1, 1'bx);
        a=1; b=1; carryin=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, carryin, s, out, carryout, 1'b0, 1'bx);
        a=1; b=0; carryin=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, carryin, s, out, carryout, 1'b0, 1'bx);

        $display("");
        $display("AND");
        $display("A B Cin Selector | out Cout | Expected");
        s=3'b100;
        a=0; b=1; carryin=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, carryin, s, out, carryout, 1'b0, 1'bx);
        a=1; b=1; carryin=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, carryin, s, out, carryout, 1'b1, 1'bx);
        a=0; b=0; carryin=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, carryin, s, out, carryout, 1'b0, 1'bx);

        $display("");
        $display("NAND");
        $display("A B Cin Selector | out Cout | Expected");
        s=3'b101;
        a=0; b=1; carryin=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, carryin, s, out, carryout, 1'b1, 1'bx);
        a=1; b=1; carryin=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, carryin, s, out, carryout, 1'b0, 1'bx);
        a=0; b=0; carryin=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, carryin, s, out, carryout, 1'b1, 1'bx);

        $display("");
        $display("NOR");
        $display("A B Cin Selector | out Cout | Expected");
        s=3'b110;
        a=0; b=0; carryin=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, carryin, s, out, carryout, 1'b1, 1'bx);
        a=0; b=1; carryin=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, carryin, s, out, carryout, 1'b0, 1'bx);
        a=1; b=1; carryin=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, carryin, s, out, carryout, 1'b0, 1'bx);

        $display("");
        $display("OR");
        $display("A B Cin Selector | out Cout | Expected");
        s=3'b111;
        a=0; b=0; carryin=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, carryin, s, out, carryout, 1'b0, 1'bx);
        a=0; b=1; carryin=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, carryin, s, out, carryout, 1'b1, 1'bx);
        a=1; b=1; carryin=1'bx; #1000
        $display("%b %b %b   %b      | %b   %b    | %b   %b",
                 a, b, carryin, s, out, carryout, 1'b1, 1'bx);
    end
endmodule
