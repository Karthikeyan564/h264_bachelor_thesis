`timescale 1ns / 1ps

module quant_4x4 #(
    parameter BIT_LENGTH = 15,
    parameter finter = 21845,
    parameter fintra = 11)(
    input clk,
    input enable,
    input reset,
    input mode,
    input signed [BIT_LENGTH : 0] transformed [15:0],
    input [3:0] QP_BY_6,
    input [2:0] QP_MOD_6,
    output reg signed [BIT_LENGTH : 0] quantized [15:0]);
    
    reg [4:0] i;
    reg [13:0] multfactor;
    reg [BIT_LENGTH:0] intermediate;
    reg wasnegative;
    
    always @ (posedge clk) begin
                
        for (i = 0; i < 16; i = i+1) begin
            
            if (i == 5'd0 || i == 5'd2 || i == 5'd8 || i == 5'd10) 
                case (QP_MOD_6)
                    3'b000: multfactor = 13107;
                    3'b001: multfactor = 11916;
                    3'b010: multfactor = 10082;
                    3'b011: multfactor = 9362;
                    3'b100: multfactor = 8192;
                    3'b101: multfactor = 7282;
                endcase
            else if (i == 5'd5 || i == 5'd7 || i == 5'd12 || i == 5'd15) 
                case (QP_MOD_6)
                    3'b000: multfactor = 5243;
                    3'b001: multfactor = 4660;
                    3'b010: multfactor = 4194;
                    3'b011: multfactor = 3647;
                    3'b100: multfactor = 3355;
                    3'b101: multfactor = 2893;
                endcase 
            else 
                case (QP_MOD_6)
                    3'b000: multfactor = 8066;
                    3'b001: multfactor = 7490;
                    3'b010: multfactor = 6554;
                    3'b011: multfactor = 5825;
                    3'b100: multfactor = 5243;
                    3'b101: multfactor = 4559;
                endcase 
                
            // quantized[i] = mode ? (((transformed[i] * multfactor) + fintra) >> (QP_BY_6+15)) : (((transformed[i] * multfactor) + finter) >> (QP_BY_6+15));
            
            if(transformed[i][31] == 1) 
            begin
                intermediate = (-transformed[i]);
                wasnegative = 1;
            end
            else begin
                intermediate = transformed[i];
                wasnegative = 0;
            end
            
            quantized[i] = (((intermediate * multfactor) + finter) >> (QP_BY_6+15));
            
            if (wasnegative == 1) quantized[i] = (~(quantized[i])+1);
            else quantized[i][31] = 0;
                
        end     
       
    end
    
endmodule
