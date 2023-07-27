// Code your testbench here
// or browse Examples
import uvm_pkg::*;

class h extends uvm_component;
  `uvm_component_utils(h)
  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("BUILD_PHASE", "Building component h", UVM_DEBUG)
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("CONNECT_PHASE", "Connecting component h", UVM_NONE)
  endfunction
endclass

class i extends uvm_component;
  `uvm_component_utils(i)
  h h_m;
  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("BUILD_PHASE", "Building component i", UVM_DEBUG)
    h_m = h::type_id::create("h_m", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("CONNECT_PHASE", "Connecting component i", UVM_NONE)
  endfunction
endclass

class c extends uvm_component;
  `uvm_component_utils(c)
  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("BUILD_PHASE", "Building component c", UVM_DEBUG)
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("CONNECT_PHASE", "Connecting component c", UVM_NONE)
  endfunction
endclass

class e extends uvm_component;
  `uvm_component_utils(e)
  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("BUILD_PHASE", "Building component e", UVM_DEBUG)
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("CONNECT_PHASE", "Connecting component e", UVM_NONE)
  endfunction
endclass

class a extends uvm_component;
  `uvm_component_utils(a)
  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("BUILD_PHASE", "Building component a", UVM_DEBUG)
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("CONNECT_PHASE", "Connecting component a", UVM_NONE)
  endfunction
endclass

class d extends uvm_component;
  `uvm_component_utils(d)
  c c_m;
  e e_m;
  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("BUILD_PHASE", "Building component d", UVM_DEBUG)
    c_m = c::type_id::create("c_m", this);
    e_m = e::type_id::create("e_m", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("CONNECT_PHASE", "Connecting component d", UVM_NONE)
  endfunction
endclass

class b extends uvm_component;
  `uvm_component_utils(b)
  a a_m;
  d d_m;
  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("BUILD_PHASE", "Building component b", UVM_DEBUG)
    a_m = a::type_id::create("a_m", this);
    d_m = d::type_id::create("d_m", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("CONNECT_PHASE", "Connecting component b", UVM_NONE)
  endfunction
endclass

class g extends uvm_component;
  `uvm_component_utils(g)
  i i_m;
  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("BUILD_PHASE", "Building component g", UVM_DEBUG)
    i_m = i::type_id::create("i_m", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("CONNECT_PHASE", "Connecting component g", UVM_NONE)
  endfunction
endclass

class f extends uvm_component;
  `uvm_component_utils(f)
  b b_m;
  g g_m;
  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("BUILD_PHASE", "Building component f", UVM_DEBUG)
    b_m = b::type_id::create("b_m", this);
    g_m = g::type_id::create("g_m", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("CONNECT_PHASE", "Connecting component f", UVM_NONE)
  endfunction
endclass

class test extends uvm_test;
  `uvm_component_utils(test)
  f f_m;
  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("BUILD_PHASE", "Building component test", UVM_DEBUG)
    f_m = f::type_id::create("f_m", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("CONNECT_PHASE", "Connecting component test", UVM_NONE)
  endfunction
endclass

module tb;
  initial begin
    run_test("test");
  end
endmodule
