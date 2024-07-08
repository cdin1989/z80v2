; Initialize the devices and load CP/M sectors from CF.
ORG 0x8000

LF EQU 0x0A
CR EQU 0x0D

JP Main

INCLUDE "sio.asm"
INCLUDE "kbc.asm"
INCLUDE "vdp.asm"
INCLUDE "memory.asm"
INCLUDE "disk.asm"
INCLUDE "digital_io.asm"

MSG_BOOT:
    DB "Bitrowz Boot Loader Ver0.1", LF, CR, 0

MSG_LoadCPM:
    DB "Loading CP/M...", LF, CR, 0

MSG_ReadDiskError:
    DB "Disk Read Error!", LF, CR, 0

MSG_ReadDiskOK:
    DB "Disk Read Complete.", LF, CR, 0

MSG_MemCheck:
    DB "Checking 64K Memory...", LF, CR, 0

MSG_MemCheckPassed:
    DB "Memory Check Passed.", LF, CR, 0

MSG_MemCheckFailed:
    DB "Memory Check Failed!", LF, CR, 0

Main:
    LD   SP, 0xFFFF               ; Set up the stack
    CALL SIO_Init                 ; Init the SIO device
    CALL VDP_Init                 ; Init the VDP device
    CALL CF_Init                  ; Init the CF device
    CALL KBC_Init                 ; Init the keyboard controller

    LD   C, %11000000             ; Turn on LED on bit7-bit6
    CALL LED_Write

    LD   C, MEM_PAGE_64K          ; Switch to 64K memory page
    CALL MEM_Switch

    LD   HL, MSG_BOOT
    CALL VDP_PutString            ;Print start message

;   Low 32K memory check, 0x0000-0x8000
    LD   HL, 0x8000
MemCheck:
    DEC  HL
    LD   A, L
    OR   H
    JR   Z, MemPassed
    LD   (HL), 0x5A
    LD   A, (HL)
    CP   0x5A
    JR   Z, MemCheck
MemError:
    LD   HL, MSG_MemCheckFailed
    PUSH HL
    CALL SIO_WriteString
    POP  HL
    CALL VDP_PutString
    LD   C, 0                     ;Turn off all LEDs
    CALL LED_Write
    JP   $
MemPassed:
    LD   HL, MSG_MemCheckPassed
    PUSH HL
    CALL SIO_WriteString
    POP  HL
    CALL VDP_PutString
    LD   C, %11100000             ;Turn on LED on bit7-bit5
    CALL LED_Write

;   Load CP/M
    LD   HL, MSG_LoadCPM          ;Print load CP/M message
    PUSH HL
    CALL SIO_WriteString
    POP  HL
    CALL VDP_PutString

;   Read the contents of the first two tracks of CF card
ReadSector:
    LD   A, (SECNO)
    LD   C, A
    CP   0x80
    JP   Z, ReadComplete          ; Read complete
    INC  A
    LD   (SECNO), A               ; Address increment
    CALL CF_Wait_NotBusy          ; Wait until CF is not busy
    CALL CF_Wait_Ready            ; Wait until CF is ready
    LD   A, 1                     ; Sector count
    OUT  (CF_REG2), A
    LD   A, C                     ; Sector number: low 6bit, track number: high 2bit
    OUT  (CF_REG3), A
    LD   A, 0                     ; Track number: high 8bit
    OUT  (CF_REG4), A
    LD   A, 0                     ; Disk number: 4bit
    OUT  (CF_REG5), A
    LD   A, 0x20                  ; Read command
    OUT  (CF_REG7), A
    CALL CF_Wait_NotBusy          ; Wait until CF is not busy
    LD   HL, HSTBUF
ReadLoop:
    IN   A, (CF_REG0)             ; Read 1 byte
    LD   (HL), A                  ; Write to the host buffer
    INC  HL                       ; Increment the host buffer address
    IN   A, (CF_REG7)		      ; Check if data transfer is ready
	AND  CF_DRQ                   ; Mask out DRQ bit
    JR   NZ, ReadLoop             ; If ready, read next byte
    IN   A, (CF_REG7)	          ; Data transfer completed, check for errors
	AND	 CF_ERR                   ; Mask out ERR bit
    JR   NZ, ReadError            ; Error occurred
    LD   HL, HSTBUF   
    LD   DE, (BDOS)               ; CP/M bdos address
    LD   BC, 128                  ; CP/M sector size
    LDIR                          ; Copy the first 128 bytes to the bdos memory space
    LD   (BDOS), DE               ; Update bdos buffer write address
    JP   ReadSector               ; Read next sector

;   Print disk read error message
ReadError:
    LD   HL, MSG_ReadDiskError
    PUSH HL
    CALL SIO_WriteString
    POP  HL
    CALL VDP_PutString
    LD   C, 0                     ; Turn off all LEDs
    CALL LED_Write
    JR   $

;   Print disk read completed message
ReadComplete:
    LD   HL, MSG_ReadDiskOK
    PUSH HL
    CALL SIO_WriteString
    POP  HL
    CALL VDP_PutString
    LD   C, %11110000             ; Turn on LEDs on bit7-bit4
    CALL LED_Write
    JP   0xF200                   ; Jump to the CP/M bios address

;Current sector number, total 2 TRKS * 64 SECS/TRK = 128 SECS
SECNO:
    DB 0

;CP/M bdos address
BDOS:
    DW 0xDC00

;CF sector buffer
HSTBUF:
    DEFS 512