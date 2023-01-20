`timescale 1ns / 1ps

module tb_intraloop #(
    parameter WIDTH = 1280,
    parameter LENGTH = 720
);
    reg clk;
    reg reset;
    reg enable;
    reg [31:0] mbnumber = 0;
    reg [15:0] row = 0, col = -4;
        
    intraloop uintraloop (.clk(clk), .reset(reset), .enable(enable), .mbnumber(mbnumber));
        
    initial begin
    
        clk = 0;
        enable = 1;
        reset = 0;
                
        forever 
            #5 clk =~ clk;
    
    end
    
    always @ (posedge clk) begin
        
        if (enable) begin
        
            if (row <= LENGTH) begin
                col = col + 4;
                if (col == WIDTH) begin
                    row = row + 4;
                    col = 0;
                end
            end
            
            mbnumber = {row, col};
            
            if (row > LENGTH) begin
                enable = 0;
                $stop;
            end
        
        end
        
    end
    
endmodule
