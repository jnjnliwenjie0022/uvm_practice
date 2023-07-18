interface dut_harness ();
    my_if input_if(clk, rst_n);
    my_if output_if(clk, rst_n);
   uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.drv", "vif", input_if);

my_if(input clk, input rst_n);
   logic [7:0] data;
   logic valid;
endinterface
