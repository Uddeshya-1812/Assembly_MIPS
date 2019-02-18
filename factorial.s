.data
	input:.asciiz"Enter N: "
.text

main:
	li $v0,4
	la $a0,input
	syscall
	li $v0,5
	syscall
	move $a0,$v0
	jal factorial
	move $t0,$v0
	li $v0,1
	move $a0,$t0
	syscall
	li $v0,10
	syscall
	
factorial:
	addi $sp,$sp,-8
	sw $s0,4($sp)
	sw $ra,0($sp)
	bne $a0,0,else
	addi $v0,$zero,1
	j free
	
else:
	move $s0,$a0
	addi $a0,$a0,-1
	jal factorial
	multu $s0,$v0
	mflo $v0

free:	
	lw $s0,4($sp)
	lw $ra,0($sp)	
	addi $sp,$sp,8
	jr $ra
