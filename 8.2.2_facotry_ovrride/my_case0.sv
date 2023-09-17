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

//function void my_case0::print_hungry(bird b_ptr);
//   b_ptr.hungry();
//   b_ptr.hungry2();
//endfunction
//
//function void my_case0::build_phase(uvm_phase phase);
//   bird bird_inst;
//   parrot parrot_inst;
//   super.build_phase(phase);
//
//   bird_inst = bird::type_id::create("bird_inst");
//   parrot_inst = parrot::type_id::create("parrot_inst");
//   print_hungry(bird_inst);
//   print_hungry(parrot_inst);
//endfunction

class my_case0 extends base_test;
    `uvm_component_utils(my_case0)
    function new(string name = "my_case0", uvm_component parent = null);
       super.new(name,parent);
    endfunction

    extern virtual function void build_phase(uvm_phase phase);
endclass


function void my_case0::build_phase(uvm_phase phase);
    Bird bird_inst1;
    Bird bird_inst2;
    Bird bird_inst3;
    ABird bird_insta;
    CBird bird_instc;
    super.build_phase(phase);

    bird_inst1 = Bird::type_id::create("bird_inst1",this);
    bird_inst1.hungry();
    bird_inst1.hungry2();

    set_inst_override_by_type("*", Bird::get_type(), ABird::get_type());
    bird_inst2 = Bird::type_id::create("bird_inst1",this);
    bird_inst2.hungry();
    bird_inst2.hungry2();

    set_inst_override_by_type("*", ABird::get_type(), CBird::get_type());
    bird_inst3 = Bird::type_id::create("bird_inst1",this);
    bird_inst3.hungry();
    bird_inst3.hungry2();

    uvm_config_db#(uvm_object_wrapper)::set(this,
                                            "env.i_agt.sqr.main_phase",
                                            "default_sequence",
                                            case0_sequence::type_id::get());
endfunction

`endif
