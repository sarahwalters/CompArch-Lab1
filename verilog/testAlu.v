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
    end

endmodule
