`ifndef REG_MODEL__SV
`define REG_MODEL__SV

class reg_invert extends uvm_reg;
    `uvm_object_utils(reg_invert)

    rand uvm_reg_field reg_data;

    function new(input string name="reg_invert");
        //        name, size, has_coverage
        // the size corresponds with bus data bit width size not register size
        super.new(name, 16,   UVM_NO_COVERAGE);
    endfunction

    // build can't automatically execute
    virtual function void build();
        reg_data = uvm_reg_field::type_id::create("reg_data");
        //                 parent, size, lsb_pos, access, volatile, reset value, has_reset, is_rand, individually accessible
        reg_data.configure(this,   1,    0,       "RW",   1,        0,           1,         1,       0);
    endfunction

endclass

class reg_model extends uvm_reg_block;
    `uvm_object_utils(reg_model)

    function new(input string name="reg_model");
        super.new(name, UVM_NO_COVERAGE);
    endfunction 

    rand reg_invert invert;

    virtual function void build();
        //                       "default_map", base_addr, bus byte width, endian,         byte enable 
        default_map = create_map("default_map", 0,         2,              UVM_BIG_ENDIAN, 0);

        invert = reg_invert::type_id::create("invert", , get_full_name());
        invert.configure(this, null, "");
        invert.build();
        //                  reg,    reg_offset,   access
        default_map.add_reg(invert, 'h9,          "RW");
    endfunction

endclass
`endif
