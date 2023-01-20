`timescale 1ns/1ps

module sader_chroma8x8 (
    input clk,
    input reset,
    input enable,
    input signed [7:0] vres [63:0],
	input signed [7:0] hres [63:0],
	input signed [7:0] dcres [63:0],
    output reg [2:0] mode,
    output reg signed [7:0] res [63:0]);
    
    reg [7:0] sads [2:0];
    reg [2:0] min;
    
    reg signed [7:0] vsamp8;
    reg signed [7:0] hsamp8;
    reg signed [7:0] dcsamp8;
    
    integer i;
    integer j;

    always @(posedge clk) begin

        if (enable) begin

            for(j =0; j<3;j=j+1)begin
                sads[j] = 8'b00000000;
            end

            for (i = 0; i < 64; i = i + 1) begin
                
                vsamp8 = vres[i]; vsamp8 = vsamp8 < 0 ? vsamp8 * -1 : vsamp8; sads[0] = sads[0] + vsamp8; 
                hsamp8 = hres[i]; hsamp8 = hsamp8 < 0 ? hsamp8 * -1 : hsamp8; sads[1] = sads[1] + hsamp8;
                dcsamp8 = dcres[i]; dcsamp8 = dcsamp8 < 0 ? dcsamp8 * -1 : dcsamp8; sads[2] = sads[2] + dcsamp8;

            end
        
            min = 0;
    
            for (i = 1; i < 3; i = i + 1) 
                if (sads[i] < sads[min]) min = i;
                 
            mode = min;

            case (mode)
                3'd0 : res = vres;
                3'd1 : res = hres;
                3'd2 : res = dcres;
                default : res = vres;
            endcase

        end

    end

endmodule

