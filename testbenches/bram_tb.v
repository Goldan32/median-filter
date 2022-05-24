`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2022 03:05:59 PM
// Design Name: 
// Module Name: bram_tb
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


module bram_tb();

reg clk = 1;
always #5 clk <= ~clk;

reg [2:0] addr = 0;
reg [1:0] pixel = 3;
reg data_valid = 0;
wire [1:0] dout;
reg rst = 1;

initial begin
#25 rst <= 0;
#5 data_valid = 1;
    pixel = 1;
#5 data_valid = 0;
#5 data_valid = 1;
    pixel = 2;
#5 data_valid = 0;
#5 data_valid = 1;
    pixel = 1;
#5 data_valid = 0;
#5 data_valid = 1;
    pixel = 2;
#5 data_valid = 0;
#5 data_valid = 1;
    pixel = 1;
#5 data_valid = 0;
#5 data_valid = 1;
    pixel = 2;
#5 data_valid = 0;
#5 data_valid = 1;
    pixel = 1;
#5 data_valid = 0;
#5 data_valid = 1;
    pixel = 3;
#5 data_valid = 0;
#5 data_valid = 1;
    pixel = 2;
#5 data_valid = 0;
#5 data_valid = 1;
    pixel = 3;
#5 data_valid = 0;
#5 data_valid = 1;
    pixel = 2;
#5 data_valid = 0;

end

always @ (posedge clk) begin
    if(rst)
        addr <= 0;
    else
        addr <= addr + 1;
end

bram#(
            .DATA_W(2),
            .ADDR_W(3)
        )uut_bram(
            .clk_a(clk),
            .we_a((data_valid != 0)),
            .addr_a(addr),
            .din_a(pixel),
            .dout_a(),
            .clk_b(clk),
            .we_b(1'b0),
            .addr_b(addr),
            .din_b(),
            .dout_b(dout)
        );

endmodule
