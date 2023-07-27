`ifndef BASE_TEST__SV
`define BASE_TEST__SV

class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    my_env         env;
    //my_env         env0;
    //my_env         env1;
    my_vsqr        v_sqr;
    //{{{
    reg_model      rm;
    my_adapter     reg_sqr_adapter;
    //}}}

    function new(string name = "base_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void report_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase);

    UVM_FILE info_log;

    virtual function void connect_phase(uvm_phase phase);
        v_sqr.p_my_sqr = env.i_agt.sqr;
        v_sqr.p_bus_sqr = env.bus_agt.sqr;

        //{{{
        v_sqr.p_rm = this.rm;
        rm.default_map.set_sequencer(env.bus_agt.sqr, reg_sqr_adapter);
        rm.default_map.set_auto_predict(1);
        //}}}

        info_log = $fopen("info.log", "w");
    endfunction

    virtual function void final_phase(uvm_phase phase);
        $fclose(info_log);
    endfunction

endclass


function void base_test::build_phase(uvm_phase phase);
   super.build_phase(phase);

    env  =  my_env::type_id::create("env", this); 
    v_sqr =  my_vsqr::type_id::create("v_sqr", this); 
    //{{{
    rm = reg_model::type_id::create("rm", this);
    rm.configure(null, "");
    rm.build();
    rm.lock_model();
    rm.reset();
    reg_sqr_adapter = new("reg_sqr_adapter");
    env.p_rm = this.rm;
    //}}}
endfunction

task base_test::main_phase(uvm_phase phase);
    phase.phase_done.set_drain_time(this, 1000);
endtask

function void base_test::report_phase(uvm_phase phase);
    uvm_report_server server;
    int err_num;
    super.report_phase(phase);

    server = get_report_server();
    err_num = server.get_severity_count(UVM_ERROR);

    if (err_num != 0) begin
        $display("TEST CASE FAILED");
    end
    else begin
        $display("TEST CASE PASSED");
    end
endfunction

`endif
