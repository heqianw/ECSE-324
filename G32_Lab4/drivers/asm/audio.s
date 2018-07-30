	.text
	.equ left_fifo, 0xFF203048
	.equ right_fifo, 0xFF20304C
	.equ fifospace, 0xFF203044
	.global audio_write_ASM

audio_write_ASM:
			PUSH {R4-R12} //saves the state of the system
			LDR R1, =left_fifo //loads the address of the data register for the left fifo
			LDR R2, =right_fifo //loads the address of the data register for the right fifo
			LDR R3, =fifospace //loads the address of the data register for the fifospace
			LDRB R4, [R3,#2] //loads the value of WSRC onto R4
			LDRB R5, [R3, #3] //loads the value of WSLC onto R5
			CMP R4, #0 //checks to see if the fifos are full
			MOVEQ R0, #0 //if so, the subroutine returns 0 and branches back
			POPEQ {R4-R12}
			BXEQ LR
			CMP R5, #0
			MOVEQ R0, #0
			POPEQ {R4-R12}
			BXEQ LR
			STR R0, [R1] //if the fifos are not full, the data is stored in them
			STR R0, [R2]
			MOV R0, #1 //and the subroutine returns 1
			POP {R4-R12}
			BX LR
