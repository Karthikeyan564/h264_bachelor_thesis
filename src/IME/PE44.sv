/*!
This contains a 4x4 matrix of processing element and processes over 4x4 of data
*/
module PE44 (
    input clk,                                                      // Input clk
    input rst,                                                      // Reset
    input roll,                                                     // Roll to next
    input [7:0] cb [3:0][3:0],                                      // 4x4 current block values
    input [7:0] rb [3:0][3:0],                                      // 4x4 reference block values
    output [7:0] sad                                                // SAD score
);
    genvar i,j;
    wire [7:0] rsad [3:0][3:0], wsad [3:0];
    generate
        for(i=0;i<4;i=i+1)
        begin
            for (j=0;j<4;j=j+1)
            begin
            PE(clk,rst,roll,cb[i][j],rb[i][j],rsad[i][j]);
            assign wsad[i] = rsad[i][0] + rsad[i][1] + rsad[i][2] + rsad[i][3];
            end
        end
        assign sad = wsad[0] + wsad[1] + wsad[2] + wsad[3];
    endgenerate
endmodule