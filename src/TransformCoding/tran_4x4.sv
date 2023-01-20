`timescale 1ns / 1ps

module tran_4x4 #(
    parameter BIT_LENGTH = 31)(
    input clk,
    input enable,
    input reset,
    input signed [7:0] residuals [15:0],
    output reg signed [BIT_LENGTH : 0] transformed [15:0]);
    
    reg signed [BIT_LENGTH : 0] intermediate [15:0];
    reg [5:0] i;

    always @(posedge clk) begin
        
        if(enable) begin
        
        // Stage 1
        // Row 1
            intermediate[0] = residuals[0] + residuals[4] + residuals[8] + residuals[12];
            intermediate[1] = residuals[1] + residuals[5] + residuals[9] + residuals[13];
            intermediate[2] = residuals[2] + residuals[6] + residuals[10] + residuals[14];
            intermediate[3] = residuals[3] + residuals[7] + residuals[11] + residuals[15];
        // Row 2
            intermediate[4] = (residuals[0]<<1) + residuals[4] - residuals[8] - (residuals[12]<<1);
            intermediate[5] = (residuals[1]<<1) + residuals[5] - residuals[9] - (residuals[13]<<1);
            intermediate[6] = (residuals[2]<<1) + residuals[6] - residuals[10] - (residuals[14]<<1);
            intermediate[7] = (residuals[3]<<1) + residuals[7] - residuals[11] - (residuals[15]<<1);   
            
        // Row 3
            intermediate[8] = residuals[0] - residuals[4] - residuals[8] + residuals[12];
            intermediate[9] = residuals[1] - residuals[5] - residuals[9] + residuals[13];
            intermediate[10] = residuals[2] - residuals[6] - residuals[10] + residuals[14];
            intermediate[11] = residuals[3] - residuals[7] - residuals[11] + residuals[15];
            
       // Row 4
            intermediate[12] = residuals[0] - (residuals[4]<<1) + (residuals[8]<<1) - residuals[12];
            intermediate[13] = residuals[1] - (residuals[5]<<1) + (residuals[9]<<1) - residuals[13];
            intermediate[14] = residuals[2] - (residuals[6]<<1) + (residuals[10]<<1) - residuals[14];
            intermediate[15] = residuals[3] - (residuals[7]<<1) + (residuals[11]<<1) - residuals[15];
            
       // Stage 2
       // Row 1
            transformed[0] = intermediate[0] + intermediate[1] + intermediate[2] + intermediate[3];
            transformed[1] = (intermediate[0]<<1) + intermediate[1] - intermediate[2] - (intermediate[3]<<1);
            transformed[2] = intermediate[0] - intermediate[1] - intermediate[2] + intermediate[3];
            transformed[3] = intermediate[0] - (intermediate[1]<<1) + (intermediate[2]<<1) - intermediate[3];
            
       // Row 2
            transformed[4] = intermediate[4] + intermediate[5] + intermediate[6] + intermediate[7];
            transformed[5] = (intermediate[4]<<1) + intermediate[5] - intermediate[6] - (intermediate[7]<<1);
            transformed[6] = intermediate[4] - intermediate[5] - intermediate[6] + intermediate[7];
            transformed[7] = intermediate[4] - (intermediate[5]<<1) + (intermediate[6]<<1) - intermediate[7];
            
       // Row 3
            transformed[8] = intermediate[8] + intermediate[9] + intermediate[10] + intermediate[11];
            transformed[9] = (intermediate[8]<<1) + intermediate[9] - intermediate[10] - (intermediate[11]<<1);
            transformed[10] = intermediate[8] - intermediate[9] - intermediate[10] + intermediate[11];
            transformed[11] = intermediate[8] - (intermediate[9]<<1) + (intermediate[10]<<1) - intermediate[11];
 
       // Row 4
            transformed[12] = intermediate[12] + intermediate[13] + intermediate[14] + intermediate[15];
            transformed[13] = (intermediate[12]<<1) + intermediate[13] - intermediate[14] - (intermediate[15]<<1);
            transformed[14] = intermediate[12] - intermediate[13] - intermediate[14] + intermediate[15];
            transformed[15] = intermediate[12] - (intermediate[13]<<1) + (intermediate[14]<<1) - intermediate[15];  
            
        end
          
     end

endmodule
