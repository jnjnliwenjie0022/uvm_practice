import uvm_pkg::*;

class pkt;

    rand int count;

    constraint c1 {
        count >= 2;
        count <= 9;
    }

    function new(string name="thursday_seq");
        if (std::randomize(count)) `uvm_info("",$psprintf(" cnt=%0d .....",count),UVM_LOW)
        else $finish;
        if (std::randomize(this.count)) `uvm_info("",$psprintf(" cnt=%0d .....",count),UVM_LOW)
        else $finish;
        //if (std::randomize(local::count)) `uvm_info("",$psprintf(" cnt=%0d .....",count),UVM_LOW)
        //else $finish;
        if (randomize(count)) `uvm_info("",$psprintf(" cnt=%0d .....",count),UVM_LOW)
        else $finish;
        if (this.randomize()) `uvm_info("",$psprintf(" cnt=%0d .....",count),UVM_LOW)
        else $finish;
    endfunction: new

endclass

module tb;
    pkt p1;

    initial begin
        p1 = new();
    end
endmodule

