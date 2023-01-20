`timescale 1ns / 1ps

module invquant_4x4 #(
    parameter BIT_LENGTH = 15)(
    input clk,
    input enable,
    input reset,
    input signed [BIT_LENGTH : 0] quantized [15:0],
    input [3:0] QP_BY_6,
    input [2:0] QP_MOD_6,
    output reg signed [BIT_LENGTH : 0] transformed [15:0]);
    
    reg [4:0] i;
    reg [4:0] multfactor;
    
    always @ (posedge clk) begin
    
        for (i = 0; i < 16; i = i + 1) begin
        
            if (i == 0 || i == 2 || i == 8 || i == 10) 
                case (QP_MOD_6)
                    3'b000: multfactor = 5'd10;
                    3'b001: multfactor = 5'd11;
                    3'b010: multfactor = 5'd13;
                    3'b011: multfactor = 5'd14;
                    3'b100: multfactor = 5'd16;
                    3'b101: multfactor = 5'd18;
                endcase 
            else if (i == 5 || i == 7 || i == 12 || i == 15) 
                case (QP_MOD_6)
                    3'b000: multfactor = 5'd16;
                    3'b001: multfactor = 5'd18;
                    3'b010: multfactor = 5'd20;
                    3'b011: multfactor = 5'd23;
                    3'b100: multfactor = 5'd25;
                    3'b101: multfactor = 5'd29;
                endcase 
            else 
                case (QP_MOD_6)
                    3'b000: multfactor = 5'd13;
                    3'b001: multfactor = 5'd14;
                    3'b010: multfactor = 5'd16;
                    3'b011: multfactor = 5'd18;
                    3'b100: multfactor = 5'd20;
                    3'b101: multfactor = 5'd23;
                endcase 
                
            transformed[i] = ((quantized[i] * multfactor) << (QP_BY_6));
            
        end     
       
    end
    
endmodule
