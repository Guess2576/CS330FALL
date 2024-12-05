.data                                                                   # Start of data section
                                                                        # Put any global or static variables here
                                                                        # Variables for input and output
    input_prompt:   .string "Enter a number of digits to calculate (0-40): "
    output:  .string "%d \n"                                            # Format for printing integers
    error_message:      .string "Error. Enter a number between 0 and 40.\n"

.section .rodata                                                        # Start of read-only data section
                                                                        # Constants here, such as strings
                                                                        # Modifying these during runtime causes a segmentation fault, so be cautious!
                                                                        # Constant format strings (read-only)
    input_format: .string "%d"

.text                                                                   # Start of text /code
                                                                        # Everything inside .text is read-only, which includes your code!
.global main                                                            # Required, tells gcc where to begin execution

# === code here ===
                                                                        # Function to create and print Fibonacci sequence
generate_fibonacci:
                                                                        # Preamble
    pushq %rbp
    movq %rsp, %rbp

                                                                        # Preserving callee saved regs
    pushq %r12
    pushq %r13
    pushq %r14

                                                                        # Input: first arg (n) is already in %edi
    movl %edi, %r14d                                                    # Counter for n
    movl $0, %r12d                                                      # First number (a)
    movl $1, %r13d                                                      # Second number (b)

                                                                        # Checking if n is 0
    testl %r14d, %r14d
    je finish_fibonacci

fibonacci_loop:
                                                                        # Printing current fibonacci number
    movl %r12d, %esi                                                    # Moving current number to second arg
    movq $output, %rdi
    movl $0, %eax
    call printf

                                                                        # Calculating next Fibonacci number
    movl %r13d, %eax                                                    # Moving b to eax
    addl %r12d, %eax                                                    # Adding a to eax (a + b)
    
    # Update values
    movl %r13d, %r12d                                                   # a = b
    movl %eax, %r13d                                                    # b = a + b

    # Decrement and check counter
    decl %r14d                                                          # Decrementing counter
    movl $0, %ecx                                                       # Preparing for comparison
    cmpl %ecx, %r14d                                                    # Comparing counter with 0
    jg fibonacci_loop                                                   # Jump if counter is greater than 0

finish_fibonacci:
                                                                        
    movl $0, %eax
    call printf
                                                                        # Restoring registers and return
    popq %r14
    popq %r13
    popq %r12
    leave
    ret

main:
                                                                        # Preamble
    pushq %rbp
    movq %rsp, %rbp

                                                                        # Make stack 16 byte aligned
                                                                        # Subtracting 16 bytes to align the stack and leave some space for user input
    subq $16, %rsp

                                                                        # Asking user for input
    movq $input_prompt, %rdi
    movl $0, %eax
    call printf

                                                                        # Reading user input
                                                                        # Use the address 8(%rsp) to make sure we have 16 byte aligment
    movq $input_format, %rdi
    leaq 8(%rsp), %rsi
    movl $0, %eax
    call scanf

    # Check input validity
    movl 8(%rsp), %eax
    movl $0, %ecx                                                       # Preparing for comparisons
    cmpl %ecx, %eax                                                     # Comparing input with 0
    jl invalid_input                                                    # Jump if less than 0
    
    movl $40, %ecx                                                      # Preparing for a limit of 40
    cmpl %ecx, %eax                                                     # Comparing input with 40
    jg invalid_input                                                    # Jump if greater than 40

                                                                        # Call Fibonacci function
    movl 8(%rsp), %edi                                                  # Passing n as argument
    call generate_fibonacci

    movl $0, %eax                                                       # Placing return value in %eax
    leave                                                               # Undo preamble, clean up the stack
    ret                                                                 # Return

invalid_input:
                                                                        # Print error message if invalid input
    movq $error_message, %rdi
    movl $0, %eax
    call printf

                                                                        # Return 1 for error
    movl $1, %eax
    leave
    ret