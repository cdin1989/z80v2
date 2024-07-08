#include <regx52.h>
#include <intrins.h>

// Joypad Port 1
//  bit 0 : Joypad 1 Up
//  bit 1 : Joypad 1 Down
//  bit 2 : Joypad 1 Left
//  bit 3 : Joypad 1 Right
//  bit 4 : Joypad 1 Button 1
//  bit 5 : Joypad 1 Button 2
//  bit 6 : Joypad 2 Up
//  bit 7 : Joypad 2 Down
//  Low logic port. 0 = pressed, 1 = released

// Joypad Port 2
//  bit 0 : Joypad 2 Left
//  bit 1 : Joypad 2 Right
//  bit 2 : Joypad 2 Button 1
//  bit 3 : Joypad 2 Button 2
//  bit 4 : Reset Button
//  Low logic port. 0 = pressed, 1 = released

// Joypad1 pins.
sbit JOYPAD1_DATA  = P2^3;
sbit JOYPAD1_LATCH = P2^4;
sbit JOYPAD1_CLK   = P2^5;

// Joypad2 pins.
sbit JOYPAD2_DATA  = P2^0;
sbit JOYPAD2_LATCH = P2^1;
sbit JOYPAD2_CLK   = P2^2;

// NES button mask.
enum NES_Button{
	NES_Mask_A = 0x01,
	NES_Mask_B = 0x02,
	NES_Mask_Select = 0x04,
	NES_Mask_Start = 0x08,
	NES_Mask_Up = 0x10,
	NES_Mask_Down = 0x20,
	NES_Mask_Left = 0x40,
	NES_Mask_Right = 0x80
};

enum SMS_Button {
	JOY1_SMS_Button_Up = 0x01,
	JOY1_SMS_Button_Down = 0x02,
	JOY1_SMS_Button_Left = 0x04,
	JOY1_SMS_Button_Right = 0x08,
	JOY1_SMS_Button_B1 = 0x10,
	JOY1_SMS_Button_B2 = 0x20,
	
	JOY2_SMS_Button_Up = 0x40,
	JOY2_SMS_Button_Down = 0x80,
	JOY2_SMS_Button_Left = 0x01,
	JOY2_SMS_Button_Right = 0x02,
	JOY2_SMS_Button_B1 = 0x04,
	JOY2_SMS_Button_B2 = 0x08,
	JOY2_SMS_Button_Reset = 0x10
};

void main()
{
	IT0 = 1;  // INT0, triggered on falling edge.
	IT1 = 1;  // INT1, triggered on falling edge.
	EX0 = 1;  // Enable INT0.
	EX1 = 1;  // Enable INT1.
	EA = 1;   // Enable interrupts.
	
	while(1); // Loop
}

//@12.000MHz
void Delay10us(void)	
{
	unsigned char data i;
	_nop_();
	_nop_();
	i = 27;
	while (--i);
}

// Poll joypad1 button.
unsigned char poll_joypad1_button()
{
	unsigned char i;
	unsigned char button = 0;
	
	// Pulse the LATCH pin, data transmission begins.
  //	 __
	//__| |__
	JOYPAD1_LATCH = 0;
	delay10us();
	JOYPAD1_LATCH = 1;
	delay10us();
	JOYPAD1_LATCH = 0;
	delay10us();
	
	// The order of shifting for the buttons.
	// 0|A 1|B 2|Select 3|Start 4|Up 5|Down 6|Left 7|Right
	if(JOYPAD1_DATA)
		button |= 0x80;
	
	// Clock next bits.
	//   __
	//__| |__
	for(i = 0; i < 7; i++) {
		JOYPAD1_CLK = 0;
		delay10us();
		JOYPAD1_CLK = 1;
		delay10us();
		JOYPAD1_CLK = 0;
		delay10us();
		
		button >>= 1;
		if(JOYPAD1_DATA)
			button |= 0x80;
			
	}  
	return button;
}

// Poll joypad2 button.
unsigned char poll_joypad2_button()
{
	unsigned char i;
	unsigned char button = 0;
	
	// Pulse the LATCH pin, data transmission begins.
  //	 __
	//__| |__
	JOYPAD2_LATCH = 0;
	delay10us();
	JOYPAD2_LATCH = 1;
	delay10us();
	JOYPAD2_LATCH = 0;
	delay10us();
	
	// The order of shifting for the buttons.
	// 0|A 1|B 2|Select 3|Start 4|Up 5|Down 6|Left 7|Right
	if(JOYPAD2_DATA)
		button |= 0x80;
	
	// Clock next bits.
	//   __
	//__| |__
	for(i = 0; i < 7; i++) {
		JOYPAD2_CLK = 0;
		delay10us();
		JOYPAD2_CLK = 1;
		delay10us();
		JOYPAD2_CLK = 0;
		delay10us();
		
		button >>= 1;
		if(JOYPAD2_DATA)
			button |= 0x80;
			
	}  
	return button;
}

// INT0 ISR.
void on_read_joypad1() interrupt 0
{
	// NES button data:
	// MSB                             LSB
	// Right|Left|Down|Up|Start|Select|B|A
	unsigned char joy1 = poll_joypad1_button();
	unsigned char joy2 = poll_joypad2_button();
	
	// SMS joypad1 button data:
	// MSB                                LSB
	// Joypad2-Down|Joypad2-Up|Button2|Button1|Right|Left|Down|Up
	unsigned char sg = 0x00;
	
	// Joypad2-Down
	if((joy2 & NES_Mask_Down) != 0)
		sg |= JOY2_SMS_Button_Down;
	
	// Joypad2-Up
	if((joy2 & NES_Mask_Up) != 0)
		sg |= JOY2_SMS_Button_Up;
	
	// Button2
	if((joy1 & NES_Mask_B) != 0)
		sg |= JOY1_SMS_Button_B2;
	
	// Button1
	if((joy1 & NES_Mask_A) != 0)
		sg |= JOY1_SMS_Button_B1;
	
	// Right
	if((joy1 & NES_Mask_Right) != 0)
		sg |= JOY1_SMS_Button_Right;
	
	// Left
	if((joy1 & NES_Mask_Left) != 0)
		sg |= JOY1_SMS_Button_Left;
	
	// Down
	if((joy1 & NES_Mask_Down) != 0)
		sg |= JOY1_SMS_Button_Down;
	
	// Up
	if((joy1 & NES_Mask_Up) != 0)
		sg |= JOY1_SMS_Button_Up;
	
	// Write to data bus.
	P1 = sg;
}

// INT1 ISR.
void on_read_joypad2() interrupt 2
{
	// NES button data:
	// MSB                             LSB
	// Right|Left|Down|Up|Start|Select|B|A
	unsigned char joy2 = poll_joypad2_button();
	
	// SMS joypad2 button data:
	// MSB                                LSB
	// X|X|X|Reset|Button2|Button1|Right|Left
	unsigned char sg = 0xE0;
	
	// Reset
	if((joy2 & NES_Mask_Start) != 0)
		sg |= JOY2_SMS_Button_Reset;
	
	// Button2
	if((joy2 & NES_Mask_B) != 0)
		sg |= JOY2_SMS_Button_B2;
	
	// Button1
	if((joy2 & NES_Mask_A) != 0)
		sg |= JOY2_SMS_Button_B1;
	
		// Right
	if((joy2 & NES_Mask_Right) != 0)
		sg |= JOY2_SMS_Button_Right;
	
	// Left
	if((joy2 & NES_Mask_Left) != 0)
		sg |= JOY2_SMS_Button_Left;
	
	// Write to data bus.
	P1 = sg;
}