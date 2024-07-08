;PSG sound test.
;Reference: https://www.smspower.org/Development/SN76489
;
;                          Input clock (Hz) (3579545)
;   Frequency (Hz) = ----------------------------------
;                     2 x register value x divider (16)
;
;   Register Value: N = 3579545 / Frequency * 32

#include "tms9118.asm"

;SN76489 ports:
PSG_PORT EQU 0x7F

Message:
    DB "Music is playing...", 0

; delay = DE*BC*27 cycles
; 10Mhz: 1000ms, BC=90
Delay:
    LD BC, 20
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

;Note <C3> Set frequency for tone0 to 130.8Hz
Play_C3:
    LD A, %10000111
    OUT (PSG_PORT), A
    LD A, %00110101
    OUT (PSG_PORT), A
    CALL Delay
    RET

; Note <D3> Set frequency for tone0 to 146.8Hz
Play_D3:
    LD A, %10001010
    OUT (PSG_PORT), A
    LD A, %00101111 
    OUT (PSG_PORT), A
    CALL Delay
    RET

; Note <E3> Set frequency for tone0 to 164.8Hz
Play_E3:
    LD A, %10000111
    OUT (PSG_PORT), A
    LD A, %00101010 
    OUT (PSG_PORT), A
    CALL Delay
    RET

; Note <F3> Set frequency for tone0 to 174.6Hz
Play_F3:
    LD A, %10000001
    OUT (PSG_PORT), A
    LD A, %00101000 
    OUT (PSG_PORT), A
    CALL Delay
    RET

; Note <G3> Set frequency for tone0 to 195.9Hz
Play_G3:
    LD A, %10001011
    OUT (PSG_PORT), A
    LD A, %00100011 
    OUT (PSG_PORT), A
    CALL Delay
    RET

; Note <A3> Set frequency for tone0 to 220.0Hz
Play_A3:
    LD A, %10001100
    OUT (PSG_PORT), A
    LD A, %00011111 
    OUT (PSG_PORT), A
    CALL Delay
    RET

; Note <B3> Set frequency for tone0 to 246.9Hz
Play_B3:
    LD A, %10000101
    OUT (PSG_PORT), A
    LD A, %00011100
    OUT (PSG_PORT), A
    CALL Delay
    RET

; Note <C4> Set frequency for tone0 to 261.6Hz
Play_C4:
    LD A, %10001100
    OUT (PSG_PORT), A
    LD A, %00011010
    OUT (PSG_PORT), A
    CALL Delay
    RET

; Comma
Play_Comma:
    LD A, %10011111     ;Set volume to min on channel 0
    OUT (PSG_PORT), A
    CALL Delay
    LD A, %10010000     ;Set volume to max on channel 0
    OUT (PSG_PORT), A
    RET


;TMS9118 interrupt service routine.
OnVBlank:
    IN A, (VDP_VREG)    ;Clear the interrupt flag of TMS9118 status register.
    LD HL, 0x0800
    CALL WriteAddress   ;Set vram address to write.
    LD HL, Message
    CALL WriteString    ;Write message to vram.

    LD A, %10010000     ;Set volume to max on channel 0
    OUT (PSG_PORT), A

    LD A, %10111111     ;Mute channel 1
    OUT (PSG_PORT), A

    LD A, %11011111     ;Mute channel 2
    OUT (PSG_PORT), A

    LD A, %11111111     ;Mute channel 3
    OUT (PSG_PORT), A

    ; Play song "Twinkle Star"
    ; 1155663
    CALL Play_C3
    CALL Play_Comma
    CALL Play_C3
    CALL Play_Comma
    CALL Play_G3
    CALL Play_Comma
    CALL Play_G3
    CALL Play_Comma
    CALL Play_A3
    CALL Play_Comma
    CALL Play_A3
    CALL Play_Comma
    CALL Play_G3

    CALL Delay
    CALL Delay

    ;4433221
    CALL Play_F3
    CALL Play_Comma
    CALL Play_F3
    CALL Play_Comma
    CALL Play_E3
    CALL Play_Comma
    CALL Play_E3
    CALL Play_Comma
    CALL Play_D3
    CALL Play_Comma
    CALL Play_D3
    CALL Play_Comma
    CALL Play_C3

    CALL Delay
    CALL Delay

    ;5544332
    CALL Play_G3
    CALL Play_Comma
    CALL Play_G3
    CALL Play_Comma
    CALL Play_F3
    CALL Play_Comma
    CALL Play_F3
    CALL Play_Comma
    CALL Play_E3
    CALL Play_Comma
    CALL Play_E3
    CALL Play_Comma
    CALL Play_D3

    CALL Delay
    CALL Delay

     ;5544332
    CALL Play_G3
    CALL Play_Comma
    CALL Play_G3
    CALL Play_Comma
    CALL Play_F3
    CALL Play_Comma
    CALL Play_F3
    CALL Play_Comma
    CALL Play_E3
    CALL Play_Comma
    CALL Play_E3
    CALL Play_Comma
    CALL Play_D3

    CALL Delay
    CALL Delay

    ; 1155663
    CALL Play_C3
    CALL Play_Comma
    CALL Play_C3
    CALL Play_Comma
    CALL Play_G3
    CALL Play_Comma
    CALL Play_G3
    CALL Play_Comma
    CALL Play_A3
    CALL Play_Comma
    CALL Play_A3
    CALL Play_Comma
    CALL Play_G3

    CALL Delay
    CALL Delay

    ;4433221
    CALL Play_F3
    CALL Play_Comma
    CALL Play_F3
    CALL Play_Comma
    CALL Play_E3
    CALL Play_Comma
    CALL Play_E3
    CALL Play_Comma
    CALL Play_D3
    CALL Play_Comma
    CALL Play_D3
    CALL Play_Comma
    CALL Play_C3

    CALL Delay
    CALL Delay
    
    EI                  ;Re-enable interrupt of Z80.
    RETI

;Benchmark Entry.
Start:
    LD SP,0xFFFF        ;Set up the stack.
    CALL InitTms9118    ;Init VDP.
    EI                  ;Enable interrupt.
    IM 1                ;Enable Interrupt mode 1.
    JP $                ;Halt CPU.
