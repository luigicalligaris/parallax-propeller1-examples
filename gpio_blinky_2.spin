{
    --------------------------------------------
    Filename: gpio_blinky_1.spin
    Author: Luigi Calligaris
    Copyright (c) 2022 Luigi Calligaris
    
    Parallax Propeller Examples Series
    
    --------------------------------------------
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    --------------------------------------------
    
    In this 2nd LED blinking example, we want to implement a led blinker 
    program in Propeller ASM. By default, the first program launched on a 
    Propeller1 is coded in Spin and runs in the interpreter running in 
    cog0. This program will launch our ASM routing on the next free cog 
    by calling the cognew default function.
    
    We are assuming that the crystal being used is a 5 MHz crystal. In my 
    tests I have been using a QANTEK 5 MHz, 18 pF crystal, product number 
    QCL5.00000F18B23B
}
CON
    ' We are using a 5 MHz crystal
    _xinfreq = 5_000_000
    
    ' Select the crystal oscillator driver mode and the PLL multiplier
    ' XTAL1  = 2 kΩ 36 pF External low-speed crystal (4 MHz to 16 MHz) 
    ' PLL16X = PLL multiplier 16x, that is, 5 * 16 = 80 MHz
    _clkmode = xtal1 + pll16x

VAR
    ' This variable will store the index of the cog on which the ASM 
    ' code has been launched
    byte blink_cog

OBJ
    

PUB main
    ' Start running a program in new cog by setting the program counter 
    ' to the address of the label "blink_entry". Pass in the special 
    ' "par" variable a NULL pointer, since we won't share memory between 
    ' the boot program and the child program.
    blink_cog := cognew(@blink_entry, 0) 
 
DAT
              ' Set the compile-time assembly pointer (i.e. the global 
              ' offset for the statements that will be listed below).
              org 0
blink_entry   
              ' Set the GPIO direction register by copying into the 
              ' register the content of the register "r_dira", which
              ' is initialized in the 'long' statement below.
              mov          dira,    r_dira
              
              ' Initialize the register r_counter to zero.
              mov     r_counter,        #0
              
              ' Copy from main memory the value of the clock frequency 
              ' in Hz (always at address 0) to the local register r_delay.
              ' In this example we expect that the frequency is 80 MHz.
              ' Shift right by 5, i.e. divide by 32.
              rdlong    r_delay,        #0
              shr       r_delay,        #5
              
              ' Copy the current clock cycle counter in r_timer and add 9.
              mov       r_timer,       cnt
              add       r_timer,        #9
:loop         
              ' Wait for the clock cycle counter to reach the value stored 
              ' into r_timer, then add r_delay into r_timer to reload it 
              ' and then continue execution. Since we did before a shift 
              ' right by 5 of the value stored in r_delay, the wait 
              ' interval is 2**-5 = 1/32th of a second.
              waitcnt   r_timer,   r_delay
              
              ' Copy the counter into a temporary register r_newouta
              mov     r_newouta, r_counter
              
              ' Shift left the least significant bits of the counter in 
              ' order to align them with the outputs connected to the LEDs.
              shl     r_newouta,       #15
              
              ' This is not necessarily needed: mask the r_newouta register 
              ' with the direction register, to set just bits chosen as 
              ' output.
              and     r_newouta,    r_dira
              
              ' Write the r_newouta register to the output register.
              mov          outa, r_newouta
              
              ' Increment the counter
              add     r_counter,        #1
              
              ' Go back to the beginning of the loop.
              jmp      #:loop

' Allocate and initialize r_dira with the direction register value we need.
r_dira        long    %0000_0000_0000_1111_0000_0000_0000_0000

' Allocate here the registers which will be used by the program
r_counter     res     1
r_newouta     res     1
r_delay       res     1
r_timer       res     1

' Compile-time assertion on the fact that the statements above fit inside 
' the cog memory. Throws an error is they generate code that does not fit.
              fit