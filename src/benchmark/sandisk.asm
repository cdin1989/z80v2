;Compact Flash API.
;CF Ports:
;0xF0: Data
;0xF1: Error[IORD] Feature[IOWR]
;0xF2: Sector Count
;0xF3: Sector Number               LBA0-LBA7
;0xF4: Cylinder Low Byte           LBA8-LBA15
;0xF5: Cylinder High Byte          LBA16-LBA23
;0xF6: Select Card /Head (HS3-HS0) LBA24-LBA27
;0xF7: Status[IORD] Command[IOWR]

CF_BASE EQU 0xF0	    ;BASE ADDRESS OF PRIMARY IDE CONTROLLER
CF_REG0	EQU	CF_BASE + 0	;DATA
CF_REG1	EQU	CF_BASE + 1	;READ: ERROR CODE, WRITE: FEATURE
CF_REG2	EQU	CF_BASE + 2	;NUMBER OF SECTORS TO TRANSFER
CF_REG3	EQU	CF_BASE + 3	;SECTOR NUMBER             LBA0-LBA7
CF_REG4	EQU	CF_BASE + 4	;CYLINDER LOW BYTE         LBA8-LBA15
CF_REG5	EQU	CF_BASE + 5	;CYLINDER HIGH BYTE        LBA16-LBA23
CF_REG6	EQU	CF_BASE + 6	;DRIVE/HEAD BITS HS3-HS0   LBA24-LBA27 (1110 HS3 HS2 HS1 HS0)
CF_REG7	EQU	CF_BASE + 7	;READ: STATUS, WRITE: COMMAND

;CF Status Bits:
;|D7   |D6   |D5   |D4   |D3   |D2   |D1   |D0   |
;|BUSY |RDY  |DWF  |DSC  |DRQ  |CORR |0    |ERR  |
CF_BUSY	EQU 0x80
CF_RDY	EQU 0x40
CF_DWF	EQU 0x20
CF_DSC	EQU 0x10
CF_DRQ	EQU 0x08
CF_CORR	EQU 0x04
CF_ERR	EQU 0x01

;Wait until CF card is not busy.
CF_Wait_NotBusy:
    IN A, (CF_REG7)
    AND CF_BUSY
    JR NZ, CF_Wait
    RET

;Wait until CF card is ready.
CF_Wait_Ready:
    IN A, (CF_REG7)
    AND CF_RDY
    JR Z, CF_Wait_Ready
    RET

;Initialize the CF card.
CF_Init:
    LD A, 0x04
    OUT (CF_REG7), A        ;Reset.
    CALL CF_Wait_NotBusy
    LD A, 0xE0
    OUT (CF_REG6), A        ;Set LBA address mode.
    LD A, 0x01
    OUT (CF_REG1), A        ;Set 8 bit mode.
    LD A, 0xEF
    OUT (CF_REG7), A        ;Issues set feature command.
    CALL CF_Wait_NotBusy
    CALL CF_Wait_Ready
    RET


