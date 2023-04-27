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
msg1: .asciiz "\nEnter the message to encrypt (100 char max): "
msg2: .asciiz "\nMessage has been encrypted: "
shiftAmount: .byte 3
inputBuffer: .space 101

.text
main:
    # Print msg1
    li $v0, 4		#print string
    la $a0, msg1	#load msg1 address
    syscall
    
    # Read user input
    li $v0, 8		#read string input
    la $a0, inputBuffer	#store into inputBuffer
    li $a1, 100		#read 100 chars max
    syscall
    
    # Encrypt the message
    la $t0, inputBuffer 	# Load address of result into $t0
    lb $t1, shiftAmount     	# Load the shift amount nto $t1
    
encrypt_loop:
    lb $t2, ($t0)   # Load the current character into $t2
    beq $t2, $zero, print_result  # If end of string is reached, print result
    
    addu $t2, $t2, $t1  # Add the key to the character
    
    
store_character:
    sb $t2, ($t0)   # Store the encrypted character back into result
    addiu $t0, $t0, 1   # Increment address to the next character
    j encrypt_loop
    
print_result:
    # Print the encrypted message
    li $v0, 4
    la $a0, inputBuffer
    syscall
    j end
    
end:
	exit
    
    
