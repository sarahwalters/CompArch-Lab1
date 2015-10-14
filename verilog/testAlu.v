module testAlu;

    reg[31:0] operandA, operandB;
    reg[2:0] command;
    wire carryout, zero, overflow;
    wire[31:0] result;

    ALU alu(result, carryout, zero, overflow, operandA, operandB, command);

    initial begin
        $dumpfile("build/alu.vcd"); //dump info to create wave propagation later
        $dumpvars(0, testAlu);

        $display("Testing ALU");
        $display();

        $display("Adding");
        $display();
        $display("A                                B                                command | result                           Cout zero overflow | Expected");
        command=3'b000;
        operandA=32'b11111111111111111111111111111111;
        operandB=32'b11111111111111111111111111111111;
        #1000000
        $display("%b %b %b     | %b %b    %b    %b        | %b %b %b %b",
                 operandA, operandB, command, result, carryout, zero, overflow,
                 32'b11111111111111111111111111111110, 1'b1, 1'b0, 1'b0);
                command=3'b000;
        operandA=32'b11111111111111111111111111111100;
        operandB=32'b00000000000000000000000000000100;
        #1000000
        $display("%b %b %b     | %b %b    %b    %b        | %b %b %b %b",
                 operandA, operandB, command, result, carryout, zero, overflow,
                 32'b00000000000000000000000000000000, 1'b1, 1'b1, 1'b0);
        operandA=32'b01000000000000000000000000000000;
        operandB=32'b01000000000000000000000000000000;
        #1000000
        $display("%b %b %b     | %b %b    %b    %b        | %b %b %b %b",
                 operandA, operandB, command, result, carryout, zero, overflow,
                 32'b10000000000000000000000000000000, 1'b0, 1'b0, 1'b1);
        $display();
        $display("Subtracting");
        command=3'b001;
        operandA=32'b11111111111111111111111111111100;
        operandB=32'b00000000000000000000000000000100;
        #1000000
        $display("%b %b %b     | %b %b    %b    %b        | %b %b %b %b",
                 operandA, operandB, command, result, carryout, zero, overflow,
                 32'b11111111111111111111111111111000, 1'b1, 1'b0, 1'b0);
        operandA=32'b00000000000000000000000000001001;
        operandB=32'b00000000000000000000000000001001;
        #1000000
        $display("%b %b %b     | %b %b    %b    %b        | %b %b %b %b",
                 operandA, operandB, command, result, carryout, zero, overflow,
                 32'b00000000000000000000000000000000, 1'b1, 1'b1, 1'b0);
        operandA=32'b10000000000000000000000000000000;
        operandB=32'b01111111111111111111111111111111;
        #1000000
        $display("%b %b %b     | %b %b    %b    %b        | %b %b %b %b",
                 operandA, operandB, command, result, carryout, zero, overflow,
                 32'b00000000000000000000000000000001, 1'b1, 1'b0, 1'b1);
        $display();
        $display("XOR");
        command=3'b010;
        operandA=32'b10000011011110000000110000001100;
        operandB=32'b00000001000000000000111111000100;
        #1000000
        $display("%b %b %b     | %b %b    %b    %b        | %b %b %b %b",
                 operandA, operandB, command, result, carryout, zero, overflow,
                 32'b10000010011110000000001111001000, 1'b1, 1'b0, 1'b0);
        $display();
        $display("SLT");
        command=3'b011;
        operandA=32'b11111111111111111111111111111111;
        operandB=32'b00000000000000000000000000000000;
        #1000000
        $display("%b %b %b     | %b %b    %b    %b        | %b %b %b %b",
                 operandA, operandB, command, result, carryout, zero, overflow,
                 32'b00000000000000000000000000000001, 1'b0, 1'b0, 1'b0);
        operandA=32'b00000000000000001111111111111111;
        operandB=32'b00000000000000000000000000000001;
        #1000000
        $display("%b %b %b     | %b %b    %b    %b        | %b %b %b %b",
                 operandA, operandB, command, result, carryout, zero, overflow,
                 32'b00000000000000000000000000000000, 1'b0, 1'b0, 1'b0);
        operandB=32'b00000000000000001111111111111111;
        operandA=32'b00000000000000000000000000000001;
        #1000000
        $display("%b %b %b     | %b %b    %b    %b        | %b %b %b %b",
                 operandA, operandB, command, result, carryout, zero, overflow,
                 32'b00000000000000000000000000000001, 1'b0, 1'b0, 1'b0);
        operandA=32'b10000001100000001111111111111111;
        operandB=32'b10000000000000000000000000000001;
        #1000000
        $display("%b %b %b     | %b %b    %b    %b        | %b %b %b %b",
                 operandA, operandB, command, result, carryout, zero, overflow,
                 32'b00000000000000000000000000000000, 1'b0, 1'b0, 1'b0);
        operandB=32'b10000000000000001111111111111111;
        operandA=32'b10000000000000000000001100000001;
        #1000000
        $display("%b %b %b     | %b %b    %b    %b        | %b %b %b %b",
                 operandA, operandB, command, result, carryout, zero, overflow,
                 32'b00000000000000000000000000000001, 1'b0, 1'b0, 1'b0);
        operandB=32'b10000000000000000111101111011111;
        operandA=32'b10000000000000000111101111011111;
        #1000000
        $display("%b %b %b     | %b %b    %b    %b        | %b %b %b %b",
                 operandA, operandB, command, result, carryout, zero, overflow,
                 32'b00000000000000000000000000000000, 1'b0, 1'b0, 1'b0);
        $display();
        $display("AND");
        command=3'b100;
        operandA=32'b10000011011110000000110000001100;
        operandB=32'b00000001000000000000111111000100;
        #1000000
        $display("%b %b %b     | %b %b    %b    %b        | %b %b %b %b",
                 operandA, operandB, command, result, carryout, zero, overflow,
                 32'b00000001000000000000110000000100, 1'b1, 1'b0, 1'b0);
        $display();
        $display("NAND");
        command=3'b101;
        operandA=32'b10000011011110000000110000001100;
        operandB=32'b00000001000000000000111111000100;
        #1000000
        $display("%b %b %b     | %b %b    %b    %b        | %b %b %b %b",
                 operandA, operandB, command, result, carryout, zero, overflow,
                 32'b11111110111111111111001111111011, 1'b1, 1'b0, 1'b0);
        $display();
        $display("NOR");
        command=3'b110;
        operandA=32'b10000011011110000000110000001100;
        operandB=32'b00000001000000000000111111000100;
        #1000000
        $display("%b %b %b     | %b %b    %b    %b        | %b %b %b %b",
                 operandA, operandB, command, result, carryout, zero, overflow,
                 32'b01111100100001111111000000110011, 1'b1, 1'b0, 1'b0);
        $display();
        $display("OR");
        command=3'b111;
        operandA=32'b10000011011110000000110000001100;
        operandB=32'b00000001000000000000111111000100;
        #1000000
        $display("%b %b %b     | %b %b    %b    %b        | %b %b %b %b",
                 operandA, operandB, command, result, carryout, zero, overflow,
                 32'b10000011011110000000111111001100, 1'b1, 1'b0, 1'b0);
    end

endmodule
