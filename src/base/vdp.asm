; TMS9118 VDP API
; IO Ports:
; 0xBE: Data Register (R/W)
; 0xBF: Address Register (W)
; 0xBF: Status Register (R)
;
; ***********************************************************************
; * TMS9118 MEMORY MAP                                                  *
; *                          TEXT                                       *
; * NAME TABLE        : 0x0000 - 0x03BF                          960    *
; * PATTERN TABLE     : 0x0800 - 0x0FFF                          2KB    *
; * UNUSED            : 0x1000 - 0x3FFF                                 *
; ***********************************************************************

INCLUDE "math.asm"

; Port address
VDP_VRAM      EQU 0xBE
VDP_VREG      EQU 0xBF

; VDP Registers
VDP_R0        EQU 0x80
VDP_R1        EQU 0x81
VDP_R2        EQU 0x82
VDP_R3        EQU 0x83
VDP_R4        EQU 0x84
VDP_R5        EQU 0x85
VDP_R6        EQU 0x86
VDP_R7        EQU 0x87

; Screen rows
VDP_ROWS      EQU 24

; Screen columns
VDP_COLS      EQU 40

; VRAM address of name table
VDP_CHRVADDR  EQU 0x0000

; VRAM address of font data
VDP_FONTVADDR EQU 0x0800

; Address of font data
VDP_FONT      EQU 0x0003

; Cursor position
VDP_POS:
    DW 0

;Copy buffer
VDP_BUF:
    DEFS 256

;----------------------------------------------------------------------
; tms9918 io wait for next vram access window
; 2us = 8 cycles in 4Mhz
;----------------------------------------------------------------------
VDP_IODELAY: MACRO
    NOP
ENDM

;----------------------------------------------------------------------
; Write VDP register R0~R7
; B: byte to write
; C: register number
;----------------------------------------------------------------------
VDP_Set:
    LD   A, B
    OUT  (VDP_VREG), A
    LD   A, C
    OUT  (VDP_VREG), A
    RET

;----------------------------------------------------------------------
;Set the VRAM address to write data
;HL stores 16 bits address
;----------------------------------------------------------------------
VDP_Write:
    LD   A, L
    OUT  (VDP_VREG), A            ; Write low byte
    LD   A, H
    LD   B, 0x40
    OR   B
    OUT  (VDP_VREG), A            ; Write high byte
    RET

;----------------------------------------------------------------------
;Set the VRAM address to write data
;HL stores 16 bits address
;----------------------------------------------------------------------
VDP_Read:
    LD   A, L
    OUT  (VDP_VREG), A            ; Write low byte
    LD   A, H
    LD   B, 0x3F
    AND  B
    OUT  (VDP_VREG), A            ; Write high byte
    RET

;----------------------------------------------------------------------
; Set cursor at current position
; C: cursor shape character
;----------------------------------------------------------------------
VDP_SetCursor:
    LD   HL, (VDP_POS)
    CALL VDP_Write
    LD   A, C
    OUT  (VDP_VRAM), A
    RET

;----------------------------------------------------------------------
; Write a character to VRAM, if carriage return is encountered, it will be a line break
; C: character to write
;----------------------------------------------------------------------
VDP_PutChar:
    LD   HL, (VDP_POS)		      ; Load current position into HL
	CALL VDP_Write
    LD   A, C
    CP   0x08                     ; Backspace key
    JR   Z, VDP_PutChar0
    CP   0x0A                     ; Line feed key
    JR   Z, VDP_PutChar1
    CP   0x0D                     ; Carriage return key
    JR   Z, VDP_PutChar1
;
    OUT  (VDP_VRAM), A            ; Write normal character
    LD   DE, (VDP_POS)		      ; Address incraments by 1
	INC	 DE
	LD   (VDP_POS), DE

    JR VDP_PutChar3               ; Scroll check

;   Write 'Backspace' control character
VDP_PutChar0:
    LD   A, ' '
    OUT  (VDP_VRAM), A            ; Clear the cursor at current position
    LD   DE, (VDP_POS)            ; Address decraments by 1
    DEC  DE
    LD   (VDP_POS), DE
;
    LD   HL, DE                   ; Update cursor
	CALL VDP_Write  
    JR   VDP_PutChar4

;   Write 'LF' control character
VDP_PutChar1:
    LD   HL, (VDP_POS)
    CALL VDP_Write
    LD   C, 0
    CALL VDP_SetCursor            ; Set cursor to blank
;
    LD   DE, VDP_COLS             ; Calculate the offset to next line
    CALL DIV16                    ; Result in BC
    INC  BC                       ; Index of next line
    LD   H, C			          ; Set H to row number
	LD   E, VDP_COLS		      ; Set E to row length
	CALL MULT8			          ; Multiply to get row offset
    LD   (VDP_POS), HL            ; Set current position
    JR   VDP_PutChar3             ; Scroll check

;   Do nothing for 'Carriage Return' control character
VDP_PutChar2:
    RET
    
;----------------------------------------------------------------------
; Check if scroll is needed
;----------------------------------------------------------------------
VDP_PutChar3:
    LD   DE, (VDP_POS)		      ; Load current position into DE
    LD   HL, VDP_ROWS * VDP_COLS - 1
    SBC  HL, DE
    JR   NC, VDP_PutChar4         ; No scoll

    CALL VDP_Scroll               ; Scroll screen forward one line
    LD   HL, (VDP_POS)
    LD   DE, VDP_COLS
    SBC  HL, DE
    LD   (VDP_POS), HL
    CALL VDP_Write

;----------------------------------------------------------------------
; Set block cursor
;----------------------------------------------------------------------
VDP_PutChar4:
    LD   C, 0xDB
    CALL VDP_SetCursor
    RET

;----------------------------------------------------------------------
; Write string to VRAM until a terminator is encountered
; HL: address of message
;----------------------------------------------------------------------
VDP_PutString:
    LD   A, (HL)
    OR   A
    RET  Z
    LD   C, A
    PUSH HL
    CALL VDP_PutChar
    POP  HL
    INC  HL
    JR   VDP_PutString

;----------------------------------------------------------------------
; Scroll entire screen forward by one line
;----------------------------------------------------------------------
VDP_Scroll:
	LD   HL, VDP_CHRVADDR	      ; Source address of character buffer
	LD   C, VDP_ROWS - 1		  ; Set up look counter for rows-1
VDP_Scroll0:				      ; Read line that is one past current destination
	PUSH HL			              ; Save current destination
	LD   DE, VDP_COLS
	ADD	 HL, DE			          ; Point to next row source
	CALL VDP_Read	              ; Set up to read
	LD   DE, VDP_BUF
	LD   B, VDP_COLS
VDP_Scroll1:
	IN   A, (VDP_VRAM)
    VDP_IODELAY
	LD   (DE), A
	INC	 DE
	DJNZ VDP_Scroll1
	POP	 HL			              ; Recover the destination
    
;   Write the buffered line to current destination
	CALL VDP_Write	              ; Set up to write
	LD   DE, VDP_BUF
	LD   B, VDP_COLS
VDP_Scroll2:
	LD   A, (DE)
	OUT	 (VDP_VRAM), A
    VDP_IODELAY
	INC	 DE
	DJNZ VDP_Scroll2

;   Bump to next line
	LD   DE, VDP_COLS
	ADD	 HL, DE
	DEC	 C			              ; Decrement row counter
	JR   NZ, VDP_Scroll0		  ; Loop thru all rows

;   Fill the newly exposed bottom line
	CALL VDP_Write
	LD   A, ' '
	LD	 B, VDP_COLS
VDP_Scroll3:
	OUT	 (VDP_VRAM), A
    VDP_IODELAY
	DJNZ VDP_Scroll3
	RET

;----------------------------------------------------------------------
; Set cursor position to row in D and column in E
;----------------------------------------------------------------------
VDP_XY:
	CALL VDP_XY2IDX	              ; Conver ROW/COL to buf idx
	LD   (VDP_POS), HL		      ; Save the result (Display Position)
    CALL VDP_Write
	RET

;----------------------------------------------------------------------
; Convert xy coordinates to linear index
; D=ROW, E=COL
;----------------------------------------------------------------------
VDP_XY2IDX:
	LD   A, E			          ; Save column number in A
	LD   H, D			          ; Set H to row number
	LD   E, VDP_COLS		      ; Set E to row length
	CALL MULT8			          ; Multiply to get row offset
	LD   E, A			          ; Get column back
	ADD	 HL, DE			          ; Add it in
	LD   DE, VDP_CHRVADDR		  ; Add offset address to start of Name Table (Char)
	ADD	 HL, DE
	RET

;----------------------------------------------------------------------
; Fill area in buffer with specified character
; C: fill character
; DE: number of character to fill
;----------------------------------------------------------------------
VDP_FILL:
    LD   A, C
	OUT  (VDP_VRAM), A
    VDP_IODELAY
	DEC	 DE
	LD   A, D
	OR   E
	JR   NZ, VDP_FILL
	RET

;---------------------------------------------------------------------- 
; Clear the screen
;----------------------------------------------------------------------
VDP_Clear:
    LD   DE, 0
    CALL VDP_XY
    LD   C, ' '			          ; Blank the screen
	LD   DE, 960	              ; Fill entire buffer
	CALL VDP_FILL
    LD   DE, 0
    CALL VDP_XY
    RET

;----------------------------------------------------------------------
; Load font data
; HL: address of font data
; DE: number of bytes to load
;----------------------------------------------------------------------
VDP_LoadFont:
    LD   C, VDP_VRAM
VDP_LoadFont0:
    OUTI
    DEC  DE
    LD   A, D
    OR   E
    JR   NZ, VDP_LoadFont0
    RET

;----------------------------------------------------------------------
; Initialize VDP and enter text mode
;----------------------------------------------------------------------
VDP_Init:
    LD   B, 0x00                  ; R0: Text Mode,No External Video
    LD   C, VDP_R0
    CALL VDP_Set
;
    LD   B, 0xD0                  ; R1: 16K,Enable Disp,Enable Int
    LD   C, VDP_R1
    CALL VDP_Set
;
    LD   B, 0x00                  ; R2: Address of Name Table in VRAM = 0x400 * 0 = 0x0000, size = 960
    LD   C, VDP_R2
    CALL VDP_Set
;
    LD   B, 0x00                  ; R3: Color Table not used Color is defined in Reg7
    LD   C, VDP_R3
    CALL VDP_Set
;
    LD   B, 0x01                  ; R4: Address of Pattern Table in VRAM = 0x800 * 1 = 0x0800, size = 256 * 8 = 2K
    LD   C, VDP_R4
    CALL VDP_Set
;
    LD   B, 0x20                  ; R5: Fixed value
    LD   C, VDP_R5
    CALL VDP_Set

    LD   B, 0x00                  ; R6: Fixed value
    LD   C, VDP_R6
    CALL VDP_Set

    LD   B, 0xF4                  ; R7: White Text on light blue Background
    LD   C, VDP_R7
    CALL VDP_Set

    LD   HL, VDP_FONTVADDR        ; Load font data
    CALL VDP_Write
    LD   HL, VDP_FONT             ; Font data resides in ROM at addresss 0x0003
    LD   DE, 2048                 ; 2KB
    CALL VDP_LoadFont

    LD   HL, (VDP_POS)		      ; Set starting position
    CALL VDP_Write
	CALL VDP_Clear			      ; Blank the screen
    RET