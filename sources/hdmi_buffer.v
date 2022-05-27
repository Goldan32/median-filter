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
    
    output       tx_dv,
    output       tx_hs,
    output       tx_vs,
    output [7:0] tx_red,
    output [7:0] tx_green,
    output [7:0] tx_blue
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

// Control signals delays
wire [2:0] control;
wire [2:0] control_delay;

// pixels in the kernel packaged by color
wire [25*8-1:0] kernel_red;
wire [25*8-1:0] kernel_green;
wire [25*8-1:0] kernel_blue;

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
                .we(1),
                .din(bram_dout[q-1]),
                .addr(addr),
                .dout(bram_dout[q])
            ); 
        end
    end 
endgenerate


// Shiftregisters to make delayed pixel signals
line_delay #(
    .DATA_W(27),
    .DELAY(4)
)dl4(
    .clk(clk),
    .value_in(pixel),
    .value_out(pixel_delay[0])
);

line_delay #(
    .DATA_W(27),
    .DELAY(3)
)dl3(
    .clk(clk),
    .value_in(bram_dout[0]),
    .value_out(pixel_delay[1])
);

line_delay #(
    .DATA_W(27),
    .DELAY(2)
)dl2(
    .clk(clk),
    .value_in(bram_dout[1]),
    .value_out(pixel_delay[2])
);

line_delay #(
    .DATA_W(27),
    .DELAY(1)
)dl1(
    .clk(clk),
    .value_in(bram_dout[2]),
    .value_out(pixel_delay[3])
);

assign pixel_delay[4] = bram_dout[3];

//Instanciating px_shr to store the kernel
genvar k;
generate
    for (k = 0; k < 5; k = k + 1) begin: inst_shr
        px_shr#(.DATA_W(27))shr(
            .clk(clk),
            .rst(rst),
            .din(pixel_delay[k]),
            .data0(shr_dout[k][0]),
            .data1(shr_dout[k][1]),
            .data2(shr_dout[k][2]),
            .data3(shr_dout[k][3]),
            .data4(shr_dout[k][4])
        );
    end
endgenerate

// Package kernel pixels for the median filter
genvar jj, ii;
generate
    for (jj = 0; jj < 5; jj = jj + 1) begin: gen_row
        for (ii = 0; ii < 5; ii = ii + 1) begin: gen_col
            assign kernel_red  [(5*jj+ii)*8 + 7: (5*jj+ii)*8] = shr_dout[jj][ii][23:16];
            assign kernel_green[(5*jj+ii)*8 + 7: (5*jj+ii)*8] = shr_dout[jj][ii][15:8]; 
            assign kernel_blue [(5*jj+ii)*8 + 7: (5*jj+ii)*8] = shr_dout[jj][ii][7:0];
        end
    end
endgenerate


// Instenciate median filter 3 times for 3 colors
calculate_median #(
    .ELEMENT_NUM(25),
    .DATA_WIDTH(8)
) median_red (
    .clk(clk),
    .pixels(kernel_red),
    .median(tx_red)
);

calculate_median #(
    .ELEMENT_NUM(25),
    .DATA_WIDTH(8)
) median_blue (
    .clk(clk),
    .pixels(kernel_green),
    .median(tx_blue)
);

calculate_median #(
    .ELEMENT_NUM(25),
    .DATA_WIDTH(8)
) median_green (
    .clk(clk),
    .pixels(kernel_blue),
    .median(tx_blue)
);


// Compensating for delay of median filter in control signals
assign control = shr_dout[2][2][26:24];

line_delay #(
    .DATA_W(3),
    .DELAY(16)
)(
    .clk(clk),
    .value_in(control),
    .value_out(control_delay)
);

assign tx_hs = shr_dout[2][2][26];//control_delay[0];
assign tx_vs = shr_dout[2][2][25];//control_delay[1];
assign tx_dv = shr_dout[2][2][26];//control_delay[2];



endmodule
