
#ifndef _SP1_H
#define _SP1_H

///////////////////////////////////////////////////////////
//                  SPRITE PACK v3.0                     //
//             Sinclair Spectrum Version                 //
//            aralbrec - April / May 2006                //
///////////////////////////////////////////////////////////
//                                                       //
//       See the wiki for documentation details          //
//             http://www.z88dk.org/wiki                 //
//                                                       //
///////////////////////////////////////////////////////////

#include <rect.h>
#include <sys/types.h>
#include <sys/compiler.h>
#include <stdint.h>

///////////////////////////////////////////////////////////
//                  DATA STRUCTURES                      //
///////////////////////////////////////////////////////////

struct sp1_Rect {

   uint8_t row;
   uint8_t col;
   uint8_t width;
   uint8_t height;

};

struct sp1_update;
struct sp1_ss;
struct sp1_cs;

struct sp1_update {                   // "update structs" - 10 bytes - Every tile in the display area managed by SP1 is described by one of these

   uint8_t              nload;          // +0 bit 7 = 1 for invalidated, bit 6 = 1 for removed, bits 5:0 = number of occluding sprites present + 1
   uint8_t              colour;         // +1 background tile attribute
   uint16_t               tile;           // +2 background 16-bit tile code (if MSB != 0 taken as address of graphic, else lookup in tile array)
   struct sp1_cs     *slist;          // +4 BIG ENDIAN ; list of sprites occupying this tile (MSB = 0 if none) points at struct sp1_cs.attr_mask
   struct sp1_update *ulist;          // +6 BIG ENDIAN ; next update struct in list of update structs queued for draw (MSB = 0 if none)
   uint8_t             *screen;         // +8 address in display file where this tile is drawn

};

struct sp1_ss {                       // "sprite structs" - 20 bytes - Every sprite is described by one of these

   uint8_t            row;            // +0  current y tile-coordinate
   uint8_t            col;            // +1  current x tile-coordinate
   uint8_t            width;          // +2  width of sprite in tiles
   uint8_t            height;         // +3  height of sprite in tiles

   uint8_t            vrot;           // +4  bit 7 = 1 for 2-byte graphical definition else 1-byte, bits 2:0 = current vertical rotation (0..7)
   uint8_t            hrot;           // +5  current horizontal rotation (0..7)

   uint8_t           *frame;          // +6  current sprite frame address added to graphic pointers

   uint8_t            res0;           // +8  "LD A,n" opcode
   uint8_t            e_hrot;         // +9  effective horizontal rotation = MSB of rotation table to use
   uint8_t            res1;           // +10 "LD BC,nn" opcode
   uint16_t           e_offset;       // +11 effective offset to add to graphic pointers, equals result of vertical rotation + frame addr
   uint8_t            res2;           // +13 "EX DE,HL" opcode
   uint8_t            res3;           // +14 "JP (HL)" opcode

   struct sp1_cs     *first;          // +15 BIG ENDIAN ; first struct sp1_cs of this sprite

   uint8_t            xthresh;        // +17 hrot must be at least this number of pixels for last column of sprite to be drawn (1 default)
   uint8_t            ythresh;        // +18 vrot must be at least this number of pixels for last row of sprite to be drawn (1 default)
   uint8_t            nactive;        // +19 number of struct sp1_cs cells on display (written by sp1_MoveSpr*)

};

struct sp1_cs {                       // "char structs" - 24 bytes - Every sprite is broken into pieces fitting into a tile, each of which is described by one of these

   struct sp1_cs     *next_in_spr;    // +0  BIG ENDIAN ; next sprite char within same sprite in row major order (MSB = 0 if none)

   struct sp1_update *update;         // +2  BIG ENDIAN ; tile this sprite char currently occupies (MSB = 0 if none)

   uint8_t            plane;          // +4  plane sprite occupies, 0 = closest to viewer
   uint8_t            type;           // +5  bit 7 = 1 occluding, bit 6 = 1 last column, bit 5 = 1 last row, bit 4 = 1 clear pixelbuffer
   uint8_t            attr_mask;      // +6  attribute mask logically ANDed with underlying attribute, default = 0xff for transparent
   uint8_t            attr;           // +7  sprite colour, logically ORed to form final colour, default = 0 for transparent

   void              *ss_draw;        // +8  struct sp1_ss + 8 bytes ; points at code embedded in sprite struct sp1_ss

   uint8_t            res0;           // +10 typically "LD HL,nn" opcode
   uint8_t           *def;            // +11 graphic definition pointer
   uint8_t            res1;           // +13 typically "LD IX,nn" opcode
   uint8_t            res2;           // +14
   uint8_t           *l_def;          // +15 graphic definition pointer for sprite character to left of this one
   uint8_t            res3;           // +17 typically "CALL nn" opcode
   void              *draw;           // +18 & draw function for this sprite char

   struct sp1_cs     *next_in_upd;    // +20 BIG ENDIAN ; & sp1_cs.attr_mask of next sprite occupying the same tile (MSB = 0 if none)
   struct sp1_cs     *prev_in_upd;    // +22 BIG ENDIAN ; & sp1_cs.next_in_upd of previous sprite occupying the same tile

};

struct sp1_ap {                       // "attribute pairs" - 2 bytes - A struct to hold sprite attribute and mask pairs

   uint8_t            attr_mask;      // +0 attribute mask logically ANDed with underlying attribute = 0xff for transparent
   uint8_t            attr;           // +1 sprite colour, logically ORed to form final colour = 0 for transparent

};

struct sp1_tp {                       // "tile pairs" - 3 bytes - A struct to hold background colour and tile pairs

   uint8_t            attr;           // +0 colour
   uint16_t           tile;           // +1 tile code

};

struct sp1_pss {                      // "print string struct" - 11 bytes - A struct holding print state information

   struct sp1_Rect   *bounds;         // +0 rectangular boundary within which printing will be allowed
   uint8_t            flags;          // +2 bit 0=invalidate?, 1=xwrap?, 2=yinc?, 3=ywrap?
   uint8_t            x;              // +3 current x coordinate of cursor with respect to top left corner of bounds
   uint8_t            y;              // +4 current y coordinate of cursor with respect to top left corner of bounds
   uint8_t            attr_mask;      // +5 current attribute mask
   uint8_t            attr;           // +6 current attribute
   struct sp1_update *pos;            // +7 RESERVED struct sp1_update associated with current cursor coordinates
   void              *visit;          // +9 void (*visit)(struct sp1_update *) function, set to 0 for none
   
};

///////////////////////////////////////////////////////////
//                      SPRITES                          //
///////////////////////////////////////////////////////////

// sprite type bits

#define SP1_TYPE_OCCLUDE   0x80       // background and sprites underneath will not be drawn
#define SP1_TYPE_BGNDCLR   0x10       // for occluding sprites, copy background tile into pixel buffer before draw

#define SP1_TYPE_2BYTE     0x40       // sprite graphic consists of (mask,graph) pairs, valid only in sp1_CreateSpr()
#define SP1_TYPE_1BYTE     0x00       // sprite graphic consists of graph only, valid only in sp1_CreateSpr()

// sprite attribute masks, logically AND together if necessary
// spectrum.h contains defines for INK and PAPER colours

#define SP1_AMASK_TRANS    0xff       // attribute mask for a transparent-colour sprite
#define SP1_AMASK_INK      0xf8       // attribute mask for an ink-only sprite
#define SP1_AMASK_PAPER    0xc7       // attribute mask for a paper-only sprite
#define SP1_AMASK_NOFLASH  0x7f       // attribute mask for no-flash
#define SP1_AMASK_NOBRIGHT 0xbf       // attribute mask for no-bright
#define SP1_ATTR_TRANS     0x00       // attribute for a transparent-colour sprite

// prototype struct_sp1_ss and struct_sp1_cs that can be used to initialize empty structures

extern struct sp1_cs  sp1_struct_cs_prototype;
extern struct sp1_ss  sp1_struct_ss_prototype;

// draw functions for sprites with two-byte graphical definitions, ie (mask,graphic) pairs

extern void  __LIB__  SP1_DRAW_MASK2(void);        // masked sprite 2-byte definition (mask,graph) pairs ; sw rotation will use MASK2_NR if no rotation necessary
extern void  __LIB__  SP1_DRAW_MASK2NR(void);      // masked sprite 2-byte definition (mask,graph) pairs ; no rotation applied, graphic always drawn at exact tile boundary
extern void  __LIB__  SP1_DRAW_MASK2LB(void);      // masked sprite 2-byte definition (mask,graph) pairs ; sw rotation as MASK2 but for left boundary of sprite only
extern void  __LIB__  SP1_DRAW_MASK2RB(void);      // masked sprite 2-byte definition (mask,graph) pairs ; sw rotation as MASK2 but for right boundary of sprite only

extern void  __LIB__  SP1_DRAW_LOAD2(void);        // load sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation will use LOAD2_NR if no rotation necessary
extern void  __LIB__  SP1_DRAW_LOAD2NR(void);      // load sprite 2-byte definition (mask,graph) pairs mask ignored; no rotation applied, always drawn at exact tile boundary
extern void  __LIB__  SP1_DRAW_LOAD2LB(void);      // load sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation as LOAD2 but for left boundary of sprite only
extern void  __LIB__  SP1_DRAW_LOAD2RB(void);      // load sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation as LOAD2 but for right boundary of sprite only

extern void  __LIB__  SP1_DRAW_OR2(void);          // or sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation will use OR2_NR if no rotation necessary
extern void  __LIB__  SP1_DRAW_OR2NR(void);        // or sprite 2-byte definition (mask,graph) pairs mask ignored; no rotation applied, always drawn at exact tile boundary
extern void  __LIB__  SP1_DRAW_OR2LB(void);        // or sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation as OR2 but for left boundary of sprite only
extern void  __LIB__  SP1_DRAW_OR2RB(void);        // or sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation as OR2 but for right boundary of sprite only

extern void  __LIB__  SP1_DRAW_XOR2(void);         // xor sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation will use XOR2_NR if no rotation necessary
extern void  __LIB__  SP1_DRAW_XOR2NR(void);       // xor sprite 2-byte definition (mask,graph) pairs mask ignored; no rotation applied, always drawn at exact tile boundary
extern void  __LIB__  SP1_DRAW_XOR2LB(void);       // xor sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation as XOR2 but for left boundary of sprite only
extern void  __LIB__  SP1_DRAW_XOR2RB(void);       // xor sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation as XOR2 but for right boundary of sprite only

extern void  __LIB__  SP1_DRAW_LOAD2LBIM(void);    // load sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation as LOAD2 but for left boundary of sprite w/ implied mask
extern void  __LIB__  SP1_DRAW_LOAD2RBIM(void);    // load sprite 2-byte definition (mask,graph) pairs mask ignored; sw rotation as LOAD2 but for right boundary of sprite w/ implied mask

// draw functions for sprites with one-byte graphical definitions, ie no mask just graphics

extern void  __LIB__  SP1_DRAW_LOAD1(void);        // load sprite 1-byte definition graph only no mask; sw rotation will use LOAD1_NR if no rotation necessary
extern void  __LIB__  SP1_DRAW_LOAD1NR(void);      // load sprite 1-byte definition graph only no mask; no rotation applied, always drawn at exact tile boundary
extern void  __LIB__  SP1_DRAW_LOAD1LB(void);      // load sprite 1-byte definition graph only no mask; sw rotation as LOAD1 but for left boundary of sprite only
extern void  __LIB__  SP1_DRAW_LOAD1RB(void);      // load sprite 1-byte definition graph only no mask; sw rotation as LOAD1 but for right boundary of sprite only

extern void  __LIB__  SP1_DRAW_OR1(void);          // or sprite 1-byte definition graph only no mask; sw rotation will use OR1_NR if no rotation necessary
extern void  __LIB__  SP1_DRAW_OR1NR(void);        // or sprite 1-byte definition graph only no mask; no rotation applied, always drawn at exact tile boundary
extern void  __LIB__  SP1_DRAW_OR1LB(void);        // or sprite 1-byte definition graph only no mask; sw rotation as OR1 but for left boundary of sprite only
extern void  __LIB__  SP1_DRAW_OR1RB(void);        // or sprite 1-byte definition graph only no mask; sw rotation as OR1 but for right boundary of sprite only

extern void  __LIB__  SP1_DRAW_XOR1(void);         // xor sprite 1-byte definition graph only no mask; sw rotation will use XOR1_NR if no rotation necessary
extern void  __LIB__  SP1_DRAW_XOR1NR(void);       // xor sprite 1-byte definition graph only no mask; no rotation applied, always drawn at exact tile boundary
extern void  __LIB__  SP1_DRAW_XOR1LB(void);       // xor sprite 1-byte definition graph only no mask; sw rotation as XOR1 but for left boundary of sprite only
extern void  __LIB__  SP1_DRAW_XOR1RB(void);       // xor sprite 1-byte definition graph only no mask; sw rotation as XOR1 but for right boundary of sprite only

extern void  __LIB__  SP1_DRAW_LOAD1LBIM(void);    // load sprite 1-byte definition graph only no mask; sw rotation as LOAD1 but for left boundary of sprite with implied mask
extern void  __LIB__  SP1_DRAW_LOAD1RBIM(void);    // load sprite 1-byte definition graph only no mask; sw rotation as LOAD1 but for right boundary of sprite with implied mask

// draw functions for sprites without graphics

extern void  __LIB__  SP1_DRAW_ATTR(void);         // pixels are not drawn, only attributes


// void *hook1  <->  void [ __FASTCALL__ ] (*hook1)(uint16_t count, struct sp1_cs *c)      // if __FASTCALL__ only struct sp1_cs* passed
// void *hook2  <->  void [ __FASTCALL__ ] (*hook2)(uint16_t count, struct sp1_update *u)  // if __FASTCALL__ only struct sp1_update* passed
//
// void *drawf  <->  void (*drawf)(void)     // sprite draw function containing draw code and data for struct_sp1_cs

extern struct sp1_ss      __LIB__  *sp1_CreateSpr(void *drawf, uint8_t type, uint8_t height, int graphic, uint8_t plane);
extern uint16_t           __LIB__   sp1_AddColSpr(struct sp1_ss *s, void *drawf, uint8_t type, int graphic, uint8_t plane);
extern void               __LIB__   sp1_ChangeSprType(struct sp1_cs *c, void *drawf);
extern void               __LIB__   sp1_DeleteSpr(struct sp1_ss *s) __z88dk_fastcall;   // only call after sprite is moved off screen

extern void               __LIB__   sp1_MoveSprAbs(struct sp1_ss *s, struct sp1_Rect *clip, void *frame, uint8_t row, uint8_t col, uint8_t vrot, uint8_t hrot);
extern void               __LIB__   sp1_MoveSprRel(struct sp1_ss *s, struct sp1_Rect *clip, void *frame, char rel_row, char rel_col, char rel_vrot, char rel_hrot);
extern void               __LIB__   sp1_MoveSprPix(struct sp1_ss *s, struct sp1_Rect *clip, void *frame, uint16_t x, uint16_t y);

extern void               __LIB__   sp1_IterateSprChar(struct sp1_ss *s, void *hook1);
extern void               __LIB__   sp1_IterateUpdateSpr(struct sp1_ss *s, void *hook2);

extern void               __LIB__   sp1_GetSprClrAddr(struct sp1_ss *s, uint8_t **sprdest);
extern void               __LIB__   sp1_PutSprClr(uint8_t **sprdest, struct sp1_ap *src, uint8_t n);
extern void               __LIB__   sp1_GetSprClr(uint8_t **sprsrc, struct sp1_ap *dest, uint8_t n);

extern void               __LIB__  *sp1_PreShiftSpr(uint8_t flag, uint8_t height, uint8_t width, void *srcframe, void *destframe, uint8_t rshift);

// some functions for displaying independent struct_sp1_cs not connected with any sprites; useful as foreground elements
// if not using a no-rotate (NR) type sprite draw function, must manually init the sp1_cs.ldef member after calling sp1_InitCharStruct()

extern void               __LIB__   sp1_InitCharStruct(struct sp1_cs *cs, void *drawf, uint8_t type, void *graphic, uint8_t plane);
extern void               __LIB__   sp1_InsertCharStruct(struct sp1_update *u, struct sp1_cs *cs);
extern void               __LIB__   sp1_RemoveCharStruct(struct sp1_cs *cs) __z88dk_fastcall;


/* CALLEE LINKAGE */

extern struct sp1_ss      __LIB__ *sp1_CreateSpr_callee(void *drawf, uint8_t type, uint8_t height, int graphic, uint8_t plane) __z88dk_callee;
extern uint16_t           __LIB__  sp1_AddColSpr_callee(struct sp1_ss *s, void *drawf, uint8_t type, int graphic, uint8_t plane) __z88dk_callee;
extern void               __LIB__  sp1_MoveSprAbs_callee(struct sp1_ss *s, struct sp1_Rect *clip, void *frame, uint8_t row, uint8_t col, uint8_t vrot, uint8_t hrot) __z88dk_callee;
extern void               __LIB__  sp1_MoveSprRel_callee(struct sp1_ss *s, struct sp1_Rect *clip, void *frame, char rel_row, char rel_col, char rel_vrot, char rel_hrot) __z88dk_callee;
extern void               __LIB__  sp1_MoveSprPix_callee(struct sp1_ss *s, struct sp1_Rect *clip, void *frame, uint16_t x, uint16_t y) __z88dk_callee;
extern void               __LIB__  sp1_IterateSprChar_callee(struct sp1_ss *s, void *hook1) __z88dk_callee;
extern void               __LIB__  sp1_IterateUpdateSpr_callee(struct sp1_ss *s, void *hook2) __z88dk_callee;
extern void               __LIB__  sp1_ChangeSprType_callee(struct sp1_cs *c, void *drawf) __z88dk_callee;
extern void               __LIB__  sp1_GetSprClrAddr_callee(struct sp1_ss *s, uint8_t **sprdest) __z88dk_callee;
extern void               __LIB__  sp1_PutSprClr_callee(uint8_t **sprdest, struct sp1_ap *src, uint8_t n) __z88dk_callee;
extern void               __LIB__  sp1_GetSprClr_callee(uint8_t **sprsrc, struct sp1_ap *dest, uint8_t n) __z88dk_callee;
extern void               __LIB__ *sp1_PreShiftSpr_callee(uint8_t flag, uint8_t height, uint8_t width, void *srcframe, void *destframe, uint8_t rshift) __z88dk_callee;
extern void               __LIB__  sp1_InitCharStruct_callee(struct sp1_cs *cs, void *drawf, uint8_t type, void *graphic, uint8_t plane) __z88dk_callee;
extern void               __LIB__  sp1_InsertCharStruct_callee(struct sp1_update *u, struct sp1_cs *cs) __z88dk_callee;

#define sp1_CreateSpr(a,b,c,d,e)       sp1_CreateSpr_callee(a,b,c,d,e)
#define sp1_AddColSpr(a,b,c,d,e)       sp1_AddColSpr_callee(a,b,c,d,e)
#define sp1_MoveSprAbs(a,b,c,d,e,f,g)  sp1_MoveSprAbs_callee(a,b,c,d,e,f,g)
#define sp1_MoveSprRel(a,b,c,d,e,f,g)  sp1_MoveSprRel_callee(a,b,c,d,e,f,g)
#define sp1_MoveSprPix(a,b,c,d,e)      sp1_MoveSprPix_callee(a,b,c,d,e)
#define sp1_IterateSprChar(a,b)        sp1_IterateSprChar_callee(a,b)
#define sp1_IterateUpdateSpr(a,b)      sp1_IterateUpdateSpr_callee(a,b)
#define sp1_ChangeSprType(a,b)         sp1_ChangeSprType_callee(a,b)
#define sp1_GetSprClrAddr(a,b)         sp1_GetSprClrAddr_callee(a,b)
#define sp1_PutSprClr(a,b,c)           sp1_PutSprClr_callee(a,b,c)
#define sp1_GetSprClr(a,b,c)           sp1_GetSprClr_callee(a,b,c)
#define sp1_PreShiftSpr(a,b,c,d,e,f)   sp1_PreShiftSpr_callee(a,b,c,d,e,f)
#define sp1_InitCharStruct(a,b,c,d,e)  sp1_InitCharStruct_callee(a,b,c,d,e)
#define sp1_InsertCharStruct(a,b)      sp1_InsertCharStruct_callee(a,b)


///////////////////////////////////////////////////////////
//                COLLISION DETECTION                    //
///////////////////////////////////////////////////////////

// BEING REVIEWED FOR CHANGES - DON'T USE

// These are adapter functions for the rectangles library.
// You must link to the rectangles library during compilation
// if you use these functions "-lrect".

// Collision is detected for non-zero return values
// and carry flag set.

// Notice that each struct_sp1_ss begins with a struct_sp1_Rect,
// meaning a struct_sp1_ss can be used where struct_sp1_Rect
// appears below.

extern int  __LIB__ sp1_IsPtInRect(uint8_t x, uint8_t y, struct sp1_Rect *r);
extern int  __LIB__ sp1_IsPt8InRect(uint16_t x, uint16_t y, struct sp1_Rect *r);   // point coords divided by 8
extern int  __LIB__ sp1_IsRectInRect(struct sp1_Rect *r1, struct sp1_Rect *r2);
extern int  __LIB__ sp1_IntersectRect(struct sp1_Rect *r1, struct sp1_Rect *r2, struct sp1_Rect *result);

// straight conversions from struct sp1_Rect to struct r_Rect8/16

extern void __LIB__ sp1_MakeRect8(struct sp1_Rect *s, struct r_Rect8 *r);
extern void __LIB__ sp1_MakeRect16(struct sp1_Rect *s, struct r_Rect16 *r);

// conversions from struct sp1_ss to struct r_Rect8/16 with character coordinates changed to pixel coordinates
// horizontal and vertical rotation also added to pixel coordinate origin

extern void __LIB__ sp1_MakeRect8Pix(struct sp1_ss *s, struct r_Rect8 *r);
extern void __LIB__ sp1_MakeRect16Pix(struct sp1_ss *s, struct r_Rect16 *r);

///////////////////////////////////////////////////////////
//                       TILES                           //
///////////////////////////////////////////////////////////

#define SP1_RFLAG_TILE          0x01
#define SP1_RFLAG_COLOUR        0x02
#define SP1_RFLAG_SPRITE        0x04

#define SP1_PSSFLAG_INVALIDATE  0x01
#define SP1_PSSFLAG_XWRAP       0x02
#define SP1_PSSFLAG_YINC        0x04
#define SP1_PSSFLAG_YWRAP       0x08

extern void  __LIB__  *sp1_TileEntry(uint8_t c, void *def);

extern void  __LIB__   sp1_PrintAt(uint8_t row, uint8_t col, uint8_t colour, uint16_t tile);
extern void  __LIB__   sp1_PrintAtInv(uint8_t row, uint8_t col, uint8_t colour, uint16_t tile);
extern uint16_t  __LIB__   sp1_ScreenStr(uint8_t row, uint8_t col);
extern uint8_t __LIB__   sp1_ScreenAttr(uint8_t row, uint8_t col);

extern void  __LIB__   sp1_PrintString(struct sp1_pss *ps, uint8_t *s);
extern void  __LIB__   sp1_SetPrintPos(struct sp1_pss *ps, uint8_t row, uint8_t col);

extern void  __LIB__   sp1_GetTiles(struct sp1_Rect *r, struct sp1_tp *dest);
extern void  __LIB__   sp1_PutTiles(struct sp1_Rect *r, struct sp1_tp *src);
extern void  __LIB__   sp1_PutTilesInv(struct sp1_Rect *r, struct sp1_tp *src);

extern void  __LIB__   sp1_ClearRect(struct sp1_Rect *r, uint8_t colour, uint8_t tile, uint8_t rflag);
extern void  __LIB__   sp1_ClearRectInv(struct sp1_Rect *r, uint8_t colour, uint8_t tile, uint8_t rflag);

/* CALLEE LINKAGE */

extern void   __LIB__  *sp1_TileEntry_callee(uint8_t c, void *def) __z88dk_callee;
extern void   __LIB__   sp1_PrintAt_callee(uint8_t row, uint8_t col, uint8_t colour, uint16_t tile) __z88dk_callee;
extern void   __LIB__   sp1_PrintAtInv_callee(uint8_t row, uint8_t col, uint8_t colour, uint16_t tile) __z88dk_callee;
extern uint16_t __LIB__   sp1_ScreenStr_callee(uint8_t row, uint8_t col) __z88dk_callee;
extern uint8_t __LIB__   sp1_ScreenAttr_callee(uint8_t row, uint8_t col) __z88dk_callee;
extern void   __LIB__   sp1_PrintString_callee(struct sp1_pss *ps, uint8_t *s) __z88dk_callee;
extern void   __LIB__   sp1_SetPrintPos_callee(struct sp1_pss *ps, uint8_t row, uint8_t col) __z88dk_callee;
extern void   __LIB__   sp1_GetTiles_callee(struct sp1_Rect *r, struct sp1_tp *dest) __z88dk_callee;
extern void   __LIB__   sp1_PutTiles_callee(struct sp1_Rect *r, struct sp1_tp *src) __z88dk_callee;
extern void   __LIB__   sp1_PutTilesInv_callee(struct sp1_Rect *r, struct sp1_tp *src) __z88dk_callee;
extern void   __LIB__   sp1_ClearRect_callee(struct sp1_Rect *r, uint8_t colour, uint8_t tile, uint8_t rflag) __z88dk_callee;
extern void   __LIB__   sp1_ClearRectInv_callee(struct sp1_Rect *r, uint8_t colour, uint8_t tile, uint8_t rflag) __z88dk_callee;

#define sp1_TileEntry(a,b)         sp1_TileEntry_callee(a,b)
#define sp1_PrintAt(a,b,c,d)       sp1_PrintAt_callee(a,b,c,d)
#define sp1_PrintAtInv(a,b,c,d)    sp1_PrintAtInv_callee(a,b,c,d)
#define sp1_ScreenStr(a,b)         sp1_ScreenStr_callee(a,b)
#define sp1_ScreenAttr(a,b)        sp1_ScreenAttr_callee(a,b)
#define sp1_PrintString(a,b)       sp1_PrintString_callee(a,b)
#define sp1_SetPrintPos(a,b,c)     sp1_SetPrintPos_callee(a,b,c)
#define sp1_GetTiles(a,b)          sp1_GetTiles_callee(a,b)
#define sp1_PutTiles(a,b)          sp1_PutTiles_callee(a,b)
#define sp1_PutTilesInv(a,b)       sp1_PutTilesInv_callee(a,b)
#define sp1_ClearRect(a,b,c,d)     sp1_ClearRect_callee(a,b,c,d)
#define sp1_ClearRectInv(a,b,c,d)  sp1_ClearRectInv_callee(a,b,c,d)


///////////////////////////////////////////////////////////
//                      UPDATER                          //
///////////////////////////////////////////////////////////

#define SP1_IFLAG_MAKE_ROTTBL      0x01
#define SP1_IFLAG_OVERWRITE_TILES  0x02
#define SP1_IFLAG_OVERWRITE_DFILE  0x04

// void *hook  <->  void [ __FASTCALL__ ] (*hook)(struct sp1_update *u)

extern void               __LIB__   sp1_Initialize(uint8_t iflag, uint8_t colour, uint8_t tile);
extern void               __LIB__   sp1_UpdateNow(void);

extern struct sp1_update  __LIB__  *sp1_GetUpdateStruct(uint8_t row, uint8_t col);
extern void               __LIB__   sp1_IterateUpdateArr(struct sp1_update **ua, void *hook);  // zero terminated array
extern void               __LIB__   sp1_IterateUpdateRect(struct sp1_Rect *r, void *hook);

extern void               __LIB__   sp1_InvUpdateStruct(struct sp1_update *u) __z88dk_fastcall;
extern void               __LIB__   sp1_ValUpdateStruct(struct sp1_update *u) __z88dk_fastcall;

extern void               __LIB__   sp1_DrawUpdateStructIfInv(struct sp1_update *u) __z88dk_fastcall;
extern void               __LIB__   sp1_DrawUpdateStructIfVal(struct sp1_update *u) __z88dk_fastcall;
extern void               __LIB__   sp1_DrawUpdateStructIfNotRem(struct sp1_update *u) __z88dk_fastcall;
extern void               __LIB__   sp1_DrawUpdateStructAlways(struct sp1_update *u) __z88dk_fastcall;

extern void               __LIB__   sp1_RemoveUpdateStruct(struct sp1_update *u) __z88dk_fastcall;
extern void               __LIB__   sp1_RestoreUpdateStruct(struct sp1_update *u) __z88dk_fastcall;

extern void              __LIB__   sp1_Invalidate(struct sp1_Rect *r) __z88dk_fastcall;
extern void              __LIB__   sp1_Validate(struct sp1_Rect *r) __z88dk_fastcall;

/* CALLEE LINKAGE */

extern void              __LIB__   sp1_Initialize_callee(uint8_t iflag, uint8_t colour, uint8_t tile) __z88dk_callee;
extern struct sp1_update __LIB__  *sp1_GetUpdateStruct_callee(uint8_t row, uint8_t col) __z88dk_callee;
extern void              __LIB__   sp1_IterateUpdateArr_callee(struct sp1_update **ua, void *hook) __z88dk_callee;
extern void              __LIB__   sp1_IterateUpdateRect_callee(struct sp1_Rect *r, void *hook) __z88dk_callee;


#define sp1_Initialize(a,b,c)       sp1_Initialize_callee(a,b,c)
#define sp1_GetUpdateStruct(a,b)    sp1_GetUpdateStruct_callee(a,b)
#define sp1_IterateUpdateArr(a,b)   sp1_IterateUpdateArr_callee(a,b)
#define sp1_IterateUpdateRect(a,b)  sp1_IterateUpdateRect_callee(a,b)


#endif
