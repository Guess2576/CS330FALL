	.file	"asgn5.c"								#source file
	.text											#start of the code section
	.globl	myAddTwoNumbersFunction					#declaring the function as global
	.type	myAddTwoNumbersFunction, @function		#specifying that it is a function


myAddTwoNumbersFunction:							#This block creates the "myAddTwoNumbersFunction". It takes 2 integer args, adds them together, and returns their result. 
.LFB0:
	.cfi_startproc
	pushq	%rbp									#save the base pointer of the caller function
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp								#set the base pointer to the stack pointer
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)							#store the first value that's in %edi into local variable at -4(%rbp)
	movl	%esi, -8(%rbp)							#store the second value that's in %esi into local variable at -8(%rbp)
	movl	-4(%rbp), %edx							#load first value into %edx
	movl	-8(%rbp), %eax							#load the second value into %eax
	addl	%edx, %eax								#add the first and second values together and store in %eax
	popq	%rbp									#restore the caller's base pointer
	.cfi_def_cfa 7, 8
	ret												#return from function with result in %eax
	.cfi_endproc


.LFE0:												#This block is wrapping up the details of the previous function while preparing to begin the main function
	.size	myAddTwoNumbersFunction, .-myAddTwoNumbersFunction		#calculate the size of the function
	.section	.rodata												#start of the read-only data section
.LC0:
	.string	"The answer is %d\n"									#declare the string used in the printf statement
	.text															#declare that we are returning to the code portion
	.globl	main													#declare main as globally accessible
	.type	main, @function											#specifying that main is a function


main:												#This block creates the main function. Within, it initializes the variables, calls the myAddTwoNumbersFunction, and prints the result. Returning with exit code of 0.
.LFB1:
	.cfi_startproc
	pushq	%rbp													#save the base pointer of the caller
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp												#set the base pointer to the stack pointer
	.cfi_def_cfa_register 6
	subq	$16, %rsp												#allocating 16 bytes on the stack for local variables
	movl	$10, -12(%rbp)											#store constant 10 as a local variable at -12(%rbp)
	movl	$7, -8(%rbp)											#store constant 7 as a local variable at -8(%rbp)
	movl	$0, -4(%rbp)											#initialize local variable to 0 at -4(%rbp)
	movl	-8(%rbp), %edx											#load 7 into %edx
	movl	-12(%rbp), %eax											#load 10 into %eax
	movl	%edx, %esi												#load 7 into %esi	(prepping for call)
	movl	%eax, %edi												#load 10 into %edi	(prepping for call)
	call	myAddTwoNumbersFunction									#call the function to add 10 and 7
	movl	%eax, -4(%rbp)											#store result of the function back into -4(%rbp)
	movl	-4(%rbp), %eax											#load result back into %eax for printing
	movl	%eax, %esi												#move result to %esi (prepping for print)
	leaq	.LC0(%rip), %rdi										#load the address of the string into %rdi
	movl	$0, %eax												#set %eax to 0
	call	printf@PLT												#call print function to show the result
	movl	$0, %eax												#set return value of main to 0
	leave															#restore stack and base pointers
	.cfi_def_cfa 7, 8
	ret																#return from main function
	.cfi_endproc
.LFE1:
	.size	main, .-main											#calculate the size of the main function
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"				#label the compiler that's being used
	.section	.note.GNU-stack,"",@progbits						#extra info on the stack
