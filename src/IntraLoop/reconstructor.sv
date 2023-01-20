`timescale 1ns / 1ps

module reconstructor #(
    parameter BIT_LENGTH = 15,
    parameter WIDTH = 1280,
    parameter LENGTH = 720,
    parameter MB_SIZE_L = 4,
    parameter MB_SIZE_W = 4)(
    input clk,
    input reset,
    input [2:0] enabler,
    input [7:0] reconstructed_luma [WIDTH*LENGTH-1:0],
    input [7:0] reconstructed_chb [WIDTH*LENGTH-1:0],
    input [7:0] reconstructed_chr [WIDTH*LENGTH-1:0],
    input [31:0] mbnumber_luma4x4, mbnumber_chromab8x8, mbnumber_chromar8x8,
    input [2:0] mode_luma4x4, mode_chromab8x8, mode_chromar8x8,
    input signed [7:0] residue_luma4x4 [15:0], residue_chromab8x8 [63:0], residue_chromar8x8 [63:0],
    output fb_luma4x4, fb_chromab8x8, fb_chromar8x8,
    output [7:0] reconst_luma4x4 [15:0], reconst_chromab8x8 [63:0], reconst_chromar8x8 [63:0]);
        
    wire [7:0] toppixels_luma4x4 [7:0];
	wire [7:0] toppixels_chromab8x8 [7:0];
	wire [7:0] toppixels_chromar8x8 [7:0];
	
	wire [7:0] leftpixels_luma4x4 [4:0];
	wire [7:0] leftpixels_chromab8x8 [7:0];
	wire [7:0] leftpixels_chromar8x8 [7:0];
	
    // Retrieve Neighbouring Pixels		
	// Luma 4x4
	extractor_np #(.WIDTH(WIDTH), .LENGTH(LENGTH), .MB_SIZE_L(4), .MB_SIZE_W(4)) uextractor_np_luma4x4 (
        .clk(clk),
        .reset(reset),
        .enable(enabler[0]),
        .mbnumber(mbnumber_luma4x4),
        .toppixels(toppixels_luma4x4),
        .reconstructed(reconstructed_luma),
        .leftpixels(leftpixels_luma4x4));

    // ChromaB 8x8
    extractor_np #(.WIDTH(WIDTH), .LENGTH(LENGTH), .MB_SIZE_L(8), .MB_SIZE_W(8)) uextractor_np_chromab8x8 (
        .clk(clk),
        .reset(reset),
        .enable(enabler[0]),
        .mbnumber(mbnumber_chromab8x8),
        .toppixels(toppixels_chromab8x8),
        .reconstructed(reconstructed_chb),
        .leftpixels(leftpixels_chromab8x8));
               
    // ChromaR 8x8
    extractor_np #(.WIDTH(WIDTH), .LENGTH(LENGTH), .MB_SIZE_L(8), .MB_SIZE_W(8)) uextractor_np_chromar8x8 (
        .clk(clk),
        .reset(reset),
        .enable(enabler[0]),
        .mbnumber(mbnumber_chromar8x8),
        .toppixels(toppixels_chromar8x8),
        .reconstructed(reconstructed_chr),
        .leftpixels(leftpixels_chromar8x8));
        
    // Predict Modes and Reconstruct Block
    // Luma 4x4
    predadder #(.MB_SIZE_L(4), .MB_SIZE_W(4)) upredadder_luma4x4 (
        .clk(clk),
        .reset(reset),
        .enable(enabler[1]),
        .mode(mode_luma4x4),
        .residue(residue_luma4x4),
        .toppixels(toppixels_luma4x4),
        .leftpixels(leftpixels_luma4x4),
        .reconst(reconst_luma4x4),
        .fb(fb_luma4x4)); 
        
    // ChromaB 8x8
    predadder #(.MB_SIZE_L(8), .MB_SIZE_W(8)) upredadder_chromab8x8 (
        .clk(clk),
        .reset(reset),
        .enable(enabler[1]),
        .mode(mode_chromab8x8),
        .residue(residue_chromab8x8),
        .toppixels(toppixels_chromab8x8),
        .leftpixels(leftpixels_chromab8x8),
        .reconst(reconst_chromab8x8),
        .fb(fb_chromab8x8)); 
        
    // ChromaR 8x8
    predadder #(.MB_SIZE_L(8), .MB_SIZE_W(8)) upredadder_chromar8x8 (
        .clk(clk),
        .reset(reset),
        .enable(enabler[1]),
        .mode(mode_chromar8x8),
        .residue(residue_chromar8x8),
        .toppixels(toppixels_chromar8x8),
        .leftpixels(leftpixels_chromar8x8),
        .reconst(reconst_chromar8x8),
        .fb(fb_chromar8x8)); 
        
endmodule
