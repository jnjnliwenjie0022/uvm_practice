`ifndef MY_CASE5__SV
`define MY_CASE5__SV

class case0_sequence extends uvm_sequence #(my_transaction);
    my_transaction m_trans;
    `uvm_object_utils(case0_sequence)

    function  new(string name= "case0_sequence");
        super.new(name);
    endfunction 
    virtual task pre_body();
        use_response_handler(1);
    endtask
  
    virtual function void response_handler(uvm_sequence_item response);
       if(!$cast(rsp, response))
          `uvm_error(get_full_name(), "can't cast")
       else begin
          `uvm_info(get_full_name(), $sformatf("Contents: \n%s", rsp.sprint()), UVM_LOW)
       end
    endfunction
    virtual task body();
        repeat (10) begin
            `uvm_info(get_full_name(), "put one req", UVM_MEDIUM)
            `uvm_do(m_trans)
        end
    endtask
endclass

class case0_bus_seq extends uvm_sequence #(bus_transaction);
    bus_transaction m_trans;

    function  new(string name= "case0_bus_seq");
        super.new(name);
    endfunction 

    virtual task body();
        // wihtout rsp, the item can simutaniously change at drv and bseq
        // becasue of the type fo function input for item(which is class type)
        // default ref
        // #1
        `uvm_do_with(m_trans, {m_trans.addr == 16'h9;
                               m_trans.bus_op == BUS_RD;})
        `uvm_info(get_type_name(), $sformatf("Contents: \n%s", m_trans.sprint()), UVM_LOW)
        `uvm_info("case0_bus_seq", $sformatf("invert's initial value is %0h", m_trans.rd_data), UVM_LOW)
        // #2
        `uvm_do_with(m_trans, {m_trans.addr == 16'h9;
                               m_trans.bus_op == BUS_WR;
                               m_trans.wr_data == 16'h1;})
        `uvm_info(get_type_name(), $sformatf("Contents: \n%s", m_trans.sprint()), UVM_LOW)
        // #3
        `uvm_do_with(m_trans, {m_trans.addr == 16'h9;
                               m_trans.bus_op == BUS_RD;})
        `uvm_info(get_type_name(), $sformatf("Contents: \n%s", m_trans.sprint()), UVM_LOW)
        `uvm_info("case0_bus_seq", $sformatf("after set, invert's value is %0h", m_trans.rd_data), UVM_LOW)
        // #4
        `uvm_do_with(m_trans, {m_trans.addr == 16'h9;
                               m_trans.bus_op == BUS_WR;
                               m_trans.wr_data == 16'h0;})
        `uvm_info(get_type_name(), $sformatf("Contents: \n%s", m_trans.sprint()), UVM_LOW)
        // #5
        `uvm_do_with(m_trans, {m_trans.addr == 16'h9;
                               m_trans.bus_op == BUS_RD;})
        `uvm_info(get_type_name(), $sformatf("Contents: \n%s", m_trans.sprint()), UVM_LOW)
        `uvm_info("case0_bus_seq", $sformatf("after set, invert's value is %0h", m_trans.rd_data), UVM_LOW)
    endtask

    `uvm_object_utils(case0_bus_seq)
endclass

class case0_ral extends uvm_sequence;
    `uvm_object_utils(case0_ral)
    `uvm_declare_p_sequencer(my_vsqr)
    
    function  new(string name= "case0_bus_seq");
        super.new(name);
    endfunction 
    
    virtual task body();
        uvm_status_e status;
        uvm_reg_data_t value;

        // read
        p_sequencer.p_rm.invert.read(status, value, UVM_FRONTDOOR);
        `uvm_info("case0_bus_seq", $sformatf("invert's initial value is %0h", value), UVM_LOW)

        // write
        p_sequencer.p_rm.invert.write(status, 1, UVM_FRONTDOOR);

        // read
        p_sequencer.p_rm.invert.read(status, value, UVM_FRONTDOOR);
        `uvm_info("case0_bus_seq", $sformatf("after set, invert's value is %0h", value), UVM_LOW)
    endtask

endclass

class case0_vseq extends uvm_sequence;
    `uvm_object_utils(case0_vseq)
    `uvm_declare_p_sequencer(my_vsqr) 
    function new(string name = "case0_vseq");
        super.new(name);
    endfunction

    virtual task body();
        case0_sequence  dseq;
        case0_bus_seq   bseq;
        case0_ral       rseq;

        if(starting_phase != null) 
            starting_phase.raise_objection(this);

        `uvm_info(get_full_name(), "in vseq body", UVM_LOW)
        bseq = case0_bus_seq::type_id::create("bseq");
        rseq = case0_ral::type_id::create("rseq");
        dseq = case0_sequence::type_id::create("dseq");

        bseq.start(p_sequencer.p_bus_sqr);
        rseq.start(p_sequencer);
        dseq.start(p_sequencer.p_my_sqr);

        if(starting_phase != null) 
            starting_phase.drop_objection(this);
    endtask
endclass

class my_case6 extends base_test;

   function new(string name = "my_case6", uvm_component parent = null);
      super.new(name,parent);
   endfunction 
   `uvm_component_utils(my_case6)
   extern virtual function void build_phase(uvm_phase phase); 
endclass

function void my_case6::build_phase(uvm_phase phase);
    super.build_phase(phase);

    uvm_config_db#(uvm_object_wrapper)::set(this, 
                                           "v_sqr.main_phase", 
                                           "default_sequence", 
                                           case0_vseq::type_id::get());
endfunction

`endif
