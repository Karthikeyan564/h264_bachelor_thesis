module comparator(input clk, input en, input [8:0][15:0] distort, output reg [3:0] best, output reg done);


wire [3:0] j,k,l,m,n,o,p;

assign j = distort[0] <= distort[1] ? 4'b0000: 4'b0001;
assign k = distort[2] <= distort[3] ? 4'b0010: 4'b0011;
assign l = distort[4] <= distort[5] ? 4'b0100: 4'b0101;
assign m = distort[6] <= distort[7] ? 4'b0110: 4'b0111;
assign n = distort[j] <= distort[k] ? j : k;
assign o = distort[l] <= distort[m] ? l : m;
assign p = distort[n] <= distort[o] ? n : o;
assign q = distort[p] <= distort[8] ? p : 4'b1000;

always @ (posedge clk)
begin
if(en)
begin
    best <= q;
    done <= 1;
end
else 
    done <= 0;

end
endmodule