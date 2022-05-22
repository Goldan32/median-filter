`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2022 07:02:14 PM
// Design Name: 
// Module Name: hdmi_buffer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module hdmi_buffer(
    input clk,
    input rst,
    
    input [7:0] rx_red,
    input [7:0] rx_green,
    input [7:0] rx_blue,
    input       rx_dv,
    input       rx_hs,
    input       rx_vs,
    
    output [25*8-1:0] kernel_red,
    output [25*8-1:0] kernel_green,
    output [25*8-1:0] kernel_blue,
    output       kernel_valid
    );
    
 // 1. HSync alapj�n felbont�st mond  ---- K�sz, addr ez alapj�n van.
 // 2. Sz�ml�l�, ami megmondja, hogy mikor van az �sszes bramban adat. ----- Kernel valid. Ha 4x eljutottunk ak�p sz�l�re, azt jelenti, hogy van 4 sor + 5 pixel
 // 3. VSync alapj�n megmondja, hogy h�ny sor van. ----- Ez lehet felesleges. Ha vsync j�n, azt jelenti, hogy v�ge a k�pnek. Ekkor a valid jeleket null�zni kell. K�rd�s, hogy az ablak t�bbi r�sz�vel mi legyen.
 // 4. Address-t sz�mol. ---- Ez k�sz. Most a READ �s WRITE addr megegyezik, rem�lhet?leg nem akadnak �ssze. (�sszeakadhatnak?)
 // 5. Bramok egym�sba t�lt�getik egym�st. ---- Ez szerintem k�sz, shift regisztereken kereszt�l megy bel�j�k az adat.
 // 6. K�p sz�l�n�l az elej�re ugr�s, vagy belepr�sel?dik. 
 
 // Get one pixel from RX
 reg [23:0] pixel;
 reg [2:0] fill_shr_cntr;
 reg shr_filled;
 
 always @ (posedge clk)
 begin
    if(rst || rx_vs)
    begin
        pixel <= 0;
        fill_shr_cntr <= 0;
        shr_filled <= 0;
    end     
    if(rx_dv)
    begin
        pixel <= {rx_red,rx_green,rx_blue};
        fill_shr_cntr <= fill_shr_cntr + 1;
        if(fill_shr_cntr == 4)
        begin
            shr_filled <= 1;
        end
    end
         
 end
 

 // Determine the length of one line
 reg [11:0] width;
 reg [11:0] width_cntr;
 
 always @ (posedge clk)
 begin
    if(rst || rx_vs)
    begin
        width <= 0;
        width_cntr <= 0;
    end
    else if(rx_hs)
    begin
        width <= width_cntr;
        width_cntr <= 0;
    end
    else
        width_cntr <= width_cntr + 1;
 end
 
 // Address counter
 reg [10:0] addr_reg_wr;
 reg [2:0] row_cntr;
 wire [10:0] addr_reg_rd;
 
 always @ (posedge  clk)
 begin
    if(rst || rx_vs)
    begin
        addr_reg_wr <= 0;
    end
    else if(addr_reg_wr == width)
    begin
        addr_reg_wr <= 0;
        row_cntr <= row_cntr + 1;
    end
    else
    begin
    addr_reg_wr <= addr_reg_wr + 1;
    end
 end
 
 assign kernel_valid  = (row_cntr == 4);
// �tgondolni, vagy t�r�lni, ha j�, ha mindkett? ugyanaz
assign addr_reg_rd = addr_reg_wr;

wire [23:0] shr_dout [4:0][4:0];

wire [23:0] bram_dout_0;
wire [23:0] bram_dout_1;
wire [23:0] bram_dout_2;
wire [23:0] bram_dout_3;
 
genvar k;
generate
    for (k = 0; k < 5; k = k + 1) begin: inst
        px_shr(
            .clk(clk),
            .rst(rst),
            .din(pixel),
            .data0(shr_dout[k][0]),
            .data1(shr_dout[k][1]),
            .data2(shr_dout[k][2]),
            .data3(shr_dout[k][3]),
            .data4(shr_dout[k][4])
        );
    end
endgenerate

genvar jj, ii;
generate
    for (jj = 0; jj < 5; jj = jj + 1) begin
        for (ii = 0; ii < 5; ii = ii + 1) begin
            assign kernel_red  [(5*jj+ii)*8 + 7: (5*jj+ii)*8] = shr_dout[jj][ii][7:0];
            assign kernel_green[(5*jj+ii)*8 + 7: (5*jj+ii)*8] = shr_dout[jj][ii][15:8];
            assign kernel_blue [(5*jj+ii)*8 + 7: (5*jj+ii)*8] = shr_dout[jj][ii][23:16];
        end
    end
endgenerate
 
 // Amikor az els? shift regiszter felt�lt?dik adattal, akkor kezd?dik a BRAM-ba �r�s
 assign data_valid = rx_dv && shr_filled;
 bram #(
    .DATA_W(24),
    .ADDR_W(11)
 )
 buffer_ram_0(
    .clk_a(clk),
    .we_a((data_valid  != 0)),
    .addr_a(addr_reg_wr),
    .din_a(shr_dout_0),
    .dout(),
    .clk_b(clk),
    .we_b((data_valid  != 0)),
    .addr_b(addr_reg_rd),
    .din_b(),
    .dout_b(bram_dout_0)
 );
 
  bram #(
    .DATA_W(24),
    .ADDR_W(11)
 )
 buffer_ram_1(
    .clk_a(clk),
    .we_a((data_valid  != 0)),
    .addr_a(addr_reg_wr),
    .din_a(shr_dout_1),
    .dout(),
    .clk_b(clk),
    .we_b((data_valid  != 0)),
    .addr_b(addr_reg_rd),
    .din_b(),
    .dout_b(bram_dout_1)
 );
 
  bram #(
    .DATA_W(24),
    .ADDR_W(11)
 )
 buffer_ram_2(
    .clk_a(clk),
    .we_a((data_valid  != 0)),
    .addr_a(addr_reg_wr),
    .din_a(shr_dout_2),
    .dout(),
    .clk_b(clk),
    .we_b((data_valid  != 0)),
    .addr_b(addr_reg_rd),
    .din_b(),
    .dout_b(bram_dout_2)
 );
 
  bram #(
    .DATA_W(24),
    .ADDR_W(11)
 )
 buffer_ram_3(
    .clk_a(clk),
    .we_a((data_valid  != 0)),
    .addr_a(addr_reg_wr),
    .din_a(shr_dout_3),
    .dout(),
    .clk_b(clk),
    .we_b((data_valid  != 0)),
    .addr_b(addr_reg_rd),
    .din_b(),
    .dout_b(bram_dout_3)
 );


endmodule
