`timescale 1ns / 1ps

module reser_chroma8x8(
    input clk,
    input reset, 
    input enable,
    input [7:0] mb [63:0],
    input [7:0] vpred [63:0],
    input [7:0] hpred [63:0],
    input [7:0] dcpred [63:0],
    output reg signed [7:0] vres [63:0],
    output reg signed [7:0] hres [63:0],
    output reg signed [7:0] dcres [63:0]);
    
    integer i;
    
    always @(posedge clk) begin
    
        if (enable == 1) begin
        
            for(i=0;i<64;i=i+1) begin
                vres[i] <= mb[i] - vpred[i];
                hres[i] <= mb[i] - hpred[i];
                dcres[i] <= mb[i] - dcpred[i];
             end
             
        end
          
    end
    
endmodule
