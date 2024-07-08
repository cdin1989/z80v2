;MC68B50 ACIA Controller API.

;Ports:
;0x3E: Control/Status Register
;0x3F: Transmit/Receive Data Register
SIO_CTRL       EQU 0x3E
SIO_DATA       EQU 0x3F

;Status bits.
SIO_RX_FULL     EQU 0x01
SIO_TX_EMPTY    EQU 0x02
SIO_FRAME_ERROR EQU 0x10 
SIO_OVERRUN     EQU 0x20

;Commnands.
;CR7 CR6 CR5 CR4 CR3 CR2 CR1 CR0
;0   0   0   1   0   1   1   1  Master Reset
;0   0   0   1   0   1   1   0  Disable interrupts,no parity,8 data bits, 1 stop bits, 115200bps
SIO_RESET       EQU 0b00010111
SIO_CONFIG      EQU 0b00010110

;Write data to ACIA.
;HL: address of data.
;DE: number of bytes to write.
SIO_Write:
    IN A, (SIO_CTRL)            ;Read status register.
    AND SIO_TX_EMPTY            ;Transmit buffer empty?
    JR Z, SIO_Write             ;No, try again.
    LD A, (HL+)
    OUT (SIO_DATA), A
    DEC DE
    JR NZ, SIO_Write
    RET

;Write message to ACIA.
;HL: address of message that is terminated by zero.
SIO_WriteString:
    LD A, (HL)
    OR A
    RET Z
SIO_Wait:
    IN A, (SIO_CTRL)            ;Read status register.
    AND SIO_TX_EMPTY            ;Transmit buffer empty?
    JR Z, SIO_Wait              ;No, try again.
    LD C, SIO_DATA
    OUTI
    JR SIO_WriteString

;Block and wait, until one byte of data is read.
;A: the received byte.
SIO_Read:
    IN A, (SIO_CTRL)            ;Read status register.
    AND SIO_RX_FULL             ;Receive buffer full?
    JR Z, SIO_Read              ;No, try again.
    IN A, (SIO_DATA)            ;Read data.
    RET

;Initialize ACIA.
SIO_Init:
    LD A, SIO_RESET
    OUT (SIO_CTRL), A           ;Reset ACIA.
    LD A, SIO_CONFIG
    OUT (SIO_CTRL), A           ;Configure ACIA.
    RET