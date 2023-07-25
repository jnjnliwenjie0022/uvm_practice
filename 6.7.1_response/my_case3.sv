`ifndef MY_CASE3__SV
`define MY_CASE3__SV
class case3_sequence extends uvm_sequence #(my_transaction);
    my_transaction m_trans;

    function  new(string name= "case3_sequence");
        super.new(name);
    endfunction 
    //{{{
    virtual task pre_body();
       `uvm_info("case3_sequence", "pre_body is called!!!", UVM_LOW)
    endtask
    
    virtual task post_body();
       `uvm_info("case3_sequence", "post_body is called!!!", UVM_LOW)
    endtask
    //}}} 
    virtual task body();
        if(starting_phase != null) 
            starting_phase.raise_objection(this);
        repeat (10) begin
            `uvm_info("case3_sequence", "body is called", UVM_LOW);
            `uvm_do(m_trans)
            `uvm_info("case3_seq", "send one transaction, print it", UVM_LOW)
            `uvm_info(get_type_name(), $sformatf("Contents: \n%s", m_trans.sprint()), UVM_LOW)
        end
        `uvm_info("case3_sequence", "drop objection",  UVM_LOW)
        if(starting_phase != null) 
            starting_phase.drop_objection(this);
    endtask

    `uvm_object_utils(case3_sequence)
endclass


class my_case3 extends base_test;

    function new(string name = "my_case3", uvm_component parent = null);
        super.new(name,parent);
    endfunction 
    extern virtual function void build_phase(uvm_phase phase); 
    extern virtual task post_main_phase(uvm_phase phase); 
    extern virtual function void final_phase(uvm_phase phase); 
    `uvm_component_utils(my_case3)
endclass


function void my_case3::build_phase(uvm_phase phase);
   super.build_phase(phase);

   uvm_config_db#(uvm_object_wrapper)::set(this, 
                                           "env.i_agt.sqr.main_phase", 
                                           "default_sequence", 
                                           case3_sequence::type_id::get());
endfunction
task my_case3::post_main_phase(uvm_phase phase);
   `uvm_info("my_case3", "enter post_main phase", UVM_LOW)
endtask

function void my_case3::final_phase(uvm_phase phase);
   `uvm_info("my_case3", "enter final phase", UVM_LOW)
endfunction
`endif
