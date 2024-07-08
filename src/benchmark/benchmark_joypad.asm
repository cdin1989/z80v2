;Joypad button test.
#include "tms9118.asm"

;Joypad ports:
JOYPAD1_PORT EQU 0xC0
JOYPAD2_PORT EQU 0xC1

;Joypad1 button bits.
JOYPAD1_UP    EQU 0x01
JOYPAD1_DOWN  EQU 0x02
JOYPAD1_LEFT  EQU 0x04
JOYPAD1_RIGHT EQU 0x08
JOYPAD1_B1    EQU 0x10
JOYPAD1_B2    EQU 0x20

;Joypad2 button bits.
JOYPAD2_UP    EQU 0x40
JOYPAD2_DOWN  EQU 0x80
JOYPAD2_LEFT  EQU 0x01
JOYPAD2_RIGHT EQU 0x02
JOYPAD2_B1    EQU 0x04
JOYPAD2_B2    EQU 0x08
JOYPAD_RESET  EQU 0x10

;MESG1.
MESG_Welcome:
    DB "******PRESS ANY BUTTON ON JOYPAD******", 0

;MESG2
MESG_UpButtonIsPressed:
    DB "Up button is pressed", 0

;MESG3
MESG_DownButtonIsPressed:
    DB "Down button is pressed", 0

;MESG3
MESG_LeftButtonIsPressed:
    DB "Left button is pressed", 0

;MESG4
MESG_RightButtonIsPressed:
    DB "Right button is pressed", 0

;MESG5
MESG_B1ButtonIsPressed:
    DB "B1 button is pressed", 0
;MESG6
MESG_B2ButtonIsPressed:
    DB "B2 button is pressed", 0

;MESG7
MESG_Blank:
    DS 260, ' '
    DB 0

;Poll joypad1 button.
PollJoypad1:
    IN A, (JOYPAD1_PORT)
    RET

;Poll joypad2 button.
PollJoypad2:
    IN A, (JOYPAD2_PORT)
    RET

;TMS9118 interrupt service routine.
OnVBlank:
    IN A, (VDP_VREG)      ;Clear the interrupt flag of TMS9118 status register.

    LD HL, 0x0800
    CALL WriteAddress
    LD HL, MESG_Blank
    CALL WriteString      ;Clear screen, 40*4

    LD HL, 0x0800
    CALL WriteAddress
    LD HL, MESG_Welcome
    CALL WriteString      ;Print welcome message.

    CALL PollJoypad1      ;Poll joypad1
    CPL                   ;Invert the bits: 1 is pressed, 0 is released.
    LD (0xC001), A        ;Store A at RAM 0xC001.

Joypad1_Up_Pressed:       ;JOYPAD1-> Check [Up] button.
    LD A, (0xC001)
    AND JOYPAD1_UP
    JR Z, Joypad1_Down_Pressed
    LD HL, MESG_UpButtonIsPressed
    CALL WriteString

Joypad1_Down_Pressed:     ;JOYPAD1->Check [Down] button.
    LD A, (0xC001)
    AND JOYPAD1_DOWN
    JR Z, Joypad1_Left_Pressed
    LD HL, MESG_DownButtonIsPressed
    CALL WriteString

Joypad1_Left_Pressed:     ;JOYPAD1->Check [Left] button.
    LD A, (0xC001)
    AND JOYPAD1_LEFT
    JR Z, Joypad1_Right_Pressed
    LD HL, MESG_LeftButtonIsPressed
    CALL WriteString

Joypad1_Right_Pressed:    ;JOYPAD1->Check [Right] button.
    LD A, (0xC001)
    AND JOYPAD1_RIGHT
    JR Z, Joypad1_B1_Pressed
    LD HL, MESG_RightButtonIsPressed
    CALL WriteString

Joypad1_B1_Pressed:       ;JOYPAD1->Check [B1] button.
    LD A, (0xC001)
    AND JOYPAD1_B1
    JR Z, Joypad1_B2_Pressed
    LD HL, MESG_B1ButtonIsPressed
    CALL WriteString

Joypad1_B2_Pressed:       ;JOYPAD1->Check [B2] button.
    LD A, (0xC001)
    AND JOYPAD1_B2
    JR Z, Joypad1_End
    LD HL, MESG_B2ButtonIsPressed
    CALL WriteString

Joypad1_End:
    RET

;Benchmark Entry.
Start:
    LD SP,0xFFFF        ;Set up the stack.
    CALL InitTms9118    ;Init VDP.
    EI                  ;Enable interrupt.
    IM 1                ;Enable Interrupt mode 1.
    JP $                ;Halt CPU.