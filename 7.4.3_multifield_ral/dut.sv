`timescale 1ns/1ps
module dut(clk,rst_n,bus_cmd_valid,bus_op,bus_addr,bus_wr_data,bus_rd_data,rxd,rx_dv,txd,tx_en);
input          clk;
input          rst_n;
input          bus_cmd_valid;
input          bus_op;
input  [15:0]  bus_addr;
input  [15:0]  bus_wr_data;
output [15:0]  bus_rd_data;
input  [7:0]   rxd;
input          rx_dv;
output [7:0]   txd;
output         tx_en;

wire         reg_a_bus_cmd_valid = bus_cmd_valid;
wire         reg_a_bus_op        = bus_op;
wire [15:0]  reg_a_bus_addr      = bus_addr;
wire [15:0]  reg_a_bus_wr_data   = bus_wr_data;
wire [15:0]  reg_a_bus_rd_data;

wire         reg_b_bus_cmd_valid = bus_cmd_valid;
wire         reg_b_bus_op = bus_op;
wire [15:0]  reg_b_bus_addr = bus_addr;
wire [15:0]  reg_b_bus_wr_data = bus_wr_data;
wire [15:0]  reg_b_bus_rd_data;

wire         reg_c_bus_cmd_valid = bus_cmd_valid;
wire         reg_c_bus_op = bus_op;
wire [15:0]  reg_c_bus_addr = bus_addr;
wire [15:0]  reg_c_bus_wr_data = bus_wr_data;
wire [15:0]  reg_c_bus_rd_data;


reg [31:0] counter;
wire [31:0] counter_nx;
reg[7:0] txd;
reg tx_en;
reg invert;

assign counter_nx = counter;
always @ (posedge clk) begin
    counter <= counter_nx;
end

always @(posedge clk) begin
    if(!rst_n) begin
        txd <= 8'b0;
        tx_en <= 1'b0;
    end
    else if(invert) begin
        txd <= ~rxd;
        tx_en <= rx_dv;
    end
    else begin
        txd <= rxd;
        tx_en <= rx_dv;
    end
end

always @(posedge clk) begin
    if(!rst_n) 
        invert <= 1'b0;
    else if(bus_cmd_valid && bus_op) begin
        case(bus_addr)
            16'h5: begin
                    counter[31:16] <= bus_wr_data;
            end
            16'h6: begin
                    counter[15:0] <= bus_wr_data;
            end
            16'h9: begin
                invert <= bus_wr_data[0];
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
            16'h5: begin
                bus_rd_data <= counter[31:16]; 
            end
            16'h6: begin
                bus_rd_data <= counter[15:0]; 
            end
            16'h9: begin
                bus_rd_data <= {15'b0, invert};
            end
            16'h105: begin
                bus_rd_data <= reg_a_bus_rd_data;
            end
            16'h106: begin
                bus_rd_data <= reg_a_bus_rd_data;
            end
            16'h205: begin
                bus_rd_data <= reg_b_bus_rd_data;
            end
            16'h206: begin
                bus_rd_data <= reg_b_bus_rd_data;
            end
            16'h300: begin
                bus_rd_data <= reg_c_bus_rd_data;
            end
            default: begin
                bus_rd_data <= 16'b0; 
            end
        endcase
    end
end

reg_a u_reg_a(
     .clk           (clk                 )
    ,.rst_n         (rst_n               )
    ,.bus_cmd_valid (reg_a_bus_cmd_valid )
    ,.bus_op        (reg_a_bus_op        )
    ,.bus_addr      (reg_a_bus_addr      )
    ,.bus_wr_data   (reg_a_bus_wr_data   )
    ,.bus_rd_data   (reg_a_bus_rd_data   )
);

reg_b u_reg_b(
     .clk           (clk                 )
    ,.rst_n         (rst_n               )
    ,.bus_cmd_valid (reg_b_bus_cmd_valid )
    ,.bus_op        (reg_b_bus_op        )
    ,.bus_addr      (reg_b_bus_addr      )
    ,.bus_wr_data   (reg_b_bus_wr_data   )
    ,.bus_rd_data   (reg_b_bus_rd_data   )
);

reg_c u_reg_c(
     .clk           (clk                 )
    ,.rst_n         (rst_n               )
    ,.bus_cmd_valid (reg_c_bus_cmd_valid )
    ,.bus_op        (reg_c_bus_op        )
    ,.bus_addr      (reg_c_bus_addr      )
    ,.bus_wr_data   (reg_c_bus_wr_data   )
    ,.bus_rd_data   (reg_c_bus_rd_data   )
);
endmodule
