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
wire [7:0] out;
wire [25*8-1:0] p;

//genvar i;
//generate
//   for (i = 25; i >= 0; i = i - 1) begin: gen_a
//        assign p[8*i+7:8*i] = i * 10;
//    end
//endgenerate

assign p[7:0] = 8'd195;
assign p[15:8] = 8'd77;
assign p[23:16] = 8'd97;
assign p[31:24] = 8'd162;
assign p[39:32] = 8'd132;
assign p[47:40] = 8'd119;
assign p[55:48] = 8'd97;
assign p[63:56] = 8'd162;
assign p[71:64] = 8'd156;
assign p[79:72] = 8'd32;
assign p[87:80] = 8'd131;
assign p[95:88] = 8'd94;
assign p[103:96] = 8'd30;
assign p[111:104] = 8'd72;
assign p[119:112] = 8'd143;
assign p[127:120] = 8'd77;
assign p[135:128] = 8'd237;
assign p[143:136] = 8'd80;
assign p[151:144] = 8'd52;
assign p[159:152] = 8'd236;
assign p[167:160] = 8'd56;
assign p[175:168] = 8'd215;
assign p[183:176] = 8'd95;
assign p[191:184] = 8'd124;
assign p[199:192] = 8'd187;
assign p[207:200] = 8'd172;
assign p[215:208] = 8'd245;
assign p[223:216] = 8'd224;
assign p[231:224] = 8'd136;
assign p[239:232] = 8'd83;
assign p[247:240] = 8'd242;
assign p[255:248] = 8'd115;

always #5 clk <= ~clk;


calculate_median #(
    .ELEMENT_NUM(25),
    .DATA_WIDTH(8)
) uut (
    .clk(clk),
    .pixels(p),
    .median(out)
);

endmodule