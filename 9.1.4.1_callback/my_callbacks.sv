`ifndef MY_CALLBACKS__SV
`define MY_CALLBACKS__SV

class A_Callback extends uvm_callback;
    virtual task pre_tran_cbf(my_driver drv, ref my_transaction tr);
    endtask
endclass

`endif
