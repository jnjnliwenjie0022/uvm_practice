`ifndef MY_CASE4__SV
`define MY_CASE4__SV
class sequence0 extends uvm_sequence #(my_transaction);
   my_transaction m_trans;
    //{{{
    int num;
    bit has_delayed;
    //}}}

   function  new(string name= "sequence0");
      super.new(name);
      //{{{
      num = 0;
      has_delayed = 0;
      //}}}
   endfunction 
   //{{{
   virtual function bit is_relevant();
      if((num >= 3)&&(!has_delayed)) begin
         `uvm_info("sequence0", "in_relevant is 0", UVM_MEDIUM)
        return 0;
      end else begin
         `uvm_info("sequence0", "in_relevant is 1", UVM_MEDIUM)
        return 1;
      end
   endfunction

   virtual task wait_for_relevant();
         `uvm_info("sequence0", "wait_for_relevant", UVM_MEDIUM)
      #10000;
      has_delayed = 1;
   endtask
   //}}}
   virtual task body();
      if(starting_phase != null) 
         starting_phase.raise_objection(this);

      //repeat (2) begin
      //   `uvm_do_with(m_trans, {m_trans.is_vlan == 16'd0;})
      //   `uvm_info("sequence0", "send one transaction", UVM_MEDIUM)
      //end
      //lock();
      //`uvm_info("sequence0", "locked the sequencer ", UVM_MEDIUM)
      repeat (10) begin
         num++;
         `uvm_info(get_type_name(), $sformatf("Num: \n%d", num), UVM_LOW)
         `uvm_do_with(m_trans, {m_trans.is_vlan == 16'd0;})
         `uvm_info("sequence0", "send one transaction", UVM_MEDIUM)
      end
      //`uvm_info("sequence0", "unlocked the sequencer ", UVM_MEDIUM)
      //unlock();
      //repeat (2) begin
      //   `uvm_do_with(m_trans, {m_trans.is_vlan == 16'd0;})
      //   `uvm_info("sequence0", "send one transaction", UVM_MEDIUM)
      //end

      `uvm_info("sequence0", "drop objection",  UVM_LOW)
      if(starting_phase != null) 
         starting_phase.drop_objection(this);
   endtask

   `uvm_object_utils(sequence0)
endclass

class sequence1 extends uvm_sequence #(my_transaction);
   my_transaction m_trans;

   function  new(string name= "sequence1");
      super.new(name);
   endfunction 
   
   virtual task body();
      if(starting_phase != null) 
         starting_phase.raise_objection(this);

      //repeat (2) begin
      //   //`uvm_do_with(m_trans, {m_trans.pload.size < 500;})
      //   `uvm_do_with(m_trans, {m_trans.is_vlan == 1;})
      //   `uvm_info("sequence1", "send one transaction", UVM_MEDIUM)
      //end
      //lock();
      //`uvm_info("sequence1", "locked the sequencer ", UVM_MEDIUM)
      repeat (10) begin
         //`uvm_do_with(m_trans, {m_trans.pload.size < 500;})
         `uvm_do_with(m_trans, {m_trans.is_vlan == 1;})
         `uvm_info("sequence1", "send one transaction", UVM_MEDIUM)
      end
      //`uvm_info("sequence1", "unlocked the sequencer ", UVM_MEDIUM)
      //unlock();
      //repeat (2) begin
      //   //`uvm_do_with(m_trans, {m_trans.pload.size < 500;})
      //   `uvm_do_with(m_trans, {m_trans.is_vlan == 1;})
      //   `uvm_info("sequence1", "send one transaction", UVM_MEDIUM)
      //end

      `uvm_info("sequence1", "drop objection",  UVM_LOW)
      if(starting_phase != null) 
         starting_phase.drop_objection(this);
   endtask

   `uvm_object_utils(sequence1)
endclass


class my_case4 extends base_test;

   function new(string name = "my_case4", uvm_component parent = null);
      super.new(name,parent);
   endfunction 
   `uvm_component_utils(my_case4)
   extern virtual task main_phase(uvm_phase phase);
endclass

task my_case4::main_phase(uvm_phase phase);
   sequence0 seq0;
   sequence1 seq1;

   seq0 = new("seq0");
   seq1 = new("seq1");
   seq0.starting_phase = phase;
   seq1.starting_phase = phase;
   //env.i_agt.sqr.set_arbitration(SEQ_ARB_STRICT_FIFO);
   fork
      //seq0.start(env.i_agt.sqr, null, 100);
      //seq1.start(env.i_agt.sqr, null, 200);
      seq0.start(env.i_agt.sqr);
      seq1.start(env.i_agt.sqr);
   join
endtask

`endif
