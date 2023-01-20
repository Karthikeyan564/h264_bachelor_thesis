`timescale 1ns / 1ps

module encoder_intra #(
    parameter LENGTH = 800,
    parameter WIDTH = 800)(
    input clk,
    input reset,
    input enable,
    output reg done_luma4x4, done_chromab8x8, done_chromar8x8);
    
    reg [7:0] reconstructed_luma [WIDTH*LENGTH-1: 0];
    reg [7:0] reconstructed_chb [WIDTH*LENGTH-1: 0];
    reg [7:0] reconstructed_chr [WIDTH*LENGTH-1:0];
    
    wire fb_luma4x4_e1, fb_chromab8x8_e1, fb_chromar8x8_e1, fb_luma4x4_e2, fb_chromab8x8_e2, fb_chromar8x8_e2;
    reg first_luma4x4_e1, first_chromab8x8_e1, first_chromar8x8_e1, first_luma4x4_e2, first_chromab8x8_e2, first_chromar8x8_e2;
    
    reg [31:0] mbnumber_luma4x4_e1, mbnumber_chromab8x8_e1, mbnumber_chromar8x8_e1, mbnumber_luma4x4_e2, mbnumber_chromab8x8_e2, mbnumber_chromar8x8_e2;
    
    reg [7:0] reconst_luma4x4_e1 [15:0], reconst_luma4x4_e2 [15:0];
    reg [7:0] reconst_chromab8x8_e1 [63:0], reconst_chromab8x8_e2 [63:0];
    reg [7:0] reconst_chromar8x8_e1 [63:0], reconst_chromar8x8_e2 [63:0];
    
    reg [15:0] row, col;
    
    integer i, j;
    
    initial for (i = 0; i < WIDTH*LENGTH; i = i + 1) begin
        reconstructed_luma[i] = 8'd0;
        reconstructed_chb[i] = 8'd0;
        reconstructed_chr[i] = 8'd0;
    end
    
    intraloop #(.WIDTH(WIDTH), .LENGTH(LENGTH)) intraloop_e1 (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .reconstructed_luma(reconstructed_luma),
        .reconstructed_chb(reconstructed_chb),
        .reconstructed_chr(reconstructed_chr),
        .mbnumber_luma4x4(mbnumber_luma4x4_e1),
        .mbnumber_chromab8x8(mbnumber_chromab8x8_e1),
        .mbnumber_chromar8x8(mbnumber_chromar8x8_e1),
        .fb_luma4x4(fb_luma4x4_e1),
        .fb_chromab8x8(fb_chromab8x8_e1),
        .fb_chromar8x8(fb_chromar8x8_e1),
        .reconst_luma4x4(reconst_luma4x4_e1),
        .reconst_chromab8x8(reconst_chromab8x8_e1),
        .reconst_chromar8x8(reconst_chromar8x8_e1));
        
    intraloop #(.WIDTH(WIDTH), .LENGTH(LENGTH)) intraloop_e2 (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .reconstructed_luma(reconstructed_luma),
        .reconstructed_chb(reconstructed_chb),
        .reconstructed_chr(reconstructed_chr),
        .mbnumber_luma4x4(mbnumber_luma4x4_e2),
        .mbnumber_chromab8x8(mbnumber_chromab8x8_e2),
        .mbnumber_chromar8x8(mbnumber_chromar8x8_e2),
        .fb_luma4x4(fb_luma4x4_e2),
        .fb_chromab8x8(fb_chromab8x8_e2),
        .fb_chromar8x8(fb_chromar8x8_e2),
        .reconst_luma4x4(reconst_luma4x4_e2),
        .reconst_chromab8x8(reconst_chromab8x8_e2),
        .reconst_chromar8x8(reconst_chromar8x8_e2));
    
    initial begin
        done_luma4x4 = 0;
        done_chromab8x8 = 0;
        done_chromar8x8 = 0;
        
        first_luma4x4_e1 = 1;
        first_chromab8x8_e1 = 1;
        first_chromar8x8_e1 = 1;
        first_luma4x4_e2 = 1;
        first_chromab8x8_e2 = 1;
        first_chromar8x8_e2 = 1;
        
        mbnumber_luma4x4_e1 = 32'd0;
        mbnumber_luma4x4_e2 = {16'd0, 16'd4};
        mbnumber_chromab8x8_e1 = 32'd0;
        mbnumber_chromab8x8_e2 = {16'd0, 16'd8};
        mbnumber_chromar8x8_e1 = 32'd0;
        mbnumber_chromar8x8_e2 = {16'd0, 16'd8};
    end
    
    always @ (posedge clk)
    
        if (reset) begin
            done_luma4x4 = 0;
            done_chromab8x8 = 0;
            done_chromar8x8 = 0;
            
            first_luma4x4_e1 = 1;
            first_chromab8x8_e1 = 1;
            first_chromar8x8_e1 = 1;
            first_luma4x4_e2 = 1;
            first_chromab8x8_e2 = 1;
            first_chromar8x8_e2 = 1;
            
            mbnumber_luma4x4_e1 = 32'd0;
            mbnumber_luma4x4_e2 = {16'd0, 16'd4};
            mbnumber_chromab8x8_e1 = 32'd0;
            mbnumber_chromab8x8_e2 = {16'd0, 16'd8};
            mbnumber_chromar8x8_e1 = 32'd0;
            mbnumber_chromar8x8_e2 = {16'd0, 16'd8};
        end
    
    always @ (posedge fb_luma4x4_e1) begin

        for (i = 0; i < 4; i = i +1) 
            for (j = 0; j < 4; j = j + 1) 
                reconstructed_luma[(((mbnumber_luma4x4_e1[31:16])+13'(i))*LENGTH)+((mbnumber_luma4x4_e1[15:0])+13'(j))] = reconst_luma4x4_e1[(i*4)+j]; 
    
        if (first_luma4x4_e1) begin
            mbnumber_luma4x4_e1 = 32'h40000;
            first_luma4x4_e1 = 0;
        end
        else if (mbnumber_luma4x4_e1[15:0] == WIDTH-4) begin
            mbnumber_luma4x4_e1[15:0] = 16'd0;
            
            if (mbnumber_luma4x4_e1[31:16] >= LENGTH-4) done_luma4x4 = 1'd1;
            else mbnumber_luma4x4_e1[31:16] = mbnumber_luma4x4_e1[31:16] + 16'd8;
        end
        else if (!done_luma4x4) mbnumber_luma4x4_e1[15:0] = mbnumber_luma4x4_e1[15:0] + 16'd4;   
             
    end
    
    always @ (posedge fb_luma4x4_e2) begin
    
        for (i = 0; i < 4; i = i +1) 
            for (j = 0; j < 4; j = j + 1) 
                reconstructed_luma[(((mbnumber_luma4x4_e2[31:16])+13'(i))*LENGTH)+((mbnumber_luma4x4_e2[15:0])+13'(j))] = reconst_luma4x4_e2[(i*4)+j]; 

        if (first_luma4x4_e2) begin
            mbnumber_luma4x4_e2 = 32'h8;
            first_luma4x4_e2 = 0;
        end
        else if (mbnumber_luma4x4_e2[15:0] == WIDTH-4) begin 
            mbnumber_luma4x4_e2[15:0] = 16'd0;
            
            if (mbnumber_luma4x4_e2[31:16] >= LENGTH-4) done_luma4x4 = 1'd1;
            else mbnumber_luma4x4_e2[31:16] = mbnumber_luma4x4_e2[31:16] + 16'd8;
        end
        else if (!done_luma4x4) mbnumber_luma4x4_e2[15:0] = mbnumber_luma4x4_e2[15:0] + 16'd4;
                
    end
    
    always @ (posedge fb_chromab8x8_e1) begin
    
        for (i = 0; i < 8; i = i +1) 
            for (j = 0; j < 8; j = j + 1) 
                reconstructed_chb[(((mbnumber_chromab8x8_e1[31:16])+13'(i))*LENGTH)+((mbnumber_chromab8x8_e1[15:0])+13'(j))] = reconst_chromab8x8_e1[(i*8)+j];

        if (first_chromab8x8_e1) begin
            mbnumber_chromab8x8_e1 = 32'h80000;
            first_chromab8x8_e1 = 0;
        end
        else if (mbnumber_chromab8x8_e1[15:0] == WIDTH-8) begin
            mbnumber_chromab8x8_e1[15:0] = 16'd0;
            
            if (mbnumber_chromab8x8_e1[31:16] >= LENGTH-8) done_chromab8x8 = 1'd1;
            else mbnumber_chromab8x8_e1[31:16] = mbnumber_chromab8x8_e1[31:16] + 16'd16;
        end
        else if (!done_chromab8x8) mbnumber_chromab8x8_e1[15:0] = mbnumber_chromab8x8_e1[15:0] + 16'd8;
                
    end
    
    always @ (posedge fb_chromab8x8_e2) begin
    
        for (i = 0; i < 8; i = i +1) 
            for (j = 0; j < 8; j = j + 1) 
                reconstructed_chb[(((mbnumber_chromab8x8_e2[31:16])+13'(i))*LENGTH)+((mbnumber_chromab8x8_e2[15:0])+13'(j))] = reconst_chromab8x8_e2[(i*8)+j];
    
        if (first_chromab8x8_e2) begin
            mbnumber_chromab8x8_e2 = 32'h16;
            first_chromab8x8_e2 = 0;
        end
        else if (mbnumber_chromab8x8_e2[15:0] == WIDTH-8) begin
            mbnumber_chromab8x8_e2[15:0] = 16'd0;
            
            if (mbnumber_chromab8x8_e2[31:16] >= LENGTH-8) done_chromab8x8 = 1'd1;
            else mbnumber_chromab8x8_e2[31:16] = mbnumber_chromab8x8_e2[31:16] + 16'd16;
        end
        else if (!done_chromab8x8) mbnumber_chromab8x8_e2[15:0] = mbnumber_chromab8x8_e2[15:0] + 16'd8;
                
    end
    
    always @ (posedge fb_chromar8x8_e1) begin
    
        for (i = 0; i < 8; i = i +1) 
            for (j = 0; j < 8; j = j + 1) 
                reconstructed_chr[(((mbnumber_chromar8x8_e1[31:16])+13'(i))*LENGTH)+((mbnumber_chromar8x8_e1[15:0])+13'(j))] = reconst_chromar8x8_e1[(i*8)+j];
    
        if (first_chromar8x8_e1) begin
            mbnumber_chromar8x8_e1 = 32'h80000;
            first_chromar8x8_e1 = 0;
        end
        else if (mbnumber_chromar8x8_e1[15:0] == WIDTH-8) begin
            mbnumber_chromar8x8_e1[15:0] = 16'd0;
            
            if (mbnumber_chromar8x8_e1[31:16] >= LENGTH-8) done_chromar8x8 = 1'd1;
            else mbnumber_chromar8x8_e1[31:16] = mbnumber_chromar8x8_e1[31:16] + 16'd16;
        end
        else if (!done_chromar8x8) mbnumber_chromar8x8_e1[15:0] = mbnumber_chromar8x8_e1[15:0] + 16'd8;
                
    end
    
    always @ (posedge fb_chromar8x8_e2) begin
    
        for (i = 0; i < 8; i = i +1) 
            for (j = 0; j < 8; j = j + 1) 
                reconstructed_chr[(((mbnumber_chromar8x8_e2[31:16])+13'(i))*LENGTH)+((mbnumber_chromar8x8_e2[15:0])+13'(j))] = reconst_chromar8x8_e2[(i*8)+j];
    
        if (first_chromar8x8_e2) begin
            mbnumber_chromar8x8_e2 = 32'h16;
            first_chromar8x8_e2 = 0;
        end
        else if (mbnumber_chromar8x8_e2[15:0] == WIDTH-8) begin
            mbnumber_chromar8x8_e2[15:0] = 16'd0;
            
            if (mbnumber_chromar8x8_e2[31:16] >= LENGTH-8) done_chromar8x8 = 1'd1;
            else mbnumber_chromar8x8_e2[31:16] = mbnumber_chromar8x8_e2[31:16] + 16'd16;
        end
        else if (!done_chromar8x8) mbnumber_chromar8x8_e2[15:0] = mbnumber_chromar8x8_e2[15:0] + 16'd8;
                
    end
    
endmodule
