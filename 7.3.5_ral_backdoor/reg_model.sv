`ifndef REG_MODEL__SV
`define REG_MODEL__SV

class reg_invert extends uvm_reg;
    `uvm_object_utils(reg_invert)

    function new(input string name="reg_invert");
        //        name, size, has_coverage
        // the size corresponds with bus data bit width size not register size
        super.new(name, 16,   UVM_NO_COVERAGE);
    endfunction

    rand uvm_reg_field reg_data;
    // build can't automatically execute
    virtual function void build();
        reg_data = uvm_reg_field::type_id::create("reg_data");
        //                 parent, size, lsb_pos, access, volatile, reset value, has_reset, is_rand, individually accessible
        reg_data.configure(this,   1,    0,       "RW",   1,        0,           1,         1,       0);
    endfunction

endclass

class reg_counter_high extends uvm_reg;
    `uvm_object_utils(reg_counter_high)

    function new(input string name="reg_counter_high");
        //        name, size, has_coverage
        // the size corresponds with bus data bit width size not register size
        super.new(name, 16,   UVM_NO_COVERAGE);
    endfunction

    rand uvm_reg_field reg_data;
    // build can't automatically execute
    virtual function void build();
        reg_data = uvm_reg_field::type_id::create("reg_data");
        //                 parent, size, lsb_pos, access, volatile, reset value, has_reset, is_rand, individually accessible
        reg_data.configure(this,   16,    0,       "RW",   1,        0,           1,         1,       0);
    endfunction

endclass

class reg_counter_low extends uvm_reg;
    `uvm_object_utils(reg_counter_low)

    function new(input string name="reg_counter_low");
        //        name, size, has_coverage
        // the size corresponds with bus data bit width size not register size
        super.new(name, 16,   UVM_NO_COVERAGE);
    endfunction

    rand uvm_reg_field reg_data;
    virtual function void build();
        reg_data = uvm_reg_field::type_id::create("reg_data");
        //                 parent, size, lsb_pos, access, volatile, reset value, has_reset, is_rand, individually accessible
        reg_data.configure(this,   16,    0,       "RW",   1,        0,           1,         1,       0);
    endfunction

endclass

class reg_model extends uvm_reg_block;
    `uvm_object_utils(reg_model)

    function new(input string name="reg_model");
        super.new(name, UVM_NO_COVERAGE);
    endfunction 

    rand reg_invert invert;
    rand reg_counter_high counter_high;
    rand reg_counter_low counter_low;

    virtual function void build();
        // instantiate the default_map
        //                       "default_map", base_addr, bus byte width, endian,         byte enable 
        default_map = create_map("default_map", 0,         2,              UVM_BIG_ENDIAN, 0);

        // instantiate the uvm_reg and configure/build
        invert = reg_invert::type_id::create("invert", , get_full_name());
        //function void configure ( uvm_reg_block blk_parent,
        //                          uvm_reg_file regfile_parent = null,
        //                          string hdl_path = "")
        
        invert.configure(this, null, "invert");
        invert.build();
        counter_high = reg_counter_high::type_id::create("counter_high");
        counter_high.configure(this, null, "counter[31:16]");
        counter_high.build();
        counter_low = reg_counter_low::type_id::create("counter_high");
        counter_low.configure(this, null, "counter[15:0]");
        counter_low.build();

        // add uvm_reg to defualt map
        //                  reg,    reg_offset,  access
        default_map.add_reg(invert,       'h9,   "RW");
        default_map.add_reg(counter_high, 'h5,   "RW");
        default_map.add_reg(counter_low,  'h6,   "RW");
    endfunction

endclass
`endif
