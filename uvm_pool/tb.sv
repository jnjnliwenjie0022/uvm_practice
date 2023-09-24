import uvm_pkg::*;
`include "uvm_macros.svh"

module tb;
    uvm_pool #(string, int) n_pool;

    initial begin
        n_pool = new("n_pool");

        n_pool.add("1x", 11);
        n_pool.add("1x", 12);
        n_pool.add("1x", 13);

        $display("n_pool[%s] = %d", "1x", n_pool.get("1x"));
    end

endmodule

//  // Function: add
//  //
//  // Adds the given (~key~, ~item~) pair to the pool. If an item already
//  // exists at the given ~key~ it is overwritten with the new ~item~.
//
//  virtual function void add (KEY key, T item);
//    pool[key] = item;
//  endfunction
