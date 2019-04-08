	#204176085	michael reubinof

.text

.globl pstrlen
    .type pstrlen, @function

pstrlen:

		movq (%rdi) , %rcx
		movzbl %cl , %eax    # move the first byte of the str.
		ret


.data 
	sr: .string "%c\n "
	invalid54: .string "invalid input!\n"

.text

.globl replaceChar
    .type replaceChar, @function

replaceChar:
				
				movq %rdi, %r11    # save src address
				movq $1, %r8 		  #r8 is counter of for loop
				incq %rdi
					
	.Start:	
				cmpq %rcx, %r8      # compare i to string length
				jg .End						# if src.length < i
				
				cmpb (%rdi), %sil      # if string[i] == oldchar
				jne .Inc
				
				#swap
				movb %dl  , (%rdi)
				
	.Inc:
		        inc %rdi
				inc %r8    # i++
				jmp .Start
				
	# return the new string			
	 .End:
             		movq %r11, %rdi
				ret

.data
  fmt_error: .string "invalid inputs\n"

.text

.globl pstrijcpy
    .type pstrijcpy, @function

pstrijcpy: 

			movq %rdi, %r10    # save src address
			
			#check the inputs
			cmp  	$0, %rdx	        # compare i to 0
			jl .Error					   # if x < 0
			cmp 		%rdx, %rcx	   #compare i to j
			jl .Error					   #if i > j
			cmpb 	%r8b, %cl      # compare src to j
			jge .Error				   # if src.length < j
			cmpb 	%r9b , %cl 	   # compare des to j
			jge .Error				   # if des.length < j
			cmpb 	%r8b, %dl      # compare src to j
			jge .Error				   # if src.length < i
			cmpb 	%r9b , %dl 	   # compare des to j
			jge .Error				   # if des.length < i
	
	
			#rdiregister is the counter, set to i		
		   addq  	%rdx , %rsi		#src adress += i
		   addq  	%rdx , %rdi		#des adress += i

	.loop1:			
			 inc 	%rdi   					# move forward on src string
			 inc 	%rdx						# move forward on dec string
			 inc 	%rsi   					# i++
	
			 # make the swap
			movb	 (%rsi) , %r11b
			movb 	%r11b  , (%rdi)
			cmpq 	%rcx, %rdx    #Compare i to the j
			jle .loop1                 #Loop while i less or equal to j
    
			# return value
			movq 	%r10 , %rax	# get the string.
			ret    
    
    
	.Error:  
		   # invalid input
		   movq 	$fmt_error, %rdi	 #set the formt
		   movq 	$0, %rax
		  call printf             			 # print error 
		  movq 		%r10 , %rax
	      ret
	
	
.text

.globl swapCase
    .type swapCase, @function

swapCase: 
				movq 	%rdi, %r10     # save src address
				movq	 $1, %rdx        #rdx is counter of for loop
				incq 		%rdi

		# run until the end of  string
		.Start1:
				cmpq 	%rsi, %rdx
				jg .End1
		# swich big to small					
		.Big:
				cmpb   $65, (%rdi)
				jl .Inc1
				cmpb  $90, (%rdi)
				jg .Small
				
				addb  $32, (%rdi)
				jmp .Inc1
		# swich small to big	
		.Small:
					cmpb	  $97, (%rdi)
					jl .Inc1
					cmpb 	$122, (%rdi)
					jg .Inc1
					
					subb 	$32, (%rdi)
					jmp .Inc1
		# go to next index			
		.Inc1:
					inc	 %rdx			#move to the next char
					inc	 %rdi			#move to the next char
					jmp .Start1
		# return the new string
		.End1:
					movq	 %r10, %rdi 		#return the first address of the string
					ret
										
.text

.globl pstrijcmp
    .type pstrijcmp, @function

pstrijcmp: 		
						
			# check the limits of i, j
			cmp  	$0, %rdx	        # compare i to 0
			jl .Error54					  # if x < 0
			cmp 		%rdx, %rcx	  #compare i to j
			jl .Error54					  #if i > j
			cmpb 	%r8b, %cl       # compare src to j
			jge .Error54				  # if src.length < j
			cmpb 	%r9b , %cl 	  # compare des to j
			jge .Error54				  # if des.length < j
			cmpb 	%r8b, %dl       # compare src to j
			jge .Error54			 	  # if src.length < i
			cmpb 	%r9b , %dl 	  # compare des to j
			jge .Error54				  # if des.length < i
	
			#rsi is the counter, set to i		
		    addq 	%rdx , %rsi		#src adress += i
		    addq  	%rdx , %rdi		#des adress += i
			subq  	%rdx,%rcx  	#find j-i
			incq 		%rcx 
			incq		%rsi
			incq		%rdi
		
	.loop54:		
			# compare the chars
			cmpq 	$0,%rcx
			jle .Equal
			xorq 		%r10,%r10
			movb 	(%rsi),%r10b
			cmpb 	(%rdi), %r10b  #compare str1[i] to str2[i]
			jl .Big54
			jg  .Small54
		
			# if equal ,jump to loop
			incq 		%rdi
			incq 		%rsi
			decq 	%rcx
			jmp .loop54
			
			#if small return -1	
	.Small54:
			movq 	$-1,%rax
			ret
			
			#if big return 1
	.Big54:
			movq $1,%rax
			ret
		
		
			#if equal we return 0
	.Equal:
			movq 	$0,%rax
			ret
			
		
		# if i or j  are not valid
	.Error54:
			movq 	$invalid54,%rdi
			xorq 		%rax,%rax
			call printf
			movq 	$-2,%rax
			ret
