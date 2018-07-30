//			.text
//			.global _start


//_start:		LDR R4, =RESULT		//R4 points to the result location

			MOV R5, #0			//Declare R5 as 0 value
			MOV R7, #0			//Declare R7 as 0 value
			MOV R3, #0
			MOV R3, #0

			LDR R2, [R4, #4]	//R2 holds the number of elements in the list, this is for the loop
			LDR R6, [R4, #4]	//R6 holds the number of elements in the list, this will be for the division

			ADD R3, R4, #8		//R3 points to the first number, in this case, it points to the **location** of 5
			

ADDLOOP:	SUBS R2, R2, #1		//decrement the loop counter
			BLT DONE			//end loop if counter has reached 0
			LDR R1, [R3]		//R1 holds the first number in the list
			ADD R5, R5, R1		//Adds the value held by R1 with the value of R5 into R5
			ADD R3, R3, #4 		//R3 points to the next number in the list
			B ADDLOOP 			//branch back to the loop

DONE: 		ADD R0, R5, #0		//store temporarily R5 into R0

AVERAGE: 	SUBS R6, R6, #1		//we loop from R6 to 0
			CMP R6, #1			//if R6 equals
			BEQ DONE1			//if yes, then done
			ASR R0, #1			//if no, divide by 1
			ADD R7, R7, #1		//R7 is our power, we increment
			B AVERAGE

DONE1:		ASR R5, R5, R7		//Since we divide the sum by the number, done by shifting by power
			ADD R3, R4, #8		//R3 points to the first number, in this case, it points to the **location** of 5
			LDR R6, [R4, #4]	//R6 holds the number of elements in the list, this will be for the division

SUBLOOP:	SUBS R6, R6, #1		//decrement the loop counter
			BLT END				//end loop if counter has reached 0
			LDR R1, [R3]		//R1 holds the next number in the list
			SUB R1, R1, R5		//Subs the value held by R1 with the value of R5 into R5
			STR R1, [R3]		//store the content of R1 into R3
			ADD R3, R3, #4 		//R3 points to the next number in the list

			B SUBLOOP 			//branch back to the loop	

END:		B END 				//infinite loop!

RESULT:		.word	0			//memory assigned for result location
N:			.word	4			//number of entries in the list
NUMBERS:	.word	5, 4, 1, 6	//the list of data
			
