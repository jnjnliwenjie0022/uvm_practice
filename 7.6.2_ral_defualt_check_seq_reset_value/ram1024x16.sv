module ram1024x16 (
     clk
    ,cs
    ,we
    ,addr
    ,din
    ,dout
);

input  clk;
input  [9:0]  addr;
input  [15:0] din;
output [15:0] dout;
input  cs;
input  we;

reg [15:0] array [0:1023];

always @(posedge clk) begin
    if(we && cs)begin
        array[addr] <= din;
    end
end

assign dout = array[addr];

endmodule
