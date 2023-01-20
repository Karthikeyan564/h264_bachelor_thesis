`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.10.2022 00:44:48
// Design Name: 
// Module Name: fme
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


module fme(input clk, rst, input[7:0] pix_pos, output reg [7:0] quat_val, output reg [3:0] half_best, quat_best);

reg [8:0][7:0] half, quat ;
reg rst1, rst2, rst3;
wire [3:0] best, best1;
reg quat_en;
wire [8:0][7:0] int_pix;
wire [7:0][7:0] half_pix;
reg [7:0] lut [255:0];
reg [3:0] state;
wire done, done1, done2;
wire [3:0][7:0] half_pix_temp;
wire [15:0][7:0] cur_pix;
parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7 = 7, S8 = 8, S9 = 9;

initial begin
    $readmemh("E:/Idaten/src/FME/mbvalues_ref.mem" ,lut); 
end

assign int_pix[0] = lut[pix_pos-17];
assign int_pix[1] = lut[pix_pos-16];
assign int_pix[2] = lut[pix_pos-15];
assign int_pix[3] = lut[pix_pos+17];
assign int_pix[4] = lut[pix_pos];
assign int_pix[5] = lut[pix_pos+1];
assign int_pix[6] = lut[pix_pos+15];
assign int_pix[7] = lut[pix_pos+16];
assign int_pix[8] = lut[pix_pos+17];

assign half_pix[0] = half_pix_temp[0];
assign half_pix[1] = half_pix_temp[2];
assign half_pix[2] = lut[pix_pos-15];
assign half_pix[3] = lut[pix_pos+17];
assign half_pix[4] = half_pix_temp[3];
assign half_pix[5] = half_pix_temp[1];
assign half_pix[6] = lut[pix_pos+15];
assign half_pix[7] = lut[pix_pos-17];

assign cur_pix[0] = lut[pix_pos-15];
assign cur_pix[1] = lut[pix_pos-14];
assign cur_pix[2] = lut[pix_pos-13];
assign cur_pix[3] = lut[pix_pos-12];
assign cur_pix[4] = lut[pix_pos-11];
assign cur_pix[5] = lut[pix_pos-10];
assign cur_pix[6] = lut[pix_pos-9];
assign cur_pix[7] = lut[pix_pos-8];
assign cur_pix[8] = lut[pix_pos-7];
assign cur_pix[9] = lut[pix_pos-6];
assign cur_pix[10] = lut[pix_pos-5];
assign cur_pix[11] = lut[pix_pos-4];
assign cur_pix[12] = lut[pix_pos-3];
assign cur_pix[13] = lut[pix_pos-2];
assign cur_pix[14] = lut[pix_pos-1];
assign cur_pix[15] = lut[pix_pos];


half_ip dutq (.clk(clk), .rst(rst1), .int_ind_pix(pix_pos), .lut(lut), .half(half), .done(done),.half_pix(half_pix_temp));
satd_gen dutw (.clk(clk), .rst1(rst2), .half_quat(half), .cur_pix(cur_pix), .best(best), .done(done1));
quat_ip dute (.en(quat_en), .int_pix(int_pix), .half_pix(half_pix), .half_cand(half), .best(best), .quat(quat));
satd_gen dutr (.clk(clk), .rst1(rst3), .half_quat(quat), .cur_pix(cur_pix), .best(best1), .done(done2));

always @ (posedge clk or negedge rst)
begin
if (!rst) begin
state<=S0;
end 
else begin
case(state)
S0: begin rst1 <= 1; rst2 <= 1; rst3 <= 1;  state<= S1;end
S1: begin rst1 <= 0; state <= S2;end
S2: begin rst1<= 1; state <= S3; end
S3: begin if(done) begin rst2 <= 0; state <= S4; end end
S4: begin rst2<= 1; state <= S5; end
S5: begin if (done1) begin quat_en <= 1; state <= S6; half_best <= best; end end
S6: begin quat_en <= 0; rst3 <= 0; state <= S7; end
S7: begin rst3<=1 ; state <= S8; end
S8: begin if(done2) begin state <= S9; quat_val <= quat[best1]; quat_best<= best1;end end
S9: begin state<= S9; end
default: begin state<=S9; end
endcase
end

end


endmodule
