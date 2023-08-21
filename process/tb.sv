class Comp;
    static int count = -1;
    task doDriver();
        repeat(20)
            #1;
        $display("doDriver exit time:%0t", $time);
    endtask

    task doMonitor();
        while(1)
            #1;
        $display("doMonitor exit time:%0t", $time);
    endtask

    static function void raise_objection();
        count++;
        $display("raise_objection time:%0t count:%0d", $time, count);
    endfunction

    static function void drop_objection();
        count--;
        $display("drop_objection time:%0t count:%0d", $time, count);
    endfunction
endclass

module tb;
    Comp driver;
    Comp monitor;
    process pro1;
    process pro2;
    initial begin
        int count;
        driver = new();
        monitor = new();

        fork
            begin : driver_main_phase
                pro1 = process::self();

                Comp::raise_objection();
                driver.doDriver();
                Comp::drop_objection();
            end
            begin : monitor_main_phase
                pro2 = process::self();

                monitor.doMonitor();
            end
        join_none

        begin : process_control
            fork
                begin
                    wait(Comp::count == -1) begin
                        pro1.kill();
                        pro2.kill();
                    end
                end
            join_any
            $display("time:%0t enter next phase ", $time);
        end
    end
endmodule
