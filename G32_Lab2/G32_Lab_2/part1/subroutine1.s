//				.text
//				.global _start

//_start:			LDR R0, =NUMBERS			// R0 points to the location of first numbers
				LDR	R1, N					// R1 contains the numbers of elements
				PUSH {R0, R1, LR}			// push parameters and LR
				BL MAX						// call subroutine
				LDR R0, [SP, #4]			// get return value from stack
				STR R0, RESULT				// store in memory
				LDR	LR, [SP, #8]			// restore LR
				ADD SP, SP, #12				// remove params from stack

stop:			B stop						// end
				
MAX:			PUSH {R0-R3}				// conventional get registers
				LDR R1, [SP, #20]			// R1 in max is the number of numbers in the set of numbers
				LDR R2, [SP, #16]			// R2 in max is a pointer to the first number in the set of numbers
				LDR R0, [R2]				// load value of first number into R0

loop:			SUBS R1, R1,#1				// decrement loop
				BEQ end						// end loop
				ADD R2, R2, #4				// point to next value in the list
				LDR	R3, [R2]				// R3 loads the next value from the list
				CMP R0, R3					// check if it is greater than the maximum
				BGE loop					// if R0 is bigger than R3, go back to loop
				MOV R0, R3					// if R0 is smaller than R3, move R3 into R0
				B loop						// go back to loop

end:			STR R0, [SP, #20]			// store largest number to stack
				POP {R0-R3}					// restore registers
				BX LR

NUMBERS:		.word	1,12,4,5
N:				.word	4
RESULT:			.word	0
				.end
