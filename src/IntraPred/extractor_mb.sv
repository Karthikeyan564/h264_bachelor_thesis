`timescale 1ns/1ps

module extractor_mb #(
    parameter BIT_LENGTH = 15,
    parameter WIDTH = 1280,
    parameter LENGTH = 720,
    parameter MB_SIZE_L = 16,
    parameter MB_SIZE_W = 16)(
    input clk,
    input reset,
    input enable,
    input [31:0] mbnumber,
    output reg [7:0] mb [MB_SIZE_L*MB_SIZE_W-1:0]);
            
    reg [7:0] image [(LENGTH*WIDTH)-1:0];
    
    initial begin
		$readmemh("frame.mem", image);
	end

    reg [15:0] row, col;
	reg [7:0] j, k;
    
    always @ (posedge clk) begin

		if (enable) begin

            row = mbnumber[31:16];
            col = mbnumber[15:0];

            // Fetch mb
            for (j = 0; j < MB_SIZE_L; j = j + 1) 
                for (k = 0; k < MB_SIZE_W; k = k +1) 
                    mb[(j*MB_SIZE_L) + k] = image[((row+16'(j))*LENGTH) + (col+16'(k))];
                    
        end

	end

endmodule