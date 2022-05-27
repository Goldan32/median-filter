`timescale 1ns / 1ps


module hdmi_buffer(
    input clk,
    input rst,
    
    input [7:0] rx_red,
    input [7:0] rx_green,
    input [7:0] rx_blue,
    input       rx_dv,
    input       rx_hs,
    input       rx_vs,
    
    output      tx_dv,
    output      tx_hs,
    output      tx_vs,
    output [7:0] kernel_red,
    output [7:0] kernel_green,
    output [7:0] kernel_blue
);

// Creating a line that can be stored in a BRAM record
reg [26:0] pixel;

always @ (posedge clk) begin
    if (rst) begin
        pixel <= 0;
    end else begin
        pixel <= {rx_dv, rx_vs, rx_hs, rx_red, rx_green, rx_blue};
    end    
end

// bram current address
wire [10:0] addr;

// reg array containing the current kernel
wire [26:0] shr_dout [4:0][4:0];

// output of bram modules
wire [26:0] bram_dout [3:0];

// delayed inputs of the pixel shiftregisters
// used for compensating bram delays
wire [26:0] pixel_delay [4:0];

addr_ctrl #(
    .ADDR_W(11)
) addr_module (
    .clk(clk),
    .rst(rst),
    .vsync(rx_vs),
    .hsync(rx_hs),
    .addr(addr)
);


// Instanciating 4 bram modules for 4 lines of pixels
genvar q;
generate
    for (q = 0; q < 4; q = q + 1) begin: inst_bram
        if (q == 0) begin
            bram #(
                .DATA_W(27),
                .ADDR_W(11)
            )(
                .clk(clk),
                .rst(rst),
                .we(1),
                .din(pixel),
                .addr(addr),
                .dout(bram_dout[q])
            );
        end else begin
            bram #(
                .DATA_W(27),
                .ADDR_W(11)
            )(
                .clk(clk),
                .rst(rst),
                .we(1),
                .din(bram_dout[q-1]),
                .addr(addr),
                .dout(bram_dout[q])
            ); 
        end
    end 
endgenerate


// Shiftregister to make delayed pixel signals
reg [26:0] delay_reg [3:0];
genvar u;
generate
    for (u = 0; u < 4; u = u + 1) begin: inst_delay
        if (u == 0) begin
            always @ (posedge clk) begin
                delay_reg[u] <= pixel;
            end
        end else begin
            always @ (posedge clk) begin
                delay_reg[u] <= delay_reg[u-1];
            end
        end
    end
endgenerate

assign pixel_delay[0] = delay_reg[3];
assign pixel_delay[1] = delay_reg[2];
assign pixel_delay[2] = delay_reg[1];
assign pixel_delay[3] = delay_reg[0];
assign pixel_delay[4] = pixel;

//Instanciating px_shr to store the kernel
genvar k;
generate
    for (k = 0; k < 5; k = k + 1) begin: inst_shr
        if(k==0) begin
            px_shr#(.DATA_W(27))shr(
                .clk(clk),
                .rst(rst),
                .din(pixel),
                .data0(shr_dout[k][0]),
                .data1(shr_dout[k][1]),
                .data2(shr_dout[k][2]),
                .data3(shr_dout[k][3]),
                .data4(shr_dout[k][4])
            );
        end else begin
            px_shr#(.DATA_W(27))shr(
                .clk(clk),
                .rst(rst),
                .din(bram_dout[k-1]),
                .data0(shr_dout[k][0]),
                .data1(shr_dout[k][1]),
                .data2(shr_dout[k][2]),
                .data3(shr_dout[k][3]),
                .data4(shr_dout[k][4])
            );
        end
    end
endgenerate




endmodule
