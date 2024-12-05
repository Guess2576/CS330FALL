.data
.global prompt
prompt: .string "Enter desired # of Fibonacci digits (0-40): "         # user prompt message
.global fibonacci_msg
fibonacci_msg: .string "Fibonacci sequence: "                           # message to indicate beginning of Fib sequence printing
.global format
format: .string "%d"                                                    # formatting the string for printf and scanf

.section .rodata                                                        # start of read-only data section
# constants here, such as strings
# modifying these during runtime causes a segmentation fault, so be cautious!
loop_vars_format: .string "n = %d, Fibonacci number = %d\n"             # format string for printing loop vars

fibonacci_start_msg: .string "Starting Fibonacci function\n"            # messages for the user but mostly just helpful in debugging
fibonacci_loop_msg: .string "Inside Fibonacci loop\n"
fibonacci_end_msg: .string "Exiting Fibonacci function\n"
main_start_msg: .string "Starting main function\n"
main_end_msg: .string "Exiting main function\n"

.text           # start of text /code
# everything inside .text is read-only, which includes your code!
.global main  # required, tells gcc where to begin execution

# === functions here ===

# Function to print the Fibonacci sequence
.global fibonacci
fibonacci:
                                                                        # preamble
    pushq %rbp
    movq %rsp, %rbp

                                                                        # print function start message
    movq $fibonacci_start_msg, %rdi
    call printf

                                                                        # n is stored at [rbp+16]
    movq 16(%rbp), %rcx

                                                                        # print value of n
    movq %rcx, %rsi                                                     # move n to rsi
    movq $format, %rdi                                                  # load the format string
    call printf                                                         # print n

                                                                        # initialize variables for Fibonacci sequence
    movq $0, %rax                                                       # first Fibonacci number
    movq $1, %rbx                                                       # second Fibonacci number

                                                                        # print the first two Fibonacci numbers
    movq $fibonacci_msg, %rdi
    call printf
    movq %rax, %rsi
    movq %rbx, %rdi
    call printf

                                                                        # calculate and print the rest of the Fibonacci sequence
    movq %rcx, %rdx                                                     # counting the remaining Fibonacci numbers
    subq $2, %rdx                                                       # already printed first two numbers so dont include them
    jz end_fibonacci                                                    # if n <= 2 stop
    movq %rax, %rdi                                                     # move second number as the first number for adding

fibonacci_loop:
                                                                        # print loop iteration message
    movq $fibonacci_loop_msg, %rdi
    call printf

                                                                        # print loop variables
    movq %rcx, %rsi                                                      # counter (n)
    movq %rax, %rdi                                                     # current Fibonacci number
    call print_fibonacci_loop_vars

                                                                        # print the current fibonacci number
    movq %rax, %rsi
    movq $format, %rdi
    call printf

    addq %rbx, %rax                                                     # calculate next fibonacci number
    movq %rax, %rdi                                                     # move it to rdi for printing
    call printf
    movq %rbx, %rdi                                                     # prepare the second number for the next iteration
    movq %rax, %rbx                                                     # update second number to be the latest Fibonacci number
    decq %rdx                                                           # decrement counter
    jnz fibonacci_loop

end_fibonacci:
                                                                        # print function end message
    movq $fibonacci_end_msg, %rdi
    call printf
    leave
    ret

                                                                        # function to print loop variables
print_fibonacci_loop_vars:
    pushq %rbp
    movq %rsp, %rbp

    movq %rsi, %rdx                                                     # counter (n)
    movq %rdi, %rsi                                                     # current fibonacci number
    movq $loop_vars_format, %rdi
    call printf

    leave
    ret

# Main function
main:
                                                                        # preamble
    pushq %rbp
    movq %rsp, %rbp

    # === code here ===

                                                                        # print function start message
    movq $main_start_msg, %rdi
    call printf

                                                                        # prompt user for input
    movq $prompt, %rdi
    call printf

                                                                        # read user input (n)
    leaq format, %rdi
    leaq -8(%rbp), %rsi                                                 # adjusted address for user input variable
    call scanf

                                                                        # print user input
    movl -8(%rbp), %esi
    movq $format, %rdi
    call printf

                                                                        # call Fibonacci function with user input as argument
    movl -8(%rbp), %edi                                                 # pass n as argument to Fibonacci function
    call fibonacci

                                                                        # print function end message
    movq $main_end_msg, %rdi
    call printf
    popq %rbp
    ret