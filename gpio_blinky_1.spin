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
    
    In this 1st LED blinking example, we want to blink a set of four leds 
    connected in series with a 330 ohm resistor to GPIOs 16, 17, 18, 19 on 
    the bottom right corner of the microcontroller when looking from the 
    top with the package marking on the top.
    
    The leds will blink representing the bits in a counter, therefore it 
    will act as a binary clock up to the maximum representable time (16 ticks).
    
    We program this first example in Spin, which by default runs on cog0 
    upon boot. This is an example, later examples will move into the real 
    of assembler.
    
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
    
    ' Bitmask of the GPIOs to be set as outputs ('1') to drive the four LEDs
    ' As we are connecting the leds to GPIO 16..19 we are setting bits 16..19
    ledmask = %00000000_00001111_00000000_00000000

VAR
    ' This long (32-bits) holds the binary counter of which a subset of bits will 
    ' be shown on the LEDs.
    long counter

OBJ
    

PUB main
    ' dira is a default register holding the direction setting for each GPIO pin
    ' 0 = put the buffer in high impedance and use as input
    ' 1 = enable the buffer and use as an output
    dira := ledmask
    
    ' initialize with zero the counter
    counter := 0
    
    ' repeat without condition translates to an infinite loop
    repeat
        ' outa is a default register holding the output state of the buffer for 
        ' each GPIO pin, when enabled as output. The bit to pin mapping is the 
        ' same as the one for dira. The ampersand is the bitwise AND operation.
        ' We shift 15 times left, to put the least significant bits into the LEDs
        outa := (counter << 15) & ledmask
        
        ' This enters a wait state that will end 20 million clock cycles after 
        ' the current cycle, which is read from the default register "cnt".
        ' As both the wakecnt and the cnt registers are 32-bits unsigned, 
        ' eventual overflows in cnt and in the sum do not need to be managed.
        ' Since we are running at 80 MHz, this delay waits 1/4 of a second.
        waitcnt(20_000_000 + cnt)
        
        ' Increment the counter, which will be copied into the output register at 
        ' the beginning of this infinite loop.
        counter += 1    

DAT
    
