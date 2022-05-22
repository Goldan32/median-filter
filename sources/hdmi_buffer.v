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
    );
    
 // 1. HSync alapj�n felbont�st mond  ---- K�sz, addr ez alapj�n van.
 // 2. Sz�ml�l�, ami megmondja, hogy mikor van az �sszes bramban adat. ----- Kernel valid. Ha 4x eljutottunk ak�p sz�l�re, azt jelenti, hogy van 4 sor + 5 pixel
 // 3. VSync alapj�n megmondja, hogy h�ny sor van. ----- Ez lehet felesleges. Ha vsync j�n, azt jelenti, hogy v�ge a k�pnek. Ekkor a valid jeleket null�zni kell. K�rd�s, hogy az ablak t�bbi r�sz�vel mi legyen.
 // 4. Address-t sz�mol. ---- Ez k�sz. Most a READ �s WRITE addr megegyezik, rem�lhet?leg nem akadnak �ssze. (�sszeakadhatnak?)
 // 5. Bramok egym�sba t�lt�getik egym�st. ---- Ez szerintem k�sz, shift regisztereken kereszt�l megy bel�j�k az adat.
 // 6. K�p sz�l�n�l az elej�re ugr�s, vagy belepr�sel?dik. 
 
 // Get one pixel from RX
 reg [23:0] pixel;
 
 always @ (posedge clk)
 begin
    if(rst || rx_vs)
    begin
        pixel <= 0;
    end     
    if(rx_dv)
    begin
        pixel <= {rx_red,rx_green,rx_blue};
    end
         
 end
 

wire [11:0] addr;
reg [11:0] width;
 
addr_ctrl #(
    .ADDR_W(11)
)
addr_module(
    .clk(clk),
    .rst(rst),
    .vsync(rx_vs),
    .hsync(rx_hs),
    .addr(addr),
    .width(width)
 );

wire [23:0] shr_dout [4:0][4:0];
wire [23:0] bram_dout [3:0];
wire data_valid;
assign data_valid = rx_dv;

genvar k;
generate
    for (k = 0; k < 5; k = k + 1) begin 
    if(k==0) begin: inst
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
    else begin: inst
        px_shr(
            .clk(clk),
            .rst(rst),
            .din(bram_dout[k-1]),
            .data0(shr_dout[k][0]),
            .data1(shr_dout[k][1]),
            .data2(shr_dout[k][2]),
            .data3(shr_dout[k][3]),
            .data4(shr_dout[k][4])
        );
    end
    end
endgenerate

genvar q;
generate
    for (q = 0; q < 4; q = q + 1) begin
    if(q==0) begin: inst
        bram#(
            .DATA_W(24),
            .ADDR_W(11)
        )(
            .clk_a(clk),
            .we_a(data_valid != 0),
            .addr_a(addr),
            .din_a(pixel),
            .dout(),
            .clk_b(clk),
            .we_b(0'b0),
            .addr_b(addr),
            .din_b(),
            .dout_b(bram_dout[k])
        );
    end
    else begin: inst
        bram#(
            .DATA_W(24),
            .ADDR_W(11)
        )(
            .clk_a(clk),
            .we_a((data_valid != 0)),
            .addr_a(addr),
            .din_a(shr_dout[k][0]),
            .dout(),
            .clk_b(clk),
            .we_b(0'b0),
            .addr_b(addr),
            .din_b(),
            .dout_b(bram_dout[k])
        );
    end
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

endmodule
