`ifndef BACKDOOR_IF__SV
`define BACKDOOR_IF__SV

interface backdoor_if (input clk, input rst_n);

    function void poke_counter (input bit[31:0] value);
        tb.u_dut.counter = value;
    endfunction

    function void peek_counter (output bit[31:0] value);
        value = tb.u_dut.counter;
    endfunction

    //function void poke_bus_op (input bit value);
    //    tb.u_dut.bus_op = value;
    //endfunction

    //function void peek_bus_op (output bit value);
    //    value = tb.u_dut.bus_op;
    //endfunction

endinterface
`endif
