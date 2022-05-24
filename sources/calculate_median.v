`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Function:       Selects the median from 25 8 bit pixel values
// Pipeline delay: x clk cycles
//
// 
//////////////////////////////////////////////////////////////////////////////////

module calculate_median
#(
    parameter ELEMENT_NUM = 25, // Kernel size here
    parameter DATA_WIDTH = 8   // 1 pixel is stored in 8 bits
)
(
    input  wire                              clk,
    input  wire [DATA_WIDTH*ELEMENT_NUM-1:0] pixels,
    output wire [DATA_WIDTH-1:0]             median
);

// A full bitonic array would be this long
localparam LOG_FULL_BITONIC_LENGTH = $clog2(ELEMENT_NUM);
localparam FULL_BITONIC_LENGTH     = 2 ** LOG_FULL_BITONIC_LENGTH;

// Number of pipeline levels
localparam COL_NUM = (((1 + LOG_FULL_BITONIC_LENGTH) * LOG_FULL_BITONIC_LENGTH)/2) + 1;

// Storing all pixel values currently in the pipeline
reg [DATA_WIDTH-1:0] bank [COL_NUM-1:0] [ELEMENT_NUM-1:0];

// Sample the input wires into a register
genvar ii;
generate
    for (ii = 0; ii < ELEMENT_NUM; ii = ii+1) begin
        always @ (posedge clk) begin: gen_first_level
            bank[0][ii] <= pixels[ii*DATA_WIDTH + DATA_WIDTH-1: ii*DATA_WIDTH];
        end
    end
endgenerate


genvar i, k, l, j;
generate
    for (k = 2; k <= FULL_BITONIC_LENGTH; k = k*2) begin
        localparam marker = $clog2(k);
        for (j = k/2; j > 0; j = j/2) begin
            localparam col = (((1 + (marker - 1)) * (marker - 1)) / 2) + (marker - $clog2(j));
            for (i = 0; i < FULL_BITONIC_LENGTH; i = i + 1) begin
                localparam l = (j == (k/2)) ? i^((2 ** marker) - 1) : i^j;
                if (l > i) begin
                    if (l < ELEMENT_NUM) begin
                        always @ (posedge clk) begin: gen_b
                            $display(l, i, col);
                            if (bank[col-1][i] > bank[col-1][l]) begin
                                bank[col][i] <= bank[col-1][l];
                                bank[col][l] <= bank[col-1][i];
                            end else begin
                                bank[col][i] <= bank[col-1][i];
                                bank[col][l] <= bank[col-1][l];
                            end
                        end
                    end else begin
                        always @ (posedge clk) begin: gen_remaining
                            $display(i, l, col, 666);
                            bank[col][i] <= bank[col-1][i];
                        end
                    end
                end
            end
        end
    end
endgenerate

reg [DATA_WIDTH-1:0] median_reg;

generate
    if (LOG_FULL_BITONIC_LENGTH[0]) begin
        always @ (posedge clk) begin
            median_reg <= bank[COL_NUM-1][ELEMENT_NUM/2];
        end
    end else begin
        always @ (posedge clk) begin
            median_reg <= ((bank[COL_NUM-1][ELEMENT_NUM/2])
                          + (bank[COL_NUM-1][ELEMENT_NUM/2 + 1]))
                          >> 1;
        end
    end
endgenerate

assign median = median_reg;

endmodule
