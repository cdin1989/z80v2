; Math Library

;----------------------------------------------------------------------
; Multiply 8-BIT values
; In:  MULTIPLY H BY E
; Out: HL = Result, E = 0, B = 0
;----------------------------------------------------------------------
MULT8:
	LD   D, 0
	LD   L, D
	LD   B, 8
MULT8_LOOP:
	ADD  HL, HL
	JR   NC, MULT8_NOADD
	ADD  HL, DE
MULT8_NOADD:
	DJNZ MULT8_LOOP
	RET

;----------------------------------------------------------------------
; COMPUTE HL / DE = BC W/ REMAINDER IN HL & ZF
;----------------------------------------------------------------------
DIV16:
	LD   A, H                     ;HL -> AC
	LD   C, L                     ;...
	LD   HL, 0                    ;INIT HL
	LD   B, 16                    ;INIT LOOP COUNT
DIV16A:
	SCF
	RL	 C
	RLA
	ADC	 HL, HL
	SBC	 HL, DE
	JR	 NC, DIV16B
	ADD	 HL, DE
	DEC	 C
DIV16B:
	DJNZ DIV16A                   ;LOOP AS NEEDED
	LD   B, A                     ;AC -> BC
	LD   A, H                     ;SET ZF
	OR   L                        ;... BASED ON REMAINDER
	RET                           ;DONE