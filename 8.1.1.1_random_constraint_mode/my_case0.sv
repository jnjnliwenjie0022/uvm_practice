`ifndef MY_CASE0__SV
`define MY_CASE0__SV
class case0_sequence extends uvm_sequence #(my_transaction);
    my_transaction item;

    function  new(string name= "case0_sequence");
        super.new(name);
    endfunction

    virtual task body();
        if(starting_phase != null)
            starting_phase.raise_objection(this);
        repeat (10) begin
            item = my_transaction::type_id::create();
            `uvm_info("", $sformatf("init item.crc_err: %d", item.crc_err), UVM_LOW)

            item.randomize();
            `uvm_info("", $sformatf("rand item.crc_err: %d", item.crc_err), UVM_LOW)

            //item.randomize() with {crc_err dist {1000:=2, 1001:=1};};
            ////show constraint error
            //`uvm_info("", $sformatf("rand with dist item.crc_err: %d", item.crc_err), UVM_LOW)

            //item.randomize() with {crc_err == 10;};
            //// show constraint error
            //`uvm_info(get_full_name(), $sformatf("rand with == item.crc_err: %d\n", item.crc_err), UVM_LOW)

            item.crc_err_cons.constraint_mode(0);
            item.randomize() with {crc_err dist {1000:=2, 1001:=1};};
            `uvm_info("", $sformatf("rand with dist but disable constraint_mode item.crc_err: %d", item.crc_err), UVM_LOW)

            wait_for_grant();
            send_request(item);
            wait_for_item_done();
        end
        #100;
        if(starting_phase != null)
            starting_phase.drop_objection(this);
    endtask

    `uvm_object_utils(case0_sequence)
endclass


class my_case0 extends base_test;

    function new(string name = "my_case0", uvm_component parent = null);
        super.new(name,parent);
    endfunction
    extern virtual function void build_phase(uvm_phase phase);
    `uvm_component_utils(my_case0)
endclass


function void my_case0::build_phase(uvm_phase phase);
    super.build_phase(phase);

    uvm_config_db#(uvm_object_wrapper)::set(this,
        "env.i_agt.sqr.main_phase",
        "default_sequence",
        case0_sequence::type_id::get());
endfunction

`endif
