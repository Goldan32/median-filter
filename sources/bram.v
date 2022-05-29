`timescale 1ns / 1ps


module bram#(
    parameter DATA_W = 24,
    parameter ADDR_W = 12
)(
    input               clk,
    input               we,
    input  [ADDR_W-1:0] addr,
    input  [DATA_W-1:0] din,
    output [DATA_W-1:0] dout
    );
    
(* ram_style = "block" *) reg [DATA_W-1:0] ram_array[(2**ADDR_W)-1:0];
integer i;
initial
   for (i=0; i<(2**ADDR_W); i=i+1) ram_array[i] = 0;

reg [DATA_W-1:0] dout_reg;
always @ (posedge clk)
begin
   if (we) ram_array[addr] <= din;
   dout_reg <= ram_array[addr];
end

assign dout = dout_reg;

endmodule
