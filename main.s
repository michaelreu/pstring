	#204176085	michael reubinof

.section  .rodata
    
 .align 8              

# string formats
fmt_invalid: .string "invalid input!\n"
int_size:  .string "%d"
char_size:  .string "%c"
	 
    .section  .text
    
.globl  main
    .type main, @function 
main:
    
    pushq   %rbp            # save old frame pointer
    movq    %rsp, %rbp
	# save cally registers
    pushq   %r12            # save callie save registers
    pushq   %r13
    pushq   %r14
    pushq   %r15
    pushq   %rbx
    
    # getting the size string1
    subq    $8, %rsp        # allocating a quad for putting the input from scanf
    movq    $0, (%rsp)      # zero rsp data
    movq    %rsp, %rsi      
	movq	  $int_size, %rdi 
	movq	  $0, %rax
	
	 call scanf
    movq    $0, %r14          # zero r14 data
    movq    (%rsp), %r14    # move inputed size to %r14 for convinence
    movq    %rsp, %rsi      
    movq    $char_size, %rdi  
    movq    $0, %rax
    call    scanf           # get the dummy
	
    cmpq    $254, %r14      # check if srt.length is valid
    ja      .invalid       
    
    # building the 1st Pstring
    subq    %r14, %rsp      
    subq    $2, %rsp        # two extra bytes for '/0' and the size of the string
    movq    %rsp, %r12      
    movq    %r14, (%rsp)   
    movq    %rsp, %r15     
    movq    $0, %rbx        # rbx is counter = 0
 # scaning the string char by char   
.First_loop:

    cmpq    %rbx, %r14      # if str.length <= counter
    jle     .End1
    
    incq 		%r15        	  # increase address by one
    movq    %r15, %rsi      
    movq    $char_size, %rdi  
    movq    $0, %rax
    call    scanf
	
    incq 		%rbx        # increase counter by one
    jmp     .First_loop
    
.End1:
    addq    $1, %r15        # put '/0' instead of '\n'
    movq    $0, (%r15)      # put '/0' at the end of the string
    
    # getting the size string2
    subq    $8, %rsp        # allocating a quad for putting the input from scanf
    movq    $0, (%rsp)      
    movq    %rsp, %rsi      
	 movq	  $int_size, %rdi  
	 movq	  $0, %rax
	 call	  scanf
	  
    movq    $0, %r14        
    movq    (%rsp), %r14    
    movq    %rsp, %rsi      #move the input to rsi
    movq    $char_size, %rdi  
    movq    $0, %rax
    call    scanf           # get the dummy
    cmpq    $254, %r14     # check if srt.length is valid
    ja      .invalid       
    
    # building the 2nd Pstring
    subq    %r14, %rsp     
    subq    $2, %rsp        # two extra bytes for '/0' and the size of the string
    movq    %rsp, %r13      
    movq    %r14, (%rsp)    # put the size at the beginning of the Pstring
    movq    %rsp, %r15      
    movq    $0, %rbx        # rbx is counter = 0
# scaning the string char by char
.Second_loop:

    cmpq    %rbx, %r14     # if str.length <= counter
    jle     .End2
    
    incq 		%r15        # increase address by one
    movq    %r15, %rsi      
    movq    $char_size, %rdi  
    movq    $0, %rax
    call    scanf
    addq    $1, %rbx        # increase counter by one
    jmp     .Second_loop
    
.End2:
    addq    $1, %r15        # put '/0' instead of '\n'
    movq    $0, (%r15)      # put '/0' at the end of the string    
    
    # getting the option number
    subq    $8, %rsp        # allocating a quad for putting the input from scanf
    movq    $0, (%rsp)      
    movq    %rsp, %rsi      
	movq	  $int_size, %rdi  
	movq	  $0, %rax
	call  scanf
	# scan dummy
    movq    $0, %r14        
    movq    (%rsp), %r14    
    movq    %rsp, %rsi      
    movq    $char_size, %rdi 
    movq    $0, %rax
    call    scanf         
    
    # calling run_func
    movq    %r14, %rdi      # inputed number
    movq    %r12, %rsi      #  1st Pstring 
    movq    %r13, %rdx      # 2nd Pstring 
    call    run_func
    jmp     .END
    
    # if (str.length<0 || str.length>254) was inputed
.invalid:
    
    movq    $fmt_invalid, %rdi   
    movq    $0, %rax 		
    call    printf
    jmp     .END
    
.END:
        
    movq    $0,  %rax       # return (0)
	# restoring callie registers
    movq    -40(%rbp), %rbx 
    movq    -32(%rbp), %r15
    movq    -24(%rbp), %r14
    movq    -16(%rbp), %r13 
    movq    -8(%rbp), %r12  
    movq    %rbp, %rsp      # restore old frame pointer
    popq    %rbp
    ret
