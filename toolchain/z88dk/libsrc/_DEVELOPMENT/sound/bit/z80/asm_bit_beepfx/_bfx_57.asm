
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_57

_bfx_57:

   ; Aww (voice)

   defb 3 ;sample
   defw 160
   defw sample_data
   defb 45
   defb 0

sample_data:

   defb 203,203,247,227,248,120,223,60,127,143,56,247,15,113,227,159
   defb 225,238,60,115,248,127,207,252,255,15,225,243,223,195,252,63
   defb 107,248,127,135,244,63,7,248,63,195,240,31,135,252,63,0
   defb 252,63,225,241,135,195,255,31,30,126,63,249,241,243,227,247
   defb 143,191,254,31,239,255,255,247,248,127,249,249,255,5,255,191
   defb 191,199,223,143,239,240,7,254,3,252,3,255,192,254,1,255
   defb 128,255,128,255,193,255,128,255,131,255,1,255,63,240,15,248
   defb 127,224,63,225,255,128,127,227,255,0,255,227,255,0,255,225
   defb 255,224,63,252,31,252,1,255,228,255,192,31,255,231,255,128
   defb 127,255,240,127,224,31,255,255,255,255,192,63,255,255,255,255
