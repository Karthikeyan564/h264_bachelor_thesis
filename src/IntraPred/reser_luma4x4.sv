`timescale 1ns/1ps

module reser_luma4x4 (
    input clk,
    input reset,
    input enable,
    input [7:0] mb [15:0],
    input [7:0] vpred [15:0],
	input [7:0] hpred [15:0],
    input [7:0] vlpred [15:0],
	input [7:0] vrpred [15:0],
	input [7:0] hupred [15:0],
	input [7:0] hdpred [15:0],
    input [7:0] ddlpred [15:0],
	input [7:0] ddrpred [15:0],
    output reg signed [7:0] vres [15:0],
	output reg signed [7:0] hres [15:0],
    output reg signed [7:0] vlres [15:0],
	output reg signed [7:0] vrres [15:0],
	output reg signed [7:0] hures [15:0],
	output reg signed [7:0] hdres [15:0],
    output reg signed [7:0] ddlres [15:0],
	output reg signed [7:0] ddrres [15:0]);
	
	reg [4:0] i;

    always @(posedge clk) begin

        if (enable) begin

            for (i = 0; i < 16; i = i + 1) begin

                vres[i] = mb[i] - vpred[i];
                hres[i] = mb[i] - hpred[i];
                vlres[i] = mb[i] - vlpred[i];
                vrres[i] = mb[i] - vrpred[i];
                hures[i] = mb[i] - hupred[i];
                hdres[i] = mb[i] - hdpred[i];
                ddlres[i] = mb[i] - ddlpred[i];
                ddrres[i] = mb[i] - ddrpred[i];

            end

        end

    end


endmodule