#Variables to hold the data
.data 

##### Ask User For Name #####
prompt: .asciiz "Hello, What's your name? "			#output prompt to user
name: .space 64 						#reserves 64 bytes for 63-character input
welcome: .asciiz "Welcome to the Basic Calculator Program, "	#new welcome message

##### Ask useres whether they want to run the program #####

welcome1: .asciiz "This program is designed to calculate VERY basic whole number calculations."
asktorun: .asciiz "Would you like to continue with the program? (enter 1 if yes or 0 if no): "
runinput: .word 0

##### Ask users what operation they would like to run #####
askoperation1: .asciiz "Which operation will you like to run on your integers?"
askoperation2: .asciiz "Enter\n1 - for Addition\n2 - for Subtraction\n3 - for Multiplication\n4 - for Division: "
runoperation: .word 0

##### Ask users whether to run again #####
askagain: .asciiz "Would you like to run the program again? (Enter 1 if yes or 0 if no): "
runagain: .word 0

#### Incase users respond wrong to the questions #####
errormess: .asciiz "You did not enter an option given please try again "


###### Asking for Number Variables #####
askuser1: .asciiz "Choose your first integer (Whole Number Only): "	#User prompt to choose number
number1: .word 0							#user's first number variable

askuser2: .asciiz "Choose your second integer (Whole Number Only): "	#user prompt to choose number
number2: .word 0							#user's second number variable

##### Variables where the prompts are saved #####
promptadd: .asciiz " + "		#prompt for + sign			
promptsubtract: .asciiz  " - "		#prompt for - sign
promptproduct: .asciiz " * "		#prompt for * sign
promptdivision: .asciiz " / "		#prompt for / sign
promptequal: .asciiz " = "		#sign for = sign

##### Variables where results are saved #####
result: .space 4
resultadd: .space 0			# variable where integer saves after addition
resultsubtract: .space 0		#variable where integer saves after subtraction
resultproduct: .space 0			#variable where integer saves after multiplying
resultdivision: .space 0		#variable where integer saves after division
remainder:.word 0			#variable where integer saves after division and calculating the remainder
nl: .asciiz "\n"			#new line
remainderlabel: .asciiz "  and remainder is "	#remainder prompt string

errorblt: .asciiz "My calculation power is limited, the number you entered is too small. The calculation result may be incorrect."
errorble: .asciiz "My calculation power is limited, the number you entered is exactly 32- bit. The calculation result may be incorrect."
errorbgt: .asciiz "My calculation power is limited, the number you entered is too large. The calculation result may be incorrect."
errorbge: .asciiz "My calculation power is limited, the number you entered is barely over 32 bit. The calculation result may be incorrect."

thankyou: "Thank you for being patient with me! Goodbye. "		#prompt for goodbye


##### Program Instructions #####
.text 

################# Asking Name Prompt #################

#output prompt FOR NAME
	li $v0, 4		#load print string service
	la $a0, prompt		#load address of prompt
	syscall 
#take input
	li $v0, 8 		#load read string service
	la $a0, name		#load address of name
	li $a1, 63		#max number of characters
	syscall
#print welcome message
	li $v0, 4		#load print string service
	la $a0, welcome		#load address welcome
	syscall 
# print name
	li $v0, 4		#load print string service
	la $a0, name		#load address name
	syscall

################# Asking User To Run Prompt #################

# print 2nd welcome message
	li $v0, 4			#load print string service
	la $a0, welcome1		#load address name
	syscall
	
	jal printnewline
    	
runerror:

#output asking users to run the code or not
	li $v0,4		#load print string service
	la $a0, asktorun	#load address of prompt
	syscall
	
	
#Take input of question to run
	li $v0, 5
	syscall
	sw $v0, runinput 
	lw $t1, runinput
	addi $t2, $zero,1
	beq $t1, $zero, exit
	beq $t1,$t2, main
	
#incase of error
	li $v0, 4
	la $a0, errormess
	syscall
	
	jal printnewline
	
	j runerror

	
################# Asking Number Prompt #################
main:

#Ask First Number Prompt
	li $v0, 4		#load print string service
	la $a0, askuser1	#load address of askuser1
	syscall 
	
	
#take input for number 1
	li $v0, 5		#read input integer, load inout into $v0
	syscall
	sw $v0, number1		#store input integer into number1
	
	
#Ask Second Number Prompt
	li $v0, 4		#load print string service
	la $a0, askuser2	#load address of askuser2
	syscall 
	
#take input for number 2
	li $v0, 5		#read input integer, load input into $v0
	syscall
	sw $v0, number2		#store input integer into number2
	
	jal printnewline

################# Asking Operation Prompt ################# 

#Ask users for which operation to run part 1
	li $v0, 4			#load print string service
	la $a0, askoperation1		#load address of askoperation1
	syscall
	
	jal printnewline

operror:	
#Ask users for which operation to run part 2
	li $v0, 4			#load print string service
	la $a0, askoperation2		#load address of askoperation2
	syscall	

#input for operation
	li $v0,5			#load integer service
	syscall
	sw $v0, runoperation		#store runoperation number
	addi $t1,$zero,1		#1 for addition
	addi $t2,$zero,2		#2 for subtraction
	addi $t3,$zero,3		#3 for product
	addi $t4,$zero,4		#4 for division
	lw $t5, runoperation		#load operation number
	
	beq $t5, $t1, additionjump		#jump to addition prompt
	beq $t5, $t2, subtractionjump		#jump to subtraction prompt
	beq $t5, $t3, multiplicationjump	#jumo to product prompt
	beq $t5, $t4, divisionjump		#jump to divsion prompt
	
	#incase of error
	li $v0, 4
	la $a0, errormess
	syscall
	
	#jump & link to print new line
	jal printnewline
	
	j operror

################# Nested Functions #################

	#addition caller conventions 
	additionjump:
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	
	lw $a0,0($sp)
	lw $a1,4($sp)
	
	jal addition 		
	j repeat		
	
	# subtraction caller conventions
	subtractionjump:
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	
	lw $a0,0($sp)
	lw $a1,4($sp)
	
	jal subtraction
	j repeat
	
	#multiplication caller conventions
	multiplicationjump:
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	
	lw $a0,0($sp)
	lw $a1,4($sp)
	
	jal multiplication
	j repeat
	
	#division caller conventions
	divisionjump:
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	sw $t3, 12($sp)
	
	lw $a0,0($sp)
	lw $a1,4($sp)
	
	jal division
	j repeat

################# Addition Program #################
addition:

	#Store addition function PC (Push Into Stack)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	#jump & link to print new line
	jal printnewline
    	
	#Add both numbers
	lw $a0, number1		#Load number1 value into $t0
	lw $a1, number2		#Load number2 value into $t1
	add $t2, $a1, $a0	#Add number1 & number 2
	sw $t2, resultadd	#store sum into another variable
				
	#Print Number1 Integer
	li $v0, 1		#Load print integer service
	lw $a0, number1		#Load word of number1
	syscall	
	
	#Print "+" symbol stored in promptadd
	li $v0, 4		#Load print string service
	la $a0, promptadd	#Load word of promptadd
	syscall
	
	#Print Number2 Integer
	li $v0, 1		#Load print integer service
	lw $a0, number2		#Load word of number2
	syscall	
	
	#Print "=" symbol stored in promptequal
	li $v0, 4		#Load print string service 
	la $a0, promptequal	#Load word of promptequal
	syscall
	
	#Print resultadd variable 
	li $v0, 1		#Load print integer service
	lw $a0, resultadd	#Load word of resultadd
	syscall
	
	#Jump & Link to Print New Line
	jal printnewline
	
   	# Jump & Link To Error Check
   	jal checkerror
   	
   	#Load addition Function PC (Pop from Stack)
   	lw $ra, 0($sp)
   	addi $sp, $sp, 4
	
	#callee conventions
	add $v0, $zero,$t2
	
	#jump back to addition function
	jr $ra
   		

################# Subtraction Program #################
subtraction:

	#Store subtraction function PC (Push into Stack)
	addi, $sp, $sp, -4
	sw $ra, 0($sp)
	
	#Jump & Link to Print New Line
	jal printnewline
    	
	#number1 - number2
	lw $a0, number1			#Load number1 value into $t0
	lw $a1, number2			#Load number2 value into $t1
	sub $t2, $a0, $a1		#number1 - number2
	sw $t2, resultsubtract		#store difference into resultsubtract
	
	#Print "number1" number
	li $v0, 1			#Load print integer service
	lw $a0, number1			#Load address of number1
	syscall	
	
	#Print "-" symbol stored in prompt1
	li $v0, 4			#Load print string service
	la $a0, promptsubtract		#Load address of promptsubtract
	syscall
	
	#Print "number2" number
	li $v0, 1			#Load print integer service
	lw $a0, number2			#Load address of number2
	syscall	
	
	#Print "=" symbol stored in promptequal
	li $v0, 4			#Load print string service 
	la $a0, promptequal		#Load address of promptequal
	syscall
	
	#Print "resultsubtract" number
	li $v0, 1			#Load print integer service
	lw $a0, resultsubtract		#Load address of resultsubtract
	syscall
					
	# Jump & Link to print new line
	jal printnewline
   
   	#jump & link to check error
   	jal checkerror
   	
   	#Load subtraction function PC (Pop from Stack)
   	
   	lw $ra, 0($sp)
   	addi $sp, $sp, 4
   	
   	#callee conventions
   	add $v0, $zero, $t2
   	
   	#jump back to subtraction function
   	jr $ra				

################# Multiplication Program #################
multiplication:
	
	#Store multiply function PC (Push into Stack)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	#jump & link to print new line 
	jal printnewline
    	
	#number1 * number2
	lw $t0, number1			#Load number1 value into $t0
	lw $t1, number2			#Load number2 value into $t1
	mul $t2, $t0, $t1		#number1 * number2
	sw $t2, resultproduct		#store sum into another variable
	
	#Print "number1" number
	li $v0, 1			#Load print integer service
	lw $a0, number1			#Load address of number1
	syscall	
	
	#Print "*" symbol stored in promptproduct
	li $v0, 4			#Load print string service
	la $a0, promptproduct		#Load address of promptproduct
	syscall
	
	#Print "number2" number
	li $v0, 1			#Load print integer service
	lw $a0, number2			#Load address of number2
	syscall	
	
	#Print "=" symbol stored in prompt2
	li $v0, 4			#Load print string service 
	la $a0, promptequal		#Load address of promptequal
	syscall
	
	#Print "resultproduct" number
	li $v0, 1			#Load print integer service
	lw $a0, resultproduct		#Load address of resultproduct
	syscall
	
	#jump & link to print new line				
	jal printnewline
   	
   	# Jump & Link To Error Check
   	jal checkerror
   	
   	#Load multiply function PC (Pop from Stack)
   	lw $ra, 0($sp)
   	addi $sp, $sp, 4
   	
   	#callee conventions
   	add $v0, $zero, $t2
   	
   	#jump back to multiply function
   	jr $ra	
	
################# Division program #################
division:
	
	#Store division function PC (Push into Stack)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	#jump & link to print new line
	jal printnewline
	
	#number1 / number2
	lw $a0, number1			#Load number1 value into $t0
	lw $a1, number2			#Load number2 value into $t1
	div $t2,$a0, $a1			#operand1 / operand2
    	rem $t3,$a0,$a1
   	sw $t2, resultdivision
	sw $t3, remainder		#store result into memory(resultdivision)
	
	#Print "number1" number
	li $v0, 1			#Load print integer service
	lw $a0, number1			#Load address of number1
	syscall	
	
	#Print "-" symbol stored in prompt1
	li $v0, 4			#Load print string service
	la $a0, promptdivision		#Load address of promptdivision
	syscall
	
	#Print "number2" number
	li $v0, 1			#Load print integer service
	lw $a0, number2			#Load address of number2
	syscall	
	
	#Print "=" symbol stored in prompt2
	li $v0, 4			#Load print string service 
	la $a0, promptequal		#Load address of promptequal
	syscall
	
	#Print "resultdivison" number
	li $v0, 1			#Load print integer service
	add $a0,$zero,$t2		#Add $t2 register into $a0
	syscall
	
	#Print remainder label
	li $v0, 4			#Load print string service 
	la $a0, remainderlabel		#Load address of remainderlabel
	syscall
	
   	#Print "remainder" 
	li $v0, 1			#Load print integer service
	add $a0,$zero,$t3		#Add $t3 register into $a0
	syscall	
	
	#jump & link to print new line
	jal printnewline
    	
    	# Jump & Link To Error Check
   	jal checkerror
   	
   	#Load division function PC (Pop from stack)
   	lw $ra, 0($sp)
   	addi $sp, $sp, 4
	
	#calle convention
	add $v0, $zero, $t2
	add $v1, $zero, $t3
	
   	#jump back to division function
   	jr $ra			


################ Print New Line Function ###############
printnewline:
	li $v0, 4			#Load print string service 
    	la $a0, nl			#Load address of nl
    	syscall
    	
    	#jump back to function
    	jr $ra				
    	
 ################ Check Error Function ################
 checkerror:
 
 	#Check if too small 
	addi $t6, $zero, -1000000000		#assign t6 = -1000000000 
	blt $t2, $t6, errormessageblt	#if result is less than -1000000000, print error message
	ble $t2, $t6, errormessageble	#if result is exactly -1000000000, print error message
	syscall
	
	#Check if too large 
	addi $t7, $zero, 1000000000		#assign t7 = 1000000000
	bgt $t2, $t7, errormessagebgt	#if result is more than 1000000000, print error message
	bge $t2, $t7, errormessagebge	#if result is exactly 1000000000, print error message
	syscall	
	
	#jump back to function
	jr $ra				


################# Repeat Prompt #################
repeat:
	# print askagain prompt
	li $v0, 4			#load print string service
	la $a0, askagain		#load address name
	syscall

	#Take input of question to run
	li $v0, 5			#load integer service
	syscall
	sw $v0, runinput 		#store input 
	lw $t1, runinput		#load input
	bne $t1, $zero, main
	
	j exit
	
################# Error Prompt #################	
# Since MIPS Assembly can be limited and provide wrong results when numbers are outside
# the 32-bit memory, it is designed to let the user know their answer may be wrong. 

errormessageblt:
   	# output error info
	li $v0, 4		#Load print string service 
    	la $a0, errorblt		#Load address of error	
   	syscall	
   	
   	#jump & link to print new line
   	jal printnewline
   	
   	j repeat
   	
   errormessageble:
   	# output error info
	li $v0, 4		#Load print string service 
    	la $a0, errorble		#Load address of error	
   	syscall	
   	
   	#jump and link to print new line
   	jal printnewline
   	
   	j repeat
   	
   errormessagebgt:
   	# output error info
	li $v0, 4		#Load print string service 
    	la $a0, errorbgt		#Load address of error	
   	syscall	
   	
   	#jump & link to print new line
   	jal printnewline
   	
   	j repeat
   	
   errormessagebge:
   	# output error info
	li $v0, 4		#Load print string service 
    	la $a0, errorbge		#Load address of error	
   	syscall	
   	
   	#jump & link to print new line
   	jal printnewline
   	
   	j repeat

################# exit program #################
exit:
	# print askagain prompt
	li $v0, 4			#load print string service
	la $a0, thankyou		#load address name
	syscall
	
	li $v0, 10
	syscall	
