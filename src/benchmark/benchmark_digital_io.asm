; Chase lights test.

; Digital-IO ports: 0x02 (write)
DIO_PORT EQU 0x02
RAMADDR  EQU 0x8000

ORG 0x0000
    JP Start

Delay1S:               ; Delay 1 second (DE*BC*27 cycles).
    LD BC, 36
DelayLoop1:
    LD DE, 4096
DelayLoop2:
    DEC DE
    LD A, D
    OR E
    JP NZ, DelayLoop2
    DEC BC              ; 6 cycles
    LD A, B             ; 4 cycles
    OR C                ; 4 cycles
    JR NZ, DelayLoop1   ; 8/13 cycles
    RET

;Benchmark entry.
Start:
    LD SP, 0xFFFF
    LD A, 0
    OUT (DIO_PORT), A   ; Turn off LEDs.
    LD A, 1
    LD (RAMADDR), A     ; Write 1 to 0x8000.
Blink:
    LD A, (RAMADDR)
    OUT (DIO_PORT), A
    RLC A               ; Rotate shift left.
    LD (RAMADDR), A     ; Write back.
    CALL Delay1S        ; Delay 1 second.
    JR Blink            ; Loop.
