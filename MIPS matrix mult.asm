.data
matrixARowsMessage: .asciiz "Enter matrixA rows: "
matrixAColsMessage: .asciiz "Enter matrixA cols: "
matrixBRowsMessage: .asciiz "Enter matrixB rows: "
matrixBColsMessage: .asciiz "Enter matrixB cols: "
matrixA: .space 100
matrixB: .space 100
matrixC: .space 100
newline: .asciiz "\n"
matrixAPrint: .asciiz "matrixA\n"
matrixBPrint: .asciiz "matrixB\n"
matrixCPrint: .asciiz "matrixC\n"
errorPrint: .asciiz "\nError , insert another row and cols\n"
Aprint: .asciiz "\nInsert matrix A:\n"
Bprint: .asciiz "\nInsert matrix B:\n"
.text

jal try
try:
#read matrixARows
li $v0 4
la $a0 matrixARowsMessage
syscall
li $v0 5
syscall
add $s0 $zero $v0  # $s0 = matrixA Rows
#read matrixACols
li $v0 4
la $a0 matrixAColsMessage
syscall
li $v0 5
syscall
add $s1 $zero $v0  # $s1 = matrixA Cols

#read matrixBRows
li $v0 4
la $a0 matrixBRowsMessage
syscall
li $v0 5
syscall
add $s2 $zero $v0  # $s2 = matrixB Rows
#read matrixBCols
li $v0 4
la $a0 matrixBColsMessage
syscall
li $v0 5
syscall
add $s3 $zero $v0  # $s3 = matrixB Cols
beq $s1 $s2 start # if input of rows and cols are valid , start..
#if invalid print this message and try again
li $v0 4
la $a0 errorPrint
syscall
jr $ra
#---------------Get Elements in matrix A-------------------------------------------------------------
start:
li $v0 4
la $a0 Aprint
syscall
la $t0 matrixA
mult $s0 $s1
mflo $k0       #amount of elements in matrixA
sll $k0 $k0 2
add $t1 $t0 $k0 #t1 point to the end of the array 
#insert matrixA Elements
GetMatrixAElements:
beq $t0 $t1 endGetMatrixAElements #will stop when t0 gets to the end of the array
li $v0 5
syscall
sw $v0 0($t0)
addi $t0 $t0 4
j GetMatrixAElements
endGetMatrixAElements:
#---------------Get Elements in matrix B-------------------------------------------------------------
li $v0 4
la $a0 Bprint
syscall
la $t0 matrixB
mult $s2 $s3
mflo $k0       #amount of elements in matrixB
sll $k0 $k0 2
add $t1 $t0 $k0 #t1 point to the end of the array
#insert matrixB Elements
GetMatrixBElements:
beq $t0 $t1 endGetMatrixBElements #will stop when t0 gets to the end of the array
li $v0 5
syscall
sw $v0 0($t0)
addi $t0 $t0 4
j GetMatrixBElements
endGetMatrixBElements:

#---------------#Multipyling Martices-------------------------------------------------------------

la $t0 matrixA
la $t1 matrixB
la $t2 matrixC
li $t5 0 #row counter
li $t6 0 #matrixC counter
li $t7 0 #matrixC sum
li $t8 0 #col counter
li $t9 0 #another col counter
sll $s4 $s3 2 # s4 = s3*4  
li $s5 0 # counter for total rows passed


multip:
beq $t5 $s1 endMultip 
sll $t3 $t5 2
add $t4 $t3 $t0 
mult $s1 $s5
mflo $t3
sll $t3 $t3 2
add $t4 $t4 $t3
lw $k0 0($t4)#k0 = the number in the row

mult $t8 $s3
mflo $t4
sll $t4 $t4 2
add $t4 $t4 $t1
add $t4 $t4 $t9 # t9 will count the cols
lw $k1 0($t4)
mult $k1 $k0
mflo $t4
add $t7 $t7 $t4
addi $t5 $t5 1 
addi $t8 $t8 1 
j multip
endMultip:


sll $t3 $t6 2 #calculate counter*word (to get space for the sum)
add $t3 $t3 $t2 #the space + matrixC address
sw $t7 0($t3)
addi $t7 $zero 0 #reset t7
addi $t6 $t6 1 # add 1 to matrixC counter

addi $t5 $zero 0 #reset $t5
addi $t8 $zero 0 # reset $t8
addi $t9 $t9 4 # go to the next word


bne $t9 $s4 multip #if not yet finishd one iterate of row*col

addi $s5 $s5 1 #add 1 to the total row counter (how many rows passed)
li $t9 0 # reset t9


bne $s0 $s5 multip

 


#~~~~~~~~printing matrices~~~~~~~~~
li $v0 1
la $t0 matrixA
la $t1 matrixB
la $t2 matrixC

li $t3 0 #counter
li $t4 0 # counter 2

li $v0, 4      
la $a0 matrixAPrint     
syscall


loop: #matrixA print
	li $v0 1
	lw $a0 0($t0)
	syscall
	addi $t0 $t0 4
	addi $t3 $t3 1
	li $a0 9
	li $v0 11
	syscall
	bne $t3 $s1 loop
	
	li $v0, 4      
	la $a0 newline     
	syscall
	
	addi $t4 $t4 1
	li $t3 0 #reset counter
	bne $t4 $s0 loop

	li $t3 0 #reset counter
	li $t4 0 # reset counter 2

li $v0, 4      
la $a0 matrixBPrint     
syscall

loop2:#matrixB print
	li $v0 1
	lw $a0 0($t1)
	syscall
	addi $t1 $t1 4
	addi $t3 $t3 1
	li $a0 9
	li $v0 11
	syscall
	bne $t3 $s3 loop2
	
	li $v0, 4      
	la $a0 newline     
	syscall
	
	addi $t4 $t4 1
	li $t3 0 #reset counter
	bne $t4 $s2 loop2


	
	
li $t3 0 #reset counter
li $t4 0 # reset counter 2

li $v0, 4      
la $a0 matrixCPrint     
syscall


loop3:#matrixC print
	li $v0 1
	lw $a0 0($t2)
	syscall
	addi $t2 $t2 4
	addi $t3 $t3 1
	li $a0 9
	li $v0 11
	syscall
	bne $t3 $s3 loop3
	
	li $v0, 4      
	la $a0 newline     
	syscall
	
	addi $t4 $t4 1
	li $t3 0 #reset counter
	bne $t4 $s0 loop3

	li $a0 9
	li $v0 11
	syscall




