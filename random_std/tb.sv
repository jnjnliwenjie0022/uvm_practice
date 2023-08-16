import uvm_pkg::*;

class pkt;

    rand logic [7:0] class_rand_num_1_to_9 = 100;
    logic [7:0] class_num_1_to_9 = 100;

    constraint c1 {
        class_rand_num_1_to_9 >= 2;
        class_rand_num_1_to_9 <= 9;
    }

    function new (string name = "pkt");
        class_rand_num_1_to_9 = 200;
        class_num_1_to_9 = 200;
    endfunction

    function logic [7:0] get_num();
        logic [7:0] scope_num = 100;

        if (std::randomize(class_rand_num_1_to_9))
            `uvm_info("",$psprintf("class: class_rand_num_1_to_9=%0d .....",class_rand_num_1_to_9),UVM_LOW)
        else
            $finish;
        if (std::randomize(this.class_rand_num_1_to_9))
            `uvm_info("",$psprintf("class: class_rand_num_1_to_9=%0d .....",class_rand_num_1_to_9),UVM_LOW)
        else
            $finish;
        if (randomize(class_rand_num_1_to_9))
            `uvm_info("",$psprintf("class: class_rand_num_1_to_9=%0d .....",class_rand_num_1_to_9),UVM_LOW)
        else
            $finish;
        if (this.randomize()) // unuseful for scope_num
            `uvm_info("",$psprintf("class: class_rand_num_1_to_9=%0d .....",class_rand_num_1_to_9),UVM_LOW)
        else
            $finish;

        if (std::randomize(scope_num))
            `uvm_info("",$psprintf("class: scope_num=%0d .....",scope_num),UVM_LOW)
        else
            $finish;
        //illegal
        //if (std::randomize(this.scope_num))
        //    `uvm_info("",$psprintf("class: scope_num=%0d .....",scope_num),UVM_LOW)
        //else
        //    $finish;
        //illegal
        //if (randomize(scope_num))
        //    `uvm_info("",$psprintf("class: scope_num=%0d .....",scope_num),UVM_LOW)
        //else
        //    $finish;
        if (this.randomize()) // unuseful for scope_num
            `uvm_info("",$psprintf("class: scope_num=%0d .....",scope_num),UVM_LOW)
        else
            $finish;

        if (std::randomize(class_num_1_to_9))
            `uvm_info("",$psprintf("class: class_num_1_to_9=%0d .....",class_num_1_to_9),UVM_LOW)
        else
            $finish;
        if (std::randomize(this.class_num_1_to_9))
            `uvm_info("",$psprintf("class: class_num_1_to_9=%0d .....",class_num_1_to_9),UVM_LOW)
        else
            $finish;
        if (randomize(class_num_1_to_9))
            `uvm_info("",$psprintf("class: class_num_1_to_9=%0d .....",class_num_1_to_9),UVM_LOW)
        else
            $finish;
        if (this.randomize()) // unuseful for scope_num
            `uvm_info("",$psprintf("class: class_num_1_to_9=%0d .....",class_num_1_to_9),UVM_LOW)
        else
            $finish;
    endfunction

endclass

module tb;
    pkt p;

    initial begin
        p = new();
        p.get_num();
        p.randomize();

        `uvm_info("",$psprintf("initial: class_rand_num_1_to_9=%0d .....",p.class_rand_num_1_to_9),UVM_LOW)
        //illegal
        //`uvm_info("",$psprintf("initial: scope_num=%0d .....",p.scope_num),UVM_LOW)

        // unuseful for class_num_1_to_9
        `uvm_info("",$psprintf("initial: class_num_1_to_9=%0d .....",p.class_num_1_to_9),UVM_LOW)
    end
endmodule

