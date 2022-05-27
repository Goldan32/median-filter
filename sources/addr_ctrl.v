`timescale 1ns / 1ps


module addr_ctrl#(
    parameter ADDR_W = 11
)(
    input clk,
    input rst,
    input vsync,
    input hsync,
    output [ADDR_W-1:0] addr
);

reg [ADDR_W-1:0] addr_reg;

always @ (posedge clk) begin
    if (rst | hsync) begin
        addr_reg <= 0;
    end else begin
        addr_reg <= addr_reg + 1;
    end
end

assign addr = addr_reg;

endmodule
