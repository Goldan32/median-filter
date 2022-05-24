`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2022 04:37:05 PM
// Design Name: 
// Module Name: hdmi_buffer_tb
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


module hdmi_buffer_tb(
    );
    
    reg clk = 1;
    always #5 clk <= ~clk;
    
    wire [2:0] addr;
    wire [2:0] width;
    
    reg rx_vs = 0;
    reg rx_hs = 0;
    reg rst = 1;
    
    reg [1:0] pixel = 0;
    reg data_valid = 0;
    wire [1:0] dout;
    
    initial begin
    #22 rst <= 0;
    #70 rx_hs <= 1;
    #10 rx_hs <= 0;
    #70 rx_hs <= 1;
    #10 rx_hs <= 0;
    #70 rx_hs <= 1;
    #10 rx_hs <= 0;
    #70 rx_hs <= 1;
    #10 rx_hs <= 0;
    #70 rx_vs <= 1;
    #10 rx_vs <= 0;
    end
    
    initial begin
#22 rst <= 0;
#5 data_valid = 1;
    pixel = 2;
#5 data_valid = 0;
#5 data_valid = 1;
    pixel = 3;
#5 data_valid = 0;
#5 data_valid = 1;
    pixel = 0;
#5 data_valid = 0;
#5 data_valid = 1;
    pixel = 3;
#5 data_valid = 0;
#5 data_valid = 1;
    pixel = 0;
#5 data_valid = 0;
#5 data_valid = 1;
    pixel = 1;
#5 data_valid = 0;
#5 data_valid = 1;
    pixel = 0;
#5 data_valid = 0;
#5 data_valid = 1;
    pixel = 3;
#5 data_valid = 0;
#5 data_valid = 1;
    pixel = 0;
#5 data_valid = 0;
#5 data_valid = 1;
    pixel = 3;
#5 data_valid = 0;
#5 data_valid = 1;
    pixel = 0;
#5 data_valid = 0;
end
    
    addr_ctrl #
    (.ADDR_W(3)) 
    uut_addr_ctrl(
    .clk(clk),
    .rst(rst),
    .vsync(rx_vs),
    .hsync(rx_hs),
    .addr(addr),
    .width(width)
);

    bram#
    (.DATA_W(2),.ADDR_W(3))
    uut_bram(
    .clk_a(clk),
    .we_a((data_valid != 0)),
    .addr_a(addr),
    .din_a(pixel),
    .dout_a(),
    .clk_b(clk),
    .we_b(1'b0),
    .addr_b(addr),
    .din_b(),
    .dout_b(dout)
);


endmodule
