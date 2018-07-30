# ECSE-324
This repositories contains the code written for the labs of the class ECSE 324 - Computer Organization at McGill University, Winter 2018. The lab were completed with ARM assembly subroutines and C programs.

All labs were completed with the use of Quartus 16.1 and Intel FPGA monitor program on an Altera DE1-SoC single board computer.

**Lab 1** - Intro to ARM assembly:
This lab required us to implement bubble sort in assembly.

**Lab 2** - Recursion and Subroutines:
The first part of this lab required us to implement a way to computer a fibonacci sequence recursively using assembly and the second part of this lab taught us to call assembly subroutine from a C program.

**Lab 3** - Drivers and Stopwatch:
This lab introduced us to Drivers development of the I/O of the DE1-SoC computer such the slider switches, push buttons and 7-segment displays. The first part required us to program drivers for the display logic on the 7 segments. The second part of the lab required us to implement a stopwatch using polling logic for the buttons and using interrupts for the buttons. 

**Lab 4** - High Level I/O:
This lab taught us how to access data on VGA, keyboard and audio registers. We were required write a program using assembly subroutines and C to display ASCII characters in hexadecimal format when the appropriate keys were pressed. The audio part of this lab required us to use the audio registers and find a way to output a 100 Hz constant sound wave.

**Lab 5** - Music Synthesizer:
Using what we learned and designed in the previous labs, we would build a music synthesizer with the FPGA board, assembly and C. We mapped the keyboard keys to the following notes and we would display the corresponding waveforms on the monitor. We also implemented volume control for this lab.

| Note | Key | Frequency  |
| ---- | --- | ---------  |
|  C   |  A  | 130.813 Hz |
|  D   |  S  | 146.832 Hz |
|  E   |  D  | 164.814 Hz |
|  F   |  F  | 174.614 Hz |
|  G   |  J  | 195.998 Hz |
|  A   |  K  | 220.000 Hz |
|  B   |  L  | 246.942 Hz |
|  C   |  ;  | 261.626 Hz |

<br/>
<br/>
<br/>
This would be the end goal.
![alt text](https://i.redditmedia.com/VDH0EnVHiLWhZmc1ySKIym4P4EoC-5VM2cl5oMGQ040.png?s=2b81574efafadcf3de30915a5e1c0b8c)
