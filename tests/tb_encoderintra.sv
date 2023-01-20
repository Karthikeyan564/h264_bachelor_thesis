`timescale 1ns / 1ps

module tb_encoderintra();

    reg clk;
    reg reset;
    reg enable;
    
    wire done_luma4x4, done_chromab8x8, done_chromar8x8;
    
    integer fd_luma, fd_chromab, fd_chromar;
    
    encoder_intra uencoder_intra (
        .clk(clk), 
        .reset(reset), 
        .enable(enable), 
        .done_luma4x4(done_luma4x4), 
        .done_chromab8x8(done_chromab8x8), 
        .done_chromar8x8(done_chromar8x8));
        
    initial begin
    
        clk = 1;
        enable = 1;
        reset = 0;
                
        forever 
            #5 clk =~ clk;
    
    end
    
    always @ (posedge done_luma4x4) begin
        fd_luma = $fopen("luma.hex", "w+");
        $fwrite(fd_luma, uencoder_intra.reconstructed_luma);
        $display("Luma dumped.");
        $fclose(fd_luma);
    end
    
    always @ (posedge done_chromab8x8) begin
        fd_chromab = $fopen("chromab.hex", "w+");
        $fwrite(fd_chromab, uencoder_intra.reconstructed_chb);
        $display("ChromaB dumped.");
        $fclose(fd_chromab);
    end
    
    always @ (posedge done_chromar8x8) begin
        fd_chromar = $fopen("chromar.hex", "w+");
        $fwrite(fd_chromar, uencoder_intra.reconstructed_chr);
        $display("ChromaR dumped.");
        $fclose(fd_chromar);
    end
    
endmodule
