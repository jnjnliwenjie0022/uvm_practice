`include "uvm_macros.svh"

import uvm_pkg::*;
`include "my_if.sv"
`include "bus_if.sv"
`include "backdoor_if.sv"
`include "my_transaction.sv"
`include "my_sequencer.sv"
`include "my_driver.sv"
`include "my_monitor.sv"
`include "my_agent.sv"
`include "bus_transaction.sv"
`include "bus_sequencer.sv"
`include "bus_driver.sv"
`include "bus_monitor.sv"
`include "bus_agent.sv"
`include "reg_access_sequence.sv"
`include "reg_model.sv"
`include "my_adapter.sv"
`include "my_model.sv"
`include "my_scoreboard.sv"
`include "my_env.sv"
`include "my_vsqr.sv"
`include "base_test.sv"
`include "my_case6.sv"

module tb;

reg clk;
reg rst_n;

my_if input_if(clk, rst_n);
my_if output_if(clk, rst_n);
bus_if b_if(clk, rst_n);
backdoor_if bk_if(clk, rst_n);

dut u_dut(.clk          (clk               ),
           .rst_n        (rst_n             ),
           .bus_cmd_valid(b_if.bus_cmd_valid), 
           .bus_op       (b_if.bus_op       ), 
           .bus_addr     (b_if.bus_addr     ), 
           .bus_wr_data  (b_if.bus_wr_data  ), 
           .bus_rd_data  (b_if.bus_rd_data  ), 
           .rxd          (input_if.data     ),
           .rx_dv        (input_if.valid    ),
           .txd          (output_if.data    ),
           .tx_en        (output_if.valid   ));


initial begin
   clk = 0;
   forever begin
      #100 clk = ~clk;
   end
end

initial begin
   rst_n = 1'b0;
   #1000;
   rst_n = 1'b1;
end

initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0, tb);
    //$dumpfile("dump.vcd");
    //$dumpvars(0);
    //$dumpflush;
    //$shm_open("dump.shm"); // The SHM Database
    //$shm_probe("ACM"); // The SHM Database
end
initial begin
    run_test();
end

initial begin
   uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.i_agt.drv", "vif", input_if);
   uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.i_agt.mon", "vif", input_if);
   uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.o_agt.mon", "vif", output_if);
   uvm_config_db#(virtual bus_if)::set(null, "uvm_test_top.env.bus_agt.drv", "vif", b_if);
   uvm_config_db#(virtual bus_if)::set(null, "uvm_test_top.env.bus_agt.mon", "vif", b_if);
   uvm_config_db#(virtual backdoor_if)::set(null, "uvm_test_top.env.mdl", "vif", bk_if);
end
endmodule
