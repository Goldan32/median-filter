`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2022 09:12:37 PM
// Design Name: 
// Module Name: px_shr
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


module px_shr(
    input din,
    input clk,
    input rst,
    output wire dout,
    output reg [23:0] data [4:0]
    );

always @ (posedge clk)
begin
if(rst)
    begin
    data <= 5'd0;
    end
else
    begin
    data <= {din, data[4:1]};
    end
end

assign data = data[0];

endmodule
