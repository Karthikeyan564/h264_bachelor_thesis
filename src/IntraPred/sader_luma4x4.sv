`timescale 1ns/1ps

module sader_luma4x4 (
    input clk,
    input reset,
    input enable,
    input signed [7:0] vres [15:0],
	input signed [7:0] hres [15:0],
    input signed [7:0] vlres [15:0],
	input signed [7:0] vrres [15:0],
	input signed [7:0] hures [15:0],
	input signed [7:0] hdres [15:0],
    input signed [7:0] ddlres [15:0],
	input signed [7:0] ddrres [15:0],
	output reg [2:0] mode,
	output reg signed [7:0] res [15:0]);
	
    reg [7:0] sads [7:0];
    reg [2:0] min;

    reg signed [7:0] vsamp;
    reg signed [7:0] hsamp;
    reg signed [7:0] vlsamp;
    reg signed [7:0] vrsamp;
    reg signed [7:0] husamp;
    reg signed [7:0] hdsamp;
    reg signed [7:0] ddlsamp;
    reg signed [7:0] ddrsamp;
    
    integer i;
    integer j;
    
    always @(posedge clk) begin

        if (enable) begin

            for(j =0; j<8;j=j+1)begin
                sads[j] = 8'b00000000;
            end

            for (i = 0; i < 16; i = i + 1) begin
                
                vsamp = vres[i]; vsamp = vsamp < 0 ? vsamp * -1 : vsamp; sads[0] = sads[0] + vsamp; 
                hsamp = hres[i]; hsamp = hsamp < 0 ? hsamp * -1 : hsamp; sads[1] = sads[1] + hsamp;
                vlsamp = vlres[i]; vlsamp = vlsamp < 0 ? vlsamp * -1 : vlsamp; sads[2] = sads[2] + vlsamp;
                vrsamp = vrres[i]; vrsamp = vrsamp < 0 ? vrsamp * -1 : vrsamp; sads[3] = sads[3] + vrsamp;
                husamp = hures[i]; husamp = husamp < 0 ? husamp * -1 : husamp; sads[4] = sads[4] + husamp;
                hdsamp = hdres[i]; hdsamp = hdsamp < 0 ? hdsamp * -1 : hdsamp; sads[5] = sads[5] + hdsamp;
                ddlsamp = ddlres[i]; ddlsamp = ddlsamp < 0 ? ddlsamp * -1 : ddlsamp; sads[6] = sads[6] + ddlsamp;
                ddrsamp = ddrres[i]; ddrsamp = ddrsamp < 0 ? ddrsamp * -1 : ddrsamp; sads[7] = sads[7] + ddrsamp;

            end
            
            min = 0;
    
            for (i = 1; i < 8; i = i + 1) 
                if (sads[i] < sads[min]) min = i;
                 
            mode = min;

            case (mode)
                3'd0 : res = vres;
                3'd1 : res = hres;
                3'd2 : res = vlres;
                3'd3 : res = vrres;
                3'd4 : res = hures;
                3'd5 : res = hdres;
                3'd6 : res = ddlres;
                3'd7 : res = ddrres;
                default : res = vres;
            endcase

        end

    end

endmodule