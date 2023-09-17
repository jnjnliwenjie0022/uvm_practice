`ifndef MY_CASE0__SV
`define MY_CASE0__SV
class case0_sequence extends uvm_sequence #(my_transaction);
   my_transaction m_trans;

   function  new(string name= "case0_sequence");
      super.new(name);
   endfunction

   virtual task body();
      if(starting_phase != null)
         starting_phase.raise_objection(this);
      repeat (10) begin
         `uvm_do(m_trans)
      end
      #100;
      if(starting_phase != null)
         starting_phase.drop_objection(this);
   endtask

   `uvm_object_utils(case0_sequence)
endclass

class Bird extends uvm_object;
    `uvm_object_utils(Bird)
    function new(string name = "Bird");
        super.new(name);
    endfunction

    virtual function void hungry();
        $display("Bird, Hungry");
    endfunction

    function void hungry2();
        $display("Bird, Hungry2");
    endfunction
endclass

class ABird extends Bird;
   `uvm_object_utils(ABird)
   function new(string name = "ABird");
      super.new(name);
   endfunction

   virtual function void hungry();
      $display("ABird, Hungry");
   endfunction

   function void hungry2();
      $display("ABird, Hungry2");
   endfunction
endclass

class CBird extends Bird;
   `uvm_object_utils(CBird)
   function new(string name = "CBird");
      super.new(name);
   endfunction

   virtual function void hungry();
      $display("CBird, Hungry");
   endfunction

   function void hungry2();
      $display("CBird, Hungry2");
   endfunction
endclass

class new_monitor extends my_monitor;
    `uvm_component_utils(new_monitor)

    function new(string name = "new_monitor", uvm_component parent = null);
       super.new(name, parent);
    endfunction

    virtual task main_phase(uvm_phase phase);
       fork
          super.main_phase(phase);
       join_none
       `uvm_info("new_monitor", "I am new monitor", UVM_MEDIUM)
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

    set_inst_override_by_type("env.o_agt.mon", my_monitor::get_type(), new_monitor::get_type());
    uvm_config_db#(uvm_object_wrapper)::set(this,
                                            "env.i_agt.sqr.main_phase",
                                            "default_sequence",
                                            case0_sequence::type_id::get());
endfunction

`endif
