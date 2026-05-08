
**Original task (Multiplication) from the course**

The inputs of this program are the values stored in R0
and R1 (RAM[0] and RAM[1]). The program computes the product R0 * R1 and stores the result in
R2 (RAM[2]). Assume that R0 ≥ 0, R1 ≥ 0, and R0 * R1 < 32768 (your program need not test these.
Your code should not change the values of R0 and R1.

You can test the BitwiseMult.asm implementation in the CPU Emulator:
https://nand2tetris.github.io/web-ide/cpu

For that, load the .asm file, fill RAM addresses 0 and 1 with some positive integers and click Run.
The product will appear in the address 3.

<img width="1854" height="1048" alt="image" src="https://github.com/user-attachments/assets/8c42a675-5f90-48b8-a0c4-1a8333f9b479" />

Some details:

Since our ALU does not offer them, we need to implement our own left and right shifters, which are used repeatedly by the algorithm.

The left shifter is easy, once you understand what it does to the original number.

However, the right shifter is trickier, and following some advice from the nabble forum [1], we need to apply n-1 (n=16 in our case) left shifts with some extra care, for each bit in the multiplicand (i.e., 16 times).

Since we'll be doing n-1 left shifts 16 times, I thought I could just do the n-1 left shifts once, and use pointers to store all intermediate values in an array. Later, for each bit in the multiplicand, we can then access the correct memory address to get the desired right shift result.

----------------
[1] http://nand2tetris-questions-and-answers-forum.52.s1.nabble.com/How-do-I-do-Multiplication-in-Mult-asm-td4001881.html#a4002331
