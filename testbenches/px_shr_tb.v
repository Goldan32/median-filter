`timescale 1ns / 1ps


module px_shr_tb();

reg clk = 0;
reg rst = 1;
reg [7:0] data = 0;
wire [7:0] dout [4:0];


always #5 clk = ~clk;

initial begin
    #100 rst = 0;
    #10 data = 8'd1;
    #10 data = 8'd2;
    #10 data = 8'd3;
    #10 data = 8'd4;
    #10 data = 8'd5;
    #10 data = 8'd6;
    #10 data = 8'd7;
    #10 data = 8'd8;
    
end

px_shr #(.DATA_W(8))px_shr_uut(
    .din(data),
    .clk(clk),
    .rst(rst),
    .data0(dout[0]),
    .data1(dout[1]),
    .data2(dout[2]),
    .data3(dout[3]),
    .data4(dout[4])
);


endmodule
