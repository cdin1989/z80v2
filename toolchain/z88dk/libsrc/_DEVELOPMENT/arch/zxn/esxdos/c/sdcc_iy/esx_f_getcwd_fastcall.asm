; unsigned char esx_f_getcwd(unsigned char *buf)

SECTION code_esxdos

PUBLIC _esx_f_getcwd_fastcall

EXTERN asm_esx_f_getcwd

_esx_f_getcwd_fastcall:

   push iy
   
   call asm_esx_f_getcwd

   pop iy
   ret
