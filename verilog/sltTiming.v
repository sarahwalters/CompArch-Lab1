module sltTiming;

    reg[31:0] operandA, operandB;
    reg[2:0] command;
    wire carryout, zero, overflow;
    wire[31:0] result;

    ALU alu(result, carryout, zero, overflow, operandA, operandB, command);

    initial begin
        $dumpfile("build/sltTiming.vcd"); //dump info to create wave propagation later
        $dumpvars(0, sltTiming);

        $display("SLT");
        command = 3'b011;
        operandA=32'b00000000000000000000000000000001;
        operandB=32'b00000000000000000000000000000001;
        #100000
        $display("%b %b %b     | %b %b    %b    %b        | %b %b %b %b",
                 operandA, operandB, command, result, carryout, zero, overflow,
                 32'b00000000000000000000000000000001, 1'b0, 1'b0, 1'b0);
    end

endmodule
