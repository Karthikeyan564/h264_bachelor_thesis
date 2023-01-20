`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.10.2022 21:39:31
// Design Name: 
// Module Name: half_ip
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// : 
// 
// Revision:Dependencies
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/* int_pix_ind - address of the centre integer pixel
 half - interpolated value*/
 
module half_ip(input clk, input rst, input [7:0] int_ind_pix, input [7:0] lut [255:0], output reg [8:0][7:0] half, output reg done, output reg [3:0][7:0] half_pix);

 

wire [47:0] pixels_int;
reg [47:0] pixels;
reg [7:0] temp_address;
reg [7:0] half_half [13:0];
wire [12:0] half_intr, half_act;




parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7 = 7, S8 = 8, S9 = 9, S10 = 10, S11 = 11, S12 = 12, S13 = 13, S14 = 14, 
              S15 = 15, S16 = 16, S17 = 17, S18 = 18, S19 = 19, S20 = 20, S21 = 21, S22 = 22, S23 = 23, S24 = 24, S25 = 25, S26 = 26, S27 = 27;
reg [4:0] state;

six_tf dut1 (.clk(clk), .a(pixels_int[7:0]), .b(pixels_int[15:8]), .c(pixels_int[23:16]), .d(pixels_int[31:24]), .e(pixels_int[39:32]), .f(pixels_int[47:40]), .half(half_intr));    
six_tf dut2 (.clk(clk), .a(pixels[7:0]), .b(pixels[15:8]), .c(pixels[23:16]), .d(pixels[31:24]), .e(pixels[39:32]), .f(pixels[47:40]), .half(half_act));

assign pixels_int[7:0] = lut[temp_address - 2];
assign pixels_int[15:8] = lut[temp_address - 1];
assign pixels_int[23:16] = lut[temp_address];
assign pixels_int[31:24] = lut[temp_address + 1];
assign pixels_int[39:32] = lut[temp_address + 2];
assign pixels_int[47:40] = lut[temp_address + 3];

always @ (posedge clk or negedge rst)
begin
if (!rst) begin
state <= S0; done <=0 ;
end 
else begin
case(state)
S0: begin state <= S1; temp_address <= int_ind_pix -48; end
S1: begin state <= S2; temp_address <= int_ind_pix -32;  end
S2: begin state <= S3; temp_address <= int_ind_pix -16; end
S3: begin state <= S4; temp_address <= int_ind_pix; half_half[0] <= (half_intr+16)>>5;   end
S4: begin state <= S5; temp_address <= int_ind_pix+16; half_half[1] <= (half_intr+16)>>5;half_pix[0]<= (half_intr+16)>>5;  end
S5: begin state <= S6; temp_address <= int_ind_pix+32;  half_half[2] <= (half_intr+16)>>5; end
S6: begin state <= S7; temp_address <= int_ind_pix+48;  half_half[3] <= (half_intr+16)>>5; end
S7: begin state <= S8; temp_address <= int_ind_pix -47; half_pix[1]<= (half_intr+16)>>5; half_half[4] <= (half_intr+16)>>5; end
S8: begin state <= S9; temp_address <= int_ind_pix -31; half_half[5] <= (half_intr+16)>>5; end
S9: begin state <= S10;temp_address <= int_ind_pix -15; half_half[6] <= (half_intr+16)>>5;  end
S10: begin state <= S11; temp_address <= int_ind_pix;  half_half[7] <= (half_intr+16)>>5;  end
S11: begin state <= S12; temp_address <= int_ind_pix+17; half_half[8] <= (half_intr+16)>>5;   end
S12: begin state <= S13; temp_address <= int_ind_pix+33; half_pix[2]<= (half_intr+16)>>5; half_half[9] <= (half_intr+16)>>5; end
S13: begin state <= S14; temp_address <= int_ind_pix+49; half_half[10] <= (half_intr+16)>>5;  end
S14: begin state <= S15; half_pix[3]<= (half_intr+16)>>5; half_half[11] <= (half_intr+16)>>5;   end
S15: begin state <= S16; half_half[12] <= (half_intr+16)>>5;  end
S16: begin state <= S17; //2
           pixels [7:0] <= lut [int_ind_pix]; 
           pixels [15:8] <= lut [int_ind_pix -16];
           pixels [23:16] <= lut [int_ind_pix -32];
           pixels [31:24] <= lut [int_ind_pix -48];
           pixels [39:32] <= lut [int_ind_pix +16];
           pixels [47:40] <= lut [int_ind_pix +32];
           half_half[13] <= (half_intr+16)>>5;
     end
S17: begin state <= S18; // 8
           pixels [7:0] <= lut [int_ind_pix]; 
           pixels [15:8] <= lut [int_ind_pix -16];
           pixels [23:16] <= lut [int_ind_pix -32];
           pixels [31:24] <= lut [int_ind_pix + 48];
           pixels [39:32] <= lut [int_ind_pix +16];
           pixels [47:40] <= lut [int_ind_pix +32]; 
     end
S18: begin state <= S19; // 4
           pixels [7:0] <= lut [int_ind_pix]; 
           pixels [15:8] <= lut [int_ind_pix -1];
           pixels [23:16] <= lut [int_ind_pix -2];
           pixels [31:24] <= lut [int_ind_pix -3 ];
           pixels [39:32] <= lut [int_ind_pix +1];
           pixels [47:40] <= lut [int_ind_pix +2]; 
           
     end
S19: begin state <= S20; // 6
           pixels [7:0] <= lut [int_ind_pix]; 
           pixels [15:8] <= lut [int_ind_pix -1];
           pixels [23:16] <= lut [int_ind_pix -2];
           pixels [31:24] <= lut [int_ind_pix +3];
           pixels [39:32] <= lut [int_ind_pix +1];
           pixels [47:40] <= lut [int_ind_pix +2];
           half[1] <= (half_act+16)>>5; 
           
           
     end
S20: begin state <= S21; // 1
           pixels [7:0] <= half_half [0]; 
           pixels [15:8] <= half_half [1];
           pixels [23:16] <= half_half [2];
           pixels [31:24] <= half_half [3];
           pixels [39:32] <= half_half [4];
           pixels [47:40] <= half_half [5];
           half[7] <= (half_act+16)>>5; 
           
           
     end
S21: begin state <= S22; // 7
           pixels [7:0] <= half_half [6]; 
           pixels [15:8] <= half_half [1];
           pixels [23:16] <= half_half [2];
           pixels [31:24] <= half_half [3];
           pixels [39:32] <= half_half [4];
           pixels [47:40] <= half_half [5]; 
           half[3] <= (half_act+16)>>5;
           
           
     end
S22: begin state <= S23; // 3
           pixels [7:0] <= half_half [7]; 
           pixels [15:8] <= half_half [8];
           pixels [23:16] <= half_half [9];
           pixels [31:24] <= half_half [10];
           pixels [39:32] <= half_half [11];
           pixels [47:40] <= half_half [12];
           half[5] <= (half_act+16)>>5;
             
           
     end
S23: begin state <= S24; // 3
           pixels [7:0] <= half_half [13]; 
           pixels [15:8] <= half_half [8];
           pixels [23:16] <= half_half [9];
           pixels [31:24] <= half_half [10];
           pixels [39:32] <= half_half [11];
           pixels [47:40] <= half_half [12];
           half[0] <= (half_act+512)>>10;
           
           
     end
S24: begin state <= S25;  half[6] <= (half_act+512)>>10;  half[4] <= lut[int_ind_pix]; end
S25: begin state <= S26;  half [2]<= (half_act+512)>>10;  end 
S26: begin state <= S27;  half [8]<= (half_act+512)>>10;  end
S27: begin state <= S27; done <= 1; end
endcase
end
end

endmodule


