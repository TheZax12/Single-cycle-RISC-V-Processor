START:
    addi x1, x0, 5        # x1 = 5
    addi x2, x0, 3        # x2 = 3
    add  x3, x1, x2       # x3 = 8
    sub  x4, x1, x2       # x4 = 2
    or   x5, x1, x2       # x5 = 7
    xor  x6, x1, x2       # x6 = 6
    andi x7, x1, 1        # x7 = 1
    ori  x8, x1, 2        # x8 = 7
    xori x9, x1, 3        # x9 = 6
    slt  x10, x2, x1      # x10 = 1 (3<5)
    sltu x11, x1, x2      # x11 = 0 (5<3? no)
    sw   x3, 0(x0)        # MEM[0] = 8
    lw   x12, 0(x0)       # x12 = 8
    beq  x1, x1, L1       # taken (5=5)
    addi x13, x0, 999     # skipped
L1:
    addi x14, x0, 111     # x14 = 111
    bne  x1, x2, L2       # taken (5!=3)
    addi x15, x0, 888     # skipped
L2:
    addi x16, x0, 222     # x16 = 222
    beq  x1, x2, L3       # NOT taken (5!=3)
    addi x17, x0, 333     # executes x17 = 333
L3:
    sw   x14, 4(x0)       # MEM[4] = 111
    lw   x18, 4(x0)       # x18 = 111
    addi x19, x0, -5      # x19 = -5   (negative number)
    add  x20, x19, x19    # x20 = -10  (add of two negatives)
    sub  x21, x0, x1      # x21 = -5   (subtraction producing a negative)
    slt  x22, x19, x1     # x22 = 1    (-5 < 5, SIGNED compare)
    sltu x23, x19, x1     # x23 = 0    (-5 as unsigned is huge, > 5)
    beq  x0, x0, START    # loop back to the start