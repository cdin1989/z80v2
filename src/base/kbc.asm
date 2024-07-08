; Keyboard Controller VT82C42 API
; IO Ports:
; 0x2E: Data Register(R/W)
; 0x2F: Status/Command Register(R/W)

; KBC Registers
KBC_DATA               EQU 0x2E
KBC_CTRL               EQU 0x2F

;Lock indicators
KBC_LOCK_SCROLL        EQU 0x01
KBC_LOCK_NUM           EQU 0x02
KBC_LOCK_CAPS          EQU 0x04

;PS/2 scan code set1
KBC_SC_ESC             EQU 0x01
KBC_SC_1               EQU 0x02
KBC_SC_2               EQU 0x03
KBC_SC_3               EQU 0x04
KBC_SC_4               EQU 0x05
KBC_SC_5               EQU 0x06
KBC_SC_6               EQU 0x07
KBC_SC_7               EQU 0x08
KBC_SC_8               EQU 0x09
KBC_SC_9               EQU 0x0A
KBC_SC_0               EQU 0x0B
KBC_SC_MINUS           EQU 0x0C
KBC_SC_EQUALS          EQU 0x0D
KBC_SC_BACKSPACE       EQU 0x0E
KBC_SC_TAB             EQU 0x0F
KBC_SC_Q               EQU 0x10
KBC_SC_W               EQU 0x11
KBC_SC_E               EQU 0x12
KBC_SC_R               EQU 0x13
KBC_SC_T               EQU 0x14
KBC_SC_Y               EQU 0x15
KBC_SC_U               EQU 0x16
KBC_SC_I               EQU 0x17
KBC_SC_O               EQU 0x18
KBC_SC_P               EQU 0x19
KBC_SC_LBRACKET        EQU 0x1A
KBC_SC_RBRACKET        EQU 0x1B
KBC_SC_ENTER           EQU 0x1C
KBC_SC_LCTRL           EQU 0x1D
KBC_SC_A               EQU 0x1E
KBC_SC_S               EQU 0x1F
KBC_SC_D               EQU 0x20
KBC_SC_F               EQU 0x21
KBC_SC_G               EQU 0x22
KBC_SC_H               EQU 0x23
KBC_SC_J               EQU 0x24
KBC_SC_K               EQU 0x25
KBC_SC_L               EQU 0x26
KBC_SC_SEMICOLON       EQU 0x27
KBC_SC_QUOTE           EQU 0x28
KBC_SC_BACKQUOTE       EQU 0x29
KBC_SC_LSHIFT          EQU 0x2A
KBC_SC_BACKSLASH       EQU 0x2B
KBC_SC_Z               EQU 0x2C
KBC_SC_X               EQU 0x2D
KBC_SC_C               EQU 0x2E
KBC_SC_V               EQU 0x2F
KBC_SC_B               EQU 0x30
KBC_SC_N               EQU 0x31
KBC_SC_M               EQU 0x32
KBC_SC_COMMA           EQU 0x33
KBC_SC_PERIOD          EQU 0x34
KBC_SC_SLASH           EQU 0x35
KBC_SC_RSHIFT          EQU 0x36
KBC_SC_NUMPAD_ASTERISK EQU 0x37
KBC_SC_LALT            EQU 0x38
KBC_SC_SPACE           EQU 0x39
KBC_SC_CAPSLOCK        EQU 0x3A
KBC_SC_F1              EQU 0x3B
KBC_SC_F2              EQU 0x3C
KBC_SC_F3              EQU 0x3D
KBC_SC_F4              EQU 0x3E
KBC_SC_F5              EQU 0x3F
KBC_SC_F6              EQU 0x40
KBC_SC_F7              EQU 0x41
KBC_SC_F8              EQU 0x42
KBC_SC_F9              EQU 0x43
KBC_SC_F10             EQU 0x44
KBC_SC_NUMLOCK         EQU 0x45
KBC_SC_SCROLLLOCK      EQU 0x46
KBC_SC_NUMPAD_7        EQU 0x47
KBC_SC_NUMPAD_8        EQU 0x48
KBC_SC_NUMPAD_9        EQU 0x49
KBC_SC_NUMPAD_MINUS    EQU 0x4A
KBC_SC_NUMPAD_4        EQU 0x4B
KBC_SC_NUMPAD_5        EQU 0x4C
KBC_SC_NUMPAD_6        EQU 0x4D
KBC_SC_NUMPAD_PLUS     EQU 0x4E
KBC_SC_NUMPAD_1        EQU 0x4F
KBC_SC_NUMPAD_2        EQU 0x50
KBC_SC_NUMPAD_3        EQU 0x51
KBC_SC_NUMPAD_0        EQU 0x52
KBC_SC_NUMPAD_PERIOD   EQU 0x53
KBC_SC_F11             EQU 0x57
KBC_SC_F12             EQU 0x58
KBC_SC_MASK            EQU 0x80

; Ascii lookup table
AsciiTable:
DB   0,    0,  '1',  '2',  '3',  '4',  '5',  '6',  '7',  '8', '9',  '0',  '-',  '=',    8, '\t'
DB 'q',  'w',  'e',  'r',  't',  'y',  'u',  'i',  'o',  'p', '[',  ']', '\r',    0,  'a',  's'
DB 'd',  'f',  'g',  'h',  'j',  'k',  'l',  ";", '\'',  '`',   0, '\\',  'z',  'x',  'c',  'v'
DB 'b',  'n',  'm',  ',',  '.',  '/',    0,    0,    0,  ' ',   0,    0,    0,    0,    0,   0
DB   0,    0,    0,    0,    0

; Ascii lookup table for shift pressed
AsciiTable1:
DB   0,    0,  '!',  '@',  '#',  '$',  '%',  '^',  '&',  '*', '(',  ')',  '_',  '+',    8, '\t'
DB 'Q',  'W',  'E',  'R',  'T',  'Y',  'U',  'I',  'O',  'P', '{',  '}', '\r',    0,  'A',  'S'
DB 'D',  'F',  'G',  'H',  'J',  'K',  'L',  ":",   34,  '~',   0,  '|',  'Z',  'X',  'C',  'V'
DB 'B',  'N',  'M',  '<',  '>',  '?',    0,    0,    0,  ' ',   0,    0,    0,    0,    0,   0
DB   0,    0,    0,    0,    0

; Ascii lookup table for ctrl pressed
AsciiTable2:
DB   0,    0,    0,    0,    0,    0,   0,     0,    0,    0,   0,    0,    0,    0,    0,   0
DB  17,   23,    5,   18,   20,   25,  21,     9,   15,   16,  27,   29,    0,    0,    1,  19
DB   4,    6,    7,    8,   10,   11,  12,     0,   34,    0,   0,   28,   26,   24,    3,  22
DB   2,   14,   13,    0,    0,    0,    0,    0,    0,    0,   0,    0,    0,    0,    0,   0
DB   0,    0,    0,    0,    0

; Shift key status
ShiftStatus:
    DB 0

; Ctrl key status
CtrlStatus:
    DB 0

; Status bits.
KBC_OBF            EQU 0x01       ; Output buffer full
KBC_IBF            EQU 0x02       ; Input buffer full

;Write a byte of data to the control register.
;C: command to be written.
KBC_WriteCmd:
    IN   A, (KBC_CTRL)            ; Read status
    AND  KBC_IBF                  ; Input buffer full?
    JR   NZ, KBC_WriteCmd         ; Wait until it's empty
    LD   A, C
    OUT  (KBC_CTRL), A            ; Write command
    RET

;----------------------------------------------------------------------
; Write a byte of data to the data register
; C: data to be written
;----------------------------------------------------------------------
KBC_WriteData:
    IN   A, (KBC_CTRL)            ; Read status.
    AND  KBC_IBF                  ; Input buffer full?
    JR   NZ, KBC_WriteData        ; Wait until it's empty
    LD   A, C
    OUT  (KBC_DATA), A            ; Write data
    RET

;----------------------------------------------------------------------
; Poll the status register to check if any key is pressed
; A: if a key is pressed, the scan code is returned, otherwise return 0
;----------------------------------------------------------------------
KBC_PollKey:
    IN   A, (KBC_CTRL)            ; Read status.
    AND  KBC_OBF                  ; Output buffer full?
    JR   Z, KBC_PollKey1          ; No key
    IN   A, (KBC_DATA)            ; Read scan code
    LD   C, A
    AND  KBC_SC_MASK
    JR   NZ, KBC_PollKey1         ; Discard the release key
    LD   A, C
    RET
KBC_PollKey1:
    LD   A, 0
    RET

;----------------------------------------------------------------------
; Block and wait util a key is pressed
; A: scan code
;----------------------------------------------------------------------
KBC_WaitKey:
    IN   A, (KBC_CTRL)            ; Read status.
    AND  KBC_OBF                  ; Output buffer full?
    JR   Z, KBC_WaitKey           ; Wait until it's full
    IN   A, (KBC_DATA)            ; Read scan code.
    LD   C, A
    AND  KBC_SC_MASK
    JR   NZ, KBC_WaitKey0         ; Goto key release

    LD   A, C
    CP   KBC_SC_LSHIFT
    JR   Z, KBC_WaitKey3         ; Goto shift press

    CP   KBC_SC_LCTRL
    JR   Z, KBC_WaitKey4         ; Goto ctrl press

;   Get ascii code
    CALL KBC_KeyChar

    RET

;   Process key release
KBC_WaitKey0:
    LD   A, C
    AND  0x7F
    CP   KBC_SC_LSHIFT
    JR   Z, KBC_WaitKey1
    CP   KBC_SC_LCTRL
    JR   Z, KBC_WaitKey2
    JR   KBC_WaitKey

;   ShiftStatus key release
KBC_WaitKey1:
    LD   HL, ShiftStatus
    LD   (HL), 0
    JR   KBC_WaitKey

;   CtrlStatus key release
KBC_WaitKey2:
    LD   HL, CtrlStatus
    LD   (HL), 0
    JR   KBC_WaitKey

;   Handle shift key press
KBC_WaitKey3:
    LD   HL, ShiftStatus
    LD   (HL), 1
    JR   KBC_WaitKey

;   Handle ctrl key press
KBC_WaitKey4:
    LD   HL, CtrlStatus
    LD   (HL), 1
    JR   KBC_WaitKey

;----------------------------------------------------------------------
; Convert a scan code to ascii code
; KBC_SC_ESC ~ KBC_SC_F10, total 68 keys can be converted
; C: scan code
; A: if successful, ascii code is returned, otherwise return 0
;----------------------------------------------------------------------
KBC_KeyChar:
    LD   A, C
    AND  0x7F                     ; Mask out key release
    CP   KBC_SC_F10
    JR   NC, KBC_KeyChar1
    LD   C, A
    LD   B, 0
    LD   A, (ShiftStatus)
    CP   1
    JR   Z, KBC_KeyChar2          ; Goto shift key combination
    LD   A, (CtrlStatus)
    CP   1
    JR   Z, KBC_KeyChar3          ; Goto ctrl key combination
;   Normal keys
    LD   HL, AsciiTable
    ADD  HL, BC
    LD   A, (HL)
    RET
;   Other keys
KBC_KeyChar1:
    LD   A, 0
    RET
;   shift keys
KBC_KeyChar2:
    LD   HL, AsciiTable1
    ADD  HL, BC
    LD   A, (HL)
    RET

;   ctrl keys
KBC_KeyChar3:
    LD   HL, AsciiTable2
    ADD  HL, BC
    LD   A, (HL)
    CP   3
    JR   Z, KBC_KeyChar4
    RET

;   CTRL + C pressed, reset ctrl status
KBC_KeyChar4:
    LD   HL, CtrlStatus
    LD   (HL), 0
    RET

; Turn on/off indicator lights
; D: Light number
; E: 0xFF to turn on, 0x00 to turn off
KBC_LockIndicator:
    LD   C, 0xED
    CALL KBC_WriteData
    LD   C, D
    CALL KBC_WriteData
    RET


; Initialize the keyboard controller.
KBC_Init:
    LD   C, 0xAA
    CALL KBC_WriteCmd
    CALL KBC_WaitKey              ; Wait for response.
    LD   C, 0x60
    CALL KBC_WriteCmd             ; Disable mouse and interrupts, enable translation.
    CALL KBC_WriteData
    LD   C, 0xAE
    CALL KBC_WriteCmd             ; Enable keyboard.
    RET