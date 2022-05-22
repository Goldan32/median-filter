## Documentation

The block RAM in Xilinx 7 series FPGA stores up to 36 Kbits of data and can be configured as either two independent 18 Kb RAMs, or one 36 Kb RAM.
The input HDMI data contains 3x8 bit RGB data, we need a minimum of 24 bits of space to store 1 pixel in 1 row.
Each 18 Kb block RAM can be configured as a (...), or 512 x 36 in simple dual-port module. 

One row contains 1600 pixels, we need 4 block RAMs to fully store one row.

The kernel is a 5x5 matrix, so we need to store 4 rows simultaneously. 
The addres counter counts from zero to (1600-5) (5 pixels will always be in the shift register)