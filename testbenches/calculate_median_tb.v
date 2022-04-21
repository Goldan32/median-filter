`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2022 11:25:02 PM
// Design Name: 
// Module Name: calculate_median_tb
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


module calculate_median_tb();

reg clk = 1;
always #5 clk <= ~clk;

wire [7:0] d0 = 8'd10;
wire [7:0] d1 = 8'd20;
wire [7:0] d2 = 8'd30;
wire [7:0] d3 = 8'd40;
wire [7:0] d4 = 8'd50;
wire [7:0] d5 = 8'd60;
wire [7:0] d6 = 8'd70;
wire [7:0] d7 = 8'd80;
wire [7:0] d8 = 8'd90;

wire [7:0] out;

calculate_median uut(
    .clk(clk),
    .p0(d0),
    .p1(d1),
    .p2(d2),
    .p3(d3),
    .p4(d4),
    .p5(d5),
    .p6(d6),
    .p7(d7),
    .p8(d8),
    .median(out)
);


endmodule
