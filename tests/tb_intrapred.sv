`timescale 1ns / 1ps

module tb_intrapred;
    reg clk;
    reg reset;
    reg enable;
    reg [12:0] mbnumber = -1;
    
    intrapred dut(.clk(clk), .reset(reset), .enable(enable), .mbnumber(mbnumber));
        
    initial begin
    
        clk = 0;
        enable = 1;
        reset = 0;
        
        forever 
            #5 clk =~ clk;
    
    end
    
    always @ (negedge clk) begin
        mbnumber = mbnumber + 13'd1;
    end
    
endmodule
