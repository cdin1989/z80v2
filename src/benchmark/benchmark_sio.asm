; SIO echo test.

#include "tms9118.asm"
#include "mc68b50.asm"

; Welcome message.
Message:
    DB "SIO echo 115200bps,N,8,1", 0

;Memory variables.
CharBuffer        EQU 0x8000    ;Character buffer.

;Init variables.
SetMemVars:
    LD A, 0
    LD (CharBuffer), A
    LD (CharBuffer + 1), A
    RET

;TMS9118 interrupt service routine.
OnVBlank:
    IN A, (VDP_VREG)            ;Clear the interrupt flag of TMS9118 status register.
    LD HL, 0x0800
    CALL WriteAddress
    LD HL, Message
    CALL WriteString            ;Print welcome message.
    RETI                        ;The ISR executes only once.

;Benchmark Entry.
Start:
    LD SP,0xFFFF        ;Set up the stack.
    CALL InitTms9118    ;Init VDP.
    CALL SIO_Init       ;Init ACIA.
    CALL SetMemVars     ;Init memory variables.
    EI                  ;Enable interrupt.
    IM 1                ;Enable Interrupt mode 1.

;Read ACIA in a loop.
ACIA_Read:
    CALL SIO_Read
    LD (CharBuffer), A
    LD HL, CharBuffer
    CALL SIO_WriteString
    JR ACIA_Read