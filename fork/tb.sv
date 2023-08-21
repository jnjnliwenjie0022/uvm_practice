program static_task;
    initial begin
        $display("------static_task");
        for(int i = 0; i < 5; i++)
            send(i);
    end

    task send(int j);
        $display("static_task driving port %0d" , j);
    endtask

endprogram

program automatic automatic_task;
    initial begin
        $display("------automatic_task");
        for(int i = 0; i < 5; i++)
            send(i);
    end

    task send(int j);
        $display("automatic_task driving port %0d" , j);
    endtask

endprogram

program static_fork_join;
    initial begin
        $display("------static_fork_join");
        for(int i = 0; i < 5; i++)
            fork
                send(i);
            join_none
        wait fork;
    end

    task send(int j);
        $display("static_fork_join driving port %0d" , j);
    endtask

endprogram

program automatic automatic_fork_join;
    initial begin
        $display("------automatic_fork_join");
        for(int i = 0; i < 5; i++)
            fork
                send(i);
            join_none
        wait fork;
    end

    task send(int j);
        $display("automatic_fork_join driving port %0d" , j);
    endtask

endprogram

program automatic automatic_tmpvariable_fork_join;
    initial begin
        $display("------automatic_tmpvariable_fork_join");
        for(int i = 0; i < 5; i++)
            fork
                int j = i;
                send(j);
            join_none
        wait fork;
    end

    task send(int j);
        $display("automatic_tmpvariable_fork_join task driving port %0d" , j);
    endtask

endprogram

program static static_tmpvariable_fork_join;
    initial begin
        $display("------static_tmpvariable_fork_join");
        for(int i = 0; i < 5; i++)
            fork
                automatic int j = i;
                send(j);
            join_none
        wait fork;
    end

    task send(int j);
        $display("static_tmpvariable_fork_join driving port %0d" , j);
    endtask

endprogram

//program automatic static_automaticvariable_fork_join;
//    initial begin
//        $display("------static_automaticvariable_fork_join");
//        for(int i = 0; i < 5; i++)
//            fork
//                int j = i;
//                send(j);
//            join_none
//        wait fork;
//    end
//
//    task send(automatic int j);
//        $display("static_automaticvariable_fork_join driving port %0d" , j);
//    endtask
//
//endprogram
//
//Error-[IDM] Invalid declaration modifier
//  Modifier 'automatic' cannot be used in a task/function ref port declaration.

program automatic automatic_fork_join_in_task;
    initial begin
        $display("------automatic_fork_join_in_task");
        for(int i = 0; i < 5; i++)
            send(i);
        wait fork;
    end

    task send(int j);
        fork
            $display("automatic_fork_join_in_task driving port %0d" , j);
        join_none
    endtask

endprogram

program static static_fork_join_in_task;
    initial begin
        $display("------static_fork_join_in_task");
        for(int i = 0; i < 5; i++)
            send(i);
        wait fork;
    end

    task send(int j);
        fork
            $display("static_fork_join_in_task driving port %0d" , j);
        join_none
    endtask

endprogram

program automatic automatic_begin_end_fork_join;
    initial begin
        $display("------automatic_begin_end_fork_join");
        for(int i = 0; i < 5; i++)
            fork
                begin
                    int j = i;
                    send(j);
                end
            join_none
        wait fork;
    end

    task send(int j);
        $display("automatic_begin_end_fork_join driving port %0d" , j);
    endtask

endprogram

program static static_begin_end_fork_join;
    initial begin
        $display("------static_begin_end_fork_join");
        for(int i = 0; i < 5; i++)
            fork
                begin
                    automatic int j = i;
                    send(j);
                end
            join_none
        wait fork;
    end

    task send(int j);
        $display("static_begin_end_fork_join driving port %0d" , j);
    endtask

endprogram

//program static static_begin_end_fork_join;
//    initial begin
//        $display("------static_begin_end_fork_join");
//        for(int i = 0; i < 5; i++)
//            fork
//                begin
//                                         // "static_begin_end_fork_join_1.0.i"
//                    automatic int j = i; // Hierarchical reference to automatic variable 'i' is not legal.
//                    send(j);
//                end
//            join_none
//        wait fork;
//    end
//
//    task send(int j);
//        $display("static_begin_end_fork_join driving port %0d" , j);
//    endtask
//
//endprogram

module tb;
    static_task();
    automatic_task();
    static_fork_join();
    automatic_fork_join();
    automatic_tmpvariable_fork_join();
    static_tmpvariable_fork_join();
    automatic_fork_join_in_task();
    static_fork_join_in_task();
    automatic_begin_end_fork_join();
    static_begin_end_fork_join();
endmodule
