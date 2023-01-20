`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.12.2022 23:51:42
// Design Name: 
// Module Name: tb_half_ip
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


module tb_fme();

reg clk, rst;
reg [7:0] pix_pos;
wire [7:0] quat_val;
wire [3:0] quat_best, half_best;


fme main_dut (.clk(clk), .rst(rst), .pix_pos(pix_pos), .quat_val(quat_val), .quat_best(quat_best),. half_best(half_best));

always #5 clk = ~clk;

initial begin
clk <= 0;
pix_pos <= 100;
rst <= 1;
#2 rst<= 0;
#2 rst<= 1;

end

endmodule
