	.text
	
	.equ VGA_PIXEL_BUF_BASE, 0xC8000000
	.equ VGA_CHAR_BUF_BASE, 0xC9000000

	.equ X_offset, 0x00000001
	.equ Y_offset, 0x00000080
	.equ Y_offset_pixel, 0x00000400
	.equ pixel_end_Y, 0xC803BE7E
	.equ pixel_end_X, 0x0000013F
	.equ char_end_Y, 0xC9001DCF
	.equ char_end_X, 0x0000004F

	.global VGA_clear_charbuff_ASM
	.global VGA_clear_pixelbuff_ASM
	.global VGA_write_char_ASM
	.global VGA_write_byte_ASM
	.global VGA_draw_point_ASM
		
VGA_clear_pixelbuff_ASM:
	PUSH {R4-R5}	
	MOV R2, #0
	LDR R3, =VGA_PIXEL_BUF_BASE
	MOV R0, #0

PIXEL_LOOPX:
	MOV R1, #0
	ADD R4, R3, R0, LSL #1
PIXEL_LOOPY:
	ADD R5, R4, R1, LSL #10
	
	STRH R2, [R5]
	
	ADD R1, R1, #1
	CMP R1, #240
	BLT PIXEL_LOOPY
	
	ADD R0, R0, #1
	CMP R0, #320
	BLT PIXEL_LOOPX

	POP {R4-R5}
	BX LR

VGA_draw_point_ASM:
	LDR R3, =319
	CMP R0, #0
	BXLT LR
	CMP R1, #0
	BXLT LR
	CMP R0, R3
	BXGT LR
	CMP R1, #239
	BXGT LR
	
	LDR R3, =VGA_PIXEL_BUF_BASE
	ADD R3, R3, R0, LSL #1
	ADD R3, R3, R1, LSL #10
	STRH R2, [R3]
	BX LR

VGA_clear_charbuff_ASM:
	PUSH {R4-R12} //save the state of the system
	LDR R4, =VGA_CHAR_BUF_BASE
	LDR R5, =X_offset
	LDR R7, =char_end_Y
	LDR R8, =char_end_X   //loading edges of display coordinates and indexes into registers 
	MOV R0, #0
	B  Y_CHAR_LOOP
	POP {R4-R12}
	BX LR

Y_CHAR_LOOP: 
	CMP R4, R7 //checks to see if we have reached the end of the screen
	BXGE LR //if so, the subroutine branches back
	MOV R9, R4
	ADD R10, R9, R8 //
	PUSH {LR}
	BL X_CHAR_LOOP
	POP {LR}
	ADD R4, R4, R6 //moves to the next row
	B Y_CHAR_LOOP

X_CHAR_LOOP: 
	CMP R9, R10
	BXGT LR
	STRB R0, [R9]
	ADD R9, R9, R5
	B X_CHAR_LOOP

VGA_write_char_ASM:					//R0, R1, R2, are x, y and char
	PUSH {R3-R7}
	CMP R0, #79
	BGT DONE_CHAR
	CMP R1, #59
	BGT DONE_CHAR

	LDR R3, =VGA_CHAR_BUF_BASE
	ADD R3, R3, R0
	LSL R1, R1, #7
	ADD R3, R3, R1
	STRB R2, [R3]
	POP {R3-R7}
	B DONE_CHAR

DONE_CHAR:
	BX LR
	
VGA_write_byte_ASM:					//R0, R1, R2 are x, y and char
	PUSH {R3-R7}
	CMP R0, #79
	BGT DONE_BYTE
	CMP R1, #59
	BGT DONE_BYTE
	
	LDR R3, =VGA_CHAR_BUF_BASE
	ADD R3, R3, R0
	LSL R1, R1, #7


	ADD R3, R3, R1					//R3 contains the address where we want to inject stuff
	LSR R4, R2, #4					//get most significant hex in R4					
	LSL R6, R4, #4					//get least significant hex in R5
	SUB R5, R2, R6					//the least significant hex in R5
	
	CMP R4, #9
	ADDGT R4, R4, #7
	CMP R5, #9	
	ADDGT R5, R5, #7
	ADD R4, R4, #48
	ADD R5, R5, #48
	
	STRB R4, [R3]
	ADD R3, R3, #1
	STRB R5, [R3]
	POP {R3-R7}
	B DONE_BYTE
	
DONE_BYTE:
	BX LR
	
HEX_ASCII:
	.byte 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46
	//      0     1     2     3     4     5     6     7     8     9     A     B     C     D     E     F  // 
	.end
	
