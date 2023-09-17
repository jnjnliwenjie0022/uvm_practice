`ifndef MY_CASE0__SV
`define MY_CASE0__SV

//class new_transaction extends my_transaction;
//   `uvm_object_utils(new_transaction)
//   function  new(string name= "new_transaction");
//      super.new(name);
//   endfunction
//
//   constraint crc_err_cons{
//      crc_err dist {0 := 2, 1 := 1};
//   }
//endclass


class crc_err_tr extends my_transaction;
    `uvm_object_utils(crc_err_tr)

    function  new(string name= "crc_err_tr");
       super.new(name);
    endfunction

    constraint crc_err_cons{
       crc_err dist {0 := 2, 1 := 1};
    }

endclass

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

            item.randomize();
            `uvm_info("", $sformatf("rand item.crc_err: %d", item.crc_err), UVM_LOW)

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
    `uvm_component_utils(my_case0)

    function new(string name = "my_case0", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    extern virtual function void build_phase(uvm_phase phase);
endclass


function void my_case0::build_phase(uvm_phase phase);
    super.build_phase(phase);

    set_type_override_by_type(my_transaction::get_type(), crc_err_tr::get_type());
    uvm_config_db#(uvm_object_wrapper)::set(this,
        "env.i_agt.sqr.main_phase",
        "default_sequence",
        case0_sequence::type_id::get());
endfunction

`endif
//
//
//class normal_sequence extends uvm_sequence #(my_transaction);
//   my_transaction m_trans;
//
//   function  new(string name= "normal_sequence");
//      super.new(name);
//   endfunction
//
//   virtual task pre_body();
//      if(starting_phase != null)
//         starting_phase.raise_objection(this);
//   endtask
//   virtual task post_body();
//      if(starting_phase != null)
//         starting_phase.drop_objection(this);
//   endtask
//
//   virtual task body();
//      `uvm_do(m_trans)
//      m_trans.print();
//   endtask
//
//   `uvm_object_utils(normal_sequence)
//endclass
//
//class case_sequence extends uvm_sequence #(my_transaction);
//   `uvm_object_utils(case_sequence)
//   function  new(string name= "case_sequence");
//      super.new(name);
//   endfunction
//
//   virtual task pre_body();
//      if(starting_phase != null)
//         starting_phase.raise_objection(this);
//   endtask
//   virtual task post_body();
//      if(starting_phase != null)
//         starting_phase.drop_objection(this);
//   endtask
//
//   virtual task body();
//      normal_sequence nseq;
//      repeat(10) begin
//         `uvm_do(nseq)
//      end
//   endtask
//endclass
//
//class abnormal_sequence extends normal_sequence;
//   `uvm_object_utils(abnormal_sequence)
//   function  new(string name= "abnormal_sequence");
//      super.new(name);
//   endfunction
//
//   virtual task body();
//      m_trans = new("m_trans");
//      m_trans.crc_err_cons.constraint_mode(0);
//      `uvm_rand_send_with(m_trans, {crc_err == 1;})
//      m_trans.print();
//   endtask
//endclass
//
//
//class my_case0 extends base_test;
//
//   function new(string name = "my_case0", uvm_component parent = null);
//      super.new(name,parent);
//   endfunction
//   extern virtual function void build_phase(uvm_phase phase);
//   `uvm_component_utils(my_case0)
//endclass
//
//
//function void my_case0::build_phase(uvm_phase phase);
//   super.build_phase(phase);
//
//   factory.set_type_override_by_type(normal_sequence::get_type(), abnormal_sequence::get_type());
//   uvm_config_db#(uvm_object_wrapper)::set(this,
//                                           "env.i_agt.sqr.main_phase",
//                                           "default_sequence",
//                                           case_sequence::type_id::get());
//endfunction
//
//`endif
