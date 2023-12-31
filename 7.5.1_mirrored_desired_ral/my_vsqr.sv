`ifndef MY_VSQR__SV
`define MY_VSQR__SV

class my_vsqr extends uvm_sequencer;
   `uvm_component_utils(my_vsqr)

   my_sequencer  p_my_sqr;
   bus_sequencer p_bus_sqr;
   reg_model     p_rm;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction 

endclass

`endif
