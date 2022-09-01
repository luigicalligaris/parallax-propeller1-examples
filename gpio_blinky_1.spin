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

    ledmask = %00000000_00001111_00000000_00000000

VAR
    long counter

OBJ
    

PUB main
    dira := ledmask
    counter := 0
    
    repeat
        outa := (counter << 15) & ledmask
        
        waitcnt(20_000_000 + cnt)
        counter += 1    

DAT
    
