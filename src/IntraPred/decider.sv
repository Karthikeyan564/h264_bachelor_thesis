`timescale 1ns / 1ps

module decider #(
    parameter WIDTH = 1280,
    parameter LENGTH = 720,
    parameter MB_SIZE_L = 8,
    parameter MB_SIZE_W = 8)(
    input clk,
    input reset,
    input enable,
    input [7:0] sads [(MB_SIZE_L == 8 ? 2 : 7):0],
    output reg [2:0] mode);
    
    // Counters
    reg [3:0] i;
    
    reg [2:0] min;
    
    
    always @ (posedge clk) begin
    
        if (enable) begin
            
             min = 0;
    
             for (i = 1; i < MB_SIZE_L; i = i + 1) 
                 if (sads[i] < sads[min]) min = i;
                 
             mode = min;
                            
        end    
    
    end
    
endmodule
