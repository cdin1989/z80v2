
// automatically generated by m4 from headers in proto subdir


#ifndef __INPUT_CPM_H__
#define __INPUT_CPM_H__

#include <stdint.h>

///////////
// keyboard
///////////

extern int in_inkey(void);


extern int in_key_pressed(uint16_t scancode);


extern uint16_t in_key_scancode(int c);



extern uint16_t in_pause(uint16_t dur_ms);


extern int in_test_key(void);


extern void in_wait_key(void);


extern void in_wait_nokey(void);



////////////
// joysticks
////////////

extern uint16_t in_stick_keyboard(udk_t *u);



////////
// mouse
////////

#endif