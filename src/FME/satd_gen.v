`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.10.2022 00:44:28
// Design Name: 
// Module Name: satd_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module satd_gen(input clk, rst1, input [8:0][7:0] half_quat , input [15:0][7:0] cur_pix, output wire [3:0] best, output reg done);

wire [3:0] state [8:0];
wire on [8:0];
wire [8:0][15:0] distort;
wire com_en;


genvar i;
generate
    for (i=0; i<9; i++) begin
    main_fsm dut2 (.clk(clk), .rst(rst1),.ref_pix(half_quat[i]), .cur_pix(cur_pix), .state(state[i]), .on(on[i]), .distort(distort[i]));
    end
endgenerate

assign com_en = on[0] ? 1'b0 : 1'b1;

comparator dutx (.clk(clk), .en(com_en), .distort(distort), .best(best), .done(done)); 

endmodule
