`timescale 1ns/1ps

module predadder #(
    parameter WIDTH = 1280,
    parameter LENGTH = 720,
    parameter MB_SIZE_L = 16,
    parameter MB_SIZE_W = 16)(
    input clk,
    input reset,
    input enable,
    input [2:0] mode,
    input signed [7:0] residue [(MB_SIZE_L*MB_SIZE_W)-1:0],
    input [7:0] toppixels [(MB_SIZE_W == 4 ? 7 : MB_SIZE_W-1):0],
    input [7:0] leftpixels [(MB_SIZE_L == 4 ? 4 : MB_SIZE_L-1):0],
    output reg fb,
    output reg [7:0] reconst [(MB_SIZE_L*MB_SIZE_W)-1:0]);

    // Counters
    reg [6:0] i, j, k;
    reg [12:0] sum;

	// Neighbouring pixels
	reg [7:0] A, B, C, D, E, F, G, H, I, J, K, L, M;
	
	// Preds
	reg [7:0] pred [(MB_SIZE_L*MB_SIZE_W)-1:0];

    always @(posedge clk) begin

        if (enable) begin
            
            case (MB_SIZE_L)
            
                32'd4:  begin
                
                    A = toppixels[0];
                    B = toppixels[1];
                    C = toppixels[2];
                    D = toppixels[3];
                    E = toppixels[4];
                    F = toppixels[5];
                    G = toppixels[6];
                    H = toppixels[7];
                    M = leftpixels[0];
                    I = leftpixels[1];
                    J = leftpixels[2];
                    K = leftpixels[3];
                    L = leftpixels[4];
                
                    case (mode)
                        
                        3'd0: begin
                            // (4x4) Vertical
                            pred[0] =I;
                            pred[1] =J;
                            pred[2] =K;
                            pred[3] =L;
                            pred[4] =I;
                            pred[5] =J;
                            pred[6] =K;
                            pred[7] =L;
                            pred[8] =I;
                            pred[9] =J;
                            pred[10] =K;
                            pred[11] =L;
                            pred[12] =I;
                            pred[13] =J;
                            pred[14] =K;
                            pred[15] =L;  
                        end
                    
                        3'd1: begin
                            // (4x4) Horizontal
                            pred[0] =I;
                            pred[1] =I;
                            pred[2] =I;
                            pred[3] =I;
                            pred[4] =J;
                            pred[5] =J;
                            pred[6] =J;
                            pred[7] =J;
                            pred[8] =K;
                            pred[9] =K;
                            pred[10] =K;
                            pred[11] =K;
                            pred[12] =L;
                            pred[13] =L;
                            pred[14] =L;
                            pred[15] =L;   
                        end 
        
                        3'd2: begin
                            // (4x4) Vertical Left
                            pred[0] = (A+B+1)>>1; //a
                            pred[1] = (B+C+1)>>1;//b
                            pred[2] = (C+D+1)>>1;//c
                            pred[3] = (D+E+1)>>1;//d
                            pred[4] = (A+2*B+C)>>2;//e
                            pred[5] = (B+2*C+D+2)>>2;//f
                            pred[6] = (C+2*D+E+2)>>2;//g
                            pred[7] = (D+2*E+F+2)>>2;//h
                            pred[8] = (E+F+1)>>1;//i
                            pred[9] = (C+D+1)>>1;//j
                            pred[10] =(J+I+1)>>1;//k
                            pred[11] =(J+2*I+M+2)>>2;//l
                            pred[12] =(B+2*C+D+2)>>2;//m
                            pred[13] =(C+2*D+E+2)>>2;//n
                            pred[14] =(D+2*E+F+2)>>2;//o
                            pred[15] =(E+2*F+G+2)>>2;//p   
                        end
            
                        3'd3: begin
                            // (4x4) Vertical Right
                            pred[0] = (M+A+1)>>1; //a
                            pred[1] = (A+B+1)>>1;//b
                            pred[2] = (B+C+1)>>1;//c
                            pred[3] = (C+D+1)>>1;//d
                            pred[4] = (I+2*M+A+2)>>2;//e
                            pred[5] = (M+2*A+B+2)>>2;//f
                            pred[6] = (A+2*B+C+2)>>2;//g
                            pred[7] = (B+2*C+D+2)>>2;//h
                            pred[8] = (J+2*I+M+2)>>2;//i
                            pred[9] = (M+A+1)>>1;//j
                            pred[10] = (A+B+1)>>1;//k
                            pred[11] =(B+C+1)>>1;//l
                            pred[12] =(K+2*J+I+2)>>2;//m
                            pred[13] =(I+2*M+A+2)>>2;;//n
                            pred[14] =(M+2*A+B+2)>>2;//o
                            pred[15] =(A+2*B+C+2)>>2;;//p     
                        end
                        
                        3'd4: begin
                            // (4x4) Horizontal Up
                            pred[0] = (J+I+1)>>1; //a
                            pred[1] = (K+2*J+I)>>2;//b
                            pred[2] = (K+J+1)>>1;//c
                            pred[3] = (L+2*K+J+2)>>2;//d
                            pred[4] = (K+J+1)>>1;//e
                            pred[5] = (L+2*K+J+2)>>2;//f
                            pred[6] = (L+K+1)>>1;//g
                            pred[7] = (3*L+J+2)>>2;//h
                            pred[8] = (L+K+1)>>1;//i
                            pred[9] = (3*L+J+2)>>2;//j
                            pred[10] =L;//k
                            pred[11] =L;//l
                            pred[12] =L;//m
                            pred[13] =L;;//n
                            pred[14] =L;//o
                            pred[15] =L;//p   
                        end 
            
                        3'd5: begin
                            // (4x4) Horizontal Down
                            pred[0] = (I+M+1)>>1; //a
                            pred[1] = (I+2*M+A+2)>>2;//b
                            pred[2] = (M+2*A+B+2)>>2;//c
                            pred[3] = (A+2*B+C+2)>>2;//d
                            pred[4] = (J+I+1)>>1;//e
                            pred[5] = (J+2*I+M+2)>>2;//f
                            pred[6] = (I+M+1)>>1;//g
                            pred[7] = (I+2*M+A+2)>>2;//h
                            pred[8] = (K+J+1)>>1;//i
                            pred[9] = (K+2*J+I+2)>>2;//j
                            pred[10] =(J+I+1)>>1;//k
                            pred[11] =(J+2*I+M+2)>>2;//l
                            pred[12] =(L+K+1)>>1;//m
                            pred[13] =(L+2*K+J+2)>>2;;//n
                            pred[14] =(K+J+1)>>1;;//o
                            pred[15] =(K+2*J+I+2)>>2;//p   
                        end
                        
                        3'd6: begin
                            // (4x4) DDL
                            pred[0] = (A+2*B+C+2)>>2;
                            pred[1] = (B+2*C+D+2)>>2;
                            pred[2] = (C+2*D+E+2)>>2;
                            pred[3] = (D+2*E+F+2)>>2;
                            pred[4] = (B+2*C+D+2)>>2;
                            pred[5] = (C+2*D+E+2)>>2;
                            pred[6] = (D+2*E+F+2)>>2;
                            pred[7] = (E+2*F+G+2)>>2;
                            pred[8] = (C+2*D+E+2)>>2;
                            pred[9] = (D+2*E+F+2)>>2;
                            pred[10] =(E+2*F+G+2)>>2;
                            pred[11] =(F+2*G+H+2)>>2;
                            pred[12] =(D+2*E+F+2)>>2;
                            pred[13] =(E+2*F+G+2)>>2;
                            pred[14] =(F+2*G+H+2)>>2;
                            pred[15] = (G+3*H+2)>>2; 
                        end
                        
                        3'd7: begin
                            // (4x4) DDR
                            pred[0] = (I+2*M+A+2)>>2; //a
                            pred[1] = (M+2*A+B+2)>>2;//b
                            pred[2] = (A+2*B+C+2)>>2;//c
                            pred[3] = (B+2*C+D+2)>>2;//d
                            pred[4] = (J+2*I+M+2)>>2;//e
                            pred[5] = (I+2*M+A+2)>>2;//f
                            pred[6] = (M+2*A+B+2)>>2;//g
                            pred[7] = (A+2*B+C+2)>>2;//h
                            pred[8] = (K+2*J+I+2)>>2;//i
                            pred[9] = (J+2*I+M+2)>>2;//j
                            pred[10] =(I+2*M+A+2)>>2;//k
                            pred[11] =(M+2*A+B+2)>>2;//l
                            pred[12] =(L+2*K+J+2)>>1;//m
                            pred[13] =(K+2*J+I+2)>>2;//n
                            pred[14] =(J+2*I+M+2)>>2;//o
                            pred[15] =(I+2*M+A+2)>>2;//p
                        end
                        
                        default: begin
                            // (4x4) DDR
                            pred[0] = (I+2*M+A+2)>>2; //a
                            pred[1] = (M+2*A+B+2)>>2;//b
                            pred[2] = (A+2*B+C+2)>>2;//c
                            pred[3] = (B+2*C+D+2)>>2;//d
                            pred[4] = (J+2*I+M+2)>>2;//e
                            pred[5] = (I+2*M+A+2)>>2;//f
                            pred[6] = (M+2*A+B+2)>>2;//g
                            pred[7] = (A+2*B+C+2)>>2;//h
                            pred[8] = (K+2*J+I+2)>>2;//i
                            pred[9] = (J+2*I+M+2)>>2;//j
                            pred[10] =(I+2*M+A+2)>>2;//k
                            pred[11] =(M+2*A+B+2)>>2;//l
                            pred[12] =(L+2*K+J+2)>>1;//m
                            pred[13] =(K+2*J+I+2)>>2;//n
                            pred[14] =(J+2*I+M+2)>>2;//o
                            pred[15] =(I+2*M+A+2)>>2;//p
                        end
                        
                    endcase
                end
                
                default: begin
                
                    case (mode) 
                    
                        3'd0: begin
                            // Vertical
                            for (i = 0; i < MB_SIZE_L; i = i + 1) 
                                for (j = 0; j < MB_SIZE_L; j = j + 1)
                                    pred[i + (MB_SIZE_L)*j] = toppixels[i];
                        end
                        
                        3'd1: begin            
                            // Horizontal
                            for(i = 0; i < MB_SIZE_L; i = i + 1) 
                                for(j = 0; j < MB_SIZE_L; j = j + 1)
                                    pred[j + (MB_SIZE_L)*i] = leftpixels[i];
                        end
                        
                        3'd2: begin
                            // DC
                            sum = 13'b000000000000;
                            
                            for (i = 0; i < MB_SIZE_L; i = i + 1) sum = sum + 13'(toppixels[i]);
                            for (i = 0; i < MB_SIZE_L; i = i + 1) sum = sum + 13'(leftpixels[i]);
                            
                            sum = sum >> 5;
                             
                            for (i = 0; i < (MB_SIZE_L*MB_SIZE_W); i = i + 1) pred[i] = 8'(sum);
                        end
                        
                    endcase
                                            
                end
                
            endcase

            for (k = 0; k < (MB_SIZE_L*MB_SIZE_W); k = k + 1)
                reconst[6'(k)] = pred[6'(k)] + residue[6'(k)];

            fb = 1;

        end

    end

    always @ (negedge clk) if (fb) fb = 0;

endmodule