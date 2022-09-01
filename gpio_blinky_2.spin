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
}
CON
    _clkmode = xtal1 + pll16x
    _xinfreq = 5_000_000

VAR
    byte blink_cog

OBJ
    

PUB main
    blink_cog := cognew(@blink_entry, 0) 
 
DAT
              org 0
blink_entry   
              mov          dira,    r_dira
              mov     r_counter,        #0
              
              rdlong    r_delay,        #0
              shr       r_delay,        #5
              
              mov       r_timer,       cnt
              add       r_timer,        #9
:loop              
              waitcnt   r_timer,   r_delay
              mov     r_newouta, r_counter
              shl     r_newouta,       #15
              and     r_newouta,    r_dira
              mov          outa, r_newouta
              add     r_counter,        #1
              jmp      #:loop

r_dira        long    %0000_0000_0000_1111_0000_0000_0000_0000
r_counter     res     1
r_newouta     res     1
r_delay       res     1
r_timer       res     1
              fit