# CS2640-01
# Group: AHHHH (Khushi Gupta, Remi Ong, Tam Dinh, Viet Nguyen)
# April 27, 2023
# Objective: Final Program: Caesar Cipher
# - User menu with encrypt, decrypt, exit options

# Encrypt objs:
# - Get user message input
# - Encode message using Caesar Cipher
# - Return encrypted message to user

# Decrypt objs:
# - get user encrypted message input
# - Decode message using Caesar Cipher
# - Return decrypted message to user

# Exit obj:
# - Exit program using macro

.macro exit
	# Exit program
    	li $v0, 10
    	syscall
.end_macro

.data
welcomeMsg: .asciiz "\nWelcome to the AHHHHHsembly Caesar Cipher!"
menu: .asciiz "\nPlease select an option:\n1) - Encrypt\n2) - Decrypt\n3) - Quit"
instruction: .asciiz "\n\nPlease enter a number 1-3 to select an option: "
invalidInput: .asciiz "\nInvalid input! Please enter a number 1-3"
encryptinput: .asciiz "\nEnter the message to encrypt (100 char max): "
encryptoutput: .asciiz "\nMessage has been encrypted: "
decryptinput: .asciiz "\nEnter the message to decrypt (100 char max): "
decryptoutput: .asciiz "\nMessage has been decrypted: "
keyask: .asciiz "\nPlease enter a number for the shift key: "
#shiftAmount: .byte 3		#no longer used
inputBuffer: .space 200
resultMsg: .asciiz "\nThe result message is: "
newTry: .asciiz "\n\nWould you like to try again?\n(Y)Yes (N)No\n\nEnter 'Y' or 'N'for your selection: "

.text
welcome: 
	# Print welcome message
	li $v0, 4
	la $a0, welcomeMsg
	syscall
main:
	# Print menu to user
	li $v0, 4
	la $a0, menu
	syscall
	
	# Print instruciton to user
	li $v0, 4
	la $a0, instruction
	syscall
	
	# Get user menu selection
	li $v0, 5
	syscall
	move $t7, $v0		#Storing the user menu input in $t7
	
	#branch to check if user input is less than 1 or greater than 3
	blt $t7, 1, invalid
	bgt $t7, 3, invalid
	#branch to check if user input is 1, 2, or 3
	beq $t7, 1, encrypt
	beq $t7, 2, decrypt
	beq $t7, 3, end

    
invalid:
	# Print out invalid input
	li $v0, 4
	la $a0, invalidInput
	syscall
	
	j main
	# Reprompt the user for valid input
    
encrypt:
	# Print encryptinput msg
    	li $v0, 4		#print string
    	la $a0, encryptinput	#load encryptinput address
    	syscall
    
    	# Read user input
    	li $v0, 8		#read string input
    	la $a0, inputBuffer	#store into inputBuffer
    	li $a1, 199		#read 100 chars max
   	syscall
    
    	# Ask for shift key
    	li $v0, 4
    	la $a0, keyask
    	syscall
    	
    	# Get user key input, store in $t1
    	li $v0, 5		#get user int input
    	syscall
    	move $t1, $v0
    
    	# Encrypt the message
    	la $t0, inputBuffer 	# Load address of result into $t0
    	#lb $t1, shiftAmount    	# Load the shift amount nto $t1, no longer used
    	
    	j encrypt_loop
    
encrypt_loop:
    	lb $t2, ($t0)   # Load the current character into $t2
    	beq $t2, $zero, print_result  # If end of string is reached, print result
    
    	add $t2, $t2, $t1  # Add the key to the character (shifts it)
    
    	sb $t2, ($t0)   # Store the encrypted character back into result
    	addi $t0, $t0, 1   # Increment address to the next character
    	j encrypt_loop
    
decrypt:
	# Print encryptinput msg
    	li $v0, 4		#print string
    	la $a0, decryptinput	#load msg1 address
    	syscall
    
    	# Read user input
    	li $v0, 8		#read string input
    	la $a0, inputBuffer	#store into inputBuffer
    	li $a1, 199		#read 100 chars max
   	syscall
   	
decrypt_key:
    	# Ask for shift key
    	li $v0, 4
    	la $a0, keyask
    	syscall
    	
    	# Get user key input, store in $t1
    	li $v0, 5		#get user int input
    	syscall
    	move $t1, $v0
    
    	# Encrypt the message
    	la $t0, inputBuffer 	# Load address of result into $t0
    	#lb $t1, shiftAmount    	# Load the shift amount nto $t1, no longer used
    	
    	j decrypt_loop
    
decrypt_loop:
    	lb $t2, ($t0)   # Load the current character into $t2
    	beq $t2, $zero, print_result  # If end of string is reached, print result
    
    	subu $t2, $t2, $t1  # Add the key to the character (shifts it)
    
    	sb $t2, ($t0)   # Store the encrypted character back into result
    	addi $t0, $t0, 1   # Increment address to the next character
    	j decrypt_loop
    
print_result:
    	# Print the encrypted/decrypted message
    	li $v0, 4
    	la $a0, resultMsg
    	syscall
    	
    	# Print the inputBuffer
    	li $v0, 4
    	la $a0, inputBuffer
    	syscall
    	j loopAgain
    	
#loopAgain to ask if user would like to try again or quit	
loopAgain:
	li $v0, 4
	la $a0, newTry
	syscall
	
	#Get user input's character
	li $v0, 12
	syscall
	
	move $t0, $v0 #move to register $t0
	
	#load immediate 'y' to $t1 and  'n' to $t2 for comparation
	li $t1, 'y'
	li $t2, 'n'
	
	#if $t1 is equal to $t0 as 'y', continue the program
	beq $t1, $t0, main
	
	#if $t2 is equal to $t0 as 'n', end the program
	beq $t2, $t0, end
	
    
end:
	exit
    
    
