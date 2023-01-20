`timescale 1ns/1ps

module moder_luma4x4 (
    input clk,
    input reset,
    input enable,
    input [7:0] A,
    input [7:0] B,
    input [7:0] C,
    input [7:0] D,
    input [7:0] E,
    input [7:0] F,
    input [7:0] G,
    input [7:0] H,
    input [7:0] I,
    input [7:0] J,
    input [7:0] K,
    input [7:0] L,
    input [7:0] M,
    output reg [7:0] vpred [15:0],
	output reg [7:0] hpred [15:0],
    output reg [7:0] vlpred [15:0],
	output reg [7:0] vrpred [15:0],
	output reg [7:0] hupred [15:0],
	output reg [7:0] hdpred [15:0],
    output reg [7:0] ddlpred [15:0],
	output reg [7:0] ddrpred [15:0]);

    always @(posedge clk) begin

        if (enable) begin
            
            // (4x4) Vertical
            vpred[0] =I;
            vpred[1] =J;
            vpred[2] =K;
            vpred[3] =L;
            vpred[4] =I;
            vpred[5] =J;
            vpred[6] =K;
            vpred[7] =L;
            vpred[8] =I;
            vpred[9] =J;
            vpred[10] =K;
            vpred[11] =L;
            vpred[12] =I;
            vpred[13] =J;
            vpred[14] =K;
            vpred[15] =L;  

            // (4x4) Horizontal
            hpred[0] =I;
            hpred[1] =I;
            hpred[2] =I;
            hpred[3] =I;
            hpred[4] =J;
            hpred[5] =J;
            hpred[6] =J;
            hpred[7] =J;
            hpred[8] =K;
            hpred[9] =K;
            hpred[10] =K;
            hpred[11] =K;
            hpred[12] =L;
            hpred[13] =L;
            hpred[14] =L;
            hpred[15] =L;    

            // (4x4) Vertical Left
            vlpred[0] = (A+B+1)>>1; //a
            vlpred[1] = (B+C+1)>>1;//b
            vlpred[2] = (C+D+1)>>1;//c
            vlpred[3] = (D+E+1)>>1;//d
            vlpred[4] = (A+2*B+C)>>2;//e
            vlpred[5] = (B+2*C+D+2)>>2;//f
            vlpred[6] = (C+2*D+E+2)>>2;//g
            vlpred[7] = (D+2*E+F+2)>>2;//h
            vlpred[8] = (E+F+1)>>1;//i
            vlpred[9] = (C+D+1)>>1;//j
            vlpred[10] =(J+I+1)>>1;//k
            vlpred[11] =(J+2*I+M+2)>>2;//l
            vlpred[12] =(B+2*C+D+2)>>2;//m
            vlpred[13] =(C+2*D+E+2)>>2;//n
            vlpred[14] =(D+2*E+F+2)>>2;//o
            vlpred[15] =(E+2*F+G+2)>>2;//p   

            // (4x4) Vertical Right
            vrpred[0] = (M+A+1)>>1; //a
            vrpred[1] = (A+B+1)>>1;//b
            vrpred[2] = (B+C+1)>>1;//c
            vrpred[3] = (C+D+1)>>1;//d
            vrpred[4] = (I+2*M+A+2)>>2;//e
            vrpred[5] = (M+2*A+B+2)>>2;//f
            vrpred[6] = (A+2*B+C+2)>>2;//g
            vrpred[7] = (B+2*C+D+2)>>2;//h
            vrpred[8] = (J+2*I+M+2)>>2;//i
            vrpred[9] = (M+A+1)>>1;//j
            vrpred[10] = (A+B+1)>>1;//k
            vrpred[11] =(B+C+1)>>1;//l
            vrpred[12] =(K+2*J+I+2)>>2;//m
            vrpred[13] =(I+2*M+A+2)>>2;;//n
            vrpred[14] =(M+2*A+B+2)>>2;//o
            vrpred[15] =(A+2*B+C+2)>>2;;//p     

            // (4x4) Horizontal Up
            hupred[0] = (J+I+1)>>1; //a
            hupred[1] = (K+2*J+I)>>2;//b
            hupred[2] = (K+J+1)>>1;//c
            hupred[3] = (L+2*K+J+2)>>2;//d
            hupred[4] = (K+J+1)>>1;//e
            hupred[5] = (L+2*K+J+2)>>2;//f
            hupred[6] = (L+K+1)>>1;//g
            hupred[7] = (3*L+J+2)>>2;//h
            hupred[8] = (L+K+1)>>1;//i
            hupred[9] = (3*L+J+2)>>2;//j
            hupred[10] =L;//k
            hupred[11] =L;//l
            hupred[12] =L;//m
            hupred[13] =L;;//n
            hupred[14] =L;//o
            hupred[15] =L;//p    

            // (4x4) Horizontal Down
            hdpred[0] = (I+M+1)>>1; //a
            hdpred[1] = (I+2*M+A+2)>>2;//b
            hdpred[2] = (M+2*A+B+2)>>2;//c
            hdpred[3] = (A+2*B+C+2)>>2;//d
            hdpred[4] = (J+I+1)>>1;//e
            hdpred[5] = (J+2*I+M+2)>>2;//f
            hdpred[6] = (I+M+1)>>1;//g
            hdpred[7] = (I+2*M+A+2)>>2;//h
            hdpred[8] = (K+J+1)>>1;//i
            hdpred[9] = (K+2*J+I+2)>>2;//j
            hdpred[10] =(J+I+1)>>1;//k
            hdpred[11] =(J+2*I+M+2)>>2;//l
            hdpred[12] =(L+K+1)>>1;//m
            hdpred[13] =(L+2*K+J+2)>>2;;//n
            hdpred[14] =(K+J+1)>>1;;//o
            hdpred[15] =(K+2*J+I+2)>>2;//p   

            // (4x4) DDL
            ddlpred[0] = (A+2*B+C+2)>>2;
            ddlpred[1] = (B+2*C+D+2)>>2;
            ddlpred[2] = (C+2*D+E+2)>>2;
            ddlpred[3] = (D+2*E+F+2)>>2;
            ddlpred[4] = (B+2*C+D+2)>>2;
            ddlpred[5] = (C+2*D+E+2)>>2;
            ddlpred[6] = (D+2*E+F+2)>>2;
            ddlpred[7] = (E+2*F+G+2)>>2;
            ddlpred[8] = (C+2*D+E+2)>>2;
            ddlpred[9] = (D+2*E+F+2)>>2;
            ddlpred[10] =(E+2*F+G+2)>>2;
            ddlpred[11] =(F+2*G+H+2)>>2;
            ddlpred[12] =(D+2*E+F+2)>>2;
            ddlpred[13] =(E+2*F+G+2)>>2;
            ddlpred[14] =(F+2*G+H+2)>>2;
            ddlpred[15] = (G+3*H+2)>>2; 

            // (4x4) DDR
            ddrpred[0] = (I+2*M+A+2)>>2; //a
            ddrpred[1] = (M+2*A+B+2)>>2;//b
            ddrpred[2] = (A+2*B+C+2)>>2;//c
            ddrpred[3] = (B+2*C+D+2)>>2;//d
            ddrpred[4] = (J+2*I+M+2)>>2;//e
            ddrpred[5] = (I+2*M+A+2)>>2;//f
            ddrpred[6] = (M+2*A+B+2)>>2;//g
            ddrpred[7] = (A+2*B+C+2)>>2;//h
            ddrpred[8] = (K+2*J+I+2)>>2;//i
            ddrpred[9] = (J+2*I+M+2)>>2;//j
            ddrpred[10] =(I+2*M+A+2)>>2;//k
            ddrpred[11] =(M+2*A+B+2)>>2;//l
            ddrpred[12] =(L+2*K+J+2)>>1;//m
            ddrpred[13] =(K+2*J+I+2)>>2;//n
            ddrpred[14] =(J+2*I+M+2)>>2;//o
            ddrpred[15] =(I+2*M+A+2)>>2;//p

        end

    end

endmodule