//			.text
//			.global _start


//_start:		LDR R1, =RESULT		//R1 represents the pointer of the stack
			LDR R2, [R1, #4]	//load into R2 the number of numbers in memory
			ADD R3,	R1, #8 		//load into R3 the location of the first number 

LOOP:		SUBS R2, R2, #1 	
			BLT DONE		
			LDR R0, [R3] 		//load into R0, the number contained at location R
			ADD R3, R3, #4		//update the location of next number
			SUBS SP, SP, #4		//update the stack pointer
			STR R0, [SP]		//store the value at that spot
			ADD R1, R1, #4		//make us go to the next value of R1
			B LOOP
						

DONE:		LDR R0, [SP]		//pop into R0
			ADD SP, SP, #4		//update stackpointer
 			LDR R1, [SP]		//pop into R1
			ADD SP, SP, #4		//update stackpointer
			LDR R2, [SP]		//pop into R2

END:		B END 				//infinite loop!

RESULT:		.word 	0
N:		 	.word	4
NUMBERS:	.word	3, 2, 1, 0	//the list of numbers to be pushed onto the stack
			
