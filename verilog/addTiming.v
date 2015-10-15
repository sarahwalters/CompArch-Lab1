module addTiming;

    reg[31:0] operandA, operandB;
    reg[2:0] command;
    wire carryout, zero, overflow;
    wire[31:0] result;

    ALU alu(result, carryout, zero, overflow, operandA, operandB, command);

    initial begin
        $dumpfile("build/addTiming.vcd"); //dump info to create wave propagation later
        $dumpvars(0, addTiming);

        $display("ADD");
        command = 3'b000;
        operandA=32'b01111111111111111111111111111111;
        operandB=32'b00000000000000000000000000000001;
        #100000
        $display("%b %b %b     | %b %b    %b    %b        | %b %b %b %b",
                 operandA, operandB, command, result, carryout, zero, overflow,
                 32'b10000000000000000000000000000000, 1'b0, 1'b0, 1'b1);
    end

endmodule
