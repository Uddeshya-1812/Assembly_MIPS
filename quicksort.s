
.data
       	space: .asciiz " " 		# a $space string.
	 line: .asciiz "\n" 		# a newline string.
	 colonsp: .asciiz ": " 		# a colon string with $space.

	 array: .word 0 : 1000 		
	 size: .word 12 		
	 question: .asciiz "Input number of values to be sorted : "
	 instruct: .asciiz "Input each value: "
	 sorted_array_string: .asciiz "Sorted:"
	 receive_values_loop_iter_string: .asciiz "Input value#"
	 msg_before:	.asciiz	"before : "
	msg_after:	.asciiz "after : "
	msg_space:	.asciiz " "
	msg_newL:	.asciiz "\n"
 
.text

main:
 params_info:
	 li $v0, 4 		
	 la $a0, question 		# print "Input N, the number of values to be sorted : "
	 syscall 			
 params:
	 li $v0, 5 			# Take the value of N
	 syscall 			
	 la $t0, size 			
	 sw $v0, 0($t0) 
 receive_values_loop_info:
	 li $v0, 4 			# prompt user to start feeding in data into the ar$ray
	 la $a0, instruct 
	 syscall 
	 li $v0, 4 			# print new line
	 la $a0, line 
	 syscall 
				### input loop
 receive_values_loop_prep:
	 la $t0, array			# load ar$ray to $$t0.
	 lw $t1, size 			# load size to $t1.
	 li $t2, 0 			# loop iter, starting from 0.
 receive_values_loop:
	 bge $t2, $t1, receive_values_end 			# while ($t2 < $t1).
	 li $v0, 4 						# prompt at every ite$ration during input
	 la $a0, receive_values_loop_iter_string 
	 syscall 
	 li $v0, 1 
	 addi $a0, $t2, 1 					# load (iter + 1) to argument register $$a0.
	 syscall 
	 li $v0, 4 
	 la $a0, colonsp 	
 	syscall 
 	li $v0, 5 
 	syscall 			# USER INPUT
 	sw $v0, 0($t0) 		# store the user input in the ar$ray.
 	addi $t0, $t0, 4 		# increment ar$ray pointer by 4.
 	addi $t2, $t2, 1 		# increment loop iter by 1.
 	j receive_values_loop 		# jump back to the beginning of the loop.
 receive_values_end:
 	jal PRINT 			# printing user input values
 				# Set up the main mergesort call.
 				# Ar$rays are	
	 la $a0, array 			# a0 adrs of the array
	 li $a1, 0 			# left val
	 lw $a2, size 			# right val
	 addi $a2, $a2, -1
	 jal QUICK
	 jal PRINT
 
 li $v0, 10
 syscall


PRINT:
## print Array
	la		$s0, array
	lw		$t0, size
Loop_main1:
	beq		$t0, $zero, Loop_main1_done
	# make space
	li		$v0, 4
	la		$a0, msg_space
	syscall
	# printing Array elements
	li		$v0, 1
	lw		$a0, 0($s0)
	syscall
	
	addi	$t0, $t0, -1
	addi	$s0, $s0, 4
	
	j		Loop_main1
	
Loop_main1_done:
	# make new line
	li		$v0, 4
	la		$a0, msg_newL
	syscall
	jr		$ra

QUICK:
## quick sort

# store $s and $ra
	addi	$sp, $sp, -24	# Adjest sp
	sw		$s0, 0($sp)		# store s0
	sw		$s1, 4($sp)		# store s1
	sw		$s2, 8($sp)		# store s2
	sw		$a1, 12($sp)	# store a1
	sw		$a2, 16($sp)	# store a2
	sw		$ra, 20($sp)	# store ra

# set $s
	move	$s0, $a1		# l = left
	move	$s1, $a2		# r = right
	move	$s2, $a1		# p = left

# while (l < r)
Loop_quick1:
	bge		$s0, $s1, Loop_quick1_done
	
# while (arr[l] <= arr[p] && l < right)
Loop_quick1_1:
						
	## t0 = &arr[l]
						
	mul	$t0, $s0, 4				# t0 =  l * 4bit
	add		$t0, $t0, $a0	# t0 = &arr[l]
	lw		$t0, 0($t0)
					# t1 = &arr[p]
	mul	$t1, $s2, 4
					# t1 =  p * 4bit
	add		$t1, $t1, $a0	# t1 = &arr[p]
	lw		$t1, 0($t1)
	# check arr[l] <= arr[p]
	bgt		$t0, $t1, Loop_quick1_1_done
	# check l < right
	bge		$s0, $a2, Loop_quick1_1_done
	# l++
	addi	$s0, $s0, 1
	j		Loop_quick1_1
	
Loop_quick1_1_done:

# while (arr[r] >= arr[p] && r > left)
Loop_quick1_2:
	#li		$t7, 4			# t7 = 4
	# t0 = &arr[r]
	mul	$t0, $s1, 4
					# t0 =  r * 4bit
	add		$t0, $t0, $a0	# t0 = &arr[r]
	lw		$t0, 0($t0)
	# t1 = &arr[p]
	mul	$t1, $s2, 4
					# t1 =  p * 4bit
	add		$t1, $t1, $a0	# t1 = &arr[p]
	lw		$t1, 0($t1)
	# check arr[r] >= arr[p]
	blt		$t0, $t1, Loop_quick1_2_done
	# check r > left
	ble		$s1, $a1, Loop_quick1_2_done
	# r--
	addi	$s1, $s1, -1
	j		Loop_quick1_2
	
Loop_quick1_2_done:

# if (l >= r)
	blt		$s0, $s1, If_quick1_jump
# SWAP (arr[p], arr[r])
	#li		$t7, 4			# t7 = 4
	# t0 = &arr[p]
	mul	$t6, $s2, 4
					# t6 =  p * 4bit
	add		$t0, $t6, $a0	# t0 = &arr[p]
	# t1 = &arr[r]
	mul	$t6, $s1, 4
					# t6 =  r * 4bit
	add		$t1, $t6, $a0	# t1 = &arr[r]
	# Swap
	lw		$t2, 0($t0)
	lw		$t3, 0($t1)
	sw		$t3, 0($t0)
	sw		$t2, 0($t1)
	
# quick(arr, left, r - 1)
	# set arguments
	move	$a2, $s1
	addi	$a2, $a2, -1	# a2 = r - 1
	jal		QUICK
	# pop stack
	lw		$a1, 12($sp)	# load a1
	lw		$a2, 16($sp)	# load a2
	lw		$ra, 20($sp)	# load ra
	
# quick(arr, r + 1, right)
	# set arguments
	move	$a1, $s1
	addi	$a1, $a1, 1		# a1 = r + 1
	jal		QUICK
	# pop stack
	lw		$a1, 12($sp)	# load a1
	lw		$a2, 16($sp)	# load a2
	lw		$ra, 20($sp)	# load ra
	
# return
	lw		$s0, 0($sp)		# load s0
	lw		$s1, 4($sp)		# load s1
	lw		$s2, 8($sp)		# load s2
	addi	$sp, $sp, 24	# Adjest sp
	jr		$ra

If_quick1_jump:

# SWAP (arr[l], arr[r])
	#li		$t7, 4			# t7 = 4
	# t0 = &arr[l]
	mul	$t6, $s0, 4
					# t6 =  l * 4bit
	add		$t0, $t6, $a0	# t0 = &arr[l]
	# t1 = &arr[r]
	mul	$t6, $s1, 4
					# t6 =  r * 4bit
	add		$t1, $t6, $a0	# t1 = &arr[r]
	# Swap
	lw		$t2, 0($t0)
	lw		$t3, 0($t1)
	sw		$t3, 0($t0)
	sw		$t2, 0($t1)
	
	j		Loop_quick1
	
Loop_quick1_done:
	
# return

	lw		$s0, 0($sp)		# load s0
	lw		$s1, 4($sp)		# load s1
	lw		$s2, 8($sp)		# load s2
	addi	$sp, $sp, 24	# Adjest sp
	jr		$ra
