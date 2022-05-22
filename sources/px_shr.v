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
    input wire [23:0] din,
    input clk,
    input rst,
    output wire [23:0] data0,
    output wire [23:0] data1,
    output wire [23:0] data2,
    output wire [23:0] data3,
    output wire [23:0] data4
    );

reg [23:0] data_reg [4:0];

always @ (posedge clk) begin
    if (rst) begin
        data_reg[4] <= 24'd0;
    end else begin
        data_reg[4] <= din;
    end
end

genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin
        always @ (posedge clk) begin
            if (rst) begin
                data_reg[i] <= 24'd0;
            end else begin
                data_reg[i] <= data_reg[i+1];
            end
        end
    end
endgenerate

assign data0 = data_reg[0];
assign data1 = data_reg[1];
assign data2 = data_reg[2];
assign data3 = data_reg[3];
assign data4 = data_reg[4];

endmodule