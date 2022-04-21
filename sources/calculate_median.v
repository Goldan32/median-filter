`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Function:       Selects the median from p0 - p8
// Pipeline delay: 4 clk cycles
//
// Kernel:     p6 | p7 | p8
//             p5 | p0 | p1
//             p4 | p3 | p2
//
// With this nameing convention, the kernel can be expanded easily.
// 
//////////////////////////////////////////////////////////////////////////////////


module calculate_median(
    input  wire       clk,
    //input  wire       rst,

    input  wire [7:0] p0,
    input  wire [7:0] p1,
    input  wire [7:0] p2,
    input  wire [7:0] p3,
    input  wire [7:0] p4,
    input  wire [7:0] p5,
    input  wire [7:0] p6,
    input  wire [7:0] p7,
    input  wire [7:0] p8,
    
    output wire [7:0] median

);

// Registers for 3 pipeline phases
// p0 is only used at the last stage
reg [7:0] stage1_reg [7:0];
reg [7:0] stage2_reg [7:0];
reg [7:0] stage3_reg [7:0];
reg [7:0] median_reg;

wire [7:0] step1 [7:0];
wire [7:0] step2 [7:0];
wire [7:0] step3 [7:0];
// Stages: Each stage performs 2 steps
// Stage 1

assign step1[0] = (p1 < p2) ? p1 : p2;
assign step1[1] = (p1 < p2) ? p2 : p1;
assign step1[2] = (p3 < p4) ? p4 : p3;
assign step1[3] = (p3 < p4) ? p3 : p4;
assign step1[4] = (p5 < p6) ? p5 : p6;
assign step1[5] = (p5 < p6) ? p6 : p5;
assign step1[6] = (p7 < p8) ? p8 : p7;
assign step1[7] = (p7 < p8) ? p7 : p8;

always @ (posedge clk) begin
    if (step1[0] < step1[2]) begin
        stage1_reg[0] <= step1[0];
        stage1_reg[2] <= step1[2];
    end else begin
        stage1_reg[0] <= step1[2];
        stage1_reg[2] <= step1[0];
    end
    
    if (step1[1] < step1[3]) begin
        stage1_reg[1] <= step1[1];
        stage1_reg[3] <= step1[3];
    end else begin
        stage1_reg[1] <= step1[3];
        stage1_reg[3] <= step1[1];
    end
    
    if (step1[4] < step1[6]) begin
        stage1_reg[4] <= step1[6];
        stage1_reg[6] <= step1[4];
    end else begin
        stage1_reg[4] <= step1[4];
        stage1_reg[6] <= step1[6];
    end
    
    if (step1[5] < step1[7]) begin
        stage1_reg[5] <= step1[7];
        stage1_reg[7] <= step1[5];
    end else begin
        stage1_reg[5] <= step1[5];
        stage1_reg[7] <= step1[7];
    end

end

// Stage 2
assign step2[0] = (stage1_reg[0] < stage1_reg[1]) ? stage1_reg[0] : stage1_reg[1];
assign step2[1] = (stage1_reg[0] < stage1_reg[1]) ? stage1_reg[1] : stage1_reg[0];
assign step2[2] = (stage1_reg[2] < stage1_reg[3]) ? stage1_reg[2] : stage1_reg[3];
assign step2[3] = (stage1_reg[2] < stage1_reg[3]) ? stage1_reg[3] : stage1_reg[2];
assign step2[4] = (stage1_reg[4] < stage1_reg[5]) ? stage1_reg[5] : stage1_reg[4];
assign step2[5] = (stage1_reg[4] < stage1_reg[5]) ? stage1_reg[4] : stage1_reg[5];
assign step2[6] = (stage1_reg[6] < stage1_reg[7]) ? stage1_reg[7] : stage1_reg[6];
assign step2[7] = (stage1_reg[6] < stage1_reg[7]) ? stage1_reg[6] : stage1_reg[7];

always @ (posedge clk) begin
    if (step2[0] < step2[4]) begin
        stage2_reg[0] <= step2[0];
        stage2_reg[4] <= step2[4];
    end else begin
        stage2_reg[0] <= step2[4];
        stage2_reg[4] <= step2[0];
    end
    
    if (step2[1] < step2[5]) begin
        stage2_reg[1] <= step2[1];
        stage2_reg[5] <= step2[5];
    end else begin
        stage2_reg[1] <= step2[5];
        stage2_reg[5] <= step2[1];
    end
    
    if (step2[2] < step2[6]) begin
        stage2_reg[2] <= step2[2];
        stage2_reg[6] <= step2[6];
    end else begin
        stage2_reg[2] <= step2[6];
        stage2_reg[6] <= step2[2];
    end
    
    if (step2[3] < step2[7]) begin
        stage2_reg[3] <= step2[3];
        stage2_reg[7] <= step2[7];
    end else begin
        stage2_reg[3] <= step2[7];
        stage2_reg[7] <= step2[3];
    end
end

// Stage3
assign step3[0] = (stage2_reg[0] < stage2_reg[2]) ? stage2_reg[0] : stage2_reg[2];
assign step3[2] = (stage2_reg[0] < stage2_reg[2]) ? stage2_reg[2] : stage2_reg[0];
assign step3[1] = (stage2_reg[1] < stage2_reg[3]) ? stage2_reg[1] : stage2_reg[3];
assign step3[3] = (stage2_reg[1] < stage2_reg[3]) ? stage2_reg[3] : stage2_reg[1];
assign step3[4] = (stage2_reg[4] < stage2_reg[6]) ? stage2_reg[4] : stage2_reg[6];
assign step3[6] = (stage2_reg[4] < stage2_reg[6]) ? stage2_reg[6] : stage2_reg[4];
assign step3[5] = (stage2_reg[5] < stage2_reg[7]) ? stage2_reg[5] : stage2_reg[7];
assign step3[7] = (stage2_reg[5] < stage2_reg[7]) ? stage2_reg[7] : stage2_reg[5];

always @ (posedge clk) begin
    if (step3[0] < step3[1]) begin
        stage3_reg[0] <= step3[0];
        stage3_reg[1] <= step3[1];
    end else begin
        stage3_reg[0] <= step3[1];
        stage3_reg[1] <= step3[0];
    end
    
    if (step3[2] < step3[3]) begin
        stage3_reg[2] <= step3[2];
        stage3_reg[3] <= step3[3];
    end else begin
        stage3_reg[2] <= step3[3];
        stage3_reg[3] <= step3[2];
    end
    
    if (step3[4] < step3[5]) begin
        stage3_reg[4] <= step3[4];
        stage3_reg[5] <= step3[5];
    end else begin
        stage3_reg[4] <= step3[5];
        stage3_reg[5] <= step3[4];
    end
    
    if (step3[6] < step3[7]) begin
        stage3_reg[6] <= step3[6];
        stage3_reg[7] <= step3[7];
    end else begin
        stage3_reg[6] <= step3[7];
        stage3_reg[7] <= step3[6];
    end
end

// Delay p0 parralell with pipeline
reg [7:0] p0_shreg [2:0];
integer i;

always @ (posedge clk) begin
    p0_shreg[0] <= p0;
    for (i = 2; i > 0; i = i - 1) begin
        p0_shreg[i] <= p0_shreg[i - 1];
    end
end

// Selecting the median, p0 is taken into consideration
always @ (posedge clk) begin
    if (stage3_reg[3] > p0_shreg[2]) begin
        median_reg <= stage3_reg[3];
    end else if (stage3_reg[4] < p0_shreg[2]) begin
        median_reg <= stage3_reg[4];
    end else begin
        median_reg <= p0_shreg[2];
    end
end

// Set output
assign median = median_reg;

endmodule
