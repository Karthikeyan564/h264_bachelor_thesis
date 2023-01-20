`timescale 1ns / 1ps

module intraloop #(
    parameter WIDTH = 1280,
    parameter LENGTH = 720,
    parameter QP = 2)(
    input clk,
    input reset,
    input enable,
    input [7:0] reconstructed_luma [WIDTH*LENGTH-1:0],
    input [7:0] reconstructed_chb [WIDTH*LENGTH-1:0],
    input [7:0] reconstructed_chr [WIDTH*LENGTH-1:0],
    input [31:0] mbnumber_luma4x4, mbnumber_chromab8x8, mbnumber_chromar8x8,
    output fb_luma4x4, fb_chromab8x8, fb_chromar8x8,
    output [7:0] reconst_luma4x4 [15:0], reconst_chromab8x8 [63:0], reconst_chromar8x8 [63:0]);
    
    // Enable Register
    reg [8:0] enabler = 9'd0;
    reg lastbit, first;
//  0 -> Extractor NP
//  1 -> Extractor MB and Moder
//  2 -> Reser
//  3 -> Sader
//  4 -> Decider
//  5 -> Forward Transform
//  6 -> Forward Quantize
//  7 -> Inverse Quantize
//  8 -> Inverse Transform and Extractor NP
//  9 -> PredAdder (and Saver)

    initial begin
        first = 1;
        lastbit = 0;
    end
    
    genvar i;
    
    wire [2:0] mode_luma4x4;
	wire [2:0] mode_chromab8x8;
	wire [2:0] mode_chromar8x8;
	
	wire signed [7:0] res_luma4x4 [0:15];
	wire signed [7:0] res_chromab8x8 [0:63];
	wire signed [7:0] res_chromar8x8 [0:63];
	
	reg signed [7:0] res_chromab8x8_quadrants [3:0][15:0];
	reg signed [7:0] res_chromar8x8_quadrants [3:0][15:0];
    
    wire signed [7:0] processedres_luma4x4 [0:15];
    reg signed [7:0] processedres_chromab8x8 [0:63];
    reg signed [7:0] processedres_chromar8x8 [0:63];
    
    wire signed [7:0] processedres_chromab8x8_quadrants [3:0][15:0];
    wire signed [7:0] processedres_chromar8x8_quadrants [3:0][15:0];
    
    always @ (negedge clk) begin
    
        // Forward map Chroma components
	   res_chromab8x8_quadrants[0] <= {res_chromab8x8[0:3], res_chromab8x8[8:11], res_chromab8x8[16:19], res_chromab8x8[24:27]};
	   res_chromab8x8_quadrants[1] <= {res_chromab8x8[4:7], res_chromab8x8[12:15], res_chromab8x8[20:23], res_chromab8x8[28:31]};
	   res_chromab8x8_quadrants[2] <= {res_chromab8x8[32:35], res_chromab8x8[40:43], res_chromab8x8[48:51], res_chromab8x8[56:59]};
	   res_chromab8x8_quadrants[3] <= {res_chromab8x8[36:39], res_chromab8x8[44:47], res_chromab8x8[52:55], res_chromab8x8[60:63]};
	   
	   res_chromar8x8_quadrants[0] <= {res_chromar8x8[0:3], res_chromar8x8[8:11], res_chromar8x8[16:19], res_chromar8x8[24:27]};
	   res_chromar8x8_quadrants[1] <= {res_chromar8x8[4:7], res_chromar8x8[12:15], res_chromar8x8[20:23], res_chromar8x8[28:31]};
	   res_chromar8x8_quadrants[2] <= {res_chromar8x8[32:35], res_chromar8x8[40:43], res_chromar8x8[48:51], res_chromar8x8[56:59]};
	   res_chromar8x8_quadrants[3] <= {res_chromar8x8[36:39], res_chromar8x8[44:47], res_chromar8x8[52:55], res_chromar8x8[60:63]};
	   
	   // Reverse map Chroma components
	   processedres_chromab8x8[0:3] <= processedres_chromab8x8_quadrants[0][15:12];
	   processedres_chromab8x8[8:11] <= processedres_chromab8x8_quadrants[0][11:8];
	   processedres_chromab8x8[16:19] <= processedres_chromab8x8_quadrants[0][7:4];
	   processedres_chromab8x8[24:27] <= processedres_chromab8x8_quadrants[0][3:0];
	   
	   processedres_chromab8x8[4:7] <= processedres_chromab8x8_quadrants[1][15:12];
	   processedres_chromab8x8[12:15] <= processedres_chromab8x8_quadrants[1][11:8];
	   processedres_chromab8x8[20:23] <= processedres_chromab8x8_quadrants[1][7:4];
	   processedres_chromab8x8[28:31] <= processedres_chromab8x8_quadrants[1][3:0];
	   
	   processedres_chromab8x8[32:35] <= processedres_chromab8x8_quadrants[2][15:12];
	   processedres_chromab8x8[40:43] <= processedres_chromab8x8_quadrants[2][11:8];
	   processedres_chromab8x8[48:51] <= processedres_chromab8x8_quadrants[2][7:4];
	   processedres_chromab8x8[56:59] <= processedres_chromab8x8_quadrants[2][3:0];
	   
	   processedres_chromab8x8[36:39] <= processedres_chromab8x8_quadrants[3][15:12];
	   processedres_chromab8x8[44:47] <= processedres_chromab8x8_quadrants[3][11:8];
	   processedres_chromab8x8[52:55] <= processedres_chromab8x8_quadrants[3][7:4];
	   processedres_chromab8x8[60:63] <= processedres_chromab8x8_quadrants[3][3:0];
	   
	   processedres_chromar8x8[0:3] <= processedres_chromar8x8_quadrants[0][15:12];
	   processedres_chromar8x8[8:11] <= processedres_chromar8x8_quadrants[0][11:8];
	   processedres_chromar8x8[16:19] <= processedres_chromar8x8_quadrants[0][7:4];
	   processedres_chromar8x8[24:27] <= processedres_chromar8x8_quadrants[0][3:0];
	   
	   processedres_chromar8x8[4:7] <= processedres_chromar8x8_quadrants[1][15:12];
	   processedres_chromar8x8[12:15] <= processedres_chromar8x8_quadrants[1][11:8];
	   processedres_chromar8x8[20:23] <= processedres_chromar8x8_quadrants[1][7:4];
	   processedres_chromar8x8[28:31] <= processedres_chromar8x8_quadrants[1][3:0];
	   
	   processedres_chromar8x8[32:35] <= processedres_chromar8x8_quadrants[2][15:12];
	   processedres_chromar8x8[40:43] <= processedres_chromar8x8_quadrants[2][11:8];
	   processedres_chromar8x8[48:51] <= processedres_chromar8x8_quadrants[2][7:4];
	   processedres_chromar8x8[56:59] <= processedres_chromar8x8_quadrants[2][3:0];
	   
	   processedres_chromar8x8[36:39] <= processedres_chromar8x8_quadrants[3][15:12];
	   processedres_chromar8x8[44:47] <= processedres_chromar8x8_quadrants[3][11:8];
	   processedres_chromar8x8[52:55] <= processedres_chromar8x8_quadrants[3][7:4];
	   processedres_chromar8x8[60:63] <= processedres_chromar8x8_quadrants[3][3:0];
	   
    end
    
    intrapred #(.WIDTH(WIDTH), .LENGTH(LENGTH)) uintrapred (
        .clk(clk),
        .reset(reset),
        .enabler(enabler[3:0]),
        .mbnumber_luma4x4(mbnumber_luma4x4),
        .mbnumber_chromab8x8(mbnumber_chromab8x8),
        .mbnumber_chromar8x8(mbnumber_chromar8x8),
        .reconstructed_luma(reconstructed_luma),
        .reconstructed_chb(reconstructed_chb),
        .reconstructed_chr(reconstructed_chr),
        .mode_luma4x4(mode_luma4x4),
        .mode_chromab8x8(mode_chromab8x8),
        .mode_chromar8x8(mode_chromar8x8),
        .res_luma4x4(res_luma4x4),
        .res_chromab8x8(res_chromab8x8),
        .res_chromar8x8(res_chromar8x8));
        
    transformcoder utransformcoder_intra (
        .clk(clk),
        .reset(reset),
        .enabler(enabler[7:4]),
        .QP(QP),
        .residuals(res_luma4x4),
        .processedres(processedres_luma4x4));
        
    generate
    
        // ChromaB
        for (i = 0; i < 4; i = i +1) begin : utransformcoder_chromab
            transformcoder stage (
                .clk(clk),
                .reset(reset),
                .enabler(enabler[7:4]),
                .QP(QP),
                .residuals(res_chromab8x8_quadrants[i]),
                .processedres(processedres_chromab8x8_quadrants[i]));
        end
        
        // ChrombaR
        for (i = 0; i < 4; i = i +1) begin : utransformcoder_chromar
            transformcoder stage (
                .clk(clk),
                .reset(reset),
                .enabler(enabler[7:4]),
                .QP(QP),
                .residuals(res_chromar8x8_quadrants[i]),
                .processedres(processedres_chromar8x8_quadrants[i]));
        end
        
    endgenerate
        
    reconstructor #(.WIDTH(WIDTH), .LENGTH(LENGTH)) ureconstructor (
        .clk(clk),
        .reset(reset),
        .enabler(enabler[8:7]),
        .mbnumber_luma4x4(mbnumber_luma4x4),
        .mbnumber_chromab8x8(mbnumber_chromab8x8),
        .mbnumber_chromar8x8(mbnumber_chromar8x8),
        .reconstructed_luma(reconstructed_luma),
        .reconstructed_chb(reconstructed_chb),
        .reconstructed_chr(reconstructed_chr),
        .mode_luma4x4(mode_luma4x4),
        .mode_chromab8x8(mode_chromab8x8),
        .mode_chromar8x8(mode_chromar8x8),
        .residue_luma4x4(processedres_luma4x4),
        .residue_chromab8x8(processedres_chromab8x8),
        .residue_chromar8x8(processedres_chromar8x8),
        .fb_luma4x4(fb_luma4x4),
        .fb_chromab8x8(fb_chromab8x8),
        .fb_chromar8x8(fb_chromar8x8),
        .reconst_luma4x4(reconst_luma4x4),
        .reconst_chromab8x8(reconst_chromab8x8),
        .reconst_chromar8x8(reconst_chromar8x8));
    
    always @ (negedge clk) begin
    
        if (reset == 1)
            enabler = 9'd0;
            
        else begin
        
            if (first) begin
                enabler <= 9'd1;
                first <= 0;
            end
            else begin
                lastbit = enabler[8];
                enabler[8:1] = enabler[7:0];
                enabler[0] = lastbit;
            end
                        
        end
        
    end
    
endmodule
