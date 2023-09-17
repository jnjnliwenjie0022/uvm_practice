`ifndef MY_CASE0__SV
`define MY_CASE0__SV

class case0_sequence extends uvm_sequence #(my_transaction);
    `uvm_object_utils(case0_sequence)

    my_transaction item;

    function  new(string name= "case0_sequence");
        super.new(name);
    endfunction

    virtual task body();
        if(starting_phase != null)
            starting_phase.raise_objection(this);
        repeat (10) begin
            item = my_transaction::type_id::create();

            item.randomize();
            `uvm_info("", "normal sequence", UVM_LOW)
            `uvm_info("", $sformatf("rand item.crc_err: %d", item.crc_err), UVM_LOW)

            wait_for_grant();
            send_request(item);
            wait_for_item_done();
        end
        #100;
        if(starting_phase != null)
            starting_phase.drop_objection(this);
    endtask
endclass

class abnormal_sequence extends case0_sequence;
    `uvm_object_utils(abnormal_sequence)

    my_transaction item;

    function new(string name= "abnormal_sequence");
        super.new(name);
    endfunction

    virtual task body();
        if(starting_phase != null)
            starting_phase.raise_objection(this);
        repeat (10) begin
            item = my_transaction::type_id::create();

            item.crc_err_cons.constraint_mode(0);
            item.randomize() with {crc_err dist {1000:=2, 1001:=1};};
            `uvm_info("", "abnormal sequence", UVM_LOW)
            `uvm_info("", $sformatf("rand item.crc_err: %d", item.crc_err), UVM_LOW)

            wait_for_grant();
            send_request(item);
            wait_for_item_done();
        end
        #100;
        if(starting_phase != null)
            starting_phase.drop_objection(this);
    endtask
endclass

class my_case0 extends base_test;
    `uvm_component_utils(my_case0)

    function new(string name = "my_case0", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    extern virtual function void build_phase(uvm_phase phase);
endclass


function void my_case0::build_phase(uvm_phase phase);
    super.build_phase(phase);

    factory.set_type_override_by_type(case0_sequence::get_type(), abnormal_sequence::get_type());
    uvm_config_db#(uvm_object_wrapper)::set(this,
        "env.i_agt.sqr.main_phase",
        "default_sequence",
        case0_sequence::type_id::get());
endfunction

`endif
