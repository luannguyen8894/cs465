#Luan Nguyen 01299044
#Algorithm
#The program prompts the user to enter a binary string.
#The program initializes registers and loads the address of the binary string.
#The program initializes a counter ($s0) to count the number of '1' bits and a pointer ($s1) to the binary string.
#The program enters a loop to process each character in the binary string.
#It loads a character from the string and checks if it's the null terminator or newline character, indicating the end of the string.
#If the character is '0', it proceeds to the next character.
#If the character is '1', it increments the counter and moves to the next character.
#If the character is anything else, it displays an error message and exits the program
#When the loop finishes, it displays a message with the count of '1' bits in the binary string.
#It calculates whether the count is even or odd and stores '0' or '1' at the end of the binary string accordingly.
#It prints the number of 1-bits and the updated binary string with the even or odd parity bit.
#Finally, the program exits.
.data
    binaryString:   .space  31      # Space to store the binary string (up to 32 bits)
    result:         .word   0       # Variable to store the count of 1s
    prompt:     .asciiz "Enter a binary string: "
    invalidMes:     .asciiz "Warning: not a valid binary string!"
    result1BiTMes:     .asciiz "Count of 1-bits:"
    evenParityBitPrompt: .asciiz "\nOutput including even parity bit: "
.text
    .globl main

main:
    # Prompt the user to enter a binary string
    li   $v0, 4
    la   $a0, prompt
    syscall

    # Read the binary string from the user
    li   $v0, 8
    la   $a0, binaryString
    li   $a1, 31         # 30 characters + 1 null byte
    syscall

    # Initialize the result to 0
    li   $s0, 0          # Counter for the number of 1s
    la   $s1, binaryString # Load address of the first string.
loop:
    # Load a character from the binary string
    lb $s2, 0($s1) 

    # Check if we've reached the end of the string (null terminator)
    beq $s2, '\0', endLoop
    beq $s2, '\n', endLoop

    # Check if the character is '1' or '0'
    li   $s3, '0'
    beq  $s3, $s2, nextChar
    li   $s4, '1'
    beq  $s4, $s2, increaseCounter

    # invalid character
    j    invalidChar

increaseCounter:
    # Increment the count of 1s
    addi $s0, $s0, 1
    addi $s1, $s1, 1
    j    loop
nextChar:
    # Move to the next character in the string
    addi $s1, $s1, 1
    j    loop
    
invalidChar:
    # Message when the input is invalid
    li   $v0, 4
    la   $a0, invalidMes
    syscall
    # Exit the program
    li   $v0, 10
    syscall

endLoop:
    # Message for the number of 1 bits
    li   $v0, 4
    la   $a0, result1BiTMes
    syscall
    
    # Display the result
    li   $v0, 1
    move $a0, $s0
    syscall
    
    addi $t0, $zero, 2    # Store 2 in $t0
    div $t0, $s0, $t0     # Divide input by 2
    mfhi $t2              # Save remainder in $t2
    
    li   $t3, '0'
    li   $t4, '1'
    beq  $t2, 1, isOdd #number of 1 bits is odd
    beq  $t2, 0, isEven #number of 1 bits is odd
    
    
# Store the character at the end of the string    
isOdd: # Display the result for an odd number of 1 bits
    sb   $t4, ($s1) # Store '1' at the end of the binary string to indicate odd parity bit
    # The final output message
    li   $v0, 4
    la   $a0, evenParityBitPrompt
    syscall
    # Print out the actual output even parity bit binary string
    li   $v0, 4
    la   $a0, binaryString
    syscall
    # Exit the program
    li   $v0, 10
    syscall
isEven:   
    sb   $t3, ($s1) # Store '0' at the end of the binary string to indicate odd parity bit
    # The final output message
    li   $v0, 4
    la   $a0, evenParityBitPrompt
    syscall
    # Print out the actual output even parity bit binary string
    li   $v0, 4
    la   $a0, binaryString
    syscall
    # Exit the program
    li   $v0, 10
    syscall

	
