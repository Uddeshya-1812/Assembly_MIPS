.data
message0: .asciiz "Enter the value of index you want to print :\n"
message1: .asciiz "The Fibonacci value is:\n"
message2: .asciiz "The Fibonacci value is:\n0"

.text
main:
li $v0, 4                        # Print message0
la $a0, message0
syscall

                                 #  Used as scanf and Read integer
li $v0, 5
syscall

beq $v0, 0, equalToZero          # Branch equal:if v0 == 0 call function "equal to zero"

                                 # Calling fibonacci
move $a0, $v0
jal fibonacci
move $a1, $v0                    # save return value to a1

                                 # Print message1
li $v0, 4
la $a0, message1
syscall

                                 # Print result
li $v0, 1
move $a0, $a1
syscall

                                  # Exit
li $v0, 10
syscall



                                                                                       # Function : fibonacci
fibonacci:
addi $sp, $sp, -12                # allocating a space in stack  
sw $ra, 8($sp) 
sw $s0, 4($sp)                    
sw $s1, 0($sp)
move $s0, $a0
li $v0, 1                          # return value for last condition
ble $s0, 2, fibonacciExit          # check last condition
addi $a0, $s0, -1                  # set args for recursive call to f(n-1)
jal fibonacci
move $s1, $v0                      # store result of f(n-1) to s1
addi $a0, $s0, -2                  # set args for recursive call to f(n-2)
jal fibonacci
add $v0, $s1, $v0                  # add result of f(n-1) to it

fibonacciExit:                     # delete stack space and return from call

lw $ra, 8($sp)
lw $s0, 4($sp)
lw $s1, 0($sp)
addi $sp, $sp, 12
jr $ra

equalToZero:
li $v0, 4
la $a0, message2                    # print message2       
syscall
li $v0, 10
syscall
                                   
 # ble = branch if less than or equal( basically expansion of slt(set if less than) and beq)
