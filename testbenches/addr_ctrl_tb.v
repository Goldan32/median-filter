`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2022 06:11:10 PM
// Design Name: 
// Module Name: addr_ctrl_tb
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


module addr_ctrl_tb();

reg clk = 1;
always #5 clk <= ~clk;

wire [10:0] addr;
wire [10:0] width;
reg rx_vs = 0;
reg rx_hs = 0;
reg rst = 1;

initial begin
#22 rst <= 0;
#100 rx_hs <= 1;
#5 rx_hs <= 0;
#100 rx_hs <= 1;
#5 rx_hs <= 0;
#100 rx_hs <= 1;
#5 rx_hs <= 0;
#100 rx_hs <= 1;
#5 rx_vs <= 0;
rx_vs <= 1;
#5 rx_vs <= 0;
end

addr_ctrl #(.ADDR_W(11)) uut_addr_ctrl(
    .clk(clk),
    .rst(rst),
    .vsync(rx_vs),
    .hsync(rx_hs),
    .addr(addr),
    .width(width)
);





endmodule
