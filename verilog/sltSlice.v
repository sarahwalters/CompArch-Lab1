module sltSlice(
    output out,
    output keepLookingOut, // 1 if this bit pair and all more significant
                           // bit pairs are equal
    output ansOut, // SLT answer, if determined before or within this block
    input keepLookingIn, // 1 if all more significant bit pairs are equal
    input ansIn, // SLT answer, if determined before this block
    input a,
    input b,
    input first // 1 if this is the first bit slice
);

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

    // Always output 0
    `BUF(out, 1'b0);

endmodule
