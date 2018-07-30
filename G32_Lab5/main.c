#include "./drivers/inc/vga.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/audio.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/wavetable.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/ps2_keyboard.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/slider_switches.h"

float make_sine(float f, int t) { 
	int floor_index,  signal, freq; 
	freq = (int) f;
	floor_index = (freq * t) % 48000; //computes the index from 0-47999 in the wavetable
	signal = (sine[floor_index]); //fetches the value of the wavetable at floor_index and stores it in signal
	return signal;
}

int keyboard() { //this is a function that runs a keyboard synthesizer
	short colour = -32767;
	int time = 0;
	int n1 = 0, n2 = 0, n3 = 0, n4 = 0, n5 = 0, n6 = 0, n7 = 0, n8 = 0; //our notes
	int key = 0;
	int audio_written = 0; //flags to indicate valid read from keyboard fifo and write to audio fifos
	double a = 1; //amplitude multiplier to be used for volume control
	int breakc = 0; //flag to indicate if a key has been released
	char c;
	char* memory = &c; //character and character pointer for keyboard data
	
	int_setup(1, (int []){199}); //setting up interrupts for tim0
		
	HPS_TIM_config_t tim0; //configuring tim0 and defining its parameters
	tim0.tim = TIM0;
	tim0.timeout = 20;
	tim0.LD_en = 1;
	tim0.INT_en = 1;
	tim0.enable = 1;
	HPS_TIM_config_ASM(&tim0);

	int_setup(1, (int[]){200});	//setting up interrupts for tim1
	
	HPS_TIM_config_t tim1; //configuring tim1 and defining its parameters
	tim1.tim = TIM1;
	tim1.timeout = 100000;
	tim1.LD_en = 1;
	tim1.INT_en = 1;
	tim1.enable = 1;
	HPS_TIM_config_ASM(&tim1);

	int p = 0, x = 0, scale = 0;
	int buff_max = 0, buff_min = 0;  //integers for display 

	int buffer[320];
	int height[320]; //height arrays
	int sounds[8][48000]; //sound array
		
	for(time=0;time<48000;time++){
		sounds[0][time] = make_sine(130.813, time); //generates low C
		sounds[1][time] = make_sine(146.832, time); //generates D
		sounds[2][time] = make_sine(164.814, time); //generates E
		sounds[3][time] = make_sine(174.614, time); //generates F
		sounds[4][time] = make_sine(195.998, time); //generates G
		sounds[5][time] = make_sine(220.000, time); //generates A
		sounds[6][time] = make_sine(246.942, time); //generates B
		sounds[7][time] = make_sine(261.626, time); //generates high C
	}
	time = 0;
	while(1){
		int sumSignal = 0; //initializing the signal to 0 each iteration
		if(hps_tim0_int_flag){ //once tim0 runs out, it interrupts the processor to write more data to the audio fifo
			key = read_ps2_data_ASM(memory); //checks to see if a key has been pressed
				if(key == 1 && *memory == 0x1C){ //checks for the 'a' key
					if(breakc == 0){ //pressed
						n1 = 1; //note on
					}
					if(breakc){ //released
						n1 = 0; //note off
					}	
					breakc = 0; //resets break code flag to 0
				}
				else if(key == 1 && *memory == 0x1B){ // 's' key
					if(breakc == 0){ //pressed
						n2 = 1; //note on
					}
					if(breakc){ //released
						n2 = 0; //note off
					}	
					breakc = 0; //resets break code flag to 0
				}	
				else if(key == 1 && *memory == 0x23){ // 'd' key
					if(breakc == 0){ //pressed
						n3 = 1; //note on
					}
					if(breakc){ //released
						n3 = 0; //note off
					}
					breakc = 0; //resets break code flag to 0
				}	
				else if(key == 1 && *memory == 0x2B){ // 'f' key
					if(breakc == 0){ //pressed
						n4 = 1; //note on
					}
					if(breakc){ //released
						n4 = 0; //note off
					}	
					breakc = 0; //resets break code flag to 0
				}
				else if(key == 1 && *memory == 0x3B){ // 'j' key
					if(breakc == 0){ //pressed
						n5 = 1; //note on
					}
					if(breakc){ //released
						n5 = 0; //note off
					}		
					breakc = 0; //resets break code flag to 0
				}
				else if(key == 1 && *memory == 0x42){ // 'k' key
					if(breakc == 0){ //pressed
						n6 = 1; //note on
					}
					if(breakc){ //released
						n6 = 0; //note off
					}	
					breakc = 0;//resets break code flag to 0
				}
				else if(key == 1 && *memory == 0x4B){ // 'l' key
					if(breakc == 0){ //pressed
						n7 = 1; //note on
					}
					if(breakc){ //released
						n7 = 0; //note off
					}		
					breakc = 0; //resets break code flag to 0
				}
				else if(key == 1 && *memory == 0x4C){ //';' key
					if(breakc == 0){ //pressed
						n8 = 1; //note on
					}
					if(breakc){ //released
						n8 = 0; //note off
					}	
					breakc = 0; //resets break code flag to 0
				}			
				else if(key && *memory == 0xF0){ //checks for the first byte of the break code, indicating a key has been released
					breakc = 1; //if so, sets break code flag to 1
				}
				else if(key && *memory == 0x32){ // 'b' key - volume up control - releasing key does not affect the signal
					if(breakc == 0){ //pressed
						a = 2 * a; //amplitude (volume) 2 times previous value
					}
					breakc = 0; //resets break code flag to 0
				}
				else if(key && *memory == 0x2A){ // 'v' key - volume down control - releasing key does not affect the signal
					if(breakc == 0){ //pressed
						a = 0.5 * a; //amplitude (volume) 0.5 times previous value
						if(a < 0.01)
							a = 0.01;
					}	
					breakc = 0; //resets break code flag to 0
				}
		}
		buff_max = -99999999;
		buff_min = 999999999;
		if(n1 == 1) 
			(sumSignal += sounds[0][time]); //generates low C
		if(n2 == 1) 
			(sumSignal += sounds[1][time]); //generates D
		if(n3 == 1)
			(sumSignal += sounds[2][time]); //generates E
		if(n4 == 1) 
			(sumSignal += sounds[3][time]); //generates F
		if(n5 == 1) 
			(sumSignal += sounds[4][time]); //generates G
		if(n6 == 1) 
			(sumSignal += sounds[5][time]); //generates A
		if(n7 == 1) 
			(sumSignal += sounds[6][time]); //generates B
		if(n8 == 1) 
			(sumSignal += sounds[7][time]); //generates high C

		sumSignal = a * sumSignal; //scales amplitude to volume level	
		
		audio_written = audio_write_data_ASM(sumSignal, sumSignal); //writes to audio fifos, in this case, the same signal is written to both the left and right fifos

		if(audio_written){ //if data was written to the fifos
			if(hps_tim0_int_flag){ //checks if the tim0 interrupt flag has been asserted
				buffer[x++] = sumSignal;
				if(x >= 320) 
					x = 0;
				hps_tim0_int_flag = 0; //if so, it is reset
				time++; //and the time counter is incremented
			}
		}
		if(hps_tim1_int_flag){ //if hps_tim1_int_flag is asserted, the processor is interrupted to draw to the screen
			hps_tim1_int_flag = 0; //the tim1 interrupt flag is reset to 0
			for(p = 0; p < 320 ; p++){
				VGA_draw_point_ASM(p, height[(p) % 320], 0x000000);  // "clears" the previous wave
				if(buffer[p] > buff_max) 
					buff_max = buffer[p];    //sets max and then min 
				if(buffer[p] < buff_min) 
					buff_min = buffer[p];
			}
			if(sumSignal == 0){
				for(p = 0; p < 320 ; p++){
				VGA_draw_point_ASM(p, 120, colour);  //draw point at p with scaled height
				height[p] = 120; //update backup 
				}
			}
			if(sumSignal != 0){
			//CALCULATE SCALE FACTOR
				scale = (buff_max - buff_min) / 240;
				for(p = 0; p < 320 ; p++){
					height[p] = buffer[(p + x) % 320] / scale + 120;
					VGA_draw_point_ASM(p, height[p] , colour);  //draw point at p with scaled height
					 //update backup 
				}
			}
		}
		colour++;
		if(colour > 32767)
			colour = -32767;
		if(time >= 48000) //checks if time reaches or exceeds 48000 (the sampling rate, or the size of the wavetable)
			time = 0; //if so, it is reset to 0
	}
	return 0;
}

int main() {
	VGA_clear_pixelbuff_ASM();
	keyboard();	
 return 0;
} 
