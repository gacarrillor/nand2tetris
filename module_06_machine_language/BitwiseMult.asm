// Germán Carrillo 07.05.26
// Bitwise multiplication
@R0
D=M
@a // Multiplier
M=D

@R1
D=M
@b // Multiplicand
M=D

@R2 // To hold the result
M=0

@16
D=A
@bits
M=D

@100
D=A
@baseaddr // Base address to store all the right shifts 
M=D

// Count in which step we are to get the proper stored right shift from memory
@step
M=0

// First, let's calculate and store all the right shifts (only once!)
(RSHIFT)
  // We need to simulate right shift, as there's no easy way of getting it from
  // the symbols available in our Assembly.
  // For that, we'll apply n-1 left shifts (n=16 (bits)), handling the overflow
  // gracefully, so that disappearing 1s to the left, appear again to the right!
  @b
  D=M
  @bcopy // to modify in this RSHIFT label
  M=D
  
  @bits
  D=M
  @expsteps // Expected steps: 'n-bits' - 1
  M=D-1
  
  @32767 
  D=!A // 2^15 => 1000 0000 0000 0000
  @testmsb
  M=D
  
  @i
  M=0
    
(LOOPRSHIFT)
  @i
  D=M
  @expsteps
  D=M-D
  @LOOP
  D;JEQ  // expsteps - i == 0 --> LOOP
  
  @testmsb
  D=M
  @bcopy
  D=D&M // Gives us 16 0s if MSB of bcopy is 0
  @msb
  M=D
  
  // Mimic a left shift by duplicating bcopy
  @bcopy
  D=M
  M=D+M
  
  @msb
  D=M
  @SAVERSHIFT
  D;JEQ // MSB == 0 --> SAVERSHIFT (i.e., skip adding 1)
  
  @bcopy
  M=M+1 // Add the disappearing 1 (in the left) to the LSB position! 
  
(SAVERSHIFT)  
  @i // Increase counter before saving, for convenience
  M=M+1
  D=M

  @expsteps
  D=M-D // expsteps - i (we'll store right shifts backwards to ease later access)
  
  @baseaddr // Random addr to store the array[15] of right shifts
  D=D+M // baseaddr + (expsteps - i)
  
  @newaddr
  M=D // Store the new address 
  
  @bcopy
  D=M
  @newaddr
  A=M
  M=D // Store the right shift value in the calculated new address!
  
  @LOOPRSHIFT // Continue to the next iteration of the right shifts
  0;JMP

(LOOP)
  // Most algs. test if b became 0. We don't, since we implement a 'custom' right shift
  // that does not clean up numbers in the left. That means, we're only interested in 
  // getting the LSB right each time.
  // So, we stop when we have applied our custom right shift n-bits - 1 times (15 times
  // for 16-bit registers).
  
  // If we had a proper right shift op., we'd do this:
  //@b
  //D=M
  //@END
  //D;JEQ // b == 0 --> END
  
  @step
  D=M
  @bits
  D=M-D
  @END
  D;JEQ // bits-step == 0 --> END 
    
  // Check that the LSB from b is a 1 (because we can skip 'a times 0')
  @1
  D=A
  @b
  D=D&M // tuvwxyz & 0000001, gives us either 0000001 or 0000000
  @SHIFTS
  D;JEQ // LSB == 0 --> Skip addition, shift numbers and continue the loop 
  
  @a
  D=M
  @R2
  M=D+M // Add current 'a' to result, shift numbers and continue the loop
  
(SHIFTS)
  // Left shift (simulates normal multiplication, where the intermediate
  // result gets shifted to the left before summing all individual results up)
  // With our instructions, we can mimic left shift by adding the same number 
  // twice (i.e., c<<=1 <==> c+c)
  @a
  D=M
  M=D+M
  
  // Right shift 
  @step
  D=M
  
  @baseaddr
  A=D+M // Base address + step, gives us the location of the new right shift 16-bit number!
  D=M // Gets the new right shift value
  
  @b
  M=D // Replace b by its right shifted version!
  
  // Increase our counter (after getting the right shift, for convenience)
  @step
  M=M+1
  
  // Finally, let's go to the next LOOP!
  @LOOP
  0;JMP
    
(END)
  @END
  0;JMP

