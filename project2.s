.globl main
main:

.data

msg1: .asciiz "Enter first integer n1: "
msg2: .asciiz "Enter second integer n2: "
msg3: .asciiz "Invalid input! please try again."
msg4: .asciiz "The greatest common divisor of n1 and n2 is "
msg5: .asciiz "The least common multiple of n1 and n2 is "
nl: .asciiz "\n"

.text

inputLoop:

la $a0, msg1    #load msg1 to a0
li $v0, 4	#print string
syscall 

li $v0, 5	#input first number
syscall 
move $s0, $v0

slti $t0, $s0, 256	#set t0=1 if n1 < 256
beq $t0, $zero, invalid

la $a0, msg2    #load msg2 to a0
li $v0, 4	#print string
syscall 

li $v0, 5	#input second number
syscall 
move $s1, $v0

slti $t0, $s1, 256	#set t0=1 if n2 < 256
beq $t0, $zero, invalid

beq $s0, $zero, zerovalid	#check if n1 is zero

j inputEnd

zerovalid:	#if n1 is zero, check if n2 is zero
beq $s1, $zero, invalid
j inputEnd

invalid:
la $a0, msg3    #load msg3 to a0
li $v0, 4	#print string
syscall 

la $a0, nl	#load nl to a0
li $v0, 4	#print string
syscall
j inputLoop

inputEnd:

la $a0, msg4   #load msg4 to a0
li $v0, 4	#print string
syscall 

add $a0, $s0, $zero	#store n1 in first argument
add $a1, $s1, $zero	#store n2 in second argument
jal gcd 
add $t0, $v0, $zero

move $a0, $t0	#move t0 to a0
li $v0, 1	#print int
syscall 

la $a0, nl  #load nl to a0
li $v0, 4	#print string
syscall 

la $a0, msg5   #load msg5 to a0
li $v0, 4	#print string
syscall 

add $a0, $s0, $zero	#store n1 in first argument
add $a1, $s1, $zero	#store n2 in second argument
jal lcm 
add $t0, $v0, $zero

move $a0, $t0	#move t0 to a0
li $v0, 1	#print int
syscall 

addi $v0, $zero, 10     # exit program on syscall
syscall                 # exit program




#greatest common divisor function*********************************************************
gcd:
add $t0, $a0, $zero	#set t0 and t1 to arguments
add $t1, $a1, $zero

beq $t1, $zero, n2zero	#if n2==0

add $t2, $t1, $zero	#else recursive step
div $t0, $t1		#modulus step
mfhi $a1
move $a0, $t2		#make result and argument
j gcd

return:		#return to main
jr $ra

n2zero:		#if n2 == 0, set return value
move $v0, $t0
j return

#least common multiplier**********************************************************************

lcm:
addi $sp, $sp, -4	#create stack 
sw $ra, 0($sp)		#store lcm return

add $t6, $a0, $zero	#save arguments
add $t7, $a1, $zero

add $a0, $t6, $zero	#store n1 in first argument for gcd
add $a1, $t7, $zero	#store n2 in second argument for gcd
jal gcd 
add $t0, $v0, $zero

mult $t6, $t7		#multiply n1 and n2
mflo $t4

div $t4, $t0		#final division
mflo $v0

lw $ra, 0($sp)		#reload $ra
addi $sp, $sp, 4	#deallocate stack

jr $ra			#return to lcm call



