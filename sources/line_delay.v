`timescale 1ns / 1ps

// value out matches value in but is delayed
module line_delay #(
    parameter DATA_W = 27,
    parameter DELAY = 1
)(
    input clk,
    input [DATA_W-1:0] value_in,
    output [DATA_W-1:0] value_out
);

reg [DATA_W-1:0] delay_reg [DELAY-1:0];
genvar u;
generate
    for (u = 0; u < DELAY; u = u + 1) begin: inst_delay
        if (u == 0) begin
            always @ (posedge clk) begin
                delay_reg[u] <= value_in;
            end
        end else begin
            always @ (posedge clk) begin
                delay_reg[u] <= delay_reg[u-1];
            end
        end
    end
endgenerate

assign value_out = delay_reg[DELAY-1];

endmodule
