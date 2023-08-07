`timescale 1ns/1ps
module reg_d(
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

reg [31:0] counter;

always @(posedge clk) begin
    if(!rst_n) 
        counter <= 'h55555555;
    else if(bus_cmd_valid && bus_op) begin
        case(bus_addr)
            16'h400: begin
                    counter[31:16] <= bus_wr_data;
            end
            16'h401: begin
                    counter[15:0] <= bus_wr_data;
            end
            default: begin
            end
        endcase
    end
end

reg [15:0]  bus_rd_data;
always @* begin
   if(bus_cmd_valid && !bus_op) begin
        case(bus_addr)
            16'h400: begin
                bus_rd_data = counter[31:16]; 
            end
            16'h401: begin
                bus_rd_data = counter[15:0]; 
            end
            default: begin
                bus_rd_data = 16'b0; 
            end
        endcase
    end
end

endmodule
