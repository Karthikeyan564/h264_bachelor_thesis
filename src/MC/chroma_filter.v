`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.11.2022 10:03:14
// Design Name: 
// Module Name: chroma_filter
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

module chroma_filter(input [2:0] xfrac, yfrac, input [7:0] A, B, C, D, output reg [16:0] half_chrome);

wire [2:0] temp1, temp2;
wire [13:0] temp3, temp4, temp5, temp6;

assign temp1 = 4'b1000 - xfrac;
assign temp2 = 4'b1000 - yfrac;
assign temp3 = A * temp1 * temp2;
assign temp4 = B * xfrac * temp2;
assign temp5 = C * yfrac * temp1;
assign temp6 = D * xfrac * yfrac;


always @ * 

begin

half_chrome <= temp3 + temp4 + temp5 + temp6;

end

endmodule