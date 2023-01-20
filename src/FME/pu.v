`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.10.2022 00:43:51
// Design Name: 
// Module Name: pu
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

module oneDtrans1 (input [8:0] rc1, rc2, rc3, rc4, output reg [11:0] op1, op2, op3, op4);

wire [9:0] i1, i2, i3, i4;

assign i1 = rc1 + rc4;
assign i2 = rc2 + rc3;
assign i3 = rc2 - rc3;
assign i4 = rc1 - rc4;

always @ rc1
begin
op1 <= i1 + i2;
op2 <= i3 + i4;
op3 <= i1 - i2;
op4 <= i4 - i3;
end

endmodule

module oneDtrans2 (input [11:0] rc1, rc2, rc3, rc4, output reg [14:0] op1, op2, op3, op4);

wire [12:0] i1, i2, i3, i4;

assign i1 = rc1 + rc4;
assign i2 = rc2 + rc3;
assign i3 = rc2 - rc3;
assign i4 = rc1 - rc4;

always @ rc1
begin
op1 <= i1 + i2;
op2 <= i3 + i4;
op3 <= i1 - i2;
op4 <= i4 - i3;
end

endmodule

module transreg (input [11:0] up, right, out1, input [1:0] sel, output wire [11:0] left, down);

reg [11:0] inter;
assign left = inter;
assign down = inter;

always @ *
begin
case(sel)
         2'b00 : inter <= out1;  
         2'b01 : inter <= up;  
         2'b10 : inter <= right;  
         2'b11 : inter <= 0;
endcase
end

endmodule

module pu(input [1:0] sel, input [8:0] rc1, rc2, rc3, rc4, output reg [15:0] i1d3);


wire [11:0] op1, op2, op3, op4;
reg [11:0] rc11, rc12, rc13, rc14;
wire [14:0] op11, op21, op31, op41;
wire [15:0][11:0] up, down, left, right;
reg  [15:0] i1d1, i1d2;

oneDtrans1 duta (.rc1(rc1),.rc2(rc2),.rc3(rc3),.rc4(rc4),.op1(op1),.op2(op2),.op3(op3),.op4(op4));
oneDtrans2 dutb (.rc1(rc11),.rc2(rc12),.rc3(rc13),.rc4(rc14),.op1(op11),.op2(op21),.op3(op31),.op4(op41));

genvar i;
generate
    for (i=0; i<16; i++) begin
    transreg dut1 (.up(up[i]), .down(down[i]), .left(left[i]), .right(right[i]), .sel(sel), .out1(left[i]));
    end
endgenerate

assign up[0] = op1;
assign up[1] = op2;
assign up[2] = op3;
assign up[3] = op4;
assign up[4] = down[0];
assign up[5] = down[1];
assign up[6] = down[2];
assign up[7] = down[3];
assign up[8] = down[4];
assign up[9] = down[5];
assign up[10] = down[6];
assign up[11] = down[7];
assign up[12] = down[8];
assign up[13] = down[9];
assign up[14] = down[10];
assign up[15] = down[11]; 

assign right[0] = op1;
assign right[1] = left[0];
assign right[2] = left[1];
assign right[3] = left[2];
assign right[4] = op2;
assign right[5] = left[4];
assign right[6] = left[5];
assign right[7] = left[6];
assign right[8] = op3;
assign right[9] = left[8];
assign right[10] = left[9];
assign right[11] = left[10];
assign right[12] = op4;
assign right[13] = left[12];
assign right[14] = left[13];
assign right[15] = left[14];

assign rc11 = left[3];
assign rc12 = left[7];
assign rc13 = left[11];
assign rc14 = left[15];

always @ op11
begin 

i1d1 <= op11 + op21;
i1d2 <= op31 + op41;
i1d3 <= i1d1 + i1d2;

end

endmodule


module main_fsm(input clk, input rst, input [7:0] ref_pix, input [15:0][7:0] cur_pix, output reg [3:0] state, output reg on, output reg [15:0] distort);

parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7 = 7, S8 = 8, S9 = 9;
reg [8:0] rc1, rc2, rc3, rc4;
reg [1:0] sel;
reg [15:0] trans_out;


pu dutx (.sel(sel), .rc1(rc1), .rc2(rc2), .rc3(rc3), .rc4(rc4), .i1d3(trans_out));

assign on = (state[3] == 1'b1 && state[0] == 1'b1) ? 1'b0 : 1'b1;

always @ (posedge clk or negedge rst)
begin
if (!rst)
state <= S0;
else begin
case(state)
S0: begin state<= S1; sel <= 2'b01; distort <= 4'b0000; end
S1: begin state <= S2; rc1 <= (ref_pix - cur_pix[0]) >= 0 ? ref_pix - cur_pix[0] : cur_pix[0] - ref_pix;
                       rc2 <= (ref_pix - cur_pix[1]) >= 0 ? ref_pix - cur_pix[1] : cur_pix[1] - ref_pix;
                       rc3 <= (ref_pix - cur_pix[2]) >= 0 ? ref_pix - cur_pix[2] : cur_pix[2] - ref_pix;
                       rc4 <= (ref_pix - cur_pix[3]) >= 0 ? ref_pix - cur_pix[3] : cur_pix[3] - ref_pix; 
    end
S2: begin state <= S3; rc1 <= (ref_pix - cur_pix[4]) >= 0 ? ref_pix - cur_pix[4] : cur_pix[4] - ref_pix;
                       rc2 <= (ref_pix - cur_pix[5]) >= 0 ? ref_pix - cur_pix[5] : cur_pix[5] - ref_pix;
                       rc3 <= (ref_pix - cur_pix[6]) >= 0 ? ref_pix - cur_pix[6] : cur_pix[6] - ref_pix;
                       rc4 <= (ref_pix - cur_pix[7]) >= 0 ? ref_pix - cur_pix[7] : cur_pix[7] - ref_pix; 
    end
S3: begin state <= S4; rc1 <= (ref_pix - cur_pix[8]) >= 0 ? ref_pix - cur_pix[8] : cur_pix[8] - ref_pix;
                       rc2 <= (ref_pix - cur_pix[9]) >= 0 ? ref_pix - cur_pix[9] : cur_pix[9] - ref_pix;
                       rc3 <= (ref_pix - cur_pix[10]) >= 0 ? ref_pix - cur_pix[10] : cur_pix[10] - ref_pix;
                       rc4 <= (ref_pix - cur_pix[11]) >= 0 ? ref_pix - cur_pix[11] : cur_pix[11] - ref_pix; 
    end
S4: begin state <= S5; rc1 <= (ref_pix - cur_pix[12]) >= 0 ? ref_pix - cur_pix[12] : cur_pix[12] - ref_pix;
                       rc2 <= (ref_pix - cur_pix[13]) >= 0 ? ref_pix - cur_pix[13] : cur_pix[13] - ref_pix;
                       rc3 <= (ref_pix - cur_pix[14]) >= 0 ? ref_pix - cur_pix[14] : cur_pix[14] - ref_pix;
                       rc4 <= (ref_pix - cur_pix[15]) >= 0 ? ref_pix - cur_pix[15] : cur_pix[15] - ref_pix; 
          
    end
S5: begin state <= S6; sel <= 2'b10; distort <= distort+trans_out; end
S6: begin state <= S7; distort <= distort+trans_out; end
S7: begin state <= S8; distort <= distort+trans_out; end
S8: begin state <= S9; distort <= distort+trans_out; end
S9: begin state <= S9; sel <= 2'b00; end

endcase
end
end


endmodule
 

