`timescale 1ns / 1ps

module tb_reconst();

    reg clk, enable, reset;
    reg [12:0] mbnumber;
    wire [7:0] mb [15:0];

    reconst reconstu (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .mbnumber(mbnumber),
        .mb(mb));
        
    initial begin
    
        clk = 0;
        reset = 0;
        enable = 1;
        mbnumber = 13'd0;
        
        forever #5 clk = ~clk;
        
        
    end

endmodule
