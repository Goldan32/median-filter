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
    input hsync,
    output [ADDR_W - 1:0] rd_addr,
    output [ADDR_W - 1:0] wr_addr
    );

// Address counter    
reg [ADDR_W-1:0] rd_addr_reg;
reg [ADDR_W-1:0] wr_addr_reg;
always @ (posedge clk) begin
    wr_addr_reg <= rd_addr_reg; 
end

always @ (posedge clk) begin
    if(hsync) begin
        rd_addr_reg <= 0;
    end else begin
        rd_addr_reg <= rd_addr_reg + 1;
    end
end

assign rd_addr = rd_addr_reg;
assign wr_addr = wr_addr_reg;

endmodule
