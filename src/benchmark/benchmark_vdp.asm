;VDP display test.
#include "tms9118.asm"

Message:
    DB "Hello World", 0

;TMS9118 interrupt service routine.
OnVBlank:
    IN A, (VDP_VREG)    ;Clear the interrupt flag of TMS9118 status register.
    LD HL, 0x0800
    CALL WriteAddress   ;Set vram address to write.
    LD HL, Message
    CALL WriteString    ;Write message to vram.
    EI                  ;Re-enable interrupt of Z80.
    RETI

;Benchmark Entry.
Start:
    LD SP,0xFFFF        ;Set up the stack.
    CALL InitTms9118    ;Init VDP.
    EI                  ;Enable interrupt.
    IM 1                ;Enable Interrupt mode 1.
    JP $                ;Halt CPU.
