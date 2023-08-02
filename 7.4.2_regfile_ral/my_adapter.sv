`ifndef MY_ADAPTER__SV 
`define MY_ADAPTER__SV 
class my_adapter extends uvm_reg_adapter;
    string tID = get_type_name();

    `uvm_object_utils(my_adapter)

    function new(string name="my_adapter");
        super.new(name);
    endfunction : new

   // notice: uvm_reg_bus_op is a structure so add "ref" at the function call
   // is reasonable
    function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
        bus_transaction tr;
        `uvm_info(get_type_name(), "reg2bus", UVM_LOW)
        tr = new("tr"); 
        tr.addr = rw.addr;
        tr.bus_op = (rw.kind == UVM_READ) ? BUS_RD: BUS_WR;
        if (tr.bus_op == BUS_WR)
            tr.wr_data = rw.data; 
        return tr;
    endfunction : reg2bus

    function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
        bus_transaction tr;
        `uvm_info(get_type_name(), "bus2reg", UVM_LOW)
        if(!$cast(tr, bus_item)) begin
            `uvm_fatal(tID,
            "Provided bus_item is not of the correct type. Expecting bus_transaction")
            return;
        end
        rw.kind = (tr.bus_op == BUS_RD) ? UVM_READ : UVM_WRITE;
        rw.addr = tr.addr;
        rw.byte_en = 'h3;
        rw.data = (tr.bus_op == BUS_RD) ? tr.rd_data : tr.wr_data;
        rw.status = UVM_IS_OK;
    endfunction : bus2reg

endclass : my_adapter
`endif
