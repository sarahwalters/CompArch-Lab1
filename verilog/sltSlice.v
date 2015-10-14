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
    `XNOR2(AxnorB, a, b);
    `AND2(logicalKOut, AxnorB, keepLookingIn);

    // Hand keepLookingIn straight through to keepLookingOut if first block
    wire notFirst, notFirstCaseAns, firstCaseAns;
    `NOT1(notFirst, first);
    `AND2(notFirstCaseAns, notFirst, logicalKOut);
    `AND2(firstCaseAns, first, keepLookingIn);
    `OR2(keepLookingOut, notFirstCaseAns, firstCaseAns);

    // ansOut=1 if A=0 and B=1 and we haven't already stopped looking, or if
    // we already determined ans=1.
    wire notA;
    wire notAandBandKin;
    `NOT1(notA, a);
    `AND3(notAandBandKin, notA, b, keepLookingIn);
    `OR2(ansOut, notAandBandKin, ansIn);

    // Always output 0
    `BUF1(out, 1'b0);

endmodule
