`ifndef MY_CASE5__SV
`define MY_CASE5__SV

class drv0_seq extends uvm_sequence #(my_transaction);
    my_transaction m_trans;
    `uvm_object_utils(drv0_seq)

    function  new(string name= "drv0_seq");
        super.new(name);
    endfunction 
    //{{{
    virtual task pre_body();
        use_response_handler(1);
        //`uvm_info(get_full_name(), "in pre_body", UVM_LOW)
    endtask
  
    virtual function void response_handler(uvm_sequence_item response);
       if(!$cast(rsp, response))
          `uvm_error(get_full_name(), "can't cast")
       else begin
          `uvm_info(get_full_name(), $sformatf("Contents: \n%s", rsp.sprint()), UVM_LOW)
       end
    endfunction
    //}}}
    virtual task body();
        repeat (10) begin
            `uvm_info(get_full_name(), "put one req", UVM_MEDIUM)
            `uvm_do(m_trans)
            //get_response(rsp);
            //`uvm_info(get_full_name(), $sformatf("Contents: \n%s", rsp.sprint()), UVM_LOW)
        end
    endtask
endclass

class case0_vseq extends uvm_sequence;
   `uvm_object_utils(case0_vseq)
   `uvm_declare_p_sequencer(my_vsqr) 
   function new(string name = "case0_vseq");
      super.new(name);
   endfunction

   virtual task body();
      my_transaction tr;
      drv0_seq seq0;
      if(starting_phase != null) 
         starting_phase.raise_objection(this);
      fork
         //`uvm_do_on(seq0, p_sequencer.p_sqr0);
         seq0 = drv0_seq::type_id::create("seq0");
         seq0.start(p_sequencer.p_sqr0);
      join 
      if(starting_phase != null) 
         starting_phase.drop_objection(this);
   endtask
endclass

class my_case5 extends base_test;

   function new(string name = "my_case5", uvm_component parent = null);
      super.new(name,parent);
   endfunction 
   `uvm_component_utils(my_case5)
   extern virtual function void build_phase(uvm_phase phase); 
endclass

function void my_case5::build_phase(uvm_phase phase);
    super.build_phase(phase);

    uvm_config_db#(uvm_object_wrapper)::set(this, 
                                           "v_sqr.main_phase", 
                                           "default_sequence", 
                                           case0_vseq::type_id::get());
endfunction

`endif
