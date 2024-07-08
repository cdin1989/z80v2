;VT82C42 Keyboard Controller API.

;Ports:
KBD_DATA       EQU 0x2E
KBD_CTRL       EQU 0x2F

;PS/2 scan code set1 macros.
KBD_SC_ESC         EQU 0x01
KBD_SC_1           EQU 0x02
KBD_SC_2           EQU 0x03
KBD_SC_3           EQU 0x04
KBD_SC_4           EQU 0x05
KBD_SC_5           EQU 0x06
KBD_SC_6           EQU 0x07
KBD_SC_7           EQU 0x08
KBD_SC_8           EQU 0x09
KBD_SC_9           EQU 0x0A
KBD_SC_0           EQU 0x0B
KBD_SC_MINUS       EQU 0x0C
KBD_SC_EQUALS      EQU 0x0D
KBD_SC_BACKSPACE   EQU 0x0E
KBD_SC_TAB         EQU 0x0F
KBD_SC_Q           EQU 0x10
KBD_SC_W           EQU 0x11
KBD_SC_E           EQU 0x12
KBD_SC_R           EQU 0x13
KBD_SC_T           EQU 0x14
KBD_SC_Y           EQU 0x15
KBD_SC_U           EQU 0x16
KBD_SC_I           EQU 0x17
KBD_SC_O           EQU 0x18
KBD_SC_P           EQU 0x19
KBD_SC_LBRACKET    EQU 0x1A
KBD_SC_RBRACKET    EQU 0x1B
KBD_SC_ENTER       EQU 0x1C
KBD_SC_LCTRL       EQU 0x1D
KBD_SC_A           EQU 0x1E
KBD_SC_S           EQU 0x1F
KBD_SC_D           EQU 0x20
KBD_SC_F           EQU 0x21
KBD_SC_G           EQU 0x22
KBD_SC_H           EQU 0x23
KBD_SC_J           EQU 0x24
KBD_SC_K           EQU 0x25
KBD_SC_L           EQU 0x26
KBD_SC_SEMICOLON   EQU 0x27
KBD_SC_QUOTE       EQU 0x28
KBD_SC_BACKQUOTE   EQU 0x29
KBD_SC_LSHIFT      EQU 0x2A
KBD_SC_BACKSLASH   EQU 0x2B
KBD_SC_Z           EQU 0x2C
KBD_SC_X           EQU 0x2D
KBD_SC_C           EQU 0x2E
KBD_SC_V           EQU 0x2F
KBD_SC_B           EQU 0x30
KBD_SC_N           EQU 0x31
KBD_SC_M           EQU 0x32
KBD_SC_COMMA       EQU 0x33
KBD_SC_PERIOD      EQU 0x34
KBD_SC_SLASH       EQU 0x35
KBD_SC_RSHIFT      EQU 0x36
KBD_SC_KP_ASTERISK EQU 0x37
KBD_SC_LALT        EQU 0x38
KBD_SC_SPACE       EQU 0x39
KBD_SC_CAPSLOCK    EQU 0x3A
KBD_SC_F1          EQU 0x3B
KBD_SC_F2          EQU 0x3C
KBD_SC_F3          EQU 0x3D
KBD_SC_F4          EQU 0x3E
KBD_SC_F5          EQU 0x3F
KBD_SC_F6          EQU 0x40
KBD_SC_F7          EQU 0x41
KBD_SC_F8          EQU 0x42
KBD_SC_F9          EQU 0x43
KBD_SC_F10         EQU 0x44
KBD_SC_NUMLOCK     EQU 0x45
KBD_SC_SCROLLLOCK  EQU 0x46
KBD_SC_KP_7        EQU 0x47
KBD_SC_KP_8        EQU 0x48
KBD_SC_KP_9        EQU 0x49
KBD_SC_KP_MINUS    EQU 0x4A
KBD_SC_KP_4        EQU 0x4B
KBD_SC_KP_5        EQU 0x4C
KBD_SC_KP_6        EQU 0x4D
KBD_SC_KP_PLUS     EQU 0x4E
KBD_SC_KP_1        EQU 0x4F
KBD_SC_KP_2        EQU 0x50
KBD_SC_KP_3        EQU 0x51
KBD_SC_KP_0        EQU 0x52
KBD_SC_KP_PERIOD   EQU 0x53
KBD_SC_F11         EQU 0x57
KBD_SC_F12         EQU 0x58
KBD_SC_MASK        EQU 0x80

;Conversion table, 85 bytes.
ConvTable:
DB 0
DB '?', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0'
DB '-', '=', '?', '?', 'Q', 'W', 'E', 'R', 'T', 'Y', 'U'
DB 'I', 'O', 'P', '[', ']', '?', '?', 'A', 'S', 'D', 'F'
DB 'G', 'H', 'J', 'K', 'L', ";", '\'', '`', '?', '\\','Z'
DB 'X', 'C', 'V', 'B', 'N', 'M', ',', '.', '/', '?', '*'
DB '?', ' ', '?', '?', '?', '?', '?', '?', '?', '?', '?'
DB '?', '?', '?', '?', '7', '8', '9', '-', '4', '5', '6'
DB '+', '1', '2', '3', '0', '.', '?', '?'


;Status bits.
KBD_OBF           EQU 0x01 ;Output buffer full.
KBD_IBF           EQU 0x02 ;Input buffer full.

;Write a byte of data to the control register.
;C: command to be written.
KBD_WriteCmd:
    IN A, (KBD_CTRL)    ;Read status.
    AND KBD_IBF         ;Input buffer full?
    JR NZ, KBD_WriteCmd ;Wait until it's empty.
    LD A, C
    OUT (KBD_CTRL), A   ;Write command.
    RET

;Write a byte of data to the data register.
;C: data to be written.
KBD_WriteData:
    IN A, (KBD_CTRL)     ;Read status.
    AND KBD_IBF          ;Input buffer full?
    JR NZ, KBD_WriteData ;Wait until it's empty.
    LD A, C
    OUT (KBD_DATA), A    ;Write data.
    RET

;Polling the status register to check if any key is pressed,
;if a key is pressed, return the scan code, otherwise return FF.
KBD_PollKey:
    IN A, (KBD_CTRL)    ;Read status.
    AND KBD_OBF         ;Output buffer full?
    JR Z, KBD_NoKey     ;End polling.
    IN A, (KBD_DATA)    ;Read scan code.
    RET
KBD_NoKey:
    LD A, 0xFF
    RET

; Block and wait util a key is pressed, then return its scan code.
KBD_WaitKey:
    IN A, (KBD_CTRL)    ;Read status.
    AND KBD_OBF         ;Output buffer full?
    JR Z, KBD_WaitKey   ;Wait until it's full.
    IN A, (KBD_DATA)    ;Read scan code.
    RET

;Convert scan code to ASCII.
;C: scan code.
;A: convertion result.
KBD_ToAscii:
    LD A, C
    AND 0x7F            ;Ignore key release.
    LD B, 0
    LD C, A
    LD HL, ConvTable
    ADD HL, BC
    LD A, (HL)
    RET

;Initialize the keyboard controller.
KBD_Init:
    LD C, 0xAA
    CALL KBD_WriteCmd
    CALL KBD_WaitKey    ;Wait for response.
    LD C, 0x60
    CALL KBD_WriteCmd   ;Disable mouse and interrupts, enable translation.
    CALL KBD_WriteData
    LD C, 0xAE
    CALL KBD_WriteCmd   ;Enable keyboard.
    RET