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
        p_sequencer.p_rm.blk_invert.invert.read(status, value, UVM_FRONTDOOR);
        `uvm_info("case0_bus_seq", $sformatf("invert's initial value is %0h", value), UVM_LOW)

        // write
        p_sequencer.p_rm.blk_invert.invert.write(status, 1, UVM_FRONTDOOR);

        // read
        p_sequencer.p_rm.blk_invert.invert.read(status, value, UVM_FRONTDOOR);
        `uvm_info("case0_bus_seq", $sformatf("after set, invert's value is %0h", value), UVM_LOW)
    endtask

endclass

class case0_cfg_vseq extends uvm_sequence;
    `uvm_object_utils(case0_cfg_vseq)
    `uvm_declare_p_sequencer(my_vsqr)

    function new(string name = "case0_cfg_vseq");
       super.new(name);
    endfunction 

    virtual task body();
        uvm_status_e   status;
        uvm_reg_data_t value;
        bit [31:0] counter;
        if (starting_phase != null) 
            starting_phase.raise_objection(this);
        p_sequencer.p_rm.blk_invert.invert.read(status, value, UVM_FRONTDOOR);
        `uvm_info("case0_cfg_vseq", $sformatf("invert's initial value is %0h", value), UVM_LOW)
        p_sequencer.p_rm.blk_invert.invert.write(status, 1, UVM_FRONTDOOR);
        p_sequencer.p_rm.blk_invert.invert.read(status, value, UVM_FRONTDOOR);
        `uvm_info("case0_cfg_vseq", $sformatf("after set, invert's value is %0h", value), UVM_LOW)
        p_sequencer.p_rm.blk_counter_low.counter_low.read(status, value, UVM_FRONTDOOR);
        counter[15:0] = value[15:0];
        p_sequencer.p_rm.blk_counter_high.counter_high.read(status, value, UVM_FRONTDOOR);
        counter[31:16] = value[15:0];
        `uvm_info("case0_cfg_vseq", $sformatf("counter's initial value(FRONTDOOR) is %0h", counter), UVM_LOW)
        //p_sequencer.p_rm.blk_counter_low.counter_low.poke(status, 16'hFFFD);
        // add
        p_sequencer.p_rm.blk_counter_low.counter_low.write(status, 1, UVM_FRONTDOOR);
        p_sequencer.p_rm.blk_counter_high.counter_high.write(status, 1, UVM_FRONTDOOR);
        //
        p_sequencer.p_rm.blk_counter_low.counter_low.read(status, value, UVM_FRONTDOOR);
        counter[15:0] = value[15:0];
        p_sequencer.p_rm.blk_counter_high.counter_high.read(status, value, UVM_FRONTDOOR);
        counter[31:16] = value[15:0];
        `uvm_info("case0_cfg_vseq", $sformatf("after poke, counter's value(FRONTDOOR) is %0h", counter), UVM_LOW)
        p_sequencer.p_rm.blk_counter_low.counter_low.peek(status, value);
        counter[15:0] = value[15:0];
        p_sequencer.p_rm.blk_counter_high.counter_high.peek(status, value);
        counter[31:16] = value[15:0];
        `uvm_info("case0_cfg_vseq", $sformatf("after poke, counter's value(BACKDOOR) is %0h", counter), UVM_LOW)
        if (starting_phase != null) 
            starting_phase.drop_objection(this);
    endtask

endclass

class case0_reg_vseq extends uvm_sequence;
    `uvm_object_utils(case0_reg_vseq)
    `uvm_declare_p_sequencer(my_vsqr)

    function new(string name = "case0_reg_vseq");
       super.new(name);
    endfunction 

    virtual task body();
        uvm_status_e   status;
        uvm_reg_data_t value;
        bit [31:0] counter;
        if (starting_phase != null) 
            starting_phase.raise_objection(this);

        p_sequencer.p_rm.regfile_a.counter_low.write(status, 2, UVM_FRONTDOOR);
        p_sequencer.p_rm.regfile_a.counter_high.write(status, 2, UVM_FRONTDOOR);
        p_sequencer.p_rm.regfile_a.counter_low.read(status, value, UVM_FRONTDOOR); counter[15:0] = value[15:0];
        p_sequencer.p_rm.regfile_a.counter_high.read(status, value, UVM_FRONTDOOR); counter[31:16] = value[15:0];
        `uvm_info("regfile_a_vseq", $sformatf("after read, regfile_a_counter value(FRONTDOOR) is %0h", counter), UVM_LOW)
        p_sequencer.p_rm.regfile_a.counter_low.peek(status, value, UVM_FRONTDOOR); counter[15:0] = value[15:0];
        p_sequencer.p_rm.regfile_a.counter_high.peek(status, value, UVM_FRONTDOOR); counter[31:16] = value[15:0];
        `uvm_info("regfile_a_vseq", $sformatf("after peek, regfile_a_counter value(BACKDOOR) is %0h", counter), UVM_LOW)

        p_sequencer.p_rm.regfile_b.counter_low.write(status, 3, UVM_FRONTDOOR);
        p_sequencer.p_rm.regfile_b.counter_high.write(status, 3, UVM_FRONTDOOR);
        p_sequencer.p_rm.regfile_b.counter_low.read(status, value, UVM_FRONTDOOR); counter[15:0] = value[15:0];
        p_sequencer.p_rm.regfile_b.counter_high.read(status, value, UVM_FRONTDOOR); counter[31:16] = value[15:0];
        `uvm_info("regfile_a_vseq", $sformatf("after read, regfile_b_counter value(FRONTDOOR) is %0h", counter), UVM_LOW)
        p_sequencer.p_rm.regfile_b.counter_low.peek(status, value, UVM_FRONTDOOR); counter[15:0] = value[15:0];
        p_sequencer.p_rm.regfile_b.counter_high.peek(status, value, UVM_FRONTDOOR); counter[31:16] = value[15:0];
        `uvm_info("regfile_a_vseq", $sformatf("after peek, regfile_b_counter value(BACKDOOR) is %0h", counter), UVM_LOW)

        if (starting_phase != null) 
            starting_phase.drop_objection(this);
    endtask

endclass

class case0_reg_multifield extends uvm_sequence;
    `uvm_object_utils(case0_reg_multifield)
    `uvm_declare_p_sequencer(my_vsqr)

    function new(string name = "case0_reg_multifield");
       super.new(name);
    endfunction 

    virtual task body();
        uvm_status_e   status;
        uvm_reg_data_t value;
        bit [31:0] counter;
        if (starting_phase != null) 
            starting_phase.raise_objection(this);

        p_sequencer.p_rm.regfile_c.reg_multifield.write(status, 16'b0100_010_01, UVM_FRONTDOOR);
        p_sequencer.p_rm.regfile_c.reg_multifield.read(status, value, UVM_FRONTDOOR); counter = value;
        p_sequencer.p_rm.regfile_c.reg_multifield.read(status, value, UVM_FRONTDOOR); counter = value;
        `uvm_info("regfile_c_vseq", $sformatf("after read, regfile_c value(FRONTDOOR) is %0h", counter), UVM_LOW)
        p_sequencer.p_rm.regfile_c.reg_multifield.fieldA.peek(status, value, UVM_FRONTDOOR); counter = value;
        `uvm_info("regfile_c_vseq", $sformatf("after peek, regfile_c_fieldA value(BACKDOOR) is %0h", counter), UVM_LOW)
        p_sequencer.p_rm.regfile_c.reg_multifield.fieldB.peek(status, value, UVM_FRONTDOOR); counter = value;
        `uvm_info("regfile_c_vseq", $sformatf("after peek, regfile_c_fieldB value(BACKDOOR) is %0h", counter), UVM_LOW)
        p_sequencer.p_rm.regfile_c.reg_multifield.fieldC.peek(status, value, UVM_FRONTDOOR); counter = value;
        `uvm_info("regfile_c_vseq", $sformatf("after peek, regfile_c_fieldC value(BACKDOOR) is %0h", counter), UVM_LOW)

        if (starting_phase != null) 
            starting_phase.drop_objection(this);
    endtask

endclass

class case0_reg_multiaddr extends uvm_sequence;
    `uvm_object_utils(case0_reg_multiaddr)
    `uvm_declare_p_sequencer(my_vsqr)

    function new(string name = "case0_reg_multiaddr");
       super.new(name);
    endfunction 

    virtual task body();
        uvm_status_e   status;
        uvm_reg_data_t value;
        bit [31:0] counter;
        if (starting_phase != null) 
            starting_phase.raise_objection(this);
        p_sequencer.p_rm.regfile_d.reg_counter.write(status, 32'h12345678, UVM_FRONTDOOR);
        p_sequencer.p_rm.regfile_d.reg_counter.read(status, value, UVM_FRONTDOOR);
        `uvm_info("case0_reg_multiaddr", $sformatf("regfile_d counter value is %0h", value), UVM_LOW)
        p_sequencer.p_rm.regfile_d.reg_counter.peek(status, value, UVM_FRONTDOOR);
        `uvm_info("case0_reg_multiaddr", $sformatf("regfile_d counter value is %0h", value), UVM_LOW)
        p_sequencer.p_rm.regfile_d.reg_counter.poke(status, 32'h11112222);
        p_sequencer.p_rm.regfile_d.reg_counter.read(status, value, UVM_FRONTDOOR);
        `uvm_info("case0_reg_multiaddr", $sformatf("regfile_d counter value is %0h", value), UVM_LOW)
        p_sequencer.p_rm.regfile_d.reg_counter.peek(status, value, UVM_FRONTDOOR);
        `uvm_info("case0_reg_multiaddr", $sformatf("regfile_d counter value is %0h", value), UVM_LOW)

        if (starting_phase != null) 
            starting_phase.drop_objection(this);
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
        case0_cfg_vseq  cseq;
        case0_reg_vseq  reg_vseq;
        case0_reg_multifield reg_multifield;
        case0_reg_multiaddr reg_multiaddr;
        
        if(starting_phase != null) 
            starting_phase.raise_objection(this);

        `uvm_info(get_full_name(), "in vseq body", UVM_LOW)
        #1000;
        cseq = case0_cfg_vseq::type_id::create("cseq");
        reg_vseq = case0_reg_vseq::type_id::create("reg_vseq");
        reg_multifield = case0_reg_multifield::type_id::create("reg_multifield");
        reg_multiaddr = case0_reg_multiaddr::type_id::create("reg_multiaddr");
        
        cseq.start(p_sequencer);
        reg_vseq.start(p_sequencer);
        reg_multifield.start(p_sequencer);
        reg_multiaddr.start(p_sequencer);

        #10000;
        //bseq = case0_bus_seq::type_id::create("bseq");
        rseq = case0_ral::type_id::create("rseq");
        dseq = case0_sequence::type_id::create("dseq");


        //bseq.start(p_sequencer.p_bus_sqr);
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
