//			.text
//			.global _start

//_start:		
			LDR R4, =N			//R4 has the location of the numbers of elements
			LDR R0, [R4]		//R2 has the number of elements 						R2=4
			
			MOV R1, #0			//Variable is false. not sorted yet
			MOV R10, #1
		

BIGLOOP:	CMP R1, R10 		//while it is not sorted, continue						
			BEQ END				//If R1 is equal to TRUE (1 is true, 0 is false
			MOV R1, #1			//Set Sorted to True
			MOV R5, #1			//Set our index to 1
			ADD R2, R4, #0		//Set R2 to point to first number-2
			ADD R3, R4, #4		//Set R3 to point to second number-2

			//B SMALLLOOP			//enter inside loop				

SMALLLOOP:	CMP R5, R0			//Check index with Number			
			BGE BIGLOOP			//if i=N, go to big loop
			ADD R5, R5, #1		//Increment our index i

			ADD R2, #4			//go check the next element
			ADD R3, #4			//go check the element after that one

			LDR R6, [R2]		//store content of R2 into R6
			LDR R7, [R3]		//store content of R3 into R7

			CMP R6, R7			//compare the values of R7 and R8
			BLE	SMALLLOOP		//if R7 is smaller, we continue the loop
								//else we swap here
		 	MOV R8, R6			//using temporary R8, store R6
			MOV R6, R7			//R6 will hold the smaller value
			MOV R7, R8			//R7 will hold the bigger value
			STR R6, [R2]		//at the location of R2, replace that value by R6
			STR R7, [R3]		//same but for R2 and R7
			MOV R1, #0			//set R1 as fals
			
			B SMALLLOOP

END:	 	B END

N:			.word	4			//number of entries in the list
NUMBERS:	.word	5, 4, 1, 3	//the list of data, should be 1,4,5,6
