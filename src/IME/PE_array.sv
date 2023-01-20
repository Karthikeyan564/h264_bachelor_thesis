/*!
This contains a 4x4 matrix of PE44 and operates of 16x16 of data. It produces SAD values for variable block sizes
*/
module PE_array (
    input clk,                                                      // Input clk
    input rst,                                                      // Reset
    input roll,                                                     // Roll to next
    input [7:0] cb [3:0][3:0][3:0][3:0],                            // Current block data
    input [7:0] rb [3:0][3:0][3:0][3:0],                            // Reference block data
    output [7:0] sad84 [1:0] [3:0],                                 // SAD value for 8x4
    output [7:0] sad48 [3:0] [1:0],                                 // SAD value for 4x8
    output [7:0] sad88 [1:0] [1:0],                                 // SAD value for 8x8
    output [7:0] sadF8 [1:0],                                       // SAD value for 16x8
    output [7:0] sad8F[1:0],                                        // SAD value for 8x16
    output [7:0] sadFF                                              // SAD value for 16x16
);

    wire [7:0] sadwr [3:0] [3:0];
    genvar i,j;
    generate
        for(i=0;i<4;i=i+1)
        begin
            for (j=0;j<4;j=j+1)
            begin
            PE44(clk,rst,roll,cb[i][j],rb[i][j],sadwr[i][j]);
            end
        end
        for(i=0;i<2;i=i+1)
        begin
            for (j=0;j<4;j=j+1)
            begin
                assign sad84[i][j]= sadwr[i*2][j] + sadwr[i*2+1][j];
            end
        end
        for(i=0;i<4;i=i+1)
        begin
            for (j=0;j<2;j=j+1)
            begin
                assign sad48[i][j]= sadwr[i][j*2] + sadwr[i][j*2+1];
            end
        end
        for(i=0;i<2;i=i+1)
        begin
            for (j=0;j<2;j=j+1)
            begin
                assign sad88[i][j]= sad84[i][j*2] + sad84[i][j*2+1];
            end
        end
        for (i=0;i<2;i=i+1)
        begin
            assign sadF8[i]= sad88[0][i] + sad88[1][i];
        end
        for (i=0;i<2;i=i+1)
        begin
            assign sad8F[i]= sad88[i][0] + sad88[i][1];
        end
            assign sadFF= sad8F[0] + sad8F[1];
    endgenerate
    

endmodule