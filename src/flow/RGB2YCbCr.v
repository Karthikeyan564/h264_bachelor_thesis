/*!
This outputs Y Cb Cr values from RGB values.
*/
module RGB2YCbCr (
   input clk,                                                      // Input clk
   input rst,                                                      // Reset
   input [7:0] R,                                                  // Red value
   input [7:0] G,                                                  // Green value
   input [7:0] B,                                                  // Blue value
   output [7:0] Y,                                                 // Luminance value
   output [7:0] Cb,                                                // Blue Difference value
   output [7:0] Cr                                                 // Red Diffence value
);
   reg [7:0] out_Y=0,out_Cb=0,out_Cr=0;
   assign Y = out_Y;
   assign Cb = out_Cb;
   assign Cr = out_Cr;
   always @(posedge clk)begin
       if(~rst) begin
          out_Y <= 0;
          out_Cb <= 0;
          out_Cr <= 0;
       end
       else begin
          out_Y <= 16+(((R<<6)+(R<<1)+(G<<7)+G+(B<<4)+(B<<3)+B)>>8);
          out_Cb <= 128 + ((-((R<<5)+(R<<2)+(R<<1))-((G<<6)+(G<<3)+(G<<1))+(B<<7)-(B<<4))>>8);
          out_Cr <= 128 + (((R<<7)-(R<<4)-((G<<6)+(G<<5)-(G<<1))-((B<<4)+(B<<1)))>>8);
       end
    end
endmodule 
