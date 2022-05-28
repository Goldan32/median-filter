`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2022 04:17:25 PM
// Design Name: 
// Module Name: addr_ctrl
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


module addr_ctrl#(
    parameter ADDR_W = 11
)(
    input clk,
    input rst,
    input hsync,
    output [ADDR_W-1:0] addr
    );

// Address counter    
reg [ADDR_W-1:0] addr_reg;

always @ (posedge clk) begin
    if(rst | hsync) begin
        addr_reg <= 0;
    end else begin
        addr_reg <= addr_reg + 1;
    end
end

assign addr = addr_reg;

endmodule
