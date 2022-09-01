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
    byte producer_cog
    byte consumer_cog
    
    byte ipc_toggle
    byte ipc_count
    
OBJ
    

PUB main
    ipc_toggle := 0
    ipc_count  := 0
    producer_cog := cognew(@blink_producer, @ipc_toggle) 
    consumer_cog := cognew(@blink_consumer, @ipc_toggle) 
 
DAT
  org 0
  blink_producer
    mov      prod_p_toggle,           par
    mov       prod_p_count, prod_p_toggle
    add       prod_p_count,            #1
    
    mov      prod_r_toggle,            #0
    mov       prod_r_count,            #0
      
    rdlong    prod_r_delay,            #0
    shr       prod_r_delay,            #1
      
    mov       prod_r_timer,           cnt
    add       prod_r_timer,            #9
  :loop
    waitcnt   prod_r_timer,  prod_r_delay
    wrbyte   prod_r_toggle, prod_p_toggle
    wrbyte    prod_r_count,  prod_p_count
    
    add       prod_r_count,            #1
    xor      prod_r_toggle,            #1
    jmp      #:loop
    
  prod_p_toggle      res     1
  prod_p_count       res     1
  prod_r_toggle      res     1
  prod_r_count       res     1
  prod_r_delay       res     1
  prod_r_timer       res     1
  fit


  org 0
  blink_consumer
        mov      cons_p_toggle,            par
        mov       cons_p_count,  cons_p_toggle
        add       cons_p_count,             #1
        
        mov  cons_r_prevtoggle,             #0
        mov      cons_r_toggle,             #0
        mov       cons_r_count,             #0
        
        mov               dira,         c_dira
        
  :loop
        rdbyte   cons_r_toggle,  cons_p_toggle
        rdbyte    cons_r_count,   cons_p_count
        
        test cons_r_prevtoggle,  cons_r_toggle
   if_z jmp      #:loop
        
        mov  cons_r_prevtoggle,  cons_r_toggle
        mov     cons_r_newouta,   cons_r_count
        shl     cons_r_newouta,            #16
        and     cons_r_newouta,         c_dira
        mov               outa, cons_r_newouta
        jmp      #:loop

  c_dira            long     %0000_0000_0000_1111_0000_0000_0000_0000
  cons_p_toggle      res     1
  cons_p_count       res     1
  cons_r_toggle      res     1
  cons_r_count       res     1
  cons_r_prevtoggle  res     1
  cons_r_newouta     res     1
  fit
  