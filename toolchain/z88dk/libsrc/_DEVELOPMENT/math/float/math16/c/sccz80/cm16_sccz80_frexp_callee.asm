
SECTION code_fp_math16

PUBLIC cm16_sccz80_frexp_callee

EXTERN asm_f16_frexp

; half_t frexp(half_t x, int16_t *pw2);

.cm16_sccz80_frexp_callee
    ; Entry:
    ; Stack: half_t left, ptr right, ret

    ; Reverse the stack
    pop de                      ;my return
    pop bc                      ;ptr
    pop hl                      ;half_t
    push de                     ;my return
    jp  asm_f16_frexp

