
; void *zx_py2saddr(uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC zx_py2saddr

EXTERN asm_zx_py2saddr

defc zx_py2saddr = asm_zx_py2saddr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zx_py2saddr
defc _zx_py2saddr = zx_py2saddr
ENDIF

