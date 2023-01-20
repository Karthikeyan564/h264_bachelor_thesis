`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.10.2022 20:57:53
// Design Name: 
// Module Name: six_tf
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

module add1 (input [7:0] a,f, output reg [7:0] i1);

always @ *
 i1 <= a+f;
 
endmodule

module add2 (input [7:0] b,e,c,d, output reg [7:0] i2);

wire [7:0] o;
assign o = (c+d) << 2;

always @ *
begin
  i2 <= b+e+o;
end

endmodule

module add3 (input [7:0] t1, t2, output reg [7:0] i3);

wire [7:0] a1, a2;
assign a1 = t1 - t2;
assign a2 = (t2 << 2);

always @ *
    i3 <= a1 - a2;
endmodule


module six_tf(input clk , input [7:0] a,b,c,d,e,f, output reg [7:0] half);

reg [7:0] t1, t2;
wire [7:0] i1, i2, i3;

add1 dut1 (.a(a), .f(f), .i1(i1));
add2 dut2 (.b(b), .c(c), .d(d), .e(e), .i2(i2));
add3 dut3 (.t1(t1), .t2(t2), .i3(i3));

always @ (posedge clk)
begin

t1 <= i1;
t2 <= i2;
half <= i3;

end

endmodule
