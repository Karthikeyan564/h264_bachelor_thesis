`timescale 1ns/1ps

module intrapred #(
    parameter WIDTH = 1280,
    parameter LENGTH = 720,
    parameter BIT_LENGTH = 31)(
	input clk,
	input reset,
	input [3:0] enabler,
    input [7:0] reconstructed_luma [WIDTH*LENGTH-1:0],
    input [7:0] reconstructed_chb [WIDTH*LENGTH-1:0],
    input [7:0] reconstructed_chr [WIDTH*LENGTH-1:0],
    input [31:0] mbnumber_luma4x4, mbnumber_chromab8x8, mbnumber_chromar8x8,
	output [2:0] mode_luma4x4, mode_chromab8x8, mode_chromar8x8,
	output signed [7:0] res_luma4x4 [15:0], res_chromab8x8 [63:0], res_chromar8x8 [63:0]);
    
	// Inputs
	wire [7:0] mb_luma4x4 [15:0];
	wire [7:0] mb_chromab8x8 [63:0];
	wire [7:0] mb_chromar8x8 [63:0];
	
	wire [7:0] toppixels_luma4x4 [7:0];
	wire [7:0] toppixels_chromab8x8 [7:0];
	wire [7:0] toppixels_chromar8x8 [7:0];
	
	wire [7:0] leftpixels_luma4x4 [4:0];
	wire [7:0] leftpixels_chromab8x8 [7:0];
	wire [7:0] leftpixels_chromar8x8 [7:0];

	// Neighbouring pixels
	wire [7:0] A = toppixels_luma4x4[0];
	wire [7:0] B = toppixels_luma4x4[1];
	wire [7:0] C = toppixels_luma4x4[2];
	wire [7:0] D = toppixels_luma4x4[3];
	wire [7:0] E = toppixels_luma4x4[4];
	wire [7:0] F = toppixels_luma4x4[5];
	wire [7:0] G = toppixels_luma4x4[6];
	wire [7:0] H = toppixels_luma4x4[7];
	wire [7:0] M = leftpixels_luma4x4[0];
	wire [7:0] I = leftpixels_luma4x4[1];
	wire [7:0] J = leftpixels_luma4x4[2];
	wire [7:0] K = leftpixels_luma4x4[3];
	wire [7:0] L = leftpixels_luma4x4[4];

	// Preds
	wire [7:0] vpred_luma4x4 [15:0];
	wire [7:0] hpred_luma4x4 [15:0];
	wire [7:0] vlpred_luma4x4 [15:0];
	wire [7:0] vrpred_luma4x4 [15:0];
	wire [7:0] hupred_luma4x4 [15:0];
	wire [7:0] hdpred_luma4x4 [15:0];
	wire [7:0] ddlpred_luma4x4 [15:0];
	wire [7:0] ddrpred_luma4x4 [15:0];
	
	wire [7:0] vpred_chromab8x8 [63:0];
	wire [7:0] hpred_chromab8x8 [63:0];
	wire [7:0] dcpred_chromab8x8 [63:0];
	wire [7:0] vpred_chromar8x8 [63:0];
	wire [7:0] hpred_chromar8x8 [63:0];
	wire [7:0] dcpred_chromar8x8 [63:0];
	
	// Residues
	wire signed [7:0] allres_luma4x4 [7:0][15:0];
//	0 -> wire [7:0] vres_luma4x4 [15:0];
//	1 -> wire [7:0] hres_luma4x4 [15:0];
//	2 -> wire [7:0] vlres_luma4x4 [15:0];
//	3 -> wire [7:0] vrres_luma4x4 [15:0];
//	4 -> wire [7:0] hures_luma4x4 [15:0];
//	5 -> wire [7:0] hdres_luma4x4 [15:0];
//	6 -> wire [7:0] ddlres_luma4x4 [15:0];
//	7 -> wire [7:0] ddrres_luma4x4 [15:0];
	
    wire signed [7:0] allres_chromab8x8 [2:0][63:0];
//  0 -> wire [7:0] vres_chromab8x8 [63:0];
//  1 -> wire [7:0] hres_chromab8x8 [63:0];
//  2 -> wire [7:0] dcres_chromab8x8 [63:0];
    wire signed [7:0] allres_chromar8x8 [2:0][63:0];
//	0 -> wire [7:0] vres_chromar8x8 [63:0];
//	1 -> wire [7:0] hres_chromar8x8 [63:0];
//	2 -> wire [7:0] dcres_chromar8x8 [63:0];
	
	// Retrieve neighbouring pixels		
	// Luma 4x4
	extractor_np #(.WIDTH(WIDTH), .LENGTH(LENGTH), .MB_SIZE_L(4), .MB_SIZE_W(4)) uextractor_np_luma4x4 (
        .clk(clk),
        .reset(reset),
        .enable(enabler[0]),
        .mbnumber(mbnumber_luma4x4),
        .reconstructed(reconstructed_luma),
        .toppixels(toppixels_luma4x4),
        .leftpixels(leftpixels_luma4x4));

    // ChromaB 8x8
    extractor_np #(.WIDTH(WIDTH), .LENGTH(LENGTH), .MB_SIZE_L(8), .MB_SIZE_W(8)) uextractor_np_chromab8x8 (
        .clk(clk),
        .reset(reset),
        .enable(enabler[0]),
        .mbnumber(mbnumber_chromab8x8),
        .reconstructed(reconstructed_chb),
        .toppixels(toppixels_chromab8x8),
        .leftpixels(leftpixels_chromab8x8));
               
    // ChromaR 8x8
    extractor_np #(.WIDTH(WIDTH), .LENGTH(LENGTH), .MB_SIZE_L(8), .MB_SIZE_W(8)) uextractor_np_chromar8x8 (
        .clk(clk),
        .reset(reset),
        .enable(enabler[0]),
        .mbnumber(mbnumber_chromar8x8),
        .reconstructed(reconstructed_chr),
        .toppixels(toppixels_chromar8x8),
        .leftpixels(leftpixels_chromar8x8));
        
    // Retrieve Macroblock
    // Luma 4x4
    extractor_mb #(.WIDTH(WIDTH), .LENGTH(LENGTH), .MB_SIZE_L(4), .MB_SIZE_W(4)) uextractor_mb_luma4x4 (
        .clk(clk),
        .reset(reset),
        .enable(enabler[1]),
        .mbnumber(mbnumber_luma4x4),
        .mb(mb_luma4x4));
		
    // ChromaB 8x8
    extractor_mb #(.WIDTH(WIDTH), .LENGTH(LENGTH), .MB_SIZE_L(8), .MB_SIZE_W(8)) uextractor_mb_chromab8x8 (
        .clk(clk),
        .reset(reset),
        .enable(enabler[1]),
        .mbnumber(mbnumber_chromab8x8), 
        .mb(mb_chromab8x8));
    
    // ChromaR 8x8  
    extractor_mb #(.WIDTH(WIDTH), .LENGTH(LENGTH), .MB_SIZE_L(8), .MB_SIZE_W(8)) uextractor_mb_chromar8x8 (
        .clk(clk),
        .reset(reset),
        .enable(enabler[1]),
        .mbnumber(mbnumber_chromar8x8),
        .mb(mb_chromar8x8));

	// Compute 8 modes
	// Luma 4x4
	moder_luma4x4 umoder_luma4x4 (
		.clk(clk),
		.reset(reset),
		.enable(enabler[1]),
		.A(A),
		.B(B),
		.C(C),
		.D(D),
		.E(E),
		.F(F),
		.G(G),
		.H(H),
		.I(I),
		.J(J),
		.K(K),
		.L(L),
		.M(M),
		.vpred(vpred_luma4x4),
		.hpred(hpred_luma4x4),
		.vlpred(vlpred_luma4x4),
		.vrpred(vrpred_luma4x4),
		.hupred(hupred_luma4x4),
		.hdpred(hdpred_luma4x4),
		.ddlpred(ddlpred_luma4x4),
		.ddrpred(ddrpred_luma4x4));
		
    // ChromaB 8x8
    moder_chroma8x8 umoder_chromab8x8 (
        .clk(clk),
        .reset(reset),
        .enable(enabler[1]),
        .toppixels(toppixels_chromab8x8),
        .leftpixels(leftpixels_chromab8x8),
        .vpred(vpred_chromab8x8),
        .hpred(hpred_chromab8x8),
        .dcpred(dcpred_chromab8x8));
        
    // ChromaR 8x8
    moder_chroma8x8 umoder_chromar8x8 (
        .clk(clk),
        .reset(reset),
        .enable(enabler[1]),
        .toppixels(toppixels_chromar8x8),
        .leftpixels(leftpixels_chromar8x8),
        .vpred(vpred_chromar8x8),
        .hpred(hpred_chromar8x8),
        .dcpred(dcpred_chromar8x8));
        
	// Compute Residual
	// Luma 4x4
	reser_luma4x4 ureser_luma4x4 (
		.clk(clk),
		.reset(reset),
		.enable(enabler[2]),
		.mb(mb_luma4x4),
		.vpred(vpred_luma4x4),
		.hpred(hpred_luma4x4),
		.vlpred(vlpred_luma4x4),
		.vrpred(vrpred_luma4x4),
		.hupred(hupred_luma4x4),
		.hdpred(hdpred_luma4x4),
		.ddlpred(ddlpred_luma4x4),
		.ddrpred(ddrpred_luma4x4),
		.vres(allres_luma4x4[0]),
		.hres(allres_luma4x4[1]),
		.vlres(allres_luma4x4[2]),
		.vrres(allres_luma4x4[3]),
		.hures(allres_luma4x4[4]),
		.hdres(allres_luma4x4[5]),
		.ddlres(allres_luma4x4[6]),
		.ddrres(allres_luma4x4[7]));
		
    // ChromaB 8x8
    reser_chroma8x8 ureser_chromab8x8 (
        .clk(clk),
		.reset(reset),
		.enable(enabler[2]),
		.mb(mb_chromab8x8),
		.vpred(vpred_chromab8x8),
		.hpred(hpred_chromab8x8),
		.dcpred(dcpred_chromab8x8),
		.vres(allres_chromab8x8[0]),
		.hres(allres_chromab8x8[1]),
		.dcres(allres_chromab8x8[2]));
		
    // ChromaR 8x8
    reser_chroma8x8 ureser_chromar8x8 (
        .clk(clk),
		.reset(reset),
		.enable(enabler[2]),
		.mb(mb_chromar8x8),
		.vpred(vpred_chromar8x8),
		.hpred(hpred_chromar8x8),
		.dcpred(dcpred_chromar8x8),
		.vres(allres_chromar8x8[0]),
		.hres(allres_chromar8x8[1]),
		.dcres(allres_chromar8x8[2]));
    
	// Compute SAD
	// Luma 4x4
	sader_luma4x4 usader_luma4x4 (
		.clk(clk),
		.reset(reset),
		.enable(enabler[3]),
		.vres(allres_luma4x4[0]),
		.hres(allres_luma4x4[1]),
		.vlres(allres_luma4x4[2]),
		.vrres(allres_luma4x4[3]),
		.hures(allres_luma4x4[4]),
		.hdres(allres_luma4x4[5]),
		.ddlres(allres_luma4x4[6]),
		.ddrres(allres_luma4x4[7]),
		.mode(mode_luma4x4),
		.res(res_luma4x4));
		
	// ChromaB 8x8
	sader_chroma8x8 usader_chromab8x8 (
	   .clk(clk),
       .reset(reset),
       .enable(enabler[3]),
       .vres(allres_chromab8x8[0]),
       .hres(allres_chromab8x8[1]),
       .dcres(allres_chromab8x8[2]),
       .mode(mode_chromab8x8),
       .res(res_chromab8x8));
       
	// ChromaR 8x8
	sader_chroma8x8 usader_chromar8x8 (
	   .clk(clk),
       .reset(reset),
       .enable(enabler[3]),
       .vres(allres_chromar8x8[0]),
       .hres(allres_chromar8x8[1]),
       .dcres(allres_chromar8x8[2]),
       .mode(mode_chromar8x8),
       .res(res_chromar8x8)); 
	
endmodule
