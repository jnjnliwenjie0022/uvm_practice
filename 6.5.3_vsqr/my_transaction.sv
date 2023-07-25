`ifndef MY_TRANSACTION__SV
`define MY_TRANSACTION__SV

class my_transaction extends uvm_sequence_item;

    rand bit[47:0] dmac;
    rand bit[47:0] smac;
    rand bit[15:0] ether_type;
    rand byte      pload[];
    rand bit[31:0] crc;
    rand bit       crc_err;
    //{{{
    rand bit[15:0] is_vlan;
    rand bit[15:0] vlan_info1;
    rand bit[2:0]  vlan_info2;
    rand bit       vlan_info3;
    rand bit[11:0] vlan_info4;
    //}}}
    //constraint pload_cons{
    //    pload.size >= 46;
    //    pload.size <= 1500;
    //}

    function bit[31:0] calc_crc();
        return 32'h0;
    endfunction

    function void post_randomize();
        if(crc_err)
        ;
        else
            crc = calc_crc;
    endfunction

    //`uvm_object_utils(my_transaction)

    function new(string name = "my_transaction");
        super.new();
    endfunction
    `uvm_object_utils_begin(my_transaction)
       `uvm_field_int(dmac, UVM_ALL_ON)
       `uvm_field_int(smac, UVM_ALL_ON)
        //{{{
        if(is_vlan)begin
            `uvm_field_int(vlan_info1, UVM_ALL_ON)
            `uvm_field_int(vlan_info2, UVM_ALL_ON)
            `uvm_field_int(vlan_info3, UVM_ALL_ON)
            `uvm_field_int(vlan_info4, UVM_ALL_ON)
        end
        //}}}
       `uvm_field_int(ether_type, UVM_ALL_ON)
       `uvm_field_array_int(pload, UVM_ALL_ON)
       `uvm_field_int(crc, UVM_ALL_ON)
        `uvm_field_int(is_vlan, UVM_ALL_ON)
       `uvm_field_int(crc_err, UVM_ALL_ON | UVM_NOPACK)
    `uvm_object_utils_end
    //function void my_print();
    //    $display("dmac = %0h", dmac);
    //    $display("smac = %0h", smac);
    //    $display("ether_type = %0h", ether_type);
    //    for(int i = 0; i < pload.size; i++) begin
    //        $display("pload[%0d] = %0h", i, pload[i]);
    //    end
    //    $display("crc = %0h", crc);
    //endfunction
    //function void my_copy(my_transaction tr);
    //    if(tr == null)
    //        `uvm_fatal("my_transaction", "tr is null!!!!")
    //    dmac = tr.dmac;
    //    smac = tr.smac;
    //    ether_type = tr.ether_type;
    //    pload = new[tr.pload.size()];
    //    for(int i = 0; i < pload.size(); i++) begin
    //        pload[i] = tr.pload[i];
    //    end
    //    crc = tr.crc;
    //endfunction
    //function bit my_compare(my_transaction tr);
    //   bit result;
    //   
    //   if(tr == null)
    //      `uvm_fatal("my_transaction", "tr is null!!!!")
    //   result = ((dmac == tr.dmac) &&
    //             (smac == tr.smac) &&
    //             (ether_type == tr.ether_type) &&
    //             (crc == tr.crc));
    //   if(pload.size() != tr.pload.size())
    //      result = 0;
    //   else 
    //      for(int i = 0; i < pload.size(); i++) begin
    //         if(pload[i] != tr.pload[i])
    //            result = 0;
    //      end
    //   return result; 
    //endfunction
endclass
`endif
