`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.10.2022 00:43:28
// Design Name: 
// Module Name: quat_ip
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


module quat_ip(input en, input [8:0][7:0] int_pix, half_cand, input [7:0][7:0] half_pix, input [3:0] best, output reg [8:0][7:0] quat);

reg [7:0][7:0] x, y;

genvar i;
generate
    for (i=0; i<4; i++) begin
        two_tf duty (.x(x[i]), .y(y[i]), .quat(quat[i]));
    end
endgenerate

generate
    for (i=5; i<9; i++) begin
        two_tf duty (.x(x[i-1]), .y(y[i-1]), .quat(quat[i]));
    end
endgenerate



always @ (posedge en)
begin

case(best)
4'b0000: begin 
         x[0] <= int_pix[0]; y[0]<=half_cand[0]; 
         x[1] <= half_pix[0]; y[1]<=half_cand[0]; 
         x[2] <= int_pix[1]; y[2]<=half_cand[0]; 
         x[3] <= half_pix[7]; y[3]<=half_cand[0]; 
         quat[4] <= half_cand[0]; 
         x[4] <= half_cand[1]; y[4]<=half_cand[0]; 
         x[5] <= int_pix[3]; y[5]<=half_cand[0]; 
         x[6] <= half_cand[3]; y[6]<=half_cand[0]; 
         x[7] <= int_pix[4]; y[7]<=half_cand[0]; 
         end

4'b0001:begin 
         x[0] <= half_pix[0]; y[0]<=half_cand[1]; 
         x[1] <= int_pix[1]; y[1]<=half_cand[1]; 
         x[2] <= half_pix[1]; y[2]<=half_cand[1]; 
         x[3] <= half_cand[0]; y[3]<=half_cand[1]; 
         quat[4] <= half_cand[1];
         x[4] <= half_cand[2]; y[4]<=half_cand[1]; 
         x[5] <= half_cand[3]; y[5]<=half_cand[1]; 
         x[6] <= int_pix[4]; y[6]<=half_cand[1]; 
         x[7] <= half_cand[5]; y[7]<=half_cand[1]; 
         end
4'b0010:begin 
         x[0] <= int_pix[1]; y[0]<=half_cand[2]; 
         x[1] <= half_pix[1]; y[1]<=half_cand[2]; 
         x[2] <= int_pix[2]; y[2]<=half_cand[2]; 
         x[3] <= half_cand[1]; y[3]<=half_cand[2]; 
         quat[4] <= half_cand[2]; 
         x[4] <= half_pix[2]; y[4]<=half_cand[2]; 
         x[5] <= int_pix[4]; y[5]<=half_cand[2]; 
         x[6] <= half_cand[5]; y[6]<=half_cand[2]; 
         x[7] <= int_pix[5]; y[7]<=half_cand[2]; 
         end
4'b0011:begin 
         x[0] <= half_pix[7]; y[0]<=half_cand[3]; 
         x[1] <= half_cand[0]; y[1]<=half_cand[3]; 
         x[2] <= half_cand[1]; y[2]<=half_cand[3]; 
         x[3] <= int_pix[3]; y[3]<=half_cand[3]; 
         quat[4] <= half_cand[3]; 
         x[4] <= int_pix[4]; y[4]<=half_cand[3]; 
         x[5] <= half_pix[6]; y[5]<=half_cand[3]; 
         x[6] <= half_cand[6]; y[6]<=half_cand[3]; 
         x[7] <= half_cand[7]; y[7]<=half_cand[3]; 
         end
4'b0100:begin 
         x[0] <= half_cand[0]; y[0]<=half_cand[4]; 
         x[1] <= half_cand[1]; y[1]<=half_cand[4]; 
         x[2] <= half_cand[2]; y[2]<=half_cand[4]; 
         x[3] <= half_cand[3]; y[3]<=half_cand[4]; 
         quat[4] <= half_cand[4]; 
         x[4] <= half_cand[5]; y[4]<=half_cand[4]; 
         x[5] <= half_cand[6]; y[5]<=half_cand[4]; 
         x[6] <= half_cand[7]; y[6]<=half_cand[4]; 
         x[7] <= half_cand[8]; y[7]<=half_cand[4]; 
         end
4'b0101:begin 
         x[0] <= half_cand[1]; y[0]<=half_cand[5]; 
         x[1] <= half_cand[2]; y[1]<=half_cand[5]; 
         x[2] <= half_pix[2]; y[2]<=half_cand[5]; 
         x[3] <= int_pix[4]; y[3]<=half_cand[5]; 
         quat[4] <= half_cand[5]; 
         x[4] <= int_pix[5]; y[4]<=half_cand[5]; 
         x[5] <= half_cand[7]; y[5]<=half_cand[5]; 
         x[6] <= half_cand[8]; y[6]<=half_cand[5]; 
         x[7] <= half_pix[3]; y[7]<=half_cand[5]; 
         end
4'b0110:begin 
         x[0] <= int_pix[3]; y[0]<=half_cand[6]; 
         x[1] <= half_cand[3]; y[1]<=half_cand[6]; 
         x[2] <= int_pix[4]; y[2]<=half_cand[6]; 
         x[3] <= half_pix[6]; y[3]<=half_cand[6]; 
         quat[4] <= half_cand[6]; 
         x[4] <= half_cand[7]; y[4]<=half_cand[6]; 
         x[5] <= int_pix[6]; y[5]<=half_cand[6]; 
         x[6] <= half_pix[5]; y[6]<=half_cand[6]; 
         x[7] <= int_pix[7]; y[7]<=half_cand[6]; 
         end
4'b0111:begin 
         x[0] <= half_cand[3]; y[0]<=half_cand[7]; 
         x[1] <= int_pix[4]; y[1]<=half_cand[7]; 
         x[2] <= half_cand[5]; y[2]<=half_cand[7]; 
         x[3] <= half_cand[6]; y[3]<=half_cand[7]; 
         quat[4] <= half_cand[7]; 
         x[4] <= half_cand[8]; y[4]<=half_cand[7]; 
         x[5] <= half_pix[5]; y[5]<=half_cand[7]; 
         x[6] <= int_pix[7]; y[6]<=half_cand[7]; 
         x[7] <= half_pix[4]; y[7]<=half_cand[7]; 
         end
4'b1000:begin 
         x[0] <= int_pix[4]; y[0]<=half_cand[8]; 
         x[1] <= half_pix[5]; y[1]<=half_cand[8]; 
         x[2] <= int_pix[5]; y[2]<=half_cand[8]; 
         x[3] <= half_cand[7]; y[3]<=half_cand[8]; 
         quat[4] <= half_cand[8]; 
         x[4] <= half_pix[3]; y[4]<=half_cand[8]; 
         x[5] <= int_pix[7]; y[5]<=half_cand[8]; 
         x[6] <= half_pix[4]; y[6]<=half_cand[8]; 
         x[7] <= int_pix[8]; y[7]<=half_cand[8]; 
         end
default:begin 
         x[0] <= int_pix[0]; y[0]<=half_cand[0]; 
         x[1] <= half_pix[0]; y[1]<=half_cand[0]; 
         x[2] <= int_pix[1]; y[2]<=half_cand[0]; 
         x[3] <= half_pix[7]; y[3]<=half_cand[0]; 
         quat[4] <= half_cand[0]; 
         x[4] <= half_cand[1]; y[4]<=half_cand[0]; 
         x[5] <= int_pix[3]; y[5]<=half_cand[0]; 
         x[6] <= half_cand[3]; y[6]<=half_cand[0]; 
         x[7] <= int_pix[4]; y[7]<=half_cand[0]; 
         end
endcase

end

endmodule
