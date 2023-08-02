`ifndef REG_MODEL__SV
`define REG_MODEL__SV
//{{{ uvm_reg
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
//}}}
//{{{ uvm_reg_block
class reg_block_invert extends uvm_reg_block;
    `uvm_object_utils(reg_block_invert)

    function new(input string name = "reg_block_invert");
        super.new(name, UVM_NO_COVERAGE);
    endfunction 

    rand reg_invert invert;
    virtual function void build();
        default_map = create_map("default_map", 0, 2, UVM_BIG_ENDIAN, 0);

        invert = reg_invert::type_id::create("invert", , get_full_name()); // TODO ??
        invert.configure(this, null, "invert"); // TODO
        invert.build();

        default_map.add_reg(invert, 'h0, "RW");
    endfunction
endclass

class reg_block_counter_high extends uvm_reg_block;
    `uvm_object_utils(reg_block_counter_high)

    function new(input string name = "reg_block_counter_high");
        super.new(name, UVM_NO_COVERAGE);
    endfunction 

    rand reg_counter_high counter_high;
    virtual function void build();
        default_map = create_map("default_map", 0, 2, UVM_BIG_ENDIAN, 0);

        counter_high = reg_counter_high::type_id::create("counter_high", , get_full_name()); // TODO ??
        counter_high.configure(this, null, "counter[31:16]"); // TODO
        counter_high.build();

        default_map.add_reg(counter_high, 'h0, "RW");
    endfunction
endclass

class reg_block_counter_low extends uvm_reg_block;
    `uvm_object_utils(reg_block_counter_low)

    function new(input string name = "reg_block_counter_low");
        super.new(name, UVM_NO_COVERAGE);
    endfunction 

    rand reg_counter_low counter_low;
    virtual function void build();
        default_map = create_map("default_map", 0, 2, UVM_BIG_ENDIAN, 0);

        counter_low = reg_counter_low::type_id::create("counter_low", , get_full_name()); // TODO ??
        counter_low.configure(this, null, "counter[15:0]");
        counter_low.build();

        default_map.add_reg(counter_low, 'h0, "RW");
    endfunction
endclass
//}}}
//{{{ reg_model 
class reg_model extends uvm_reg_block;
    `uvm_object_utils(reg_model)

    function new(input string name="reg_model");
        super.new(name, UVM_NO_COVERAGE);
    endfunction 

    rand reg_block_invert       blk_invert;
    rand reg_block_counter_high blk_counter_high;
    rand reg_block_counter_low  blk_counter_low;

    virtual function void build();
        default_map = create_map("default_map", 0, 2, UVM_BIG_ENDIAN, 0);

        blk_invert = reg_block_invert::type_id::create("blk_invert");
        blk_invert.configure(this, ""); // TODO
        blk_invert.build();
        default_map.add_submap(blk_invert.default_map, 'h9); // TODO
        blk_invert.lock_model();

        blk_counter_high = reg_block_counter_high::type_id::create("blk_counter_high");
        blk_counter_high.configure(this, ""); // TODO
        blk_counter_high.build();
        default_map.add_submap(blk_counter_high.default_map, 'h5); // TODO
        blk_counter_high.lock_model();

        blk_counter_low = reg_block_counter_low::type_id::create("blk_counter_low");
        blk_counter_low.configure(this, ""); // TODO
        blk_counter_low.build();
        default_map.add_submap(blk_counter_low.default_map, 'h6); // TODO
        blk_counter_low.lock_model();
    endfunction

endclass
//}}}
`endif
