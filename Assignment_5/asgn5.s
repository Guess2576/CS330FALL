#I decided to use %rip in my code. I learned its usage from the following page while browsing for assembly clarification. https://cs61.seas.harvard.edu/site/2020/Asm/


.data                                              # start of data section
# put any global or static variables here

A: .quad 0                                         #initialize A & B to 0 to avoid problems
B: .quad 0
result: .quad 0
promptA: .string "Enter the value of A: "           #terminal text for user inputs
promptB: .string "Enter the value of B: "
resultMsg: .string "Result: %ld\n"                  #terminal text for displaying results
scanfA: .string "%ld"                            #format the strings to take user input for vars
scanfB: .string "%ld" 

.section .rodata                                    # start of read-only data section
# constants here, such as strings
# modifying these during runtime causes a segmentation fault, so be cautious!
five: .quad 5                                       #hardcode 5 so it can be used in problem 1

.text                                               # start of text/code
# everything inside .text is read-only, which includes your code!
.global main                                        # required, tells gcc where to begin execution

# === functions here ===
main:                                               # start of main() function
    pushq %rbp
    movq %rsp, %rbp

    # === code here ===
                                                    #get user input for A                    
    movq $promptA, %rdi
    call printf                                     #print prompt for A
    movq $scanfA, %rdi                           
    leaq A(%rip), %rsi          
    call scanf                                      #ask user input

                                                    #get user input for B (same as A)
    movq $promptB, %rdi
    call printf
    movq $scanfB, %rdi
    leaq B(%rip), %rsi
    call scanf                                      

                                                    #call all problem functions
    call problem_1
    call problem_2
    call problem_3

    movq $0, %rax                                   #return value 0
    leave                                           #restore stack pointer
    ret


#====Problem Functions====

problem_1:                                          #A * 5
    pushq %rbx                                      #
    movq A(%rip), %rax                              #A into rax
    movq five(%rip), %rbx                           #5 into rbx
    imulq %rbx, %rax                                #calculate a*5 (stores result in rax)
    movq %rax, result(%rip)                         #take a*5 and put it into the result
    movq $resultMsg, %rdi
    movq result(%rip), %rsi
    xorq %rax, %rax                                 #XOR rax with itself to clear it
    call printf                                     #print result
    popq %rbx                                       #restore callee saved registers
    ret


problem_2:                                          #(A + B) - (A / B) 
    pushq %rbx                                      #
    movq A(%rip), %rax                              #A into rax
    addq B(%rip), %rax                              #A + B (stores result in rax)
    movq %rax, %rbx                                 #store (A + B) result in rbx

    movq A(%rip), %rax                              #A into rax for division
    cqo                                             #sign extend rax to rdx:rax for division
    idivq B(%rip)                                   #divides rdx:rax by B, quotient in rax

    subq %rax, %rbx                                 #subtract the quotient from (A + B)
    movq %rbx, result(%rip)                         #store the result in memory

    movq $resultMsg, %rdi                           #set up result text in terminal
    movq result(%rip), %rsi                         #load the result for printing
    xorq %rax, %rax                                 #clear %rax by xoring it with itself
    call printf                                     #print result

    popq %rbx                                       #restore callee saved registers
    ret

problem_3:                                          #(A - B) + (A * B) 
    pushq %rbx                                      
    movq A(%rip), %rax                              #A into rax
    subq B(%rip), %rax                              #subtract B from rax
    movq A(%rip), %rcx                              #A into rcx
    imulq B(%rip), %rcx                             #multiply A and B and store in rcx
    addq %rcx, %rax                                 #add result into rax
    movq %rax, result(%rip)                         #take result value and put into result var
    movq $resultMsg, %rdi                          
    movq result(%rip), %rsi
    xorq %rax, %rax                                 #clear %rax by xoring it with itself
    call printf                                     #print result
    popq %rbx                                       #restore callee saved registers
    ret                                             