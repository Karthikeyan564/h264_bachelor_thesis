/*!
This contains the processing element which returns the absolute value of difference between the two elements
*/
module PE (
    input clk,                                                     // Input clock
    input rst,                                                     // Reset
    input roll,                                                    // Roll to next
    input [7:0] a,                                                 // Input A
    input [7:0] b,                                                 // Input B
    output [7:0] c                                                 // Output C = abs(A-B)
);

    wire diff;
    assign diff = (a>b)?a-b:b-a;
    assign c = rst & diff;
    
endmodule