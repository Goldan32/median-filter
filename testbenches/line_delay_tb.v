`timescale 1ns / 1ps


module line_delay_tb(

    );


reg clk = 0;
reg [7:0] color;
wire [7:0] owire;

always #5 clk = ~clk;

initial begin
    #10 color = 8'd11;
    #10 color = 8'd22;
    #10 color = 8'd33;
    #10 color = 8'd44;
    #10 color = 8'd55;
    #10 color = 8'd66;
    #10 color = 8'd77;
end

line_delay #(
    .DATA_W(8),
    .DELAY(4)
)line_delay_uut(
    .clk(clk),
    .value_in(color),
    .value_out(owire)
);

endmodule
