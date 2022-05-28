`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2022 06:36:13 PM
// Design Name: 
// Module Name: bram
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
//  log2 2048 - 11
//////////////////////////////////////////////////////////////////////////////////


module bram#(
   parameter DATA_W = 24,
   parameter ADDR_W = 11
)(
   input                 clk,
   input                 we,
   input  [ADDR_W - 1:0] rd_addr,
   input  [ADDR_W - 1:0] wr_addr,
   input  [DATA_W - 1:0] din,
   output [DATA_W - 1:0] dout
   );
    
(* ram_style = "block" *) reg [DATA_W-1:0] ram_array[(2**ADDR_W)-1:0];
integer i;
initial
   for (i=0; i<(2**ADDR_W); i=i+1) ram_array[i] = 0;

reg [DATA_W-1:0] dout_reg;
always @ (posedge clk)
begin
   if (we) ram_array[wr_addr] <= din;
   dout_reg <= ram_array[rd_addr];
end
assign dout = dout_reg;

endmodule