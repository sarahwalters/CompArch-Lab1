module testBitSlice;

    reg a, b;
    reg[2:0] s;
    reg addCarryIn, sltKin, sltAnsIn, first;
    wire out;
    wire addCarryout, sltKout, sltAnsOut;

    bitSlice slice (out, addCarryout, sltKout, sltAnsOut, a, b, s, addCarryIn,
                    sltKin, sltAnsIn, first);

    initial begin
        $dumpfile("build/bitSlice.vcd"); // dump info to create wave propagation later
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
        addCarryIn=1'bx;

        $display("");
        $display("XOR");
        $display("A B Selector | out | Expected");
        s=3'b010;
        a=0; b=0; #1000
        $display("%b %b %b      | %b   | %b",
                 a, b, s, out, 1'b0);
        a=0; b=1; #1000
        $display("%b %b %b      | %b   | %b",
                 a, b, s, out, 1'b1);
        a=1; b=1; #1000
        $display("%b %b %b      | %b   | %b",
                 a, b, s, out, 1'b0);

        $display("");
        $display("AND");
        $display("A B Selector | out | Expected");
        s=3'b100;
        a=0; b=1; #1000
        $display("%b %b %b      | %b   | %b",
                 a, b, s, out, 1'b0);
        a=1; b=1; #1000
        $display("%b %b %b      | %b   | %b",
                 a, b, s, out, 1'b1);
        a=0; b=0; #1000
        $display("%b %b %b      | %b   | %b",
                 a, b, s, out, 1'b0);

        $display("");
        $display("NAND");
        $display("A B Selector | out | Expected");
        s=3'b101;
        a=0; b=1; #1000
        $display("%b %b %b      | %b   | %b",
                 a, b, s, out, 1'b1);
        a=1; b=1; #1000
        $display("%b %b %b      | %b   | %b",
                 a, b, s, out, 1'b0);
        a=0; b=0; #1000
        $display("%b %b %b      | %b   | %b",
                 a, b, s, out, 1'b1);

        $display("");
        $display("NOR");
        $display("A B Selector | out | Expected");
        s=3'b110;
        a=0; b=0; #1000
        $display("%b %b %b      | %b   | %b",
                 a, b, s, out, 1'b1);
        a=0; b=1; #1000
        $display("%b %b %b      | %b   | %b",
                 a, b, s, out, 1'b0);
        a=1; b=1; #1000
        $display("%b %b %b      | %b   | %b",
                 a, b, s, out, 1'b0);

        $display("");
        $display("OR");
        $display("A B Selector | out | Expected");
        s=3'b111;
        a=0; b=0; #1000
        $display("%b %b  %b     | %b   | %b ",
                 a, b, s, out, 1'b0);
        a=0; b=1; #1000
        $display("%b %b  %b     | %b   | %b ",
                 a, b, s, out, 1'b1);
        a=1; b=1; #1000
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
