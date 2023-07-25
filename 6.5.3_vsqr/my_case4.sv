`ifndef MY_CASE4__SV
`define MY_CASE4__SV
class crc_seq extends uvm_sequence#(my_transaction);
    `uvm_object_utils(crc_seq)
    `uvm_declare_p_sequencer(my_sequencer)
    function  new(string name= "crc_seq");
        super.new(name);
    endfunction 
   
    virtual task body();
        my_transaction tr;
        //`uvm_do_with(tr, {tr.crc_err == 1;
        //                  tr.dmac == 48'h980F;})
      repeat(10)begin
        `uvm_do_with(tr, {tr.dmac == p_sequencer.dmac;
                          tr.smac == p_sequencer.smac;})
      `uvm_info("crc", "seq_crc",  UVM_LOW)
      end
    endtask
endclass

class long_seq extends uvm_sequence#(my_transaction);
   `uvm_object_utils(long_seq)
   function  new(string name= "long_seq");
      super.new(name);
   endfunction 
   
   virtual task body();
      my_transaction tr;
      repeat(10)begin
      `uvm_do_with(tr, {tr.crc_err == 0;
                        tr.pload.size() == 10;
                        tr.dmac == 48'hF675;})
      `uvm_info("long", "seq_long",  UVM_LOW)
      end
   endtask
endclass
//class sequence0 extends uvm_sequence #(my_transaction);
//    my_transaction m_trans;
//    //int num;
//    //bit has_delayed;
//
//   function  new(string name= "sequence0");
//      super.new(name);
//      //num = 0;
//      //has_delayed = 0;
//   endfunction 
//   //virtual function bit is_relevant();
//   //   if((num >= 3)&&(!has_delayed)) begin
//   //      `uvm_info("sequence0", "in_relevant is 0", UVM_MEDIUM)
//   //     return 0;
//   //   end else begin
//   //      `uvm_info("sequence0", "in_relevant is 1", UVM_MEDIUM)
//   //     return 1;
//   //   end
//   //endfunction
//
//   //virtual task wait_for_relevant();
//   //      `uvm_info("sequence0", "wait_for_relevant", UVM_MEDIUM)
//   //   #10000;
//   //   has_delayed = 1;
//   //endtask
//   virtual task body();
//      crc_seq cseq;
//      long_seq lseq;
//      if(starting_phase != null) 
//         starting_phase.raise_objection(this);
//
//         m_sequencer.set_arbitration(SEQ_ARB_STRICT_FIFO);
//      //repeat (10) begin
//         //num++;
//         //`uvm_info(get_type_name(), $sformatf("Num: \n%d", num), UVM_LOW)
//         //`uvm_do_with(m_trans, {m_trans.is_vlan == 16'd0;})
//         //`uvm_info("sequence0", "send one transaction", UVM_MEDIUM)
//         //cseq = new("cseq");
//         //lseq = new("lseq");
//         //cseq.start(m_sequencer);
//         //lseq.start(m_sequencer);
//         fork
//            `uvm_do_pri(cseq, 10)
//            `uvm_do_pri(lseq, 11)
//         join 
//      //end
//
//      `uvm_info("sequence0", "drop objection",  UVM_LOW)
//      if(starting_phase != null) 
//         starting_phase.drop_objection(this);
//   endtask
//
//   `uvm_object_utils(sequence0)
//endclass
class drv0_seq extends uvm_sequence #(my_transaction);
   my_transaction m_trans;
   `uvm_object_utils(drv0_seq)

   function  new(string name= "drv0_seq");
      super.new(name);
   endfunction 
   
   virtual task body();
      repeat (10) begin
         `uvm_do(m_trans)
         `uvm_info("drv0_seq", "send one transaction", UVM_MEDIUM)
      end
   endtask
endclass

class drv1_seq extends uvm_sequence #(my_transaction);
   my_transaction m_trans;
   `uvm_object_utils(drv1_seq)

   function  new(string name= "drv1_seq");
      super.new(name);
   endfunction 
   
   virtual task body();
      repeat (10) begin
         `uvm_do(m_trans)
         `uvm_info("drv1_seq", "send one transaction", UVM_MEDIUM)
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
      drv1_seq seq1;
      if(starting_phase != null) 
         starting_phase.raise_objection(this);
      `uvm_do_on_with(tr, p_sequencer.p_sqr0, {tr.pload.size == 1500;})
      `uvm_info("vseq", "send one longest packet on p_sequencer.p_sqr0", UVM_MEDIUM)
      fork
         `uvm_do_on(seq0, p_sequencer.p_sqr0);
         `uvm_do_on(seq1, p_sequencer.p_sqr1);
      join 
      if(starting_phase != null) 
         starting_phase.drop_objection(this);
   endtask
endclass

class my_case4 extends base_test;

   function new(string name = "my_case4", uvm_component parent = null);
      super.new(name,parent);
   endfunction 
   `uvm_component_utils(my_case4)
   extern virtual function void build_phase(uvm_phase phase); 
endclass

function void my_case4::build_phase(uvm_phase phase);
   super.build_phase(phase);

   //uvm_config_db#(bit[47:0])::set(this, "env.i_agt.sqr", "dmac", 48'hF9765); 
   //uvm_config_db#(bit[47:0])::set(this, "env.i_agt.sqr", "smac", 48'h89F23); 
   ////uvm_config_db#(uvm_object_wrapper)::set(this, 
   //                                        "env.i_agt.sqr.main_phase", 
   //                                        "default_sequence", 
   //                                        sequence0::type_id::get());
   //env.i_agt.sqr.set_arbitration(SEQ_ARB_STRICT_FIFO);
   uvm_config_db#(uvm_object_wrapper)::set(this, 
                                           "v_sqr.main_phase", 
                                           "default_sequence", 
                                           case0_vseq::type_id::get());
endfunction

`endif
