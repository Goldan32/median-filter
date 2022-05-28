`timescale 1ns / 1ps


module hdmi_buffer_tb();

wire [7:0] tx_red, tx_green, tx_blue;
wire tx_dv, tx_hs, tx_vs;

reg clk = 0;
always #5 clk = ~clk;

reg rst = 1;
reg [7:0] rx_red = 11;
reg [7:0] rx_green = 22;
reg [7:0] rx_blue = 33;
reg rx_dv = 1;
reg rx_hs = 0;
reg rx_vs = 0;


initial begin
    #100  rst = 0;
    #1000 rx_hs = 1;
    #10   rx_hs = 0;
    #1000 rx_hs = 1;
    #10   rx_hs = 0;
    #1000 rx_hs = 1;
    #10   rx_hs = 0;
    #1000 rx_hs = 1;
    #10   rx_hs = 0;
    #1000 rx_hs = 1;
    #10   rx_hs = 0;
    #1000 rx_hs = 1;
    #10   rx_hs = 0;
    #1000 rx_hs = 1;
    #10   rx_hs = 0;
    #1000 rx_hs = 1;
    #10   rx_hs = 0;
    #1000 rx_hs = 1;
    #10   rx_hs = 0;
    #1000 rx_hs = 1;
          rx_vs = 1;
    #10   rx_hs = 0;
          rx_vs = 0;
    #1000 rx_hs = 1;
    #10   rx_hs = 0;
    #1000 rx_hs = 1;
    #10   rx_hs = 0;
    #1000 rx_hs = 1;
    #10   rx_hs = 0;
    #1000 rx_hs = 1;
    #10   rx_hs = 0;
    #1000 rx_hs = 1;
    #10   rx_hs = 0;
    #1000 rx_hs = 1;
    #10   rx_hs = 0;
    #1000 rx_hs = 1;
    #10   rx_hs = 0;
    #1000 rx_hs = 1;
    #10   rx_hs = 0;
    #1000 rx_hs = 1;
    #10   rx_hs = 0;

end

hdmi_buffer hdmi_buffer_uut(
    .clk(clk),
    .rst(rst),
    .rx_red(rx_red),
    .rx_green(rx_green),
    .rx_blue(rx_blue),
    .rx_hs(rx_hs),
    .rx_vs(rx_vs),
    .rx_dv(rx_dv),

    .tx_red(tx_red),
    .tx_green(tx_green),
    .tx_blue(tx_blue),
    .tx_hs(tx_hs),
    .tx_vs(tx_vs),
    .tx_dv(tx_dv)
);


endmodule
