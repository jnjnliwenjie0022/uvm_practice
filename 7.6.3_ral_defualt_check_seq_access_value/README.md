UVM_INFO my_case6.sv(363) @ 1256700000: uvm_test_top.v_sqr@@access_vseq [case0_reg_multiaddr] before mirror
UVM_INFO my_adapter.sv(16) @ 1256700000: reporter [my_adapter] reg2bus
UVM_INFO bus_driver.sv(37) @ 1256700000: uvm_test_top.env.bus_agt.drv [bus_driver] begin to drive one pkt
UVM_INFO bus_driver.sv(54) @ 1257300000: uvm_test_top.env.bus_agt.drv [bus_driver] Contents:
----------------------------------------------------------------------------------
Name                           Type             Size  Value
----------------------------------------------------------------------------------
uvm_sequence_item              bus_transaction  -     @26400
  rd_data                      integral         16    'h0
  wr_data                      integral         16    'h0
  addr                         integral         16    'h401
  bus_op                       bus_op_e         32    BUS_RD
  begin_time                   time             64    1256700000
  depth                        int              32    'd2
  parent sequence (name)       string           18    default_parent_seq
  parent sequence (full name)  string           18    default_parent_seq
  sequencer                    string           28    uvm_test_top.env.bus_agt.sqr
----------------------------------------------------------------------------------

UVM_INFO bus_driver.sv(58) @ 1257300000: uvm_test_top.env.bus_agt.drv [bus_driver] end drive one pkt
UVM_INFO my_adapter.sv(27) @ 1257300000: reporter [my_adapter] bus2reg
UVM_INFO my_adapter.sv(16) @ 1257300000: reporter [my_adapter] reg2bus
UVM_INFO bus_driver.sv(37) @ 1257300000: uvm_test_top.env.bus_agt.drv [bus_driver] begin to drive one pkt
UVM_INFO bus_driver.sv(54) @ 1257900000: uvm_test_top.env.bus_agt.drv [bus_driver] Contents:
----------------------------------------------------------------------------------
Name                           Type             Size  Value
----------------------------------------------------------------------------------
uvm_sequence_item              bus_transaction  -     @26404
  rd_data                      integral         16    'h0
  wr_data                      integral         16    'h0
  addr                         integral         16    'h400
  bus_op                       bus_op_e         32    BUS_RD
  begin_time                   time             64    1257300000
  depth                        int              32    'd2
  parent sequence (name)       string           18    default_parent_seq
  parent sequence (full name)  string           18    default_parent_seq
  sequencer                    string           28    uvm_test_top.env.bus_agt.sqr
----------------------------------------------------------------------------------

UVM_INFO bus_driver.sv(58) @ 1257900000: uvm_test_top.env.bus_agt.drv [bus_driver] end drive one pkt
UVM_INFO my_adapter.sv(27) @ 1257900000: reporter [my_adapter] bus2reg
UVM_INFO my_case6.sv(365) @ 1257900000: uvm_test_top.v_sqr@@access_vseq [case0_reg_multiaddr] after mirror

