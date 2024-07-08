; BIOS for bitrowz z80 CP/M 2.2
; Using the ACIA as input and output device. 
; Refercence:
; https://www.seasip.info/Cpm/bios.html

SECTION BIOS_REGION               ; 0xF200

CCP:	 	EQU	0xDC00            ; Base of CCP
BDOS:	 	EQU	0xE406            ; BDOS entry
BIOS:	 	EQU	0xF200            ; Base of BIOS
CDISK:	 	EQU	0x0004            ; Current disk number, 0=A ... 15=P
IOBYTE:	 	EQU	0x0003            ; Intel I/O byte
DISKS:	 	EQU	16                ; Number of disks in the system
NSECTS:	 	EQU	44                ; Warm start sector count, reload CCP+BDOS, (0xF200-0xDC00)/128=44 SECS
LF		 	EQU	0x0A              ; Line feed character
CR		 	EQU 0x0D              ; Carriage return

; Jump vector for individual subroutines
	JP   BOOT	                  ; Cold start
WBOOTE:
	JP   WBOOT	                  ; Warm start
	JP   CONST	                  ; Console status
	JP   CONIN	                  ; Console character out
	JP   CONOUT	                  ; Console character out
	JP   LIST	                  ; List character out
	JP   PUNCH	                  ; Punch character out
	JP   READER	                  ; Read character out
	JP   HOME	                  ; Move head to home position
	JP   SELDSK	                  ; Select disk
	JP   SETTRK	                  ; Set track number
	JP   SETSEC	                  ; Set sector number
	JP   SETDMA	                  ; Set dma address
	JP   READ	                  ; Read disk
	JP   WRITE	                  ; Write disk
	JP   LISTST	                  ; Return list status
	JP   SECTRAN                  ; Sector translate

INCLUDE "disk.asm"
INCLUDE "sio.asm"
INCLUDE "vdp.asm"
INCLUDE "kbc.asm"
INCLUDE "digital_io.asm"

;----------------------------------------------------------------------
; This function is completely implementation-dependent and should never be called from user code
;----------------------------------------------------------------------
BOOT:
    LD   C, %11111000             ; Turn on LED on bit7-bit3
    CALL LED_Write
;
	CALL VDP_Clear                ; Clear the screen
	LD   HL, MSG_GoCPM            ; CP/M startup message
	PUSH HL
	CALL SIO_WriteString          ; Print message to ACIA 
	POP	 HL
	CALL VDP_PutString            ; Print message to VDP
;
    DI
	LD   SP, BIOSSTACK            ; Set up the stack
	XOR  A						  ; Zero in the accum
	LD   (IOBYTE), A              ; Clear the IOBYTE
	LD   (CDISK), A               ; Select disk 0
	JP   GoCPM                    ; Go to cp/m

;----------------------------------------------------------------------
; Reloads the command processor and (on some systems) the BDOS as well
; How it does this is implementation-dependent; it may use the reserved tracks of a floppy disc or extra memory
;----------------------------------------------------------------------
WBOOT:
	DI
	LD   SP, BIOSSTACK            ; Set up the stack
	LD   C, 0
	CALL SELDSK                   ; Select disk 0
	CALL HOME                     ; Go to track 0
;   Load CCP from disk
    LD   HL, CCP
    LD   (DMAAD), HL
    LD   B, NSECTS                ; Sector count
    LD   C, 0                     ; Sector number
WBOOT0:
    PUSH BC
	LD   A, C
    LD   (SECNO), A
    CALL READ
    POP  BC
    LD   DE, 128
    LD   HL, (DMAAD)
    ADD  HL, DE
    LD   (DMAAD), HL
	INC  C 					      ; Go to next sector
    DJNZ WBOOT0
    JP   GoCPM                    ; Go to cp/m

;----------------------------------------------------------------------
; End of	load operation, set parameters and go to cp/m
;----------------------------------------------------------------------
GoCPM:
	LD   A, 0xC3                  ; Load A with 'JP' instruction
	LD   (0), A                   ; JP opcode goes here
	LD   HL, WBOOTE               ; Get WBOOT entry address
	LD   (1), HL                  ; Set address field for jmp at 0
;
	LD   (5), A                   ; JP opcode at 0x0005
	LD   HL, BDOS                 ; Get BDOS entry address
	LD   (6), HL                  ; Put it at 0x0006
;
	LD   BC, 0x80                 ; Default DMA address
	CALL SETDMA
;
	LD   A, (CDISK)               ; Get current disk
	CP   DISKS                    ; See if valid disk number
	JP   C, DiskOk                ; Disk valid, go to CCP
	LD   A, 0                     ; Invalid disk, change to disk 0
DiskOk:
	LD   C, A                     ; Send to the CCP
	JP   CCP                      ; Go to cp/m for further processing

;----------------------------------------------------------------------
; Returns its status in A; 0 if no character is ready, 0FFh if one is
;----------------------------------------------------------------------
CONST:
	CALL SIO_Status
	AND  SIO_RX_FULL				;Check RxRDY bit
	JP   Z, NoChar
	LD   A, 0xFF					;Char ready	
	LD   C, 'Y'
	CALL SIO_WriteChar
	LD  A, 0xFF
	RET
NoChar:
	LD   C, 'N'
	CALL SIO_WriteChar
	LD 		A, 0x00					;No char
	RET

;----------------------------------------------------------------------
; Wait until the keyboard is ready to provide a character, and return it in A
;----------------------------------------------------------------------
CONIN:
	LD   C, 'I'
	CALL SIO_WriteChar
	CALL SIO_Read                 ;Block until char ready
	AND  0x7F                     ;Strip parity bit
	RET

;----------------------------------------------------------------------
; Write the character in C to the screen
;----------------------------------------------------------------------
CONOUT:
	CALL SIO_WriteChar
	CALL VDP_PutChar
	RET

;----------------------------------------------------------------------
; Write the character in C to the printer
; If the printer isn't ready, wait until it is
;----------------------------------------------------------------------
LIST:
	LD   A, C                     ; Character to register A
	RET                           ; Null subroutine

;----------------------------------------------------------------------
; Return status of current printer device
; Returns A=0 (not ready) or A=0FFh (ready)
;----------------------------------------------------------------------
LISTST:	
	XOR  A                        ; 0 is always ok to return
	RET

;----------------------------------------------------------------------
; Write the character in C to the "paper tape punch" - or whatever the current auxiliary device is
; If the device isn't ready, wait until it is
;----------------------------------------------------------------------
PUNCH:
	LD   A, C                     ; Character to register A
	RET                           ; Null subroutine

;----------------------------------------------------------------------
; Read a character from the "paper tape reader" - or whatever the current auxiliary device is
; If the device isn't ready, wait until it is. The character will be returned in A
; If this device isn't implemented, return character 26 (^Z)
;----------------------------------------------------------------------
READER:
	LD   A, 0x1A                  ; Enter end of file for now (replace later)
	AND  0x7F                     ; Remember to strip parity bit
	RET

;----------------------------------------------------------------------
; Move the current drive to track 0
;----------------------------------------------------------------------
HOME:
	LD   C, 0                     ; Select track 0
	CALL SETTRK
	RET                           ; We will move to 00 on first READ/WRITE

;----------------------------------------------------------------------
; Select the disc drive in register C (0=A:, 1=B: ...). Called with E=0 or 0FFFFh
; If bit 0 of E is 0, then the disc is logged in as if new;
; if the format has to be determined from the boot sector, for example, this will be done;
; If bit 0 if E is 1, then the disc has been logged in before
; The disc is not accessed; the DPH address (or zero) is returned immediately
;----------------------------------------------------------------------
SELDSK:
	LD 	 HL, 0x0000               ; Error return code
	LD 	 A, C
	LD 	 (DSKNO), A
	CP 	 DISKS                    ; Must be between 0 AND 3
	RET	 NC                       ; No carry if 4, 5,...
	LD 	 A,(DSKNO)
	LD 	 L, A                     ; L=disk number 0, 1, 2, 3
	LD 	 H, 0                     ; High order zero
	ADD	 HL, HL                   ; *2
	ADD	 HL, HL                   ; *4
	ADD	 HL, HL                   ; *8
	ADD	 HL, HL                   ; *16 (size of each header)
	LD 	 DE, DPBASE
	ADD	 HL, DE                   ; HL=dpbase (DSKNO*16) Note typo here in original source.
	RET

;----------------------------------------------------------------------
; Set the track in BC - 0 based
;----------------------------------------------------------------------
SETTRK:
	LD   A, C
	LD   (TRKNO), A
	RET

;----------------------------------------------------------------------
; Set the sector in BC. Under CP/M 1 and 2 a sector is 128 bytes
;----------------------------------------------------------------------
SETSEC:
	LD   A, C
	LD   (SECNO), A
	RET

;----------------------------------------------------------------------
; Translate sector numbers to take account of skewing
; On entry, BC=logical sector number (zero based) and DE=address of translation table
; On exit, HL contains physical sector number
; On a system with hardware skewing, this would normally ignore DE and return either BC or BC+1
;----------------------------------------------------------------------
SECTRAN:
	EX   DE, HL                   ; HL=.trans
	ADD  HL, BC                   ; HL=.trans (sector)
	RET                           ; Debug no translation
	LD   L, (HL)                  ; L=trans (sector)
	LD   H, 0					  ; HL=trans (sector)
	RET                           ; With value in HL

;----------------------------------------------------------------------
; The next disc operation will read its data from (or write its data to) the address given in BC
;----------------------------------------------------------------------
SETDMA:
	LD   L, C                     ; Low order address
	LD   H, B                     ; High order address
	LD   (DMAAD), HL              ; Save the address
	RET


;----------------------------------------------------------------------
; Read the currently set track and sector at the current DMA address
; Returns A=0 for OK, 1 for unrecoverable error, 0FFh if media changed
;----------------------------------------------------------------------
READ:
    CALL CF_Wait_NotBusy          ; Wait until CF is not busy.
    CALL CF_Wait_Ready            ; Wait until CF is ready.

    LD   A, 1                     ; Sector count
    OUT  (CF_REG2), A
;-------------------------------------------------------------------
    LD   A, (SECNO)               ; Sector number, LBA0-LBA5 (6bit) 
	AND  0x3F                     ; Mask out the low 6bit
	LD   L, A
	LD   BC, (TRKNO)
	RRC  C
	RRC  C
	LD   A, C
	AND  0xC0                     ;Mask out the low 2bit of track number, LBA6-LBA7
	OR   L
    OUT  (CF_REG3), A
;-------------------------------------------------------------------
    LD   BC, (TRKNO)              ; Track number: LBA6-LBA15 (10bit)
	RRC  C
	RRC  C                        ; Remove the low 2bit, since they are moved to the high 2bit of CF_REG3
	LD   A, C
	AND  0x3F                     ; Mask out the low 6bit of track number, LBA8-LBA13
	LD   L, A
	RRC  B
	RRC  B
	LD   A, B
	AND  0xC0                     ; Mask out the high 2bit of track number, LBA14-LBA15
	OR   L
    OUT  (CF_REG4), A
;-------------------------------------------------------------------
    LD   A, (DSKNO)               ; Disk number: LBA16-LBA19 (4bit)
	AND  0x0F
    OUT  (CF_REG5), A
    LD   A, 0x20                  ; Read command.
    OUT  (CF_REG7), A
    CALL CF_Wait_NotBusy          ; Wait until CF is not busy.
    LD   HL, HSTBUF
CF_ReadByte:
    IN   A, (CF_REG0)             ; Read data byte.
    LD   (HL), A                  ; Write a byte to memory.
    INC  HL
    IN   A, (CF_REG7)		      ; Check if data transfer is ready
	AND  CF_DRQ                   ; Mask out DRQ bit
    JR   NZ, CF_ReadByte          ; Read next byte
    IN   A, (CF_REG7)	          ; Check status
	AND	 CF_ERR                   ; Mask out ERR bit
    JR   NZ, CF_ReadError         ; Handle error.
    LD   HL, HSTBUF
    LD   DE, (DMAAD)              ; Copy to memory at DMMA
    LD   BC, 128                  ; CP/M 2 sector size
    LDIR
CF_ReadComplete:
	LD   A, 0x00
	RET
CF_ReadError:
	LD   A, 0x01
	RET

;----------------------------------------------------------------------
; Write the currently set track and sector. C contains a deblocking code:
; C=0 - Write can be deferred
; C=1 - Write must be immediate
; C=2 - Write can be deferred, no pre-read is necessary
; Returns A=0 for OK, 1 for unrecoverable error, 2 if disc is readonly, 0FFh if media changed
;
; Disk number in 'DSKNO'
; Track number in 'TRKNO'
; Sector number in 'SECNO'
; DMA address in 'DMAAD' (0-65535)
;----------------------------------------------------------------------
WRITE:
	LD   HL, (DMAAD)
	LD   DE, HSTBUF
	LD   BC, 128
	LDIR                          ; Copy data to host buffer
    CALL CF_Wait_NotBusy          ; Wait until CF is not busy
    CALL CF_Wait_Ready            ; Wait until CF is ready
    LD   A, 1                     ; Sector count
    OUT  (CF_REG2), A
;-------------------------------------------------------------------
    LD   A, (SECNO)               ; Sector number, LBA0-LBA5 (6bit) 
	AND  0x3F                     ; Mask out the low 6bit
	LD   L, A
	LD   BC, (TRKNO)
	RRC  C
	RRC  C
	LD   A, C
	AND  0xC0                     ; Mask out the low 2bit of track number, LBA6-LBA7
	OR   L
    OUT  (CF_REG3), A
;-------------------------------------------------------------------
    LD   BC, (TRKNO)              ; Track number: LBA6-LBA15 (10bit)
	RRC  C
	RRC  C                        ; Remove the low 2bit, since they are moved to the high 2bit of CF_REG3
	LD   A, C
	AND  0x3F                     ; Mask out the low 6bit of track number, LBA8-LBA13
	LD   L, A
	RRC  B
	RRC  B
	LD   A, B
	AND  0xC0                     ; Mask out the high 2bit of track number, LBA14-LBA15
	OR   L
    OUT  (CF_REG4), A
;-------------------------------------------------------------------
    LD   A, (DSKNO)               ; Disk number: LBA16-LBA19 (4bit)
	AND  0x0F
    OUT  (CF_REG5), A
    LD   A, 0x30                  ; Write command.
    OUT  (CF_REG7), A
    CALL CF_Wait_NotBusy          ; Wait until CF is not busy.
    LD   HL, HSTBUF
CF_WriteByte:
	LD   A, (HL)                  ; Read a byte.
    OUT  (CF_REG0), A             ; Write a byte to CF.
    INC  HL
    IN   A, (CF_REG7)             ; Check if data transfer is ready
	AND  CF_DRQ                   ; Mask out DRQ bit
    JR   NZ, CF_WriteByte         ; Read next byte
    IN   A, (CF_REG7)             ; Check status
	AND	 CF_ERR                   ; Mask out ERR bit
    JR   NZ, CF_WriteError        ; Handle error.
CF_WriteComplete:
	LD   A, 0x00
	RET
CF_WriteError:
	LD   A, 0x01
	RET

; Disk parameter header table.
DPBASE:
; Disk A:
DW 0000  ,0000
DW 0000  ,0000
DW DIRBUF,DPBHD
DW CSV00 ,ALV00

; Disk B:
DW 0000   ,0000
DW 0000   ,0000
DW DIRBUF ,DPBHD
DW CSV01  ,ALV01

; Disk C:
DW 0000   ,0000
DW 0000   ,0000
DW DIRBUF ,DPBHD
DW CSV02  ,ALV02

; Disk D:
DW 0000   ,0000
DW 0000   ,0000
DW DIRBUF ,DPBHD
DW CSV03  ,ALV03

; Disk E:
DW 0000   ,0000
DW 0000   ,0000
DW DIRBUF ,DPBHD
DW CSV04  ,ALV04

; Disk F:
DW 0000   ,0000
DW 0000   ,0000
DW DIRBUF ,DPBHD
DW CSV05  ,ALV05

; Disk G:
DW 0000   ,0000
DW 0000   ,0000
DW DIRBUF ,DPBHD
DW CSV06  ,ALV06

; Disk H:
DW 0000   ,0000
DW 0000   ,0000
DW DIRBUF ,DPBHD
DW CSV07  ,ALV07

; Disk I:
DW 0000   ,0000
DW 0000   ,0000
DW DIRBUF ,DPBHD
DW CSV08  ,ALV08

; Disk J:
DW 0000   ,0000
DW 0000   ,0000
DW DIRBUF ,DPBHD
DW CSV09  ,ALV09

; Disk K:
DW 0000   ,0000
DW 0000   ,0000
DW DIRBUF ,DPBHD
DW CSV10  ,ALV10

; Disk L:
DW 0000   ,0000
DW 0000   ,0000
DW DIRBUF ,DPBHD
DW CSV11  ,ALV11

; Disk M:
DW 0000   ,0000
DW 0000   ,0000
DW DIRBUF ,DPBHD
DW CSV12  ,ALV12

; Disk N:
DW 0000   ,0000
DW 0000   ,0000
DW DIRBUF ,DPBHD
DW CSV13  ,ALV13

; Disk O:
DW 0000   ,0000
DW 0000   ,0000
DW DIRBUF ,DPBHD
DW CSV14  ,ALV14

; Disk P:
DW 0000   ,0000
DW 0000   ,0000
DW DIRBUF ,DPBHD
DW CSV15  ,ALV15


; Disk parameter block for all disks
; 8M Compact Flash Disk (8160K Data Space, 32K Reserved Space)
; 1024 TRKS (4 Reserved), 64 SEC/TRK, 128 B/SEC
; 4K BlockSize (BLS), 512 Directory Entries
; 4 Reserved Tracks, 4 TRKS * 64 SECS/TRK * 128B = 32K
DPBHD:
    DW 64                         ; SPT: Sectors per track.
    DB 5                          ; BSH: Block shift factor
    DB 31                         ; BLM: Block mask = 2^BSH-1
    DB 1                          ; EXM: Extent mask
    DW 2039                       ; DSM: Total storage in blocks - 1, BLK = (8M-32K)/4K - 1 = 2039
	DW 511                        ; DRM: Dir entries - 1 = 511
	DB 11110000B                  ; AL0: Dir BLK bitmap
	DB 00000000B                  ; AL1: Dir BLK bitmap
	DW 0                          ; CKS: Zero for non-removable media
	DW 4                          ; OFF: Reserved tracks = 4

; Scratch pad for bdos use.
DIRBUF: DEFS 128

; Check sum vector for disk A-P
CSV00:  DEFS 16
CSV01:  DEFS 16
CSV02:  DEFS 16
CSV03:  DEFS 16
CSV04:  DEFS 16
CSV05:  DEFS 16
CSV06:  DEFS 16
CSV07:  DEFS 16
CSV08:  DEFS 16
CSV09:  DEFS 16
CSV10:  DEFS 16
CSV11:  DEFS 16
CSV12:  DEFS 16
CSV13:  DEFS 16
CSV14:  DEFS 16
CSV15:  DEFS 16

;Allocation vector for disk A-P
ALV00:  DEFS 32
ALV01:  DEFS 32
ALV02:  DEFS 32
ALV03:  DEFS 32
ALV04:  DEFS 32
ALV05:  DEFS 32
ALV06:  DEFS 32
ALV07:  DEFS 32
ALV08:  DEFS 32
ALV09:  DEFS 32
ALV10:  DEFS 32
ALV11:  DEFS 32
ALV12:  DEFS 32
ALV13:  DEFS 32
ALV14:  DEFS 32
ALV15:  DEFS 32

; The remainder of the cbios is reserved uninitialized
; data area, and does not need to be a part of the
; system	memory image
TRKNO:		DEFS	2             ; Track number
SECNO:		DEFS	2             ; Sector number
DSKNO:		DEFS	1             ; Disk number, 0-15
DMAAD:		DEFS	2             ; Direct memory address
HSTBUF: 	DEFS	512           ; Buffer for host disk sector
STACKSEG:	DEFS    128           ; Stack area.
BIOSSTACK: 	EQU 	$             ; Stack top address.

; Boot message.
MSG_GoCPM:
	DB "56K CP/M 2, BIOS BY BITROWZ             ", LF, CR
	DB "COPYRIGHT (C)  1979  BY DIGITAL RESEARCH", LF, CR, 0