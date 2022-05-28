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
    output [25*8-1:0] kernel_blue
    );
    
    localparam ADDR_W = 11;
    localparam DATA_W = 24;
 
 // Get one pixel from RX
 wire [DATA_W - 1:0] pixel;
 assign pixel = rx_dv ? {rx_red, rx_green, rx_blue} : 24'd0;

// Delay the HDMI signals
 reg [1:0] hsync_dly;
 reg [1:0] vsync_dly;
 reg [1:0] dv_dly;
 
 always @ (posedge clk) begin
    hsync_dly <= {hsync_dly[1:0], rx_hs};
    vsync_dly <= {vsync_dly[1:0], rx_vs};
    dv_dly    <= {dv_dly[1:0], rx_dv};
 end

// Detect rising hsync edge
wire hsync_rise;
assign hsync_rise = (~hsync_dly[1] && rx_hs);

wire [ADDR_W - 1:0] addr;
 
addr_ctrl #(
    .ADDR_W(ADDR_W)
)
addr_module(
    .clk(clk),
    .hsync(hsync_rise),
    .addr(addr)
 );

wire [DATA_W - 1:0] shr_dout [4:0][4:0];
wire [DATA_W - 1:0] bram_dout [3:0];

genvar k;
generate
    for (k = 0; k < 5; k = k + 1) begin: inst
    if(k==0) begin
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
    else begin
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
            .DATA_W(DATA_W),
            .ADDR_W(ADDR_W)
        )bram_module(
            .clk_a(clk),
            .we_a(1'b1),
            .addr_a(addr),
            .din_a(pixel),
            .dout_a(),
            .clk_b(clk),
            .we_b(1'b0),
            .addr_b(addr),
            .din_b(),
            .dout_b(bram_dout[q])
        );
    end
    else begin: inst
        bram#(
            .DATA_W(DATA_W),
            .ADDR_W(ADDR_W)
        )bram_module(
            .clk_a(clk),
            .we_a(1'b1),
            .addr_a(addr),
            .din_a(shr_dout[q][0]),
            .dout_a(),
            .clk_b(clk),
            .we_b(1'b0),
            .addr_b(addr),
            .din_b(),
            .dout_b(bram_dout[q])
        );
    end
    end
endgenerate


genvar jj, ii;
generate
    for (jj = 0; jj < 5; jj = jj + 1) begin
        for (ii = 0; ii < 5; ii = ii + 1) begin
            assign kernel_red  [(5*jj+ii)*8 + 7: (5*jj+ii)*8] = shr_dout[jj][ii][23:16];
            assign kernel_green[(5*jj+ii)*8 + 7: (5*jj+ii)*8] = shr_dout[jj][ii][15:8]; 
            assign kernel_blue [(5*jj+ii)*8 + 7: (5*jj+ii)*8] = shr_dout[jj][ii][7:0];
        end
    end
endgenerate

endmodule
