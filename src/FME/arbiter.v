`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.10.2022 00:41:23
// Design Name: 
// Module Name: arbiter
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


module arbiter(input [71:0] e1h, e1q, e2h, e2q, e3i1, e3i2, satdo1, satdo2, input reqsel1, reqsel2, satdsel1, satdsel2, input [1:0] satsel1, satsel2, output reg [71:0] satd1, satd2, satd_1, satd_2);

reg [71:0] linesel1, linesel2;

always @ (reqsel1 or reqsel2 or satsel1 or satsel2)
begin

case (reqsel1)
    1'b0 : linesel1 <= e1h;
    1'b1 : linesel1 <= e1q;
    default : linesel1 <= e1h;
endcase

case (reqsel2)
    1'b0 : linesel2 <= e2h;
    1'b1 : linesel2 <= e2q;
    default : linesel2 <= e2h;
endcase

case (satsel1)
    2'b00 : satd1 <= linesel1;
    2'b01 : satd1 <= e3i1;
    2'b10 : satd1 <= e3i2;
    2'b11 : satd1 <= linesel1;
    default : satd1 <= linesel1;
endcase

case (satsel2)
    2'b00 : satd2 <= linesel2;
    2'b01 : satd2 <= e3i1;
    2'b10 : satd2 <= e3i2;
    2'b11 : satd2 <= linesel2;
    default : satd1 <= linesel2;
endcase

case (satdsel1)
    1'b0 : satd_1 <= satdo1;
    1'b1 : satd_1 <= satdo2;
    default: satd_1 <= satdo1;
endcase

case (satdsel2)
    1'b0 : satd_2 <= satdo1;
    1'b1 : satd_2 <= satdo2;
    default: satd_1 <= satdo2;
endcase

end

endmodule
