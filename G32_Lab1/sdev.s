		.text
		.global _start


_start:
			LDR R4, =RESULT		//R4 points to the result location
			
			LDR R2, [R4, #4]	//R2 holds the number of elements in the list
			ADD R3, R4, #8		//R3 points to the first number
			LDR R0, [R3]		//R0 holds the first number in the list

			LDR R5, [R4, #4]	//R2 holds the number of elements in the list
			ADD R6, R4, #8		//R3 points to the first number
			LDR R7, [R6]		//R0 holds the first number in the list

MLOOP:		SUBS R2, R2, #1		//decrement the loop counter
			BEQ LLOOP			//end loop if counter has reached 0
			ADD R3, R3, #4 		//R3 points to the next number in the list
			LDR R1, [R3]		//R1 holds the next number in the list
			CMP R0, R1			//check if it is greater than the maximum
			BGE MLOOP 			//if no, branch back to the loop
			MOV R0, R1			//if yes, update the current maximum
			B MLOOP 				//branch back to the loop


			STR R0, [R4]		//store value of biggest in R0


LLOOP:		SUBS R5, R5, #1		//decrement the loop counter
			BEQ DONE			//end loop if counter has reached 0
			ADD R6, R6, #4 		//R3 points to the next number in the list
			LDR R1, [R6]		//R1 holds the next number in the list
			CMP R7, R1			//check if it is greater than the maximum
			BLE LLOOP 			//if no, branch back to the loop
			MOV R7, R1			//if yes, update the current maximum
			B LLOOP 			//branch back to the loop


			STR R7, [R4]		//store the result to the memory location


DONE:		SUBS R0, R0, R7		//substract contents of R0 by R5
			ASR R0, R0, #2		//shift right by 2 bits
			STR R0, [R4]

END:		B END 				//infinite loop!

RESULT:		.word	0			//memory assigned for result location
N:			.word	7			//number of entries in the list
NUMBERS:	.word	4, 5, 3, 6	//the list of data
			.word	1, 8, 2
