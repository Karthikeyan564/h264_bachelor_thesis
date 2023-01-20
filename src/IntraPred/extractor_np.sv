`timescale 1ns/1ps

module extractor_np #(
    parameter BIT_LENGTH = 15,
    parameter WIDTH = 1280,
    parameter LENGTH = 720,
    parameter MB_SIZE_L = 16,
    parameter MB_SIZE_W = 16,
    parameter CHROMAB = 0)(
    input clk,
    input reset,
    input enable,
    input [31:0] mbnumber,
    input [7:0] reconstructed [(LENGTH*WIDTH)-1:0],
    output reg [7:0] toppixels [(MB_SIZE_W == 4 ? 7 : MB_SIZE_W-1):0],
    output reg [7:0] leftpixels [(MB_SIZE_L == 4 ? 4 : MB_SIZE_L-1):0]);

    reg [15:0] row, col;
	reg [7:0] i, j;
    
    always @ (posedge clk) begin

		if (enable) begin

            row = mbnumber[31:16];
            col = mbnumber[15:0];
                
            if (MB_SIZE_W == 4) begin
                // Fetch toppixels
                for (j = 0; j < 8; j = j + 1) 
                    toppixels[5'(j)] = ((j+col == LENGTH)  ? 128 : (row == 0 ? 128 : (reconstructed[((row-1)*LENGTH) + (col+16'(j))])));
                // Fetch leftpixels
                leftpixels[0] = (row == 0 ? 128 : reconstructed[((row-1)*LENGTH) + (col-1)]);
                for (i = 0; i < 4; i = i + 1) 
                    leftpixels[5'(i)+1] = ((col == 0) ? 128 : (reconstructed[((row+16'(i))*LENGTH) + (col-1)]));
            end
            else begin
                 // Fetch toppixels
                for (j = 0; j < MB_SIZE_W; j = j + 1) 
                    toppixels[5'(j)] = ((row == 0)  ? 128 : (reconstructed[((row-1)*LENGTH) + (col+16'(j))]));
                // Fetch leftpixels
                for (i = 0; i < MB_SIZE_L; i = i +1) 
                    leftpixels[5'(i)] = ((col == 0) ? 128 : (reconstructed[((row+16'(i))*LENGTH) + (col-1)]));
            end
                        
        end

	end
	
endmodule