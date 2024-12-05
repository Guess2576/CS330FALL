.data
    # Variables for input and output
    input_prompt:   .string "Enter the number of Fibonacci numbers to generate (0-40): "
    output_format:  .string "%d "  # Format for printing integers
    newline:        .string "\n"
    error_msg:      .string "Invalid input. Please enter a number between 0 and 40.\n"

.section .rodata
    # Constant format strings (read-only)
    input_format: .string "%d"

.text
.global main

# Function to generate and print Fibonacci sequence
generate_fibonacci:
    # Prologue
    pushq %rbp
    movq %rsp, %rbp

    # Preserve callee-saved registers
    pushq %r12
    pushq %r13
    pushq %r14

    # Input: first argument (n) is already in %edi
    movl %edi, %r14d   # Counter for n
    movl $0, %r12d     # First number (a)
    movl $1, %r13d     # Second number (b)

    # Check if n is 0
    testl %r14d, %r14d
    je done_fibonacci

fibonacci_loop:
    # Print current Fibonacci number
    movl %r12d, %esi   # Move current number to second argument
    movq $output_format, %rdi
    movl $0, %eax
    call printf

    # Calculate next Fibonacci number
    movl %r13d, %eax   # Move b to eax
    addl %r12d, %eax   # Add a to eax (a + b)
    
    # Update values
    movl %r13d, %r12d  # a = b
    movl %eax, %r13d   # b = a + b

    # Decrement and check counter
    decl %r14d         # Decrement counter
    movl $0, %ecx      # Prepare for comparison
    cmpl %ecx, %r14d   # Compare counter with 0
    jg fibonacci_loop  # Jump if counter is greater than 0

done_fibonacci:
    # Print newline after sequence
    movq $newline, %rdi
    movl $0, %eax
    call printf

    # Restore registers and return
    popq %r14
    popq %r13
    popq %r12
    leave
    ret

main:
    # Preamble
    pushq %rbp
    movq %rsp, %rbp

    # Prompt user for input
    movq $input_prompt, %rdi
    movl $0, %eax
    call printf

    # Allocate space on stack for input
    subq $8, %rsp
    
    # Read user input
    movq $input_format, %rdi
    movq %rsp, %rsi
    movl $0, %eax
    call scanf

    # Check input validity
    movl (%rsp), %eax
    movl $0, %ecx      # Prepare for comparisons
    cmpl %ecx, %eax    # Compare input with 0
    jl invalid_input   # Jump if less than 0
    
    movl $40, %ecx     # Prepare upper bound
    cmpl %ecx, %eax    # Compare input with 40
    jg invalid_input   # Jump if greater than 40

    # Call Fibonacci function
    movl (%rsp), %edi  # Pass n as argument
    call generate_fibonacci

    # Return 0 for successful execution
    movl $0, %eax
    leave
    ret

invalid_input:
    # Print error message
    movq $error_msg, %rdi
    movl $0, %eax
    call printf

    # Return 1 to indicate error
    movl $1, %eax
    leave
    ret