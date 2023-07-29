`ifndef MY_MODEL__SV
`define MY_MODEL__SV

class my_model extends uvm_component;
    `uvm_component_utils(my_model)

    virtual backdoor_if vif;
    uvm_blocking_get_port #(my_transaction)  port;
    uvm_analysis_port #(my_transaction)  ap;
    bus_sequencer p_sqr;
    reg_model p_rm;

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern virtual  task main_phase(uvm_phase phase);
    extern virtual  function void invert_tr(my_transaction tr);

endclass 

function my_model::new(string name, uvm_component parent);
   super.new(name, parent);
endfunction 

function void my_model::build_phase(uvm_phase phase);
    super.build_phase(phase);
    port = new("port", this);
    ap = new("ap", this);
    if(!uvm_config_db#(virtual backdoor_if)::get(this, "", "vif", vif))
        `uvm_fatal(get_full_name(), "virtual interface must be set for vif!!!")
endfunction

function void my_model::invert_tr(my_transaction tr);
    tr.dmac = tr.dmac ^ 48'hFFFF_FFFF_FFFF;
    tr.smac = tr.smac ^ 48'hFFFF_FFFF_FFFF;
    tr.ether_type = tr.ether_type ^ 16'hFFFF;
    tr.crc = tr.crc ^ 32'hFFFF_FFFF;
    for(int i = 0; i < tr.pload.size; i++)
        tr.pload[i] = tr.pload[i] ^ 8'hFF;
endfunction

task my_model::main_phase(uvm_phase phase);

    my_transaction tr;
    my_transaction new_tr;
    reg_access_sequence reg_seq;
    logic [31:0] value;

    #1000;
    vif.poke_counter(10);
    vif.peek_counter(value);
    `uvm_info(get_full_name(), $sformatf("Peek Counter: \n%d", value), UVM_LOW)

    //vif.poke_bus_op(1);
    //vif.peek_bus_op(value);
    //`uvm_info(get_full_name(), $sformatf("Peek Bus OP: \n%d", value), UVM_LOW)

    reg_seq = reg_access_sequence::type_id::create("rseq");
    reg_seq.addr = 16'h9;
    reg_seq.is_wr = 1;
    reg_seq.start(p_sqr);
    while(1) begin
        port.get(tr);
        new_tr = new("new_tr");
        new_tr.copy(tr);
        if(reg_seq.rdata)
            invert_tr(new_tr);
        ap.write(new_tr);
    end
endtask
`endif
