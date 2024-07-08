; Keyboard test.

#include "tms9118.asm"
#include "vt82c42.asm"

; Welcome message.
Message:
    DB "PRESS ANY KEY...", 0

;Memory variables.
IsWelcomePrinted  EQU 0x8000    ;Welcome message printed?
CharBuffer        EQU 0x8001    ;Character buffer.

;Init variables.
SetMemVars:
    LD A, 0
    LD (IsWelcomePrinted), A
    LD (CharBuffer), A
    LD (CharBuffer + 1), A
    RET

;TMS9118 interrupt service routine.
OnVBlank:
    IN A, (VDP_VREG)            ;Clear the interrupt flag of TMS9118 status register.
    LD A, (IsWelcomePrinted)    ;Is welcome message printed?
    OR A
    JR Z, PrintWelcomeMessage
    JR PollKey
PrintWelcomeMessage:            ;Print welcome message.
    LD HL, 0x0800
    CALL WriteAddress
    LD HL, Message
    CALL WriteString
    LD HL, 0x0828
    CALL WriteAddress           ;Next line.
    LD A, 1
    LD (IsWelcomePrinted), A    ;Mark the message as printed.
PollKey:
    CALL KBD_PollKey            ;Is any key pressed?
    CP 0xFF
    JR Z, PollEnds
    LD C, A
    CALL KBD_ToAscii            ;Convert scan code to ASCII code.
    LD (CharBuffer), A          ;Save it to memory location at 0x8001.
    LD HL, CharBuffer           ;Print the characer on the screen.
    CALL WriteString
PollEnds:
    EI                          ;Re-enable interrupt of Z80.
    RETI

;Benchmark Entry.
Start:
    LD SP,0xFFFF        ;Set up the stack.
    CALL SetMemVars     ;Init memory variables.
    CALL InitTms9118    ;Init VDP.
    CALL KBD_Init       ;Init keyboard controller.
    EI                  ;Enable interrupt.
    IM 1                ;Enable Interrupt mode 1.
    JP $                ;Halt CPU.
