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
    input vsync,
    input hsync,
    output [ADDR_W-1:0] addr,
    output [ADDR_W-1:0] width
    );

// Determine length of line
reg [ADDR_W-1:0] width_reg = 2047; 
reg [ADDR_W-1:0] width_cntr;
always @(posedge clk) begin
    if(rst || vsync) begin
        width_reg <= 2047;
        width_cntr <= 0;
    end
    else if(hsync) begin
        width_reg <= width_cntr;
        width_cntr <= 0;
    end
    else begin
        width_cntr <= width_cntr + 1;
    end
end

assign width = width_reg;

// Address counter    
reg [ADDR_W-1:0] addr_reg;

always @ (posedge clk) begin
    if(rst || vsync) begin
        addr_reg <= 0;
    end
    else if(addr_reg == width_reg || hsync) begin
        addr_reg <= 0;
    end
    else begin
        addr_reg <= addr_reg + 1;
    end
end

assign addr = addr_reg;
endmodule
