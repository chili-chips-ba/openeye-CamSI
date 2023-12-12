/*
 *  PicoSoC - A simple example SoC using PicoRV32
 *
 *  Coyright (C) 2017  Clifford Wolf <clifford@clifford.at>
 *
 *  Permission to use, coy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  coyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

// INCLUDES AND DEFINES--------------------------------------------------

#include <stdint.h>
#include <stdbool.h>
#include "uart.h"

#define RAM_TOTAL 0x2000 // 8 KB

#define reg_uart_clkdiv (*(volatile uint32_t*)0x02000004)
#define reg_uart_data (*(volatile uint32_t*)0x02000008)

#define reg_gpio (*(volatile uint32_t*) 0x03000000)
#define reg_video_char	((volatile uint32_t*)0x05100000)
#define reg_video_map	((volatile uint32_t*)0x05200000)

#define BUTTON_UP 0x01
#define BUTTON_RIGHT 0x02
#define BUTTON_LEFT 0x04
#define BUTTON_DOWN 0x08
#define BUTTON_CENTER 0x10

#define DELAY   10000

#define 	fieldWidth		40
#define		fieldHeight	30

// GLOBAL VARIABLES--------------------------------------------------------

uint8_t buttons;
static uint32_t delay = DELAY;
static uint8_t field[1200];

static uint8_t tetrominoes[7][16]={{1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0},
								   {0,0,1,0,0,1,1,0,0,0,1,0,0,0,0,0},
								   {0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0},
								   {0,0,1,0,0,1,1,0,0,1,0,0,0,0,0,0},
								   {0,1,0,0,0,1,1,0,0,0,1,0,0,0,0,0},
								   {0,1,0,0,0,1,0,0,0,1,1,0,0,0,0,0},
								   {0,0,1,0,0,0,1,0,0,1,1,0,0,0,0,0}};

// PRIVATE FUNCTIONS DECLARATIONS--------------------------------------------

static void CharactersInit(void);
static void DisplayProjectName(void);
static void DisplayCompanyName(void);
static void DisplayGameName(void);
static void DisplayHeart(int x_start, int y_start, int color);
static void setScreenColor(int color);
static void DisplayGameOverScreen(int numLives );
static void DisplayTheEndScreen(void);
static void GetButtonStates(void);
static int Rotate(int x, int y, int r);
static bool DoesPieceFit(int ntetrominoes, int nRotation, int nPosX, int nPosY);						  
static void DisplayDigit(uint8_t number, uint8_t startX, uint8_t startY);
static void WriteScore(int score); 

// PRIVATE FUNCTIONS IMPLEMENTATION-------------------------------------------

/* 
 * brief   reads the gpio register and changes the state of buttons variable
 * return  void
 */
void GetButtonStates() {  
	buttons = (uint8_t)(reg_gpio >> 16)&0xFF;
}

/* 
 * brief   displays openXC7 Demo on the screen
 * return  void
 */
void DisplayProjectName() 
{
	uint8_t nameY = 3;
	for (uint8_t y = 0; y < 30; y++)
	{ 
		for (uint8_t x = 0; x < 40; x++) // Board Boundary
		{
			reg_video_map[y * 40 + x] = 9; // Background color
			
			//o
			if (((y == nameY || y == nameY + 4) && (x >= 6 && x <= 8)) || ((x == 6 || x == 8) && (y >= nameY && y <= nameY + 4)))			
				reg_video_map[y * 40 + x] = 1;

			//p
			if (((y == nameY || y == nameY + 2) && (x >= 10 && x <= 12)) || (x == 10 && (y >= nameY && y <= nameY + 4)) || (x == 12 && (y >= nameY && y <= nameY + 2)))
				reg_video_map[y * 40 + x] = 1;
			
			//e
			if (((y == nameY || y == nameY + 2 || y == nameY + 4) && (x >= 14 && x <= 16)) || (x == 14 && (y >= nameY && y <= nameY + 4)))
				reg_video_map[y * 40 + x] = 1;
			
			//n
			if (((y == nameY) && (x >= 18 && x <= 20)) || ((x == 18 || x == 20) && (y >= nameY && y <= nameY + 4)))			
				reg_video_map[y * 40 + x] = 1;
			
			//x
			if ((((x == 22 || x == 24) && (y >= nameY && y <= nameY + 4)) && (y != nameY + 2)) || (x == 23 && y == nameY + 2))
				reg_video_map[y * 40 + x] = 2;
			
			//c
			if (((y == nameY || y == nameY + 4) && (x >= 26 && x <= 28)) || (x == 26 && (y >= nameY && y <= nameY + 4)))			
				reg_video_map[y * 40 + x] = 2;
			
			//7
			if ((y == nameY && (x >= 30 && x <= 32)) || (x == 31 && (y >= nameY + 2 && y <= nameY + 4)) || (x == 32 && y == nameY + 1))
				reg_video_map[y * 40 + x] = 2;
		}
	}
}
/* 
 * brief   displays CHILI CHIPS on the screen
 * return  void
 */
void DisplayCompanyName() 
{	
	uint8_t lineY = 11;
	uint8_t lineXStart = 3, lineXEnd = 36;
	uint8_t nameY = 14;
	for (uint8_t y = 0; y < 30; y++)
	{ 
		for (uint8_t x = 0; x < 40; x++) // Board Boundary
		{
			// blue line
			if (y == lineY && (x >= lineXStart && x <= lineXEnd))
				reg_video_map[y * 40 + x] = 10;
			
			//C
			if (x == 4 && (y >= nameY && y <= nameY + 4))
				reg_video_map[y * 40 + x] = 7;
			if (y == nameY && (x == 5 || x == 6))
				reg_video_map[y * 40 + x] = 7;
			if (y == nameY + 4 && (x == 5 || x == 6))
				reg_video_map[y * 40 + x] = 7;
			//h
			if (x == 8 && (y >= nameY && y <= nameY + 4) )
				reg_video_map[y*40+x]=7;
			if (y == nameY + 2 && (x == 9 || x == 10))
				reg_video_map[y * 40 + x] = 7;
			if (x == 10 && (y >= nameY + 2 && y <= nameY + 4))
				reg_video_map[y * 40 + x] = 7;
			// i 
			if (x == 12 && (y >= nameY + 2 && y <= nameY + 4))
				reg_video_map[y * 40 + x] = 7;
			if (x == 12 && y == nameY)
				reg_video_map[y * 40 + x] = 7;
			// l 
			if (x == 14 && (y >= nameY && y <= nameY + 4))
				reg_video_map[y * 40 + x]=7;
			// i 
			if (x == 16 && (y >= nameY + 2 && y <= nameY + 4))
				reg_video_map[y * 40 + x] = 7;
			if (x == 16 && y == nameY)
				reg_video_map[y * 40 + x] = 7;
			// C 
			if (x == 19 && (y >= nameY && y <= nameY + 4) )
				reg_video_map[y * 40 + x] = 10;
			if (y == nameY && (x == 20 || x == 21))
				reg_video_map[y * 40 + x] = 10;
			if (y == nameY + 4 && (x == 20 || x == 21))
				reg_video_map[y * 40 + x] = 10;
			//H
			if (x == 23 && (y >= nameY && y <= nameY + 4))
				reg_video_map[y * 40 + x] = 10;
			if (y == nameY + 2 && (x == 24 || x == 25))
				reg_video_map[y * 40 + x] = 10;
			if (x == 25 && (y >= nameY && y <= nameY + 4))
				reg_video_map[y * 40 + x] = 10;
			// I
			if (x == 27 && (y >= nameY && y <= nameY + 4))
				reg_video_map[y * 40 + x] = 10;
			// P
			if (x == 29 && (y >= nameY && y <= nameY + 4))
				reg_video_map[y * 40 + x] = 10;
			if (y == nameY && (x == 30 || x == 31))
				reg_video_map[y * 40 + x] = 10;
			if (y == nameY + 2 && (x == 30 || x == 31))
				reg_video_map[y * 40 + x] = 10;
			if (x == 31 && (y >= nameY && y <= nameY + 2))
				reg_video_map[y * 40 + x] = 10;
			
			// S 
			if (y == nameY && (x >= 33 && x <= 35 ))
				reg_video_map[y * 40 + x] = 10;
			if (y == nameY + 2 && (x >= 33 && x <= 35))
				reg_video_map[y * 40 + x] = 10;
			if (y == nameY + 4 && (x >= 33 && x <= 35))
				reg_video_map[y * 40 + x] = 10;
			if (x == 33 && y == nameY + 1)
				reg_video_map[y * 40 + x] = 10;
			if (x == 35 && y == nameY + 3)
				reg_video_map[y * 40 + x] = 10;
		}
	}
}

/* 
 * brief   displays TETRISARAJ on the screen
 * return  void
 */
void DisplayGameName() 
{
	uint8_t nameY = 22;
	for (uint8_t y = 0; y < 30; y++)
	{ 
		for (uint8_t x = 0; x < 40; x++) // Board Boundary
		{
			//T
			if(y == nameY && (x>=3 && x<=5))
				reg_video_map[y * 40 + x] = 2;
			if(x == 4 && (y >= nameY && y <= nameY + 4))
				reg_video_map[y * 40 + x] = 2;
			 //E
			if(x == 7 && (y >= nameY && y <= nameY + 4))
				reg_video_map[y * 40 + x] = 2;
			if(x == 8 && (y == nameY || y == nameY + 2 || y == nameY + 4))
				reg_video_map[y * 40 + x] = 2;
			 //T
			if(y == nameY && (x >= 10 && x <= 12))
				reg_video_map[y * 40 + x] = 2;
			if(x == 11 && (y >= nameY && y <= nameY + 4))
				reg_video_map[y * 40 + x] = 2;
			 // R
			if(x == 14 && (y >= nameY && y <= nameY + 4))
				reg_video_map[y * 40 + x] = 2;
			if(x == 15 && y== nameY)
				reg_video_map[y * 40 + x] = 2;
			if(x == 16 && y == nameY + 1)
				reg_video_map[y * 40 + x] = 2;
			if(x == 15 && y == nameY + 2)
				reg_video_map[y * 40 + x] = 2;
			if(x == 16 && (y == nameY + 3 || y == nameY + 4))
				reg_video_map[y * 40 + x] = 2;
			// I
			if(x == 18 && (y >= nameY && y <= nameY + 4))
				reg_video_map[y * 40 + x] = 2;
			
			// S
			if(y == nameY && (x == 20 || x == 21))
				reg_video_map[y * 40 + x] = 7;
			if(x == 20 && (y == nameY + 1 || y == nameY + 2 || y == nameY + 4))
				reg_video_map[y * 40 + x] = 7;
			if(x == 21 && (y >= nameY + 2 && y <= nameY + 4))
				reg_video_map[y * 40 + x] = 7;
			// A
			if((x == 23 || x == 25) && (y >= nameY + 1 && y <= nameY + 4))
				reg_video_map[y * 40 + x] = 7;
			if(x == 24 && y == nameY + 2)
				reg_video_map[y * 40 + x] = 7;
			if(x == 24 && y == nameY)
				reg_video_map[y * 40 + x] = 7;
			// R
			if(x == 27 && (y >= nameY && y <= nameY + 4))
				reg_video_map[y * 40 + x] = 7;
			if(x == 28 && y == nameY)
				reg_video_map[y * 40 + x] = 7;
			if(x == 29 && y == nameY + 1)
				reg_video_map[y * 40 + x] = 7;
			if(x == 28 && y == nameY + 2)
				reg_video_map[y * 40 + x] = 7;
			if(x == 29 && (y == nameY + 3 || y == nameY + 4))
				reg_video_map[y * 40 + x] = 7;
			// A
			if((x == 31 || x == 33) && (y >= nameY + 1 && y <= nameY + 4))
				reg_video_map[y * 40 + x] = 7;
			if(x == 32 && y == nameY + 2)
				reg_video_map[y * 40 + x] = 7;
			if(x == 32 && y == nameY)
				reg_video_map[y * 40 + x] = 7;
			// J
			if(x == 37 && (y >= nameY && y <= nameY + 4))
				reg_video_map[y * 40 + x] = 7;
			if((x == 35 || x == 36) && y == nameY + 4)
				reg_video_map[y * 40 + x] = 7;
			if(x == 35 && y == nameY + 3)
				reg_video_map[y * 40 + x] = 7; 
		}
	}
}
/* 
 * brief   displays heart on screen 
 * return  void
 */
void DisplayHeart(int x_start, int y_start, int color){
	for (int y = 0; y < 30; y++)
	{ 
		for (int x = 0; x < 40; x++) // Board Boundary
		{
			if((x==2+x_start || x==3+x_start || x==7+x_start || x==8+x_start) && y==y_start)
				reg_video_map[y * 40 + x] = 0;
			if((x==1+x_start || x==4+x_start || x==6+x_start || x==9+x_start) && y==y_start+1)
				reg_video_map[y * 40 + x] = 0;
			if((x==x_start || x==5+x_start || x==10+x_start) && y==y_start+2)
				reg_video_map[y * 40 + x] = 0;
			if((x==x_start || x==10+x_start) && y==y_start+3)
				reg_video_map[y * 40 + x] = 0;
			if((x==1+x_start || x==9+x_start) && y==y_start+4)
				reg_video_map[y * 40 + x] = 0;	
			if((x==2+x_start || x==8+x_start) && y==y_start+5)
				reg_video_map[y * 40 + x] = 0;
			if((x==3+x_start || x==7+x_start) && y==y_start+6)
				reg_video_map[y * 40 + x] = 0;
			if((x==4+x_start || x==6+x_start) && y==y_start+7)
				reg_video_map[y * 40 + x] = 0;
			if((x==5+x_start) && y==y_start+8)
				reg_video_map[y * 40 + x] = 0;
			
			if((x==2+x_start || x==3+x_start || x==7+x_start || x==8+x_start) && y==y_start+1)
				reg_video_map[y * 40 + x] = color;
			if(((x>=1+x_start && x<=4+x_start) || (x>=6+x_start && x<=9+x_start)) && y==y_start+2)
				reg_video_map[y * 40 + x] = color;
			if((x>=1+x_start && x<=9+x_start) && y==y_start+3)
				reg_video_map[y * 40 + x] = color;
			if((x>=2+x_start && x<=8+x_start) && y==y_start+4)
				reg_video_map[y * 40 + x] = color;
			if((x>=3+x_start && x<=7+x_start) && y==y_start+5)
				reg_video_map[y * 40 + x] = color;
			if((x>=4+x_start && x<=6+x_start) && y==y_start+6)
				reg_video_map[y * 40 + x] = color;
			if(x==5+x_start && y==y_start+7)
				reg_video_map[y * 40 + x] = color;
			
		}
	}

}
/* 
 * brief   set screen color
 * return  void
 */
 void setScreenColor(int color){
	for (uint8_t y = 0; y < 30; y++)
	{ 
		for (uint8_t x = 0; x < 40; x++) // Board Boundary
		{
			reg_video_map[y * 40 + x] = color;
		}
	}
 }
/* 
 * brief   displays game over screen 
 * return  void
 */
void DisplayGameOverScreen(int numLives )
{
	uint8_t nameY = 1;
	for (uint8_t y = 0; y < 30; y++)
	{ 
		for (uint8_t x = 0; x < 40; x++) // Board Boundary
		{
			reg_video_map[y * 40 + x] = 9;
			
			//G
			if((x == 5 && (y >= nameY+2 && y <= nameY+5)) || (x == 6 && (y == nameY+1 || y == nameY+6)) || ((x >= 7 && x<= 11) && (y == nameY || y==nameY+7)) || (x==11 && (y>=nameY+4 && y<=nameY+7)) || (x >= 8 && x<= 11) && (y == nameY+4) )
			reg_video_map[y * 40 + x] = 3;

			//A	
			if((x==16 && y==nameY) || ((x==15 || x==17) && y==nameY+1) || ((x==14 || x==18) && (y>=nameY+2 && y<=nameY+3)) || ((x>=13 && x<=19) && y==nameY+4) || ((x==13 || x==19) && (y>=nameY+5 && y<=nameY+7)))
			reg_video_map[y * 40 + x] = 1;

			//M
			if(((x==21 || x==28) && (y>=nameY && y<=nameY+7)) || ((x==22 || x==27) && y==nameY) || ((x==23 || x==26) && (y>=nameY+1 && y<=nameY+2)) || ((x==24 || x==25) && y==nameY+3))
			reg_video_map[y * 40 + x] = 2;

			//E
			if(((x>=30 && x<=34) && (y==nameY || y==nameY+7)) || (x==30 && (y>=nameY+1 && y<=nameY+6)) || ((x>=31 && x<=33) && y==nameY+4))
			reg_video_map[y * 40 + x] = 4;


			//O
			if(((x==7 || x==12) && (y>=nameY+11 && y<=nameY+16)) || ((y==nameY+10 || y==nameY+17) && (x>=8 && x<=11)))
			reg_video_map[y * 40 + x] = 3;

			//V
			if(((x==14 || x==20) && (y>=nameY+10 && y<=nameY+12)) || ((x==15 || x==19) && (y>=nameY+13 && y<=nameY+14)) || ((x==16 || x==18) && (y==nameY+15)) || ((x==17) && (y>=nameY+16 && y<=nameY+17)))
			reg_video_map[y * 40 + x] = 1;

			//E
			if(((x>=22 && x<=26) && (y==nameY+10 || y==nameY+17)) || (x==22 && (y>=nameY+11 && y<=nameY+16)) || ((x>=23 && x<=25) && y==nameY+14))
			reg_video_map[y * 40 + x] = 2;

			//R
			if((x==28 && (y>=nameY+10 && y<=nameY+17)) || ((x>=29 && x<=31) && (y==nameY+14 || y==nameY+10)) || ((x==32) && (y>=nameY+11 && y<=nameY+13)) || (x==30 && y==nameY+15) || (x==31 && y==nameY+16) || (x==32 && y==nameY+17))			
			reg_video_map[y * 40 + x] = 4;
		
		
		
		}
	}
		// Lives
			if(numLives==3){
				DisplayHeart(5,21,3);
				DisplayHeart(15,21,3);
				DisplayHeart(25,21,3);
			}
			
			if(numLives==2){
				DisplayHeart(5,21,3);
				DisplayHeart(15,21,3);
				DisplayHeart(25,21,9);
			}
			
			if(numLives==1){
				DisplayHeart(5,21,3);
				DisplayHeart(15,21,9);
				DisplayHeart(25,21,9);
			}
			
	
}
/* 
 * brief   displays THE END screen 
 * return  void
 */
void DisplayTheEndScreen(void)
{
	uint8_t nameY = 8;
	for (uint8_t y = 0; y < 23; y++)
	{ 
		for (uint8_t x = 0; x < 40; x++) // Board Boundary
		{
			reg_video_map[y * 40 + x] = 0;
			
			// T
			if ((y == nameY && (x >= 5 && x <= 7)) || (x == 6 && (y >= nameY && y <= nameY + 4)))
				reg_video_map[y * 40 + x] = 3;
			
			// H
			if ((y == nameY + 2 && (x >= 9 && x <= 11)) || ((x == 9 || x == 11) && (y >= nameY && y <= nameY + 4)))			
				reg_video_map[y * 40 + x] = 3;
			
			// E
			if (((y == nameY || y == nameY + 4) && (x >= 13 && x <= 15)) || (x == 13 && (y >= nameY && y <= nameY + 4)) || (y == nameY + 2 && (x >= 13 && x <= 14)))			
				reg_video_map[y * 40 + x] = 3;
			
			// E
			if (((y == nameY || y == nameY + 4) && (x >= 20 && x <= 22)) || (x == 20 && (y >= nameY && y <= nameY + 4)) || (y == nameY + 2 && (x >= 20 && x <= 21)))			
				reg_video_map[y * 40 + x] = 3;
			
			// N
			if ((y == nameY + 2 && x == 25) || (y == nameY + 3 && x == 26) || ((x == 24 || x == 27) && (y >= nameY && y <= nameY + 4)))			
				reg_video_map[y * 40 + x] = 3;
			
			// D
			if ((x == 31 && (y >= nameY + 1 && y <= nameY + 3)) || ((y == nameY || y == nameY + 4) && (x >= 29 && x <= 30)) || (x == 29 && (y >= nameY && y <= nameY + 4)))
				reg_video_map[y * 40 + x] = 3;
			
			// !
			if ((x == 33 && (y >= nameY && y <= nameY + 2)) || (x == 33 && y == nameY + 4))
				reg_video_map[y * 40 + x] = 3;
		}
	}
}

/* 
 * brief   defines all characters that can be used
 * return  void
 */
void CharactersInit() {
	uint32_t pixel = 0x00000FFF;
	for(uint8_t z = 0; z < 16; z++) 
	{
		for(uint8_t y = 0; y < 16; y++) 
		{
			for(uint8_t x = 0; x < 16; x++) 
			{
				if(z == 0) // color black
				{ 
					if(y == 0 || y == 1) pixel = 0x00000222;
					else if (x == 14 || x == 15) pixel = 0x00000111; 
					else pixel = 0x00000000; 
				} 
				else if(z == 1) // color green
				{  
					if(y == 0 || y == 1) pixel = 0x00000080; 
					else if (x == 14 || x == 15) pixel = 0x00000080;
					else pixel = 0x000008B4; 
				} 
				else if(z == 2) // color blue
				{
					if(y == 0 || y == 1) pixel = 0x0000000B;
					else if (x == 14 || x == 15) pixel = 0x0000000B;
					else pixel = 0x00000009; 
				} 
				else if(z == 3) // color red
				{ 
					if(y == 0 || y == 1) pixel = 0x00000A00;
					else if (x == 14 || x == 15) pixel = 0x00000B00; 
					else pixel = 0x00000F00; 
				} 
				else if(z == 4) // color yellow
				{ 
					if(y == 0 || y == 1) pixel = 0x00000FD8; 
					else if (x == 14 || x == 15) pixel = 0x00000FD4; 
					else pixel = 0x00000FF0; 
				} 
				else if(z == 5) // color purple
				{ 
					if(y == 0 || y == 1) pixel = 0x00000075D;
					else if (x == 14 || x == 15) pixel = 0x00000074D; 
					else pixel = 0x00000070D; 
				} 
				else if(z == 6) // color pink
				{ 
					if(y == 0 || y == 1) pixel = 0x00000FAF;
					else if (x == 14 || x == 15) pixel = 0x00000F6F; 
					else pixel = 0x00000F0F;
				} 
				else if(z == 7) // color orange
				{ 
					if(y == 0 || y == 1) pixel = 0x00000FB0; 
					else if (x == 14 || x == 15) pixel = 0x00000F90;
					else pixel = 0x00000FA0; 
				} 
				else if(z == 8)  // not used
				{
					pixel = 0x000000A0;		
				} 
				else if(z == 9) // color gray
				{ 
					if (x == 14 || x == 15) pixel = 0x00000CCC; 
					else if(y == 0 || y == 1) pixel = 0x00000111; 
					else pixel = 0x00000AAA; 	
				} 
				else if(z == 10) // color light blue
				{
					if(y == 0 || y == 1) pixel = 0x0000000B;
					else if (x == 14 || x == 15) pixel = 0x0000000B;
					else pixel = 0x00000007; 
				} 
				else if(z == 11) // not used
				{
					pixel = 0x00000AA0;		
				} 
				else if(z == 12) // not used 
				{
					pixel = 0x000000AA;		
				} 
				else if(z == 13) // not used 
				{
					pixel = 0x00000A0A;
				} 
				else if(z == 14) // not used 
				{
					pixel = 0x00000FFF; 				
				} 
				else 
				{
					pixel = 0x00000000;
				}
				reg_video_char[z * 256 + y * 16 + x] = pixel;
			}
		}	
	}
}

/* 
 * brief   handles the rotation of the piece
 * return  index of the rotated piece
 */
int Rotate(int x, int y, int r)
{
    int pi = 0;
    switch (r % 4)
    {
        case 0: // 0 degrees			// 0  1  2  3
            pi = y * 4 + x;			// 4  5  6  7
            break;						// 8  9 10 11
            //12 13 14 15

        case 1: // 90 degrees			//12  8  4  0
            pi = 12 + y - (x * 4);	//13  9  5  1
            break;						//14 10  6  2
            //15 11  7  3

        case 2: // 180 degrees			//15 14 13 12
            pi = 15 - (y * 4) - x;	//11 10  9  8
            break;						// 7  6  5  4
            // 3  2  1  0

        case 3: // 270 degrees			// 3  7 11 15
            pi = 3 - y + (x * 4);		// 2  6 10 14
            break;						// 1  5  9 13
    }									// 0  4  8 12

    return pi;
}

/* 
 * brief   checks if the piece can be moved to a specified position
 * return  true if the piece can fit and false otherwise
 */
bool DoesPieceFit(int tetrominosIndex, int nRotation, int nPosX, int nPosY)
{
    // All Field cells >0 are occupied
    for (int x = 0; x < 4; x++)
        for (int y = 0; y < 4; y++)
        {
            // Get index into piece
            int pi = Rotate(x, y, nRotation);

            // Get index into field
            int fi = (nPosY + y) * fieldWidth + (nPosX + x);

            // Check that test is in bounds. Note out of bounds does
            // not necessarily mean a fail, as the long vertical piece
            // can have cells that lie outside the boundary, so we'll
            // just ignore them
            if (nPosX + x >= 0 && nPosX + x < fieldWidth)
            {
                if (nPosY + y >= 0 && nPosY + y < fieldHeight)
                {
                    // In Bounds so do collision check
                    if ((tetrominoes[tetrominosIndex][pi] != 0 && field[fi] != 0) /* || (tetrominoes[ntetrominoes][pi] != 0 && (nPosY+y)==0) */) // dodali smo || ....
                        return false; // fail on first hit
                }
            }
        }

    return true;
}

/* 
 * brief   displays a digit on specified location
 * return  void
 */
void DrawDigit(int number, int startX, int startY)
{
	for (uint8_t y = startY; y < startY + 5; y++)
	{ 
		for (uint8_t x = startX; x < startX + 3; x++) 
		{
			switch (number)
			{
				case 0:
					if (x == startX || x == startX + 2 || y == startY || y == startY + 4)
						field[y * fieldWidth + x] = 0;
					else
						field[y * fieldWidth + x] = 9;
					break;
				case 1:
					if (x == startX + 2 || y == startY + 1)
						field[y * fieldWidth + x] = 0;
					else
						field[y * fieldWidth + x] = 9;
					break;
				case 2:
					if (y == startY || y == startY + 2 || y == startY + 4 || (y == startY + 1 && x == startX + 2) || (y == startY + 3 && x == startX))
						field[y * fieldWidth + x] = 0;
					else
						field[y * fieldWidth + x] = 9;
					break;
				case 3:
					if (x == startX + 2 || y == startY || y == startY + 2 ||y == startY + 4)
						field[y * fieldWidth + x] = 0;
					else
						field[y * fieldWidth + x] = 9;
					break;
				case 4:
					if (x == startX + 2 || y == startY + 2 || (y <= startY + 2 && x == startX))
						field[y * fieldWidth + x] = 0;
					else
						field[y * fieldWidth + x] = 9;
					break;
				case 5:
					if (y == startY || y == startY + 2 || y == startY + 4 || (y == startY + 1 && x == startX) || (y == startY + 3 && x == startX + 2))
						field[y * fieldWidth + x] = 0;
					else
						field[y * fieldWidth + x] = 9;
					break;
				case 6:
					if (x == startX || y == startY || y == startY + 2 || y == startY + 4 || (y == startY + 3 && x == startX + 2))
						field[y * fieldWidth + x] = 0;
					else
						field[y * fieldWidth + x] = 9;
					break;
				case 7:
					if (x == startX + 2 || y == startY)
						field[y * fieldWidth + x] = 0;
					else
						field[y * fieldWidth + x] = 9;
					break;
				case 8:
					if (x == startX || x == startX + 2 || y == startY || y == startY + 2 || y == startY + 4)
						field[y * fieldWidth + x] = 0;
					else
						field[y * fieldWidth + x] = 9;
					break;
				case 9:
					if (x == startX + 2 || y == startY || y == startY + 2 || y == startY + 4 || (y == startY + 1 && x == startX))
						field[y * fieldWidth + x] = 0;
					else
						field[y * fieldWidth + x] = 9;
					break;
				default:
					break;
			}
		}
	}
}

/* 
 * brief   displays the current player score
 * return  void
 */
void DisplayScore(int score, int startX, int startY)
{
	int digits[4] = {0,0,0,0};
	int i = 0;
	while (score != 0)
	{
		digits[i++] = score % 10;
		score /= 10;
	}
	
	for (i = 3; i >= 0; i--)
	{
		DrawDigit(digits[i], startX + (3 - i)*4, startY);
	}
}

/* 
 * brief   displays the word score on the screen
 * return  void
 */
void WriteScore(int score) 
{
	for (uint8_t y = 24; y < 29; y++) {
		for (uint8_t x = 3; x < 21; x++) {
			if (x == 3 || x == 4) // letter S
			{
				if (y == 24 || y == 26 || y == 28 || (x == 3 && y == 25) || (x == 4 && y == 27))
					field[y * fieldWidth + x] = 0;
				else 
					field[y * fieldWidth + x] = 9;
			}
			else if (x == 6 || x == 7) // letter C
			{
				if (x == 6 || y == 24 || y == 28)
					field[y * fieldWidth + x] = 0;
				else 
					field[y * fieldWidth + x] = 9;
			}
			else if (x == 9 || x == 10 || x == 11) // letter O
			{
				if (x == 9 || x == 11 || y == 24 || y == 28)
					field[y * fieldWidth + x] = 0;
				else 
					field[y * fieldWidth + x] = 9;
			}
			else if (x == 13 || x == 14 || x == 15) // letter R
			{
				if (x == 13 || (x == 14 && (y == 24 || y == 26)) || (x == 15 && (y == 25 || y > 26)))
					field[y * fieldWidth + x] = 0;
				else 
					field[y * fieldWidth + x] = 9;
			}
			else if (x == 17 || x == 18) // letter E
			{
				if (x == 17 || (x == 18 && y % 2 == 0))
					field[y * fieldWidth + x] = 0;
				else 
					field[y * fieldWidth + x] = 9;
			}
			else if (x == 20) // colon
			{
				if (y == 25 || y == 27)
					field[y * fieldWidth + x] = 0;
				else 
					field[y * fieldWidth + x] = 9;
			}
		}
	}
	
	DisplayScore(score, 22, 24);
}
/* 
 * brief   creating the initial field
 * return  void
 */
void FieldInitialization(){
		
	for (uint8_t y = 0; y < fieldHeight; y++) 
	{
		for (uint8_t x = 0; x < fieldWidth; x++)
		{			
			field[y * fieldWidth + x] = (y == 0 ||
                                           y >= fieldHeight - 7 ||
                                           x + 1 == fieldWidth / 2 ||
                                           x == fieldWidth / 2 ) ? 9u : 0u;
		}
	}
}

/* 
 * brief   delay function, u32_delay = 40000 -> approx. 5 seconds
 * return  void
 */
static inline void _delay(uint32_t u32_delay)
{ 
	uint16_t local = 0;
	for (uint32_t i = 0u; i<u32_delay; i++)
	{
		print("_delay called");
		if (i % 2 == 0) local++;
	}
}
/* 
 * brief   generates a 32-bit random number using XORSHIFT algorithm
 * param   state: Pointer to the state variable for the random number generator
 * return  unsigned int: The generated random number.
 */
unsigned int xorshift32(unsigned int *state) {
    unsigned int x = *state;
    x ^= x << 13;
    x ^= x >> 17;
    x ^= x << 5;
    *state = x;
    return x;
}
/* 
 * brief   generates a random binary number (0 or 1)
 * return  int: The generated random binary number (0 or 1)
 */
int generateRandomBinary() {
    static unsigned int state = 123456789;  
    return xorshift32(&state) % 2;
}
/* 
 * brief   generates a random number within the specified range [min, max]
 * param   min: The minimum value of the range
 * param   max: The maximum value of the range
 * return  int: The generated random number within the range [min, max]
 */
int generateRandomNumber(int min, int max) {
    static unsigned int state = 123456789; 
    unsigned int range = max - min + 1;
    unsigned int randomValue = xorshift32(&state) % range + min;
    return randomValue;
}


void main()
{
    reg_uart_clkdiv = 217; // 100 MHz / 460800 baud
    print("TetriSaraj!\n");

	bool rightButton = false, downButton = false, centerButton = false, upButton = false, leftButton = false;	
	
	reg_gpio = 0x0;	
	
	CharactersInit();
	DisplayProjectName();
	_delay(15000);

	DisplayCompanyName(); 
	_delay(15000);
	
	DisplayGameName();
	_delay(15000);
	
	FieldInitialization();
	
	setScreenColor(9);

	DisplayHeart(5,9,3);
	DisplayHeart(15,9,3);
	DisplayHeart(25,9,3);
	_delay(20000);
	
    // Game Logic
    uint16_t pieceIndex = 0;
    uint8_t pieceRotation = 3;
    uint8_t pieceXCoordinate = 0;
    uint8_t pieceYCoordinate = fieldHeight / 2;
	
    uint8_t speed = 15;
    uint8_t gameTicksCount = 0;
	uint8_t numLives=3;
    bool movePiece = false;
    bool rotationFlag = true;
	
    uint16_t pieceCount = 0;
    uint16_t score = 0;

    uint8_t linesXCoordinates[4] = {0, 0, 0, 0};
    uint8_t linesCount = 0;
    bool isGameOver = false;
	bool isTheEnd = false;
    uint8_t previousSide = 0;
	bool hasScoreChanged = false;
	
    uint8_t randomSideGenerator = 0;  // left - 0, right - 1
	
	WriteScore(score);

	while (1) {
		
		if(isGameOver && numLives==1){
			isTheEnd=true;
			isGameOver=false;
		}
		
		if (isGameOver)
		{
			numLives=numLives-1;
			DisplayGameOverScreen(numLives);
			
			_delay(18000);
			
			for (uint8_t y = 0; y < fieldHeight; y++) 
			{
				for (uint8_t x = 0; x < fieldWidth; x++)
				{
					field[y * fieldWidth + x] = (y == 0 ||
									   y >= fieldHeight - 7 ||
									   x + 1 == fieldWidth / 2 ||
									   x == fieldWidth / 2 ) ? 9u : 0u;
				}
			}
			isGameOver=false;
			WriteScore(score);
		}
		
		if (isTheEnd)
		{
					DisplayTheEndScreen();
				
					while (!(buttons & BUTTON_CENTER))
					{
						// Press center button to restart the game
						GetButtonStates();
					}
					
					for (uint8_t y = 0; y < fieldHeight; y++) 
					{
						for (uint8_t x = 0; x < fieldWidth; x++)
						{
							field[y * fieldWidth + x] = (y == 0 ||
											   y >= fieldHeight - 7 ||
											   x + 1 == fieldWidth / 2 ||
											   x == fieldWidth / 2 ) ? 9u : 0u;
						}
					}
					isTheEnd=false;

					score=0;
					speed=15;
					
					WriteScore(score);
		}
		delay--;
				
		GetButtonStates();
		
		if (buttons & BUTTON_UP)
		{
			upButton = true;
			print("BUTTON_UP\n");
		}	
		if (buttons & BUTTON_DOWN)
		{
			downButton = true;			
			print("BUTTON_DOWN\n");
		}		
		if (buttons & BUTTON_RIGHT)
		{
			rightButton = true;			
			print("BUTTON_RIGHT\n");
		}
		if (buttons & BUTTON_LEFT) 
		{
			leftButton = true;			
			print("BUTTON_LEFT\n");
		}
		if (buttons & BUTTON_CENTER)
		{
			centerButton = true;			
			print("BUTTON_CENTER\n");
		}
		reg_gpio = 0x00000100 | buttons; // first 9 leds				
			
			
		// Game Logic
		if (delay == 0)
		{	
			delay = DELAY;			
			gameTicksCount++;
			movePiece = (gameTicksCount == speed);			


		 	// Player input handling
			if (!randomSideGenerator) // left part of the screen
			{
				pieceYCoordinate += (downButton && DoesPieceFit(pieceIndex, pieceRotation, pieceXCoordinate, pieceYCoordinate + 1)) ? 1 : 0;
				pieceYCoordinate -= (upButton && DoesPieceFit(pieceIndex, pieceRotation, pieceXCoordinate, pieceYCoordinate - 1)) ? 1 : 0;
				pieceXCoordinate += (rightButton && DoesPieceFit(pieceIndex, pieceRotation, pieceXCoordinate + 1, pieceYCoordinate)) ? 1 : 0;
			}
			else // right part of the screen
			{ 
				pieceYCoordinate -= (upButton && DoesPieceFit(pieceIndex, pieceRotation, pieceXCoordinate, pieceYCoordinate - 1)) ? 1 : 0;
				pieceYCoordinate += (downButton && DoesPieceFit(pieceIndex, pieceRotation, pieceXCoordinate, pieceYCoordinate + 1)) ? 1 : 0;
				pieceXCoordinate -= (leftButton && DoesPieceFit(pieceIndex, pieceRotation, pieceXCoordinate - 1, pieceYCoordinate)) ? 1 : 0;
			} 

			if (centerButton)
			{
				pieceRotation += (rotationFlag && DoesPieceFit(pieceIndex, pieceRotation + 1, pieceXCoordinate, pieceYCoordinate)) ? 1 : 0;
				rotationFlag = false;
			}
			else
				rotationFlag = true;
		
			// Move the piece "down" the playfield if it's time
			if (movePiece)
			{
				// Update difficulty every 50 pieces
				gameTicksCount = 0;
				pieceCount++;
				 if (pieceCount % 50 == 0)
					if (speed >= 10) speed--; 

				// Test if piece can be moved down
				if (DoesPieceFit(pieceIndex, pieceRotation, pieceXCoordinate + 1, pieceYCoordinate) && !randomSideGenerator)
				{
					pieceXCoordinate++;
				}
				else if (DoesPieceFit(pieceIndex, pieceRotation, pieceXCoordinate - 1, pieceYCoordinate) && randomSideGenerator)
				{
					pieceXCoordinate--;
				}
				else
				{
					// Lock the piece in place
					for (int x = 0; x < 4; x++)
					{	
						for (int y = 0; y < 4; y++)
						{
							if (tetrominoes[pieceIndex][Rotate(x, y, pieceRotation)] != 0)
							{
								field[(pieceYCoordinate + y) * fieldWidth + (pieceXCoordinate + x)] = pieceIndex + 1;
							}
						}
					}

					// Check if any lines formed
					for (int x = 0; x < 4; x++)
					{
						bool bLine = true;
						for (int y = 1; y < fieldHeight - 7; y++)
						{
							if (field[(pieceXCoordinate + x) + fieldWidth * y] == 0 || field[(pieceXCoordinate + x) + fieldWidth * y] == 9u) 
							{
								bLine = false;
								break;
							}
						}

						if (bLine)
						{
							// Remove the line
							for (int y = 1; y < fieldHeight - 7; y++)
							{
								field[(pieceXCoordinate + x) + fieldWidth * y] = 0;
							}
							
							// Remember the coordinates of the removed line
							linesXCoordinates[linesCount] = pieceXCoordinate + x;
							linesCount++;
						}
					}
					previousSide = randomSideGenerator;

					// Score handling
					score += 1;
					if (linesCount != 0) score += (1 << linesCount) * 20;
					hasScoreChanged = true;
					
					// Generate new piece
					pieceYCoordinate = generateRandomNumber(2,19);
					// Generate new side
					randomSideGenerator= generateRandomBinary();

					if (!randomSideGenerator) 
					{
						pieceRotation = 3;
						pieceXCoordinate = 0;
					}
					else 
					{
						pieceRotation = 3;
						pieceXCoordinate = fieldWidth - 4;
					}

					pieceIndex = pieceCount % 7;

					// Game is over if the piece doesn't fit at the beginning
					isGameOver = !DoesPieceFit(pieceIndex, pieceRotation, pieceXCoordinate, pieceYCoordinate);
				}
			}

			// Rendering part
			if (hasScoreChanged)
			{
				hasScoreChanged = false;
				DisplayScore(score, 22, 24);
			}

			// Display the current field state
			 for (int y = 0; y < fieldHeight; y++) 
			 {
				for (int x = 0; x < fieldWidth; x++) 
				{
					reg_video_map[y * fieldWidth + x] = field[y * fieldWidth + x];
				}
			}

			// Display the current piece on the field
			for (int x = 0; x < 4; x++)
			{
				for (int y = 0; y < 4; y++)
				{
					if (tetrominoes[pieceIndex][Rotate(x, y, pieceRotation)] != 0)
					{
						reg_video_map[(pieceYCoordinate + y) * fieldWidth + (pieceXCoordinate + x)] = pieceIndex + 1; 
					}
				}
			 }		

			// Handle the lines removal
			if (linesCount != 0)
			{
				if (previousSide == 0)
				{
					for (uint8_t v = 0; v < linesCount; v++) 
					{
						for (uint8_t x = linesXCoordinates[v]; x > 0; x--) 
						{
							for (uint8_t y = 1; y < fieldHeight - 7; y++)
							{
								field[x + fieldWidth * y] = field[x - 1 + fieldWidth * y];
							}
						}
					}
				} 
				else
				{
					for (uint8_t v = linesCount; v > 0; v--)
					{
						for (uint8_t x = linesXCoordinates[v - 1]; x < fieldWidth - 1; x++)
						{
							for (uint8_t y = 1; y < fieldHeight - 7; y++) 
							{
								field[x + fieldWidth * y] = field[x + 1 + fieldWidth * y];
							}
						}
					}

				}
				
				// clear the coordinates array
				linesXCoordinates[0] = 0;
				linesXCoordinates[1] = 0;
				linesXCoordinates[2] = 0;
				linesXCoordinates[3] = 0;
				linesCount = 0;		
			}

			rightButton = false;
			downButton = false;
			centerButton = false;
			upButton = false;
			leftButton = false;		
		}
	}
}

