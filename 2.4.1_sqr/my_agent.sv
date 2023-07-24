`ifndef MY_AGENT__SV
`define MY_AGENT__SV

class my_agent extends uvm_agent ;
    //}}}
    my_sequencer  sqr;
    //}}}
    my_driver     drv;
    my_monitor    mon;

    uvm_analysis_port #(my_transaction)  ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction 
   
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

    `uvm_component_utils(my_agent)
endclass 


function void my_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (is_active == UVM_ACTIVE) begin
        //{{{
        sqr = my_sequencer::type_id::create("sqr", this);
        //}}}
        drv = my_driver::type_id::create("drv", this);
    end
    mon = my_monitor::type_id::create("mon", this);
    ap = new("ap", this); 
endfunction 

function void my_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    mon.ap.connect(ap);
endfunction
`endif
