SECTION code_driver

PUBLIC disk_status

EXTERN asm_disk_status

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called from diskio.h
; extern DSTATUS disk_status (BYTE pdrv) __smallc __z88dk_fastcall;
;

; get the ide drive status

defc disk_status = asm_disk_status