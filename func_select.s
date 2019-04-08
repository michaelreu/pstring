#204176085	michael reubinof

.data 

	pstring_format: .string "first pstring length: %d, second pstring length: %d\n"
    fmt_1: .string "first pstring length: %c, second pstring length: %c\n"
    fmt_2: .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
	fmt_53: .string "length: %d, string: %s\n"
    fmt_4: .string "compare result: %d\n"
    invalid_option: .string "invalid option!\n"
    fmt_char: .string " %c\n"
	st: .string " %s\n"
	fmt_char_no_space: .string " %c"
    fmt_int: .string "%d"

.align  8   #Align address to multiple of 8

.My_Switch:
	.quad .My_Switch_50      #Case 50
	.quad .My_Switch_51      #Case 51
	.quad .My_Switch_52      #Case 52
	.quad .My_Switch_53      #Case 53
	.quad .My_Switch_54      #Case 54
	.quad .My_Switch_Def     #Case Def:loc_Def


.text

.globl run_func
    .type run_func, @function
 
run_func:
						
	#save the prev address
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	pushq	%r12
	pushq	%r13
	pushq	%r14
	pushq	%r15
	subq 	$40, %rsp	
	
	# switch 
	leaq	 -50(%rdi), %r10           # compute r10 = x - 50
	cmpq	$4,	%r10                     # compare x : 4
	ja .My_Switch_Def		        # if >, Go to default case.		
	jmp *.My_Switch(,%r10,8)    # Go to jt[xi]
     
     #case 50
     .My_Switch_50:                             
         movq	%rdx, %r9               # save the second string
         movq	%rsi, %rdi 						
         call pstrlen                          # calling function pstrlen  
	
         movq 	%rax, %r8                # move return value of pstring_format to rsi
         movq 	%r9, %rdi               # move second string to rdi
         call pstrlen
	
         movq $pstring_format, %rdi        
         movq	%rax, %rdx				  # move return value of pstring_format to rsi 
		 movq	%r8, %rsi  
		 movq	$0, %rax						
		call printf                             # call printf function						
	
		jmp  .End_func
         
		 
	#case 51
    .My_Switch_51: 
		 
			movq	%rsi, %r12        #save str1
			movq	%rdx , %r13        #save str2
        		
			leaq		-9(%rbp), %rax							# allcate memmory to the enter comes after the last input
			movq	%rax, %rsi							
			movl		$fmt_char_no_space, %edi		# c = %c
			movl		$0, %eax
			call scanf
			
			movzbl	-9(%rbp), %eax					# get the char from the stack
			movsbl	%al, %eax							# take the first byte
			movq	$0, %r14				
			movb	%al, %r14b							# put the char in %r14b
				
			leaq		-9(%rbp), %rax							# I will put the char that comes as input in the same place that the dummy was
			movq	%rax, %rsi							# the second parameter to scanf 
			movl		$fmt_char_no_space, %edi		# c = %c
			movl		$0, %eax
			call scanf
			
			movzbl	-9(%rbp), %eax					# get the char from the stack
			movsbl	%al, %eax							# take the first byte
			movq 	$0, %r15
			movb	%al, %r15b							# put the char in %r15b 

			# get strings size
			movq 	(%r12) , %rbx
			movzbl 	%bl, %r8d
			
			# replace first string	
			movq %r12 , %rdi             
			movq %r14 , %rsi
			movq %r15 , %rdx
			movq %r8   , %rcx
			
			call replaceChar
			
			# replace second string
			movq 	(%r13) , %rbx
			movzbl 	%bl , %r9d
			movq 	%r13 , %rdi             
			movq 	%r14 , %rsi
			movq 	%r15 , %rdx
			movq 	%r9 , %rcx
			 
			 call replaceChar
			 
			 # print the new strings
			 movq $fmt_2, %rdi
			 movq %r14 , %rsi
			 movq %r15 , %rdx
			 movq %r12, %rcx
			 incq   %rcx
			 movq %r13, %r8
			 incq   %r8
			xorq 	  %rax , %rax                  
			 call printf
	
			# end func
			jmp .End_func
                     
     #case 52
    .My_Switch_52:  
        
					movq %rsi , %r12        #save str1
					movq %rdx , %r13        #save str2
					
					#scan i
					subq		$16, %rsp             		# increas the stack    
					movq	$0 , (%rsp)            		# zero 
					movq 	%rsp , %rsi           		      
					movq 	$fmt_int , %rdi       		
					xorq  	%rax , %rax
					call scanf
					mov 		(%rsp) , %r14          		# save i in r14
					
					#scan j
					movq	$0 , (%rsp)
					movq	%rsp , %rsi            
					movq	$fmt_int , %rdi       # the format in 1 arg
					xorq	    %rax , %rax
					call scanf
					movq	(%rsp) , %r15          # save j in r15
					
					#get the strings length
					movq 	(%r12) , %rbx
					movzbl  %bl, %r8d
					movq 	(%r13) , %rbx
					movzbl 	%bl , %r9d
					
					#set the registers to call pstrijcpy func
					movq 	%r12 , %rdi             
					movq 	%r13 , %rsi
					movq 	%r14 , %rdx
					movq 	%r15 , %rcx
					
					call pstrijcpy
					
					#set the registers to call printf
					movq 	%r12, %rdx
					addq 	$1 , %rdx
					movq 	%r12 , %rdi
					call pstrlen
					movq 	%rax , %rsi
					movq 	$fmt_53 , %rdi
					xorq 		%rax , %rax
					
					call printf
					
					#set the registers to call printf
					movq 	%r13 , %rdx
					addq 	$1 , %rdx
					movq 	%r13 , %rdi
					call pstrlen
					movq 	%rax , %rsi
					movq 	$fmt_53 , %rdi
					xorq 		%rax , %rax
					
					call printf
					
					
					# end func
					jmp .End_func

                                                        
       #case 53
       .My_Switch_53 : 
					
					movq 	%rsi , %r12        #save str1
					movq 	%rdx , %r13        #save str2
					
					# get string1 size
					movq 	(%r12) , %rbx
					movzbl	 %bl, %r8d
				
					
					# switch first string
					movq 	%rsi, %rdi
					movq 	%r8, %rsi
					call swapCase
					
					#print srtring 1
					movq 	%r12, %rdx
					incq 		%rdx
					movq 	%r8, %rsi
					movq 	$fmt_53, %rdi
					movq 	$0, %rax
					call printf
					
					# get string2 size 
					movq 	(%r13) , %rbx
					movzbl 	 %bl , %r9d 
				
					
					# switch second string
					movq 	%r13, %rdi
					movq 	%r9, %rsi
					call swapCase
					
					#print srtring 2
					movq 	%r13, %rdx
					incq 		%rdx
					movq 	%r9, %rsi
					movq 	$fmt_53, %rdi
					movq 	$0, %rax
					call printf
					
					# end func
					jmp .End_func
					
		#case 54
		.My_Switch_54 : 
								
					movq 	%rsi , %r12        		 #save str1
					movq 	%rdx , %r13       			 #save str2
				
					#scan i
					subq		 $16 , %rsp            		 # increas the stack    
					movq	 $0 , (%rsp)           		 # zero 
					movq	 %rsp , %rsi          		     
					mov		 $fmt_int , %rdi      		 
					xorq 		 %rax , %rax		
					call scanf		
					mov 		 (%rsp) , %r14        		 # save the i in r14
				
					#scan j
					movq 	$0 , (%rsp)
					movq 	%rsp , %rsi            
					movq 	$fmt_int , %rdi       
					xorq 		%rax , %rax
					call scanf
					movq 	(%rsp) , %r15          # save the j in r15
					
					#get the length of the strings
					movq 	(%r12) , %rbx
					movzbl 	%bl, %r8d
					movq 	(%r13) , %rbx
					movzbl 	%bl , %r9d
					
					# set the registers and send them to strcmp
					movq   %r12 , %rdi
					movq   %r13 , %rsi   
					movq   %r14 , %rdx
					movq   %r15 , %rcx
					call pstrijcmp
					
					#print the result
					movq 	$fmt_4,%rdi #first parameter
					movq 	%rax,%rsi
					xorq 		%rax,%rax
					call printf
		
					# end func
					jmp .End_func
                     
        #defult
         .My_Switch_Def : 
					
					movq 	$invalid_option, %rdi
					xorq 		%rax, %rax
                     call printf   
					 	# end func
					jmp .End_func
			
		.End_func:
					popq 	%r15
					popq 	%r14
					popq 	%r13
					popq 	%r12
					popq 	%rbx
					movq	 %rbp, %rsp
					popq 	%rbp
					xorq  	%rax, %rax
                    ret                    
					