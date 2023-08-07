`timescale 1ns/1ps
module reg_c(
    clk,
    rst_n,
    bus_cmd_valid,
    bus_op,
    bus_addr,
    bus_wr_data,
    bus_rd_data
);

input          clk;
input          rst_n;
input          bus_cmd_valid;
input          bus_op;
input  [15:0]  bus_addr;
input  [15:0]  bus_wr_data;
output [15:0]  bus_rd_data;

reg [1:0] fieldA;
reg [2:0] fieldB;
reg [3:0] fieldC;

always @(posedge clk) begin
    if(!rst_n) 
        {fieldC,fieldB,fieldA} <= 'd0;
    else if(bus_cmd_valid && bus_op) begin
        case(bus_addr)
            16'h300: begin
                    {fieldC,fieldB,fieldA} <= bus_wr_data;
            end
            default: begin
            end
        endcase
    end
end

reg [15:0]  bus_rd_data;
always @(posedge clk) begin
    if(!rst_n)
        bus_rd_data <= 16'b0;
    else if(bus_cmd_valid && !bus_op) begin
        case(bus_addr)
            16'h300: begin
                bus_rd_data <= {fieldC,fieldB,fieldA};
            end
            default: begin
                bus_rd_data <= 16'b0; 
            end
        endcase
    end
end

endmodule
