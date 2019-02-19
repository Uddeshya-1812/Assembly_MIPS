.data
	input:
	 .asciiz "Enter the value of n:"	
	output: 
	 .asciiz "Sum: "
.text
sum:
loop:
	beq $t1, $t0,end
	add $t2,$t2,$t1
	addi $t1,$t1,1
	j loop
end:
	jr $ra

main:
	li $v0,4
	la $a0,input
	syscall
	li $v0,5
	syscall
	move $t0, $v0 
	addi $t0,$t0,1
         li $t1, 1
	li $t2, 0
	jal sum
	li $v0,4
	la $a0,output
	syscall	 
	
	li $v0,1
	move $a0,$t2
	syscall
	li $v0,10
	syscall
