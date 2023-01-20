`timescale 1ns / 1ps

module transformcoder #(
    parameter BIT_LENGTH = 31)(
    input clk,
    input reset,
    input [3:0] enabler,
    input [5:0] QP,
    input signed [7:0] residuals [15:0],
    output reg signed [7:0] processedres [15:0]);

    wire signed [BIT_LENGTH:0] res2tran [15:0];
    wire signed [BIT_LENGTH:0] tran2quant [15:0];
    wire signed [BIT_LENGTH:0] quant2tran [15:0];
    
    reg mode = 0;
    
    reg [2:0] QP_MOD_6;
    reg [3:0] QP_BY_6;
    
    initial begin
    
        if( QP == 0 || QP == 6 || QP == 12 || QP == 18 || QP == 24 || QP == 30 || QP == 36 || QP == 42 || QP == 48) 
            QP_MOD_6 = 3'b000;
        else if( QP == 1 || QP == 7 || QP == 13 || QP == 19 || QP == 25 || QP == 31 || QP == 37|| QP == 43 || QP == 49) 
            QP_MOD_6 = 3'b001;
        else if( QP == 2 || QP == 8 || QP == 14 || QP == 20 || QP == 26 || QP == 32 || QP == 38 || QP == 44 || QP == 50) 
            QP_MOD_6 = 3'b010;
        else if( QP == 3 || QP == 9 || QP == 15 || QP == 21 || QP == 27 || QP == 33 || QP == 39 || QP == 45 || QP == 51)
            QP_MOD_6 = 3'b011;
        else if( QP ==4 ||QP == 10 || QP == 16 || QP == 22 || QP == 28 || QP == 34 || QP == 40 || QP == 46)
            QP_MOD_6 = 3'b100;
        else if( QP == 5 || QP == 11 || QP == 17 || QP == 23 || QP == 29 || QP == 35 || QP == 41 || QP == 47)
            QP_MOD_6 = 3'b101;
        
        if( QP == 0 || QP == 1 || QP == 2 || QP == 3 || QP == 4 || QP == 5)
            QP_BY_6 = 4'b0000;
        else if( QP == 6 || QP == 7 || QP == 8 || QP == 9 || QP == 10 || QP == 11)
            QP_BY_6 = 4'b0001;
        else if( QP == 12 || QP == 13 || QP == 14 || QP == 15 || QP == 16 || QP == 17)
            QP_BY_6 = 4'b0010;
        else if( QP == 18 || QP == 19 || QP == 20 || QP == 21 || QP == 22 || QP == 23)
            QP_BY_6 = 4'b0011;
        else if( QP == 24 || QP == 25 || QP == 26 || QP == 27 || QP == 28 || QP == 29)
            QP_BY_6 = 4'b0100;
        else if( QP == 30 || QP == 31 || QP == 32 || QP == 33 || QP == 34 || QP == 35)
            QP_BY_6 = 4'b0101;
        else if( QP == 36 || QP == 37 || QP == 38 || QP == 39 || QP == 40 || QP == 41)
            QP_BY_6 = 4'b0110;
        else if( QP == 42 || QP == 43 || QP == 44 || QP == 45 || QP == 46 || QP == 47)
            QP_BY_6 = 4'b0111;
        else if( QP == 48 || QP == 49 || QP == 50 || QP == 51)
            QP_BY_6 = 4'b1000;
    
    end
    
    tran_4x4 #(.BIT_LENGTH(BIT_LENGTH)) utran_4x4 (
        .clk(clk),
        .enable(enabler[0]),
        .reset(reset),
        .residuals(residuals),
        .transformed(res2tran));
    
    quant_4x4 #(.BIT_LENGTH(BIT_LENGTH)) uquant_4x4 (
        .clk(clk),
        .enable(enabler[1]),
        .reset(reset),
        .mode(mode),
        .transformed(res2tran),
        .QP_BY_6(QP_BY_6),
        .QP_MOD_6(QP_MOD_6),
        .quantized(tran2quant));
        
    invquant_4x4 #(.BIT_LENGTH(BIT_LENGTH)) uinvquant_4x4 (
        .clk(clk),
        .enable(enabler[2]),
        .reset(reset),
        .quantized(tran2quant),
        .QP_BY_6(QP_BY_6),
        .QP_MOD_6(QP_MOD_6),
        .transformed(quant2tran));
        
    invtran_4x4 #(.BIT_LENGTH(BIT_LENGTH)) uinvtran_4x4 (
        .clk(clk),
        .enable(enabler[3]),
        .reset(reset),
        .transformed(quant2tran),
        .residuals(processedres));        

endmodule
