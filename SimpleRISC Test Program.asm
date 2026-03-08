// SimpleRISC Test Program
MAIN:
    MOV R1, 5       // Load immediate 5 into R1
    MOV R2, 10      // Load immediate 10 into R2
    ADD R3, R1, R2  // R3 = R1 + R2 = 15
    ST R3, 20[R0]   // Store R3 into Memory at offset 20 from R0
    CMP R3, R1      // Compare R3 and R1
    BGT END         // Branch to END if R3 > R1
    NOP             // This should be skipped!
END:
    RET             // Return / Exit program