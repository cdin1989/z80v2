; Memory Page API
; IO Ports:
; 0x00: 32K ROM(0x0000-0x7FFF) + 32K RAM(0x8000-0xFFFF) (W)
; 0x01: 64K RAM(0x0000-0xFFFF) (W)

MEM_PAGE_32K EQU 0x00
MEM_PAGE_64K EQU 0x01

;C: page number
MEM_Switch:
    LD   A, 0                     ; the value is not important
    OUT  (C), A
    RET