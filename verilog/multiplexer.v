module multiplexer(
    output out,
    input[2:0] address,
    input[7:0] in
);

    wire[2:0] naddress;
    wire[7:0] outputs;

    `NOT1(naddress[0], address[0]);
    `NOT1(naddress[1], address[1]);
    `NOT1(naddress[2], address[2]);

    `AND4(outputs[0], naddress[2], naddress[1], naddress[0], in[0]);
    `AND4(outputs[1], naddress[2], naddress[1], address[0], in[1]);
    `AND4(outputs[2], naddress[2], address[1], naddress[0], in[2]);
    `AND4(outputs[3], naddress[2], address[1], address[0], in[3]);
    `AND4(outputs[4], address[2], naddress[1], naddress[0], in[4]);
    `AND4(outputs[5], address[2], naddress[1], address[0], in[5]);
    `AND4(outputs[6], address[2], address[1], naddress[0], in[6]);
    `AND4(outputs[7], address[2], address[1], address[0], in[7]);

    `OR8(out, outputs[7], outputs[6], outputs[5], outputs[4], outputs[3], outputs[2], outputs[1], outputs[0]);

endmodule
