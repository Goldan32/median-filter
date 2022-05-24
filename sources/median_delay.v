`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2022 07:58:42 PM
// Design Name: 
// Module Name: median_delay
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
//vs hs dv
//msb..lsb
module median_delay(
        input  wire clk,
        input  wire vs_in,
        input  wire hs_in,
        input  wire dv_in,
        output wire vs_out,
        output wire hs_out,
        output wire dv_out
    );

reg [15:0] shr_vs;
reg [15:0] shr_hs;
reg [15:0] shr_dv;

always @ (posedge clk) begin
    shr_vs <= {shr_vs[14:0], vs_in};
    shr_hs <= {shr_hs[14:0], hs_in};
    shr_dv <= {shr_dv[14:0], dv_in};
end

assign vs_out = shr_vs[15];
assign hs_out = shr_hs[15];
assign dv_out = shr_dv[15];

endmodule
