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

        $display("A B command | result Cout zero overflow | Expected");
        command=3'b000;
        operandA=32'b11111111111111111111111111111111; 
        operandB=32'b11111111111111111111111111111111; 
        #1000000
        $display("%b %b %b      | %b   %b    | %b   %b",
                 operandA, operandB, command, result, carryout, 1'b0, 1'b0);
    end

endmodule
