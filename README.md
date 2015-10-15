# CompArch-Lab1

To test bit slice:
`./build/bitSlice`

To test ALU:
`./build/alu`

<a href="https://docs.google.com/document/d/1Or2dEDvPbOtU_OmnNjMwlDB4KzblUfdGv9sKJHLLQBs/edit?usp=sharing" target="_blank">Link to report writing Google doc</a>


## Implementation
We decided to implement our ALU using a bitslice design. Bitslices are modular and reusable -- it is possible to use the same bitslice to produce an ALU of any input length, and it is possible to test a single bitslice to verify that it is behaving correctly.

![Bitslice design](/images/bitslice.png)
Figure 1: Bitslice logic design

Each bitslice performs multiple operations on each bit (from left to right: add, subtract, XOR, set less than, AND, NAND, NOR, and OR), and an 8:1 multiplexer uses the three-bit ALU command to select the appropriate result.

![ALU design](/images/alu.png)
Figure 2: ALU block diagram

Three of the eight ALU operations require communication between adjacent bitslices: addition, subtraction, and set less than. The adder/subtractor within each bitslice passes a carryout to the left, and the SLT module passes a “keep looking” flag and an “answer” flag to the right.
The SLT first checks if the signs of the numbers are different. If they are, then the SLT output is set to `operandA[31]` (because if `operandA[31] = 1` then `operandA` is negative and `operandA < operandB`.) If not, the SLT looks from the most significant bit to the least significant until it reaches a pair of bits that are different. If they are different and the `operandA[i]` bit is `0`, then `operandA < operandB`, so we set our “keep looking” flag to `0` and our “answer” to `1`. If the `operandA[i]` bit is `1`, we set “answer” to `0`. The “answer” flag is then passed along the remaining bitslices (the rest of the less-significant bits are not compared because “keep looking” is `0`) and set as the output of the ALU.

![Overflow design](/images/overflow.png)
Figure 3: Overflow logic design

The ALU sets three flags when adding or subtracting: zero, carryout, and overflow. The zero flag is the output of a 32-bit `NOR` gate which checks that no bit in the result is `1`. The carryout flag is simply the carryout of the most significant bitslice’s adder. The overflow flag checks whether the signs of the operands are the same and the sign of the result is different. 


## Test results
When writing test cases for our ALU, we made sure to check that each operation was performed correctly and that the right flags were set. The complete test resuls are included in <a href="/testresults.txt" target="_blank">this text file</a>.

### Add
We chose three test cases to test the three addition/subtraction flags in various combinations. The first case adds -1<sub>10</sub> and -1<sub>10</sub> (negative one is represented in two’s complement as all 1s). Adding two negative numbers always produces a carryout, but the result (negative two) does not overflow and does not set the zero flag. The second test case adds -4<sub>10</sub> and 4<sub>10</sub>, which produces a carryout and sets the zero flag but does not overflow. The third test case adds 2<sup>30</sup><sub>10</sub> and 2<sup>30</sup><sub>10</sub>, which overflows but does not produce a carryout and does not set the zero flag.

### Subtract
We also did three test cases for subtraction. The first case computes -4<sub>10</sub> - 4<sub>10</sub>, which results in a carryout, but no overflow or zero, as the answer is correctly computed to -8<sub>10</sub>. The second case computes 9<sub>10</sub> - 9<sub>10</sub>, which both sets the zero flag and has a carryout, but no overflow. The third case computes -2<sup>31</sup><sub>10</sub> - (2<sup>31</sup> - 1)<sub>10</sub>, which overflows and produces 1<sub>10</sub>, and has a carry-out, but is not zero.

### XOR
We chose two operands which cover all of the bitwise XOR combinations in a single test case (0 XOR 0, 0 XOR 1, and 1 XOR 1). The least significant bits cover the 0 XOR 0 = 0 case, the third-to-least significant bits cover the 1 XOR 1 = 0 case, and the most significant bits cover the 0 XOR 1 = 1 case.

10000011011110000000110000001100  
XOR  
00000001000000000000111111000100  
is  
10000010011110000000001111001000

### SLT
We chose six cases to test the set less than operation. The first case tests that SLT works when the numbers have different signs (-1 SLT 0 = 1). The next two cases compare two positive operands where A < B (so, A SLT B = 1) and where B < A (so, A SLT B = 0). The following two cases compare two negative operands where A < B and where B < A. The last case compares two operands where A = B (so, A SLT B = 0).

### AND
The AND operation was tested with one example. We only used one test case because we were able to show all the bitwise combinations (0 AND 0, 0 AND 1, 1 AND 1) using the two operands. The least significant bits cover the 0 AND 0 = 0 case, the third-to-least significant bits cover the 1 AND 1 = 1 case, and the most significant bits cover the 0 AND 1 = 0 case.

10000011011110000000110000001100  
AND  
00000001000000000000111111000100  
is  
00000001000000000000110000000100  

### NAND
We chose two operands which cover all of the bitwise NAND combinations in a single test case (0 NAND 0, 0 NAND 1, 1 NAND 1). The least significant bits cover the 0 NAND 0 = 1 case, the third-to-least significant bits cover the 1 NAND 1 = 0 case, and the most significant bits cover the 0 NAND 1 = 1 case.

10000011011110000000110000001100  
NAND  
00000001000000000000111111000100  
is  
11111110111111111111001111111011  

### NOR
We chose two operands which cover all of the bitwise NOR combinations in a single test case (0 NOR 0 = 1, 0 NOR 1 = 0, and 1 NOR 1 = 0). The least significant bits cover the 0 NAND 0 = 1 case, the third-to-least significant bits cover the 1 NAND 1 = 0 case, and the most significant bits cover the 0 NAND 1 = 1 case.

10000011011110000000110000001100  
NOR  
00000001000000000000111111000100  
is  
01111100100001111111000000110011  

### OR
We chose two operands which cover all of the bitwise NOR combinations in a single test case (0 OR 0, 0 OR 1, and 1 OR 1). The least significant bits cover the 0 NAND 0 = 1 case, the third-to-least significant bits cover the 1 NAND 1 = 0 case, and the most significant bits cover the 0 NAND 1 = 1 case.

10000011011110000000110000001100  
OR  
00000001000000000000111111000100  
is  
10000011011110000000111111001100  

### Cases which caught flaws
When running our test bench for the first time, we did not get all of the results we expected. 
We tried to flip the bits in `operandB` in place (we were wiring each bit to both the input and output of a `NOT` gate), and we got outputs which included the x symbol which represents an unknown logic value. We realized that it isn’t possible to assign two different values to the same bit, so we resolved the bug by creating an additional wire for the flipped operand.

We found our second mistake when testing subtraction. Instead of flipping all the bits of the second operand and adding one, we realized we were not using the flipped bit in the least-significant bit. 

Our third mistake was caught when testing SLT. The SLT operation works by first comparing the sign bit of the two operands and only continues to compare the value of the following 31 bits if the signs were the same. Although we were comparing the two most significant bits correctly, we mistakenly passed the incorrect flag to signal to the following SLT slices whether they should continue to compare the bits.

## Timing Analysis
### Calculated worst case propagation delay:
SLT: `60*32 = 1920`
Adder/subtractor: `250 + 31*110 = 3660`

The worst case propagation delay occurs in either the set less than operation or the addition/subtraction operation -- those operations occur in series (each bitslice uses information produced by an adjacent bitslice). By contrast, operations like `OR` and `AND` occur within each bitslice without dependence on any other bitslice.

We examine the set less than and addition blocks to determine which takes longer.

##### Set less than
![SLT timing](/images/timing_slt.jpg)
Figure 4: Set less than logic design -- path with longest delay marked in red

|                   | K<sub>out</sub> | Ans<sub>out</sub> |
| ----------------- |:---------------:| -----------------:|
| K<sub>in</sub>    | 60              | 70                |
| a                 | 190             | 80                |
| b                 | 190             | 70                |
| Ans<sub>in</sub>  | 30              | n/a               |
Table 1: Input to output delays for set less than portion of bitslice

Table 1 describes the input to output delays for the set less than portion of a bitslice. The longest path is marked in red in Figure 4 -- changing either operand bit (a or b) results in a 190-unit delay before K<sub>out</sub> changes.  

##### Addition/subtraction
![Adder timing](/images/timing_adder.jpg)
Figure 5: Adder logic design -- path with longest delay marked in red

|                   | out  | C<sub>out</sub>   |
| ----------------- |:----:| -----------------:|
| C<sub>in</sub>    | 110  | 140               |
| a                 | 220  | 250               |
| b                 | 220  | 250               |
Table 2: Input to output delays for addition/subtraction portion of bitslice

Again, the longest path within the addition/subtraction block is marked in red -- cahnging either operand bit (a or b) results in a 250-unit delay before C<sub>out</sub> changes.  

### Simulated worst case propagation delay:


## Work Plan Reflection
2-hr meeting on Friday or Saturday:  
* 30 min: block diagram for single bit & for whole ALU -> took 30 min
* 30 min: write test bench for a bitslice -> took 15 min
* 1 hr or a little more: write a bitslice in Verilog -> took 1 hr

After this meeting, we realized we had done SLT wrong, and added a 2-hour Sunday meeting to fix SLT.

2-hr meeting on Sunday or Monday (actually was Tuesday)
* 30 min: write test bench for whole 32-bit ALU -> took 30 min
* 1 hr: chain bitslices together in Verilog -> took ~1.5hrs (encountered a few bugs we had to find and fix)
* 30 min: timing analysis -> took ~45 min

Distribute the report-writing on Monday and Tuesday; done by Tuesday night
- 1 hr: write report -> took ~1 hr




